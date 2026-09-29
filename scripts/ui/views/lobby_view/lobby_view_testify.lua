-- chunkname: @scripts/ui/views/lobby_view/lobby_view_testify.lua

local LobbyViewTestify = {
	lobby_set_ready_status = function (lobby_view, is_ready)
		Log.info("Testify", "Setting local player ready status to %s", is_ready)
		lobby_view:set_own_player_ready_status(is_ready)

		if lobby_view:_own_player_ready_status() ~= true then
			return Testify.RETRY
		end
	end,
	accept_mission_board_vote = function ()
		if GameParameters.network_wan then
			return Testify.RETRY
		end
	end
}

return LobbyViewTestify
