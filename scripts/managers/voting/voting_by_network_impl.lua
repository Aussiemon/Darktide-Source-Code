local NetworkLookup = require("scripts/network_lookup/network_lookup")
local VotingTemplates = require("scripts/settings/voting/voting_templates")
local VotingHost = require("scripts/managers/voting/voting_host")
local VotingClient = require("scripts/managers/voting/voting_client")
local VotingNetworkInterface = require("scripts/managers/voting/voting_network_interface")
local Promise = require("scripts/foundation/utilities/promise")
local HOST_RPCS = {
	"rpc_voting_client_ready",
	"rpc_request_voting_no_params",
	"rpc_request_voting_kick_player",
	"rpc_request_vote"
}
local CLIENT_RPCS = {
	"rpc_start_voting_no_params",
	"rpc_start_voting_accept_mission",
	"rpc_start_voting_mission_lobby_ready",
	"rpc_start_voting_kick_player",
	"rpc_start_voting_stay_in_party",
	"rpc_voting_accepted",
	"rpc_voting_completed",
	"rpc_voting_aborted",
	"rpc_register_vote",
	"rpc_vote_denied",
	"rpc_voting_member_joined",
	"rpc_voting_member_left"
}
local VotingByNetworkImpl = class("VotingByNetworkImpl")

VotingByNetworkImpl.init = function (self, network_event_delegate)
	self._event_delegate = network_event_delegate
	self._registered_channel_rpcs = {}
	self._votings = {}
	self._voting_results = {}
	self._voting_index = 0
	self._last_vote_started = {}
	local connection_manager = Managers.connection

	connection_manager:register_event_listener(self, "client_connected", "_event_network_client_connected")
	connection_manager:register_event_listener(self, "client_disconnected", "_event_network_client_disconnected")
	connection_manager:register_event_listener(self, "connected_to_host", "_event_network_connected_to_host")
	connection_manager:register_event_listener(self, "disconnected_from_host", "_event_network_disconnected_from_host")
end

VotingByNetworkImpl._generate_voting_id = function (self)
	local index = self._voting_index + 1
	self._voting_index = index

	return string.format("%s:%s", Network.peer_id(), index)
end

VotingByNetworkImpl.can_start_voting = function (self, template_name, params, initiator_peer)
	local template = VotingTemplates[template_name]

	if not template then
		return false, string.format("voting template %s not found", template_name)
	end

	local max_num_instances = template.max_num_instances or 1

	if max_num_instances and max_num_instances == self:_num_votings_by_template_name(template_name) then
		return false, string.format("reached max num votings using this template")
	end

	local required_params = template.required_params

	if required_params then
		for i = 1, #required_params do
			local param_name = required_params[i]

			if params[param_name] == nil then
				return false, string.format("required voting param %s not found", param_name)
			end
		end
	end

	local network_interface = template.network_interface()

	if not network_interface:is_host() and not network_interface:is_client() then
		return false, "can't become voting host/client"
	end

	local retry_delay = template.retry_delay

	if retry_delay then
		local last_started_at = self._last_vote_started[template_name] and self._last_vote_started[template_name][initiator_peer]
		local current_time = Managers.time:time("main")

		if last_started_at and current_time < last_started_at + retry_delay then
			return false, string.format("must wait %s seconds before starting a new vote", last_started_at + retry_delay - current_time)
		end
	end

	if template.can_start then
		return template.can_start()
	end

	return true
end

VotingByNetworkImpl._on_started = function (self, voting_id, template, params, initiator_peer)
	self._last_vote_started[template.name] = self._last_vote_started[template.name] or {}
	self._last_vote_started[template.name][initiator_peer] = Managers.time:time("main")

	template.on_started(voting_id, template, table.clone(params))
end

VotingByNetworkImpl.start_voting = function (self, template_name, params)
	local voting_id = self:_generate_voting_id()
	local initiator_peer = Network.peer_id()
	local template = VotingTemplates[template_name]
	local network_interface = template.network_interface()

	assert_interface(network_interface, VotingNetworkInterface)

	if network_interface:is_host() then
		local voting = VotingHost:new(voting_id, initiator_peer, template, params)
		self._votings[voting_id] = voting

		self:_on_started(voting_id, template, params, initiator_peer)
	elseif network_interface:is_client() then
		local voting = VotingClient:new(voting_id, initiator_peer, template, params)
		self._votings[voting_id] = voting
	end

	return Promise.resolved(voting_id)
