local LobbyViewTestify = {
	lobby_set_ready_status = function (is_ready, lobby_view)
		Log.info("Testify", "Setting local player ready status to %s", is_ready)
		lobby_view:set_own_player_ready_status(is_ready)

		if lobby_view:_own_player_ready_status() ~= true then
			return Testify.RETRY
		end
	end,
	accept_mission_board_vote = function (_, _)
		if GameParameters.network_wan then
			return Testify.RETRY
		end
	end
}

return LobbyViewTestify
