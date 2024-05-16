-- chunkname: @scripts/settings/difficulty/danger_settings.lua

local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local DangerSettings = {
	by_index = {
		{
			display_name = "loc_mission_board_danger_lowest",
			expected_resistance = 2,
			index = 1,
			color = {
				255,
				169,
				211,
				158,
			},
		},
		{
			display_name = "loc_mission_board_danger_low",
			expected_resistance = 2,
			index = 2,
			color = {
				255,
				169,
				211,
				158,
			},
		},
		{
			display_name = "loc_mission_board_danger_medium",
			expected_resistance = 3,
			index = 3,
			color = {
				255,
				228,
				189,
				81,
			},
		},
		{
			display_name = "loc_mission_board_danger_high",
			expected_resistance = 3,
			index = 4,
			color = {
				255,
				228,
				189,
				81,
			},
		},
		{
			display_name = "loc_mission_board_danger_highest",
			expected_resistance = 4,
			index = 5,
			color = {
				255,
				233,
				84,
				84,
			},
		},
	},
}

DangerSettings.calculate_danger = function (challenge, resistance)
	return challenge
end

DangerSettings.required_level_by_mission_type = function (index, mission_type)
	if not mission_type or not PlayerProgressionUnlocks.mission_difficulty_unlocks[mission_type] then
		mission_type = "normal"
	end

	return PlayerProgressionUnlocks.mission_difficulty_unlocks[mission_type][index] or 1
end

return settings("DangerSettings", DangerSettings)
