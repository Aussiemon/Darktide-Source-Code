local Promise = require("scripts/foundation/utilities/promise")
local internal_vote_mission_matchmaking_immaterium = {
	voting_impl = "party_immaterium",
	name = "internal_vote_mission_matchmaking_immaterium",
	immaterium_party_vote_type = "start_matchmaking",
	required_params = {
		"backend_mission_id"
	},
	static_params = {
		matchmaker_type = "mission"
	},
	on_started = function (voting_id, template, params)
		if not Managers.voting:has_voted(voting_id, Managers.party_immaterium:get_myself():unique_id()) then
			Managers.voting:cast_vote(voting_id, "yes")
		end
	end,
	on_completed = function (voting_id, template, vote_state, result)
		if result == "rejected" then
			Log.info("internal_vote_mission_matchmaking_immaterium", "vote was rejected")
		end
	end,
	fetch_my_vote_params = function (template, params, option)
		if option == "yes" then
			local profile = Managers.player:local_player_backend_profile()
			local character_id = profile and profile.character_id

			return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_mission(params.backend_mission_id, character_id):next(function (response)
				return {
					ticket = response.ticket
				}
			end)
		else
			return Promise.resolved({})
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		return
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
		return
	end
}

return internal_vote_mission_matchmaking_immaterium
