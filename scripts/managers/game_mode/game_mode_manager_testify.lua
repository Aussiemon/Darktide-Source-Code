local GameModeManagerTestify = {
	complete_game_mode = function (_, game_mode_manager)
		game_mode_manager:complete_game_mode()
	end,
	end_conditions_met = function (_, game_mode_manager)
		return game_mode_manager:end_conditions_met()
	end,
	end_conditions_met_outcome = function (_, game_mode_manager)
		return game_mode_manager:end_conditions_met_outcome()
	end
}

return GameModeManagerTestify