end

VotingByNetworkImpl.can_cast_vote = function (self, voting_id, option, voter_peer_id)
	local voting = self._votings[voting_id]

	if not voting then
		return false, string.format("voting %q not found", voting_id)
	end

	local state = voting:state()

	if state ~= "in_progress" then
		return false, string.format("voting not ready", state)
	end

	if not voting:has_member(voter_peer_id) then
		return false, string.format("peer %s not member in voting", voter_peer_id)
	end

	local template = voting:template()

	if voting:has_voted(voter_peer_id) and not template.can_change_vote then
		return false, string.format("peer %s already voted", voter_peer_id)
	end

	if not voting:has_option(option) then
		return false, string.format("invalid vote option %s", option)
	end

	return true
end

VotingByNetworkImpl.cast_vote = function (self, voting_id, option)
	local voter_peer_id = Network.peer_id()
	local success, fail_reason = self:can_cast_vote(voting_id, option, voter_peer_id)

	if not success then
		return false, fail_reason
	end

	local voting = self._votings[voting_id]

	if voting:is_host() then
		voting:register_vote(voter_peer_id, option)

		local template = voting:template()

		template.on_vote_casted(voting_id, template, voter_peer_id, option)
	else
		voting:request_vote(option)
	end

	return true
end

local delete_votings = {}

