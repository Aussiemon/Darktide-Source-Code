local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local DangerSettings = {
	by_index = {
		{
			index = 1,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_lowest",
			required_level = PlayerProgressionUnlocks.mission_difficulty_1
		},
		{
			index = 2,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_low",
			required_level = PlayerProgressionUnlocks.mission_difficulty_2
		},
		{
			index = 3,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_medium",
			required_level = PlayerProgressionUnlocks.mission_difficulty_3
		},
		{
			index = 4,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_high",
			required_level = PlayerProgressionUnlocks.mission_difficulty_4
		},
		{
			index = 5,
			expected_resistance = 4,
			display_name = "loc_mission_board_danger_highest",
			required_level = PlayerProgressionUnlocks.mission_difficulty_5
		}
	},
	calculate_danger = function (challenge, resistance)
		return challenge
	end
}

return settings("DangerSettings", DangerSettings)
