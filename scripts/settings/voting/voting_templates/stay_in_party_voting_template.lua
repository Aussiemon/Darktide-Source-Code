local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "rejected")
local stay_in_party_voting_template = {
	name = "stay_in_party",
	can_change_vote = true,
	duration = 600,
	rpc_start_voting = "rpc_start_voting_stay_in_party",
	abort_on_member_left = false,
	voting_impl = "network",
	abort_on_member_joined = false,
	options = {
		OPTIONS.yes,
		OPTIONS.no
	},
	results = {
		RESULTS.approved
	},
	timeout_option = OPTIONS.no,
	required_params = {
		"new_party_id"
	},
	pack_params = function (params)
		return params.new_party_id
	end,
	unpack_params = function (new_party_id)
		return {
			new_party_id = new_party_id
		}
	end,
	evaluate = function (votes)
		return nil
	end,
	complete_vote = function (votes)
		for _, option in pairs(votes) do
			if option == StrictNil or option == OPTIONS.no then
				return RESULTS.rejected
			end
		end

		return RESULTS.approved
	end,
	network_interface = function ()
		return Managers.connection
	end
}

stay_in_party_voting_template.on_started = function (voting_id, template, params)
	if DEDICATED_SERVER then
		return
	end

	local new_party_id = params.new_party_id

	Log.info("STAY_IN_PARTY_VOTING", "voting_started: %s, new_party_id %s", voting_id, new_party_id)
	Managers.event:trigger("event_stay_in_party_voting_started", voting_id, new_party_id)
end

stay_in_party_voting_template.on_completed = function (voting_id, template, params, result)
	if DEDICATED_SERVER then
		if result == RESULTS.approved then
			Log.info("STAY_IN_PARTY_VOTING", "PARTY MERGE APPROVED")
		elseif result == RESULTS.rejected then
			Log.info("STAY_IN_PARTY_VOTING", "PARTY MERGE REJECTED")
		end

		return
	end

	Log.info("STAY_IN_PARTY_VOTING", "voting_completed: %s, result: %s", voting_id, result)
	Managers.event:trigger("event_stay_in_party_voting_completed", result)
end

stay_in_party_voting_template.on_aborted = function (voting_id, template, params, abort_reason)
	if DEDICATED_SERVER then
		return
	end

	Log.info("STAY_IN_PARTY_VOTING", "voting_aborted %s", voting_id)
	Managers.event:trigger("event_stay_in_party_voting_aborted")
end

stay_in_party_voting_template.on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
	if DEDICATED_SERVER then
		return
	end

	Log.info("STAY_IN_PARTY_VOTING", "vote_casted %s voter_peer_id:%s voter_peer_id:%s", voting_id, voter_peer_id, voter_peer_id)
	Managers.event:trigger("event_stay_in_party_vote_casted", voter_peer_id, vote_option)
end

return stay_in_party_voting_template
