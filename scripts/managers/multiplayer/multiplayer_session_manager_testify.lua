local MultiplayerSessionManagerTestify = {
	exit_to_main_menu = function (_, multiplayer_session_manager)
		multiplayer_session_manager:leave("exit_to_main_menu")
	end
}

return MultiplayerSessionManagerTestify
