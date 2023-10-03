local MissionVotingViewTestify = {}

MissionVotingViewTestify.accept_mission_board_vote = function (mission_voting_view)
	mission_voting_view:cb_on_accept_mission_pressed()
end

return MissionVotingViewTestify