VotingByNetworkImpl.update = function (self, dt, t)
	table.clear(delete_votings)

	local votings = self._votings

	for voting_id, voting in pairs(votings) do
		voting:update(dt, t)

		local state = voting:state()

		if state == "completed" then
			local result = voting:result()
			self._voting_results[voting_id] = {
				result = result
			}
			local template = voting:template()

			template.on_completed(voting_id, template, table.clone(voting:params()), result)

			delete_votings[#delete_votings + 1] = voting_id

			if DEDICATED_SERVER then
				local votes = {}

				for _, value in pairs(voting:votes()) do
					votes[value] = (votes[value] or 0) + 1
				end

				Managers.telemetry_events:vote_completed(template.name, result, votes)
			end
		elseif state == "aborted" then
			local abort_reason = voting:abort_reason()
			self._voting_results[voting_id] = {
				abort_reason = abort_reason
			}
			local template = voting:template()

			template.on_aborted(voting_id, template, table.clone(voting:params()), abort_reason)

			delete_votings[#delete_votings + 1] = voting_id
		end
	end

	for i = 1, #delete_votings do
		local voting_id = delete_votings[i]

		votings[voting_id]:delete()

		votings[voting_id] = nil
	end
end

VotingByNetworkImpl.member_list = function (self, voting_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:member_list()
	end
end

VotingByNetworkImpl.votes = function (self, voting_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:votes()
	end
end

VotingByNetworkImpl.time_left = function (self, voting_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:time_left()
	end
end

VotingByNetworkImpl.voting_template = function (self, voting_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:template()
	end
end

VotingByNetworkImpl.voting_exists = function (self, voting_id)
	return self._votings[voting_id] ~= nil
end

VotingByNetworkImpl.voting_result = function (self, voting_id)
	local result = self._voting_results[voting_id]

	if result then
		return true, result.result, result.abort_reason
	else
		return false
	end
end

VotingByNetworkImpl.has_voted = function (self, voting_id, voter_peer_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:has_voted(voter_peer_id)
	end
end

VotingByNetworkImpl.is_host = function (self, voting_id)
	local voting = self._votings[voting_id]

	if voting then
		return voting:is_host()
	end
end

VotingByNetworkImpl._num_votings_by_template_name = function (self, template_name)
	local num = 0

	for _, voting in pairs(self._votings) do
		if voting:template().name == template_name then
			num = num + 1
		end
	end

	return num
end

VotingByNetworkImpl._delete_voting = function (self, voting_id)
	self._votings[voting_id]:delete()

	self._votings[voting_id] = nil
end

VotingByNetworkImpl.destroy = function (self)
	local connection_manager = Managers.connection

	connection_manager:unregister_event_listener(self, "client_connected")
	connection_manager:unregister_event_listener(self, "client_disconnected")
	connection_manager:unregister_event_listener(self, "connected_to_host")
	connection_manager:unregister_event_listener(self, "disconnected_from_host")

	for _, voting in pairs(self._votings) do
		voting:delete()
	end

	self._votings = nil

	for channel_id, rpcs in pairs(self._registered_channel_rpcs) do
		self._event_delegate:unregister_channel_events(channel_id, unpack(rpcs))
	end

	self._registered_channel_rpcs = nil
	self._event_delegate = nil
end

VotingByNetworkImpl.complete_vote = function (self, voting_id)
	local voting = self._votings[voting_id]

	if not voting:is_host() then
		return
	end

	voting:complete_vote()
end

VotingByNetworkImpl.rpc_voting_client_ready = function (self, channel_id)
	local network_interface = nil

	if Managers.connection:channel_to_peer(channel_id) then
		network_interface = Managers.connection
	end

	if not network_interface then
		return
	end

	local votings = self._votings

	for voting_id, voting in pairs(votings) do
		if voting:network_interface() == network_interface and voting:is_host() then
			local template = voting:template()

			if template.abort_on_member_joined then
				voting:on_voting_aborted("Member joined voting network")
			else
				local peer_id = Network.peer_id(channel_id)

				voting:on_member_joined(peer_id, channel_id)
			end
		end
	end
end

VotingByNetworkImpl._rpc_request_voting = function (self, channel_id, voting_id, template_id, ...)
	local initiator_peer = Network.peer_id(channel_id)
	local template_name = NetworkLookup.voting_templates[template_id]
	local template = template_name and VotingTemplates[template_name]
	local params = template and template.unpack_params(...)
	local success, fail_reason = self:can_start_voting(template_name, params, initiator_peer)

	if not success then
		RPC.rpc_voting_aborted(channel_id, voting_id, string.format("Denied by host, %s", fail_reason))

		return
	end

	local voting = VotingHost:new(voting_id, initiator_peer, template, params)
	self._votings[voting_id] = voting

	self:_on_started(voting_id, template, params, initiator_peer)
end

VotingByNetworkImpl.rpc_request_voting_no_params = function (self, channel_id, voting_id, template_id)
	self:_rpc_request_voting(channel_id, voting_id, template_id)
end

VotingByNetworkImpl.rpc_request_voting_kick_player = function (self, channel_id, voting_id, template_id, kick_peer_id)
	self:_rpc_request_voting(channel_id, voting_id, template_id, kick_peer_id)
end

VotingByNetworkImpl.rpc_request_vote = function (self, channel_id, voting_id, option_id)
	local option = NetworkLookup.voting_options[option_id]
	local voter_peer_id = Network.peer_id(channel_id)
	local success, fail_reason = self:can_cast_vote(voting_id, option, voter_peer_id)

	if not success then
		RPC.rpc_vote_denied(channel_id, voting_id, fail_reason)

		return
	end

	local voting = self._votings[voting_id]

	voting:register_vote(voter_peer_id, option)

	local template = voting:template()

	template.on_vote_casted(voting_id, template, voter_peer_id, option)
end

VotingByNetworkImpl.rpc_voting_accepted = function (self, channel_id, voting_id, member_list, initial_votes_list, time_left)
	local voting = self._votings[voting_id]

	if voting then
		local voting_options_lookup = NetworkLookup.voting_options

		for i = 1, #initial_votes_list do
			local option_id = initial_votes_list[i]
			local option = voting_options_lookup[option_id]
			initial_votes_list[i] = option == "nil" and StrictNil or option
		end

		voting:on_voting_accepted(member_list, initial_votes_list, time_left)

		local template = voting:template()
		local initiator_peer = Network.peer_id()

		self:_on_started(voting_id, template, voting:params(), initiator_peer)
	end
end

VotingByNetworkImpl._rpc_start_voting = function (self, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, ...)
	local template_name = NetworkLookup.voting_templates[template_id]
	local template = VotingTemplates[template_name]
	local params = template.unpack_params(...)
	local voting_options_lookup = NetworkLookup.voting_options

	for i = 1, #initial_votes_list do
		local option_id = initial_votes_list[i]
		local option = voting_options_lookup[option_id]
		initial_votes_list[i] = option == "nil" and StrictNil or option
	end

	local voting = VotingClient:new(voting_id, initiator_peer, template, params, member_list, initial_votes_list, time_left)
	self._votings[voting_id] = voting

	self:_on_started(voting_id, template, params, initiator_peer)
end

VotingByNetworkImpl.rpc_voting_aborted = function (self, channel_id, voting_id, reason)
	local voting = self._votings[voting_id]

	if voting then
		voting:on_voting_aborted(reason)
	end
end

VotingByNetworkImpl.rpc_voting_completed = function (self, channel_id, voting_id, result_id)
	local voting = self._votings[voting_id]

	if voting then
		local result = NetworkLookup.voting_results[result_id]

		voting:on_voting_completed(result)
	end
end

VotingByNetworkImpl.rpc_start_voting_no_params = function (self, channel_id, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left)
	self:_rpc_start_voting(voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left)
end

VotingByNetworkImpl.rpc_start_voting_accept_mission = function (self, channel_id, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, backend_mission_id, mission_initiator_peer, mission_data_string)
	self:_rpc_start_voting(voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, backend_mission_id, mission_initiator_peer, mission_data_string)
end

VotingByNetworkImpl.rpc_start_voting_mission_lobby_ready = function (self, channel_id, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, mission_name_id, circumstance_name_id)
	self:_rpc_start_voting(voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, mission_name_id, circumstance_name_id)
end

VotingByNetworkImpl.rpc_start_voting_kick_player = function (self, channel_id, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, kick_peer_id)
	self:_rpc_start_voting(voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, kick_peer_id)
end

VotingByNetworkImpl.rpc_start_voting_stay_in_party = function (self, channel_id, voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, new_party_id, new_party_invite_token)
	self:_rpc_start_voting(voting_id, template_id, initiator_peer, member_list, initial_votes_list, time_left, new_party_id, new_party_invite_token)
end

VotingByNetworkImpl.rpc_register_vote = function (self, channel_id, voting_id, voter_peer_id, option_id)
	local voting = self._votings[voting_id]

	if voting then
		local option = NetworkLookup.voting_options[option_id]

		voting:register_vote(voter_peer_id, option)

		local template = voting:template()

		template.on_vote_casted(voting_id, template, voter_peer_id, option)
	end
end

VotingByNetworkImpl.rpc_vote_denied = function (self, channel_id, voting_id, reason)
	local voting = self._votings[voting_id]

	if voting then
		voting:on_vote_denied(reason)
	end
end

VotingByNetworkImpl.rpc_voting_member_joined = function (self, channel_id, voting_id, peer_id)
	local voting = self._votings[voting_id]

	if voting then
		voting:on_member_joined(peer_id)
	end
end

VotingByNetworkImpl.rpc_voting_member_left = function (self, channel_id, voting_id, peer_id)
	local voting = self._votings[voting_id]

	if voting then
		voting:on_member_left(peer_id)
	end
end

VotingByNetworkImpl._event_network_client_connected = function (self, network_interface, peer_id, channel_id)
	self._event_delegate:register_connection_channel_events(self, channel_id, unpack(HOST_RPCS))

	self._registered_channel_rpcs[channel_id] = HOST_RPCS
end

VotingByNetworkImpl._event_network_client_disconnected = function (self, network_interface, peer_id, channel_id)
	self._event_delegate:unregister_channel_events(channel_id, unpack(HOST_RPCS))

	self._registered_channel_rpcs[channel_id] = nil
	local votings = self._votings

	for _, voting in pairs(votings) do
		if voting:network_interface() == network_interface and voting:is_host() and voting:has_member(peer_id) then
			local template = voting:template()

			if template.abort_on_member_left then
				voting:on_voting_aborted("Member left", peer_id)
			else
				voting:on_member_left(peer_id)
			end
		end
	end
end

VotingByNetworkImpl._event_network_connected_to_host = function (self, network_interface, peer_id, channel_id)
	self._event_delegate:register_connection_channel_events(self, channel_id, unpack(CLIENT_RPCS))

	self._registered_channel_rpcs[channel_id] = CLIENT_RPCS

	RPC.rpc_voting_client_ready(channel_id)
end

VotingByNetworkImpl._event_network_disconnected_from_host = function (self, network_interface, peer_id, channel_id)
	self._event_delegate:unregister_channel_events(channel_id, unpack(CLIENT_RPCS))

	self._registered_channel_rpcs[channel_id] = nil
	local votings = self._votings

	for voting_id, voting in pairs(votings) do
		if voting:network_interface() == network_interface and not voting:is_host() then
			voting:on_voting_aborted("Disconnected from voting host")
		end
	end
end

return VotingByNetworkImpl
