-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local new_hub_session_voting_template_immaterium = {
	voting_impl = "party_immaterium",
	name = "new_hub_session_immaterium",
	immaterium_party_vote_type = "",
	required_params = {},
	static_params = {},
	on_started = function (voting_id, template, params)
		Managers.voting:cast_vote(voting_id, "yes"):catch(function (error)
			if type(error) == "string" then
				Log.error("could not cast vote " .. error)
			else
				Log.error("could not cast vote " .. table.tostring(error, 5))
			end
		end)
	end,
	on_completed = function (voting_id, template, vote_state, result)
		if result == "approved" and Managers.presence:presence() == "hub" then
			Managers.party_immaterium:latched_hub_server_matchmaking():next(function (hub_session_id)
				Managers.multiplayer_session:party_immaterium_hot_join_hub_server(hub_session_id)
			end):catch(function (error)
				Log.error("could not join hub server after vote " .. table.tostring(error, 5))
			end)
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-1, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-1, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end
}

return new_hub_session_voting_template_immaterium
