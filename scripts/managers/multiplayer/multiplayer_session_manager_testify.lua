-- chunkname: @scripts/managers/multiplayer/multiplayer_session_manager_testify.lua

local MultiplayerSessionManagerTestify = {
	exit_to_main_menu = function (multiplayer_session_manager)
		multiplayer_session_manager:leave("exit_to_main_menu")
	end
}

return MultiplayerSessionManagerTestify
