local VotingManagerImmateriumPartyTestify = {
	wait_for_ongoing_vote = function (_, voting_manager_immaterium_party)
		if not voting_manager_immaterium_party:_current_vote().state == "ONGOING" then
			return Testify.RETRY
		end
	end,
	accept_vote = function (_, voting_manager_immaterium_party)
		local current_vote = voting_manager_immaterium_party:current_vote()
		local voting_id = current_vote.id

		Managers.voting:cast_vote(voting_id, "yes")
	end
}

return VotingManagerImmateriumPartyTestify
