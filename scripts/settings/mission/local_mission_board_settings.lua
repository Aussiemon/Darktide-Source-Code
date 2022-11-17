local local_mission_board_settings = {
	refresh_time = 120,
	time_between_missions_popping_in = 5,
	mission_alive_time = 90,
	missions = {
		{
			resistance = 3,
			credits = 1000,
			xp = 700,
			circumstance = "assault_01",
			challenge = 2,
			required_level = 1,
			mission = "fm_cargo",
			flags = {
				altered = true
			}
		},
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
		},
		{
			resistance = 2,
			credits = 400,
			xp = 400,
			circumstance = "default",
			challenge = 2,
			required_level = 1,
			mission = "cm_habs",
			flags = {
				flash = true
			}
		},
		{
			resistance = 1,
			credits = 100,
			xp = 200,
			circumstance = "default",
			required_level = 1,
			challenge = 1,
			mission = "dm_stockpile"
		},
		{
			resistance = 4,
			credits = 800,
			xp = 600,
			circumstance = "heretical_disruption_01",
			challenge = 4,
			required_level = 5,
			mission = "lm_scavenge",
			flags = {
				altered = true,
				flash = true
			}
		},
		{
			resistance = 5,
			credits = 2500,
			xp = 1000,
			circumstance = "heretical_disruption_01",
			challenge = 5,
			required_level = 5,
			mission = "hm_cartel",
			flags = {
				altered = true
			}
		},
		{
			resistance = 1,
			credits = 100,
			xp = 200,
			required_level = 1,
			challenge = 1,
			mission = "km_station"
		}
	},
	happening_name = "Happy Happy Test Happening",
	happening_cirucumstances = {
		"darkness_01",
		"heretical_disruption_01"
	}
}

return settings("LocalMissionBoardSettings", local_mission_board_settings)
