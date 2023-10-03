local GameModeManagerTestify = {}

GameModeManagerTestify.complete_game_mode = function (game_mode_manager)
	game_mode_manager:complete_game_mode()
end

GameModeManagerTestify.end_conditions_met = function (game_mode_manager)
	return game_mode_manager:end_conditions_met()
end

GameModeManagerTestify.end_conditions_met_outcome = function (game_mode_manager)
	return game_mode_manager:end_conditions_met_outcome()
end

return GameModeManagerTestify
