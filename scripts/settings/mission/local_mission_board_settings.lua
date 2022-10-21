local local_mission_board_settings = {
	refresh_time = 120,
	time_between_missions_popping_in = 5,
	mission_alive_time = 90,
	missions = {
		{
			resistance = 1,
			credits = 500,
			xp = 600,
			circumstance = "default",
			required_level = 1,
			challenge = 2,
			mission = "lm_cooling"
		},
		{
			resistance = 2,
			credits = 800,
			xp = 600,
			circumstance = "heretical_disruption_01",
			challenge = 4,
			required_level = 1,
			mission = "dm_forge",
			flags = {
				altered = true
			}
		}
	},
	happening_name = "Happy Happy Test Happening",
	happening_cirucumstances = {
		"darkness_01",
		"heretical_disruption_01"
	}
}

return settings("LocalMissionBoardSettings", local_mission_board_settings)
