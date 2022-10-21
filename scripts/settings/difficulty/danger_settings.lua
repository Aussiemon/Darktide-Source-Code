local DangerSettings = {
	by_index = {
		{
			index = 1,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_lowest",
			required_level = 1
		},
		{
			index = 2,
			expected_resistance = 2,
			display_name = "loc_mission_board_danger_low",
			required_level = 1
		},
		{
			index = 3,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_medium",
			required_level = 1
		},
		{
			index = 4,
			expected_resistance = 3,
			display_name = "loc_mission_board_danger_high",
			required_level = 6
		},
		{
			index = 5,
			expected_resistance = 4,
			display_name = "loc_mission_board_danger_highest",
			required_level = 12
		}
	},
	calculate_danger = function (challenge, resistance)
		return challenge
	end
}

return settings("DangerSettings", DangerSettings)
