-- chunkname: @scripts/managers/game_mode/game_mode_manager_testify.lua

local GameModeManagerTestify = {
	complete_game_mode = function (game_mode_manager)
		game_mode_manager:complete_game_mode()
	end,
	end_conditions_met = function (game_mode_manager)
		return game_mode_manager:end_conditions_met()
	end,
	end_conditions_met_outcome = function (game_mode_manager)
		return game_mode_manager:end_conditions_met_outcome()
	end,
}

return GameModeManagerTestify
