-- chunkname: @scripts/managers/voting/voting_by_immaterium_party_impl_testify.lua

local VotingManagerImmateriumPartyTestify = {
	accept_vote = function (voting_manager_immaterium_party)
		local current_vote = voting_manager_immaterium_party:current_vote()
		local voting_id = current_vote.id

		Managers.voting:cast_vote(voting_id, "yes")
	end,
	wait_for_ongoing_vote = function (voting_manager_immaterium_party)
		if not voting_manager_immaterium_party:current_vote().state == "ONGOING" then
			return Testify.RETRY
		end
	end,
}

return VotingManagerImmateriumPartyTestify
