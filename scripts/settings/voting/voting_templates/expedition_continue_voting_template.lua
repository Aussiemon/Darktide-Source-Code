-- chunkname: @scripts/settings/voting/voting_templates/expedition_continue_voting_template.lua

local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "rejected")
local voting_template = {
	abort_on_member_joined = false,
	abort_on_member_left = false,
	agreement_duration = 5,
	can_change_vote = true,
	duration = 60,
	initial_votes = nil,
	name = "expedition_continue",
	rpc_request_voting = "rpc_request_voting_no_params",
	rpc_start_voting = "rpc_start_voting_no_params",
	voting_impl = "network",
	options = {
		OPTIONS.yes,
		OPTIONS.no,
	},
	results = {
		RESULTS.approved,
	},
	timeout_option = OPTIONS.yes,
	required_params = {},
	pack_params = function (params)
		return
	end,
	unpack_params = function ()
		return {}
	end,
	evaluate = function (votes, duration_ended)
		if duration_ended then
			local num_total_votes = table.size(votes)
			local num_yes_votes = 0

			for _, option in pairs(votes) do
				if option == OPTIONS.yes then
					num_yes_votes = num_yes_votes + 1
				end
			end

			if num_yes_votes > num_total_votes * 0.5 then
				return RESULTS.approved
			else
				return RESULTS.rejected
			end
		else
			return nil
		end
	end,
	complete_vote = function (votes)
		local num_total_votes = table.size(votes)
		local num_yes_votes = 0

		for _, option in pairs(votes) do
			if option == OPTIONS.yes then
				num_yes_votes = num_yes_votes + 1
			end
		end

		if num_yes_votes > num_total_votes * 0.5 then
			return RESULTS.approved
		else
			return RESULTS.rejected
		end
	end,
	network_interface = function ()
		return Managers.connection
	end,
	on_started = function (voting_id, template, params)
		if DEDICATED_SERVER then
			return
		end

		Log.info("EXPEDITION_CONTINUE_VOTING", "voting_started: %s", voting_id)
		Managers.event:trigger("event_on_continue_vote_start", voting_id)
	end,
	on_completed = function (voting_id, template, params, result)
		if DEDICATED_SERVER then
			if result == RESULTS.approved then
				Log.info("EXPEDITION_CONTINUE_VOTING", "PARTY MERGE APPROVED")
			elseif result == RESULTS.rejected then
				Log.info("EXPEDITION_CONTINUE_VOTING", "PARTY MERGE REJECTED")
			end
		end

		Log.info("EXPEDITION_CONTINUE_VOTING", "voting_completed: %s, result: %s", voting_id, result)
		Managers.event:trigger("event_on_continue_vote_completed", result)
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		return
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
		if DEDICATED_SERVER then
			return
		end

		Log.info("EXPEDITION_CONTINUE_VOTING", "vote_casted %s voter_peer_id:%s voter_peer_id:%s", voting_id, voter_peer_id, voter_peer_id)
		Managers.event:trigger("event_on_continue_vote_casted", voter_peer_id, vote_option)
	end,
}

return voting_template
