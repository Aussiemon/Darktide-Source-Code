local VotingTemplates = require("scripts/settings/voting/voting_templates")
local Promise = require("scripts/foundation/utilities/promise")
local VotingManagerImmateriumPartyTestify = GameParameters.testify and require("scripts/managers/voting/voting_by_immaterium_party_impl_testify")

local function _info(...)
	Log.info("VotingManagerImmateriumParty", ...)
end

local VotingManagerImmateriumParty = class("VotingManagerImmateriumParty")

VotingManagerImmateriumParty.init = function (self)
	self._current_vote_id = nil
	self._current_vote_state = nil
	self._casted_votes = {}
end

VotingManagerImmateriumParty._current_vote = function (self)
	return Managers.party_immaterium:party_vote_state()
end

VotingManagerImmateriumParty._can_start_matchmaking = function (self)
	return Managers.party_immaterium:current_game_session_id() == nil
end

VotingManagerImmateriumParty._get_myself = function (self)
	return Managers.party_immaterium:get_myself()
end

VotingManagerImmateriumParty._unwrap_vote_id = function (self, id)
	local p = "immaterium_party:"

	return string.sub(id, p:len() + 1, id:len())
end

VotingManagerImmateriumParty._wrap_vote_id = function (self, id)
	return string.format("immaterium_party:%s", id)
end

VotingManagerImmateriumParty.can_start_voting = function (self, template_name, params)
	local template = VotingTemplates[template_name]

	if template.immaterium_party_vote_type == "matchmaking_start" and not self:_can_start_matchmaking() then
		return false, "CANT_START_MATCHMAKING"
	end

	if self:_current_vote().state == "ONGOING" then
		return false, "VOTE_ALREADY_ONGOING"
	end

	return true
end

VotingManagerImmateriumParty.start_voting = function (self, template_name, params)
	local success, fail_reason = self:can_start_voting(template_name, params)

	if not success then
		return Promise.rejected({
			fail_reason
		})
	end

	local template = VotingTemplates[template_name]
	params.template_name = template_name

	if template.static_params then
		for key, value in pairs(template.static_params) do
			params[key] = value
		end
	end

	local params_promise = nil

	if template.fetch_my_vote_params then
		params_promise = template:fetch_my_vote_params(params, "yes")
	else
		params_promise = Promise.resolved({})
	end

	return params_promise:next(function (vote_params)
		return Managers.party_immaterium:start_vote(template.immaterium_party_vote_type, params, vote_params)
	end)
end

VotingManagerImmateriumParty.can_cast_vote = function (self, voting_id, option, voter_peer_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) ~= voting_id then
		return false, string.format("voting %q not found", voting_id)
	end

	if current_vote.state ~= "ONGOING" then
		return false, string.format("voting not ready", current_vote.state)
	end

	if current_vote.votes[voter_peer_id] == nil then
		return false, string.format("peer %s not member in voting", voter_peer_id)
	end

	if self:has_voted(voting_id, voter_peer_id) then
		return false, string.format("peer %s member has already voted", voter_peer_id)
	end

	if option ~= "yes" and option ~= "no" then
		return false, string.format("invalid vote option %s", option)
	end

	return true
end

VotingManagerImmateriumParty.current_vote = function (self)
	return self:_current_vote()
end

VotingManagerImmateriumParty.cast_vote = function (self, voting_id, option)
	local current_vote = self:_current_vote()
	local success, fail_reason = self:can_cast_vote(voting_id, option, self:_get_myself():unique_id())

	if not success then
		return Promise.rejected(fail_reason)
	end

	local template = VotingTemplates[current_vote.params.template_name]
	local vote_params_promise = nil

	if template.fetch_my_vote_params then
		vote_params_promise = template:fetch_my_vote_params(current_vote.params, option)
	else
		vote_params_promise = Promise.resolved({})
	end

	local promise = vote_params_promise:next(function (myParams)
		return Managers.party_immaterium:answer_vote(self:_unwrap_vote_id(voting_id), option == "yes", myParams)
	end)

	return promise
end

