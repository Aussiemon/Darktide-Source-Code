local VotingHost = class("VotingHost")

local function _info(...)
	Log.info("VotingHost", ...)
end

local STATES = table.enum("in_progress", "completed", "aborted")

VotingHost.init = function (self, voting_id, initiator_peer, template, optional_params)
	self._voting_id = voting_id
	self._initiator_peer = initiator_peer
	self._template = template
	local params = optional_params or {}
	self._params = params
	local network_interface = template.network_interface()
	self._network_interface = network_interface
	local duration = template.duration
	self._duration = duration
	self._time = 0
	self._member_list = {}
	self._votes = {}
	self._result = nil
	self._abort_reason = nil
	self._state = STATES.in_progress
	local member_list = network_interface:member_peers()

	if not DEDICATED_SERVER then
		member_list[#member_list + 1] = Network.peer_id()
	end

	local initial_votes_by_peer = {}

	if template.initial_votes then
		initial_votes_by_peer = template.initial_votes(params, initiator_peer)
	end

	local initial_votes_list = {}

	for i = 1, #member_list do
		local peer_id = member_list[i]
		self._member_list[i] = peer_id
		local initial_vote_option = initial_votes_by_peer[peer_id]

		if initial_vote_option then
			fassert(self:has_option(initial_vote_option), "Initial voting option %q not found", initial_vote_option)

			self._votes[peer_id] = initial_vote_option
			initial_votes_list[i] = NetworkLookup.voting_options[initial_vote_option]

			_info("Auto-voted %q for %s", initial_vote_option, peer_id)
		else
			self._votes[peer_id] = StrictNil
			initial_votes_list[i] = NetworkLookup.voting_options["nil"]
		end
	end

	local rpc_start_voting = template.rpc_start_voting
	local template_id = NetworkLookup.voting_templates[template.name]

	if initiator_peer == Network.peer_id() then
		self:_send_rpc_members(rpc_start_voting, voting_id, template_id, initiator_peer, member_list, initial_votes_list, duration, template.pack_params(params))
		_info("Initiated voting %q (%s), params: %s", voting_id, template.name, table.tostring(params))
	else
		self:_send_rpc_members_except(rpc_start_voting, initiator_peer, voting_id, template_id, initiator_peer, member_list, initial_votes_list, duration, template.pack_params(params))

		local channel_id = network_interface:peer_to_channel(initiator_peer)

		RPC.rpc_voting_accepted(channel_id, voting_id, member_list, initial_votes_list, duration)
		_info("Accepted voting %q (%s) initiated by %s, params: %s", voting_id, template.name, initiator_peer, table.tostring(params))
	end
end

VotingHost.destroy = function (self)
	self._template = nil
	self._params = nil
	self._member_list = nil
	self._votes = nil
end

VotingHost.is_host = function (self)
	return true
end

VotingHost.state = function (self)
	return self._state
end

VotingHost.on_member_joined = function (self, peer_id)
	local member_list = self._member_list
	member_list[#member_list + 1] = peer_id
	local votes = self._votes
	votes[peer_id] = StrictNil
	local votes_list_lookup = {}

	for i = 1, #member_list do
		local member_peer_id = member_list[i]
		local vote_option = votes[member_peer_id]

		if vote_option == StrictNil then
			votes_list_lookup[i] = NetworkLookup.voting_options["nil"]
		else
			votes_list_lookup[i] = NetworkLookup.voting_options[vote_option]
		end
	end

	local template = self._template
	local rpc_start_voting = template.rpc_start_voting
	local channel_id = self._network_interface:peer_to_channel(peer_id)
	local voting_id = self._voting_id
	local template_id = NetworkLookup.voting_templates[template.name]
	local initiator_peer = self._initiator_peer
	local time_left = self._duration and math.max(self._duration - self._time, 0) or nil
	local params = self._params

	RPC[rpc_start_voting](channel_id, voting_id, template_id, initiator_peer, member_list, votes_list_lookup, time_left, template.pack_params(params))
	self:_send_rpc_members_except("rpc_voting_member_joined", peer_id, self._voting_id, peer_id)
	_info("Voting member %s joined voting %q", peer_id, self._voting_id)
end

VotingHost.on_member_left = function (self, peer_id)
	local member_list = self._member_list
	local index = table.index_of(member_list, peer_id)

	table.remove(member_list, index)

	self._votes[peer_id] = nil

	self:_send_rpc_members("rpc_voting_member_left", self._voting_id, peer_id)
	_info("Voting member %s left voting %q", peer_id, self._voting_id)
end

VotingHost.on_voting_aborted = function (self, reason)
	self._state = STATES.aborted
	self._abort_reason = reason

	self:_send_rpc_members("rpc_voting_aborted", self._voting_id, reason)
	_info("Voting %q aborted, reason: %s", self._voting_id, reason)
end

VotingHost.has_member = function (self, peer_id)
	return table.index_of(self._member_list, peer_id) ~= -1
end

VotingHost.has_voted = function (self, peer_id)
	return self._votes[peer_id] ~= StrictNil
end

VotingHost.has_option = function (self, option)
	return table.contains(self._template.options, option)
end

VotingHost.network_interface = function (self)
	return self._network_interface
end

VotingHost.template = function (self)
	return self._template
end

VotingHost.params = function (self)
	return self._params
end

local member_list_copy = {}

VotingHost.member_list = function (self)
	table.clear(member_list_copy)

	local member_list = self._member_list

	for i = 1, member_list do
		member_list_copy[i] = member_list[i]
	end

	return member_list_copy
end

local votes_copy = {}

VotingHost.votes = function (self)
	table.clear(votes_copy)

	for peer_id, vote in pairs(self._votes) do
		votes_copy[peer_id] = vote
	end

	return votes_copy
end

VotingHost.time_left = function (self)
	local duration = self._duration

	if not duration then
		return nil, nil
	end

	local time_left = math.max(self._duration - self._time, 0)
	local time_left_normalized = math.max(time_left / duration, 0)

	return time_left, time_left_normalized
end

VotingHost.register_vote = function (self, voter_peer_id, option)
	self._votes[voter_peer_id] = option
	local option_id = NetworkLookup.voting_options[option]
	local voting_id = self._voting_id

	self:_send_rpc_members("rpc_register_vote", voting_id, voter_peer_id, option_id)

	local template = self._template

	_info("Registered vote %q casted by %s in voting %q (%s)", option, voter_peer_id, voting_id, template.name)
end

VotingHost.update = function (self, dt, t)
	if self._state ~= STATES.in_progress then
		return
	end

	local time = self._time + dt
	self._time = time
	local template = self._template
	local evaluate_delay = template.evaluate_delay

	if evaluate_delay and time < evaluate_delay then
		return
	end

	local duration = self._duration

	if duration then
		local time_left = duration - time

		if time_left <= 0 then
			_info("Voting %q timed out", self._voting_id)
			self:_handle_undecided_votes()
		end
	end

	local result = template.evaluate(self._votes)

	if result then
		self._state = STATES.completed
		self._result = result
		local result_id = NetworkLookup.voting_results[result]
		local voting_id = self._voting_id

		self:_send_rpc_members("rpc_voting_completed", voting_id, result_id)
		_info("Voting %q (%s) completed, result: %s, votes: %s", voting_id, template.name, result, table.tostring(self._votes))
	end
end

VotingHost.complete_vote = function (self)
	local template = self._template
	local result = template.complete_vote(self._votes)
	self._result = result
	self._state = STATES.completed
	local result_id = NetworkLookup.voting_results[result]
	local voting_id = self._voting_id

	self:_send_rpc_members("rpc_voting_completed", voting_id, result_id)
	_info("Voting %q (%s) force completed, result: %s, votes: %s", voting_id, template.name, result, table.tostring(self._votes))
end

VotingHost._handle_undecided_votes = function (self)
	local timeout_option = self._template.timeout_option
	local votes = self._votes

	for voter_peer_id, vote in pairs(votes) do
		if vote == StrictNil then
			_info("Casting timeout option %q for undecided member %s", timeout_option, voter_peer_id)
			self:register_vote(voter_peer_id, timeout_option)
		end
	end
end

VotingHost.result = function (self)
	return self._result
end

VotingHost.abort_reason = function (self)
	return self._abort_reason
end

VotingHost._send_rpc_members = function (self, rpc_name, ...)
	local rpc = RPC[rpc_name]
	local local_peer_id = Network.peer_id()
	local network_interface = self._network_interface
	local member_list = self._member_list

	for i = 1, #member_list do
		local peer_id = member_list[i]

		if peer_id ~= local_peer_id then
			local channel_id = network_interface:peer_to_channel(peer_id)

			rpc(channel_id, ...)
		end
	end
end

VotingHost._send_rpc_members_except = function (self, rpc_name, except_peer_id, ...)
	local rpc = RPC[rpc_name]
	local local_peer_id = Network.peer_id()
	local network_interface = self._network_interface
	local member_list = self._member_list

	for i = 1, #member_list do
		local peer_id = member_list[i]

		if peer_id ~= local_peer_id and peer_id ~= except_peer_id then
			local channel_id = network_interface:peer_to_channel(peer_id)

			rpc(channel_id, ...)
		end
	end
end

return VotingHost
