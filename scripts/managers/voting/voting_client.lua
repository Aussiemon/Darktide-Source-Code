local VotingClient = class("VotingClient")

local function _info(...)
	Log.info("VotingClient", ...)
end

local STATES = table.enum("waiting_for_host_accept", "in_progress", "completed", "aborted")

VotingClient.init = function (self, voting_id, initiator_peer, template, optional_params, member_list, initial_votes_list, time_left)
	self._voting_id = voting_id
	self._initiator_peer = initiator_peer
	self._template = template
	local params = optional_params or {}
	self._params = params
	local network_interface = template.network_interface()
	self._network_interface = network_interface
	self._time_left = time_left
	self._member_list = {}
	self._votes = {}
	self._result = nil
	self._abort_reason = nil

	if initiator_peer == Network.peer_id() then
		self._state = STATES.waiting_for_host_accept
		local rpc_name = template.rpc_request_voting
		local template_id = NetworkLookup.voting_templates[template.name]

		self:_send_rpc_host(rpc_name, voting_id, template_id, template.pack_params(params))
		_info("Requested voting %q (%s), params: %s", voting_id, template.name, table.tostring(params))
	else
		self._state = STATES.in_progress

		for i = 1, #member_list do
			local peer_id = member_list[i]
			self._member_list[i] = peer_id
			self._votes[peer_id] = initial_votes_list[i]
		end
	end
end

VotingClient.destroy = function (self)
	self._template = nil
	self._params = nil
	self._member_list = nil
	self._votes = nil
end

VotingClient.on_voting_accepted = function (self, member_list, initial_votes_list, time_left)
	self._state = STATES.in_progress

	for i = 1, #member_list do
		local peer_id = member_list[i]
		self._member_list[i] = peer_id
		self._votes[peer_id] = initial_votes_list[i]
	end

	self._time_left = time_left

	_info("Voting %q accepted by host", self._voting_id)
end

VotingClient.on_voting_aborted = function (self, reason)
	self._state = STATES.aborted
	self._abort_reason = reason

	_info("Voting %q aborted, reason: %s", self._voting_id, reason)
end

VotingClient.on_voting_completed = function (self, result)
	self._state = STATES.completed
	self._result = result

	_info("Voting %q completed, result: %s, votes: %s", self._voting_id, result, table.tostring(self._votes))
end

VotingClient.on_vote_denied = function (self, reason)
	_info("Vote denied by host in voting %q, reason: %s", self._voting_id, reason)
end

VotingClient.on_member_joined = function (self, peer_id)
	local member_list = self._member_list
	member_list[#member_list + 1] = peer_id
	self._votes[peer_id] = StrictNil

	_info("Voting member %s joined voting %q", peer_id, self._voting_id)
end

VotingClient.on_member_left = function (self, peer_id)
	local member_list = self._member_list
	local index = table.index_of(member_list, peer_id)

	table.remove(member_list, index)

	self._votes[peer_id] = nil

	_info("Voting member %s left voting %q", peer_id, self._voting_id)
end

VotingClient.is_host = function (self)
	return false
end

VotingClient.state = function (self)
	return self._state
end

VotingClient.host_channel = function (self)
	return self._network_interface:host_channel()
end

VotingClient.has_member = function (self, peer_id)
	return table.index_of(self._member_list, peer_id) ~= -1
end

VotingClient.has_voted = function (self, peer_id)
	return self._votes[peer_id] ~= StrictNil
end

VotingClient.has_option = function (self, option)
	return table.contains(self._template.options, option)
end

VotingClient.network_interface = function (self)
	return self._network_interface
end

VotingClient.template = function (self)
	return self._template
end

VotingClient.params = function (self)
	return self._params
end

local member_list_copy = {}

VotingClient.member_list = function (self)
	table.clear(member_list_copy)

	local member_list = self._member_list

	for i = 1, member_list do
		member_list_copy[i] = member_list[i]
	end

	return member_list_copy
end

local votes_copy = {}

VotingClient.votes = function (self)
	table.clear(votes_copy)

	for peer_id, vote in pairs(self._votes) do
		votes_copy[peer_id] = vote
	end

	return votes_copy
end

VotingClient.time_left = function (self)
	local duration = self._template.duration
	local time_left = self._time_left
	local time_left_normalized = time_left and math.max(time_left / duration, 0)

	return time_left, time_left_normalized
end

VotingClient.register_vote = function (self, voter_peer_id, option)
	self._votes[voter_peer_id] = option
	local voting_id = self._voting_id
	local template = self._template

	_info("Registered vote %q casted by %s in voting %q (%s)", option, voter_peer_id, voting_id, template.name)
end

VotingClient.request_vote = function (self, option)
	local option_id = NetworkLookup.voting_options[option]
	local voting_id = self._voting_id

	self:_send_rpc_host("rpc_request_vote", voting_id, option_id)
	_info("Requested vote %q in %s, voting_id: %q", option, self._template.name, voting_id)
end

VotingClient.result = function (self)
	return self._result
end

VotingClient.abort_reason = function (self)
	return self._abort_reason
end

VotingClient.update = function (self, dt, t)
	if self._state ~= STATES.in_progress then
		return
	end

	local time_left = self._time_left

	if time_left then
		time_left = math.max(time_left - dt, 0)
		self._time_left = time_left
	end
end

VotingClient._send_rpc_host = function (self, rpc_name, ...)
	local host_channel = self._network_interface:host_channel()

	RPC[rpc_name](host_channel, ...)
end

return VotingClient
