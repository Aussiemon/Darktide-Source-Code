-- chunkname: @scripts/settings/voting/voting_templates/new_hub_session_voting_template_immaterium.lua

local new_hub_session_voting_template_immaterium = {
	voting_impl = "party_immaterium",
	name = "new_hub_session_immaterium",
	immaterium_party_vote_type = "",
	required_params = {},
	static_params = {},
	on_started = function (voting_id, template, params)
		Managers.voting:cast_vote(voting_id, "yes"):catch(function (error)
			if type(error) == "string" then
				Log.error("could not cast vote %s", error)
			else
				Log.error("could not cast vote %s", table.tostring(error, 5))
			end
		end)
	end,
	on_completed = function (voting_id, template, vote_state, result)
		if result == "approved" and Managers.presence:presence() == "hub" then
			Managers.party_immaterium:latched_hub_server_matchmaking():next(function ()
				Managers.multiplayer_session:party_immaterium_hot_join_hub_server()
			end):catch(function (error)
				Log.error("could not join hub server after vote %s", table.tostring(error, 5))
			end)
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		return
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
		return
	end
}

return new_hub_session_voting_template_immaterium