VotingManagerImmateriumParty.update = function (self, dt, t)
	if not Managers.party_immaterium then
		return
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(VotingManagerImmateriumPartyTestify, self, true)
	end

	local current_vote = self:_current_vote()

	if not current_vote.params or not current_vote.params.template_name then
		if self._current_vote_state == "started" then
			local current_vote = self._initial_current_vote
			local template = VotingTemplates[current_vote.params.template_name]
			local abort_reason = "disappeared"
			self._current_vote_state = "finished"

			_info("Party Vote Aborted: " .. abort_reason)
			template.on_aborted(current_vote.id, template, current_vote.params, abort_reason)
		end

		return
	end

	local vote_id = self:_wrap_vote_id(current_vote.id)
	local template = VotingTemplates[current_vote.params.template_name]

	if current_vote.id == self._current_vote_id then
		if self._current_vote_state == "started" then
			for k, v in pairs(current_vote.votes) do
				if v.state ~= "WAITING" and not self._casted_votes[k] then
					local option = v.state:lower()

					template.on_vote_casted(vote_id, template, k, option)
					_info("Party Member Voted: " .. option)

					self._casted_votes[k] = true
				end
			end

			local finished, result, abort_reason = self:voting_result(vote_id)

			if finished then
				self._current_vote_state = "finished"

				if result == "approved" or result == "rejected" then
					_info("Party Vote Completed: " .. result)
					template.on_completed(vote_id, template, current_vote, result)

					if DEDICATED_SERVER then
						local votes = {}

						for _, value in pairs(current_vote.votes) do
							votes[value] = (votes[value] or 0) + 1
						end

						Managers.telemetry_events:vote_completed(template.name, result, votes)
					end
				else
					_info("Party Vote Aborted: " .. result .. ":" .. abort_reason)
					template.on_aborted(vote_id, template, current_vote.params, abort_reason)
				end
			end
		end
	elseif current_vote.id ~= "" and current_vote.state == "ONGOING" then
		self._current_vote_state = "started"
		self._current_vote_id = current_vote.id
		self._casted_votes = {}
		self._initial_current_vote = current_vote

		_info("Party Vote Started")
		template.on_started(vote_id, template, current_vote.params)
	end
end

VotingManagerImmateriumParty.member_list = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		local keyset = {}

		for k, v in pairs(current_vote.votes) do
			table.insert(keyset, k)
		end

		return keyset
	end
end

VotingManagerImmateriumParty.votes = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		local result = {}

		for k, v in pairs(current_vote.votes) do
			result[k] = v.state
		end

		return result
	end
end

VotingManagerImmateriumParty.time_left = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		local time_left = current_vote.timeout - os.time()
		local time_left_normalized = time_left and math.max(time_left / current_vote.timeout_duration, 0)

		return time_left, time_left_normalized
	end
end

VotingManagerImmateriumParty.voting_template = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		return VotingTemplates[current_vote.params.template_name]
	end
end

VotingManagerImmateriumParty.voting_exists = function (self, voting_id)
	local current_vote = self:_current_vote()

	return self:_wrap_vote_id(current_vote.id) == voting_id
end

VotingManagerImmateriumParty.voting_result = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		if current_vote.state == "ONGOING" then
			return false
		elseif current_vote.state == "COMPLETED_APPROVED" then
			return true, "approved"
		elseif current_vote.state == "COMPLETED_REJECTED" then
			return true, "rejected"
		else
			return true, "failed", current_vote.state
		end
	else
		return true, "failed", "vote_id " .. voting_id .. " is not active"
	end
end

VotingManagerImmateriumParty.has_voted = function (self, voting_id, voter_peer_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id and current_vote.votes[voter_peer_id] then
		return current_vote.votes[voter_peer_id].state ~= "WAITING"
	end
end

VotingManagerImmateriumParty.is_host = function (self, voting_id)
	local current_vote = self:_current_vote()

	if self:_wrap_vote_id(current_vote.id) == voting_id then
		return current_vote.started_by:unique_id() == self:_get_myself():unique_id()
	end
end

VotingManagerImmateriumParty.complete_vote = function (self, voting_id)
	return
end

return VotingManagerImmateriumParty
