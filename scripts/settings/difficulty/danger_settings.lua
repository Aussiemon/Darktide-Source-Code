local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local DangerSettings = {
	by_index = {
		{
			index = 1,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_lowest"
		},
		{
			index = 2,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_low"
		},
		{
			index = 3,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_medium"
		},
		{
			index = 4,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_high"
		},
		{
			index = 5,
			expected_resistance = 4,
			display_name = "loc_mission_board_danger_highest"
		}
	},
	calculate_danger = function (challenge, resistance)
		return challenge
	end,
	required_level_by_mission_type = function (index, mission_type)
		if not mission_type or not PlayerProgressionUnlocks.mission_difficulty_unlocks[mission_type] then
			mission_type = "normal"
		end

		return PlayerProgressionUnlocks.mission_difficulty_unlocks[mission_type][index] or 1
	end
}

return settings("DangerSettings", DangerSettings)
