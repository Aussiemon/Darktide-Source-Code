local presence_settings = {
	splash_screen = {
		hud_localization = "loc_hud_presence_main_menu"
	},
	title_screen = {
		hud_localization = "loc_hud_presence_main_menu"
	},
	main_menu = {
		hud_localization = "loc_hud_presence_main_menu"
	},
	loading = {
		hud_localization = "loc_hud_presence_loading"
	},
	prologue = {
		hud_localization = "loc_hud_presence_prologue"
	},
	hub = {
		hud_localization = "loc_hud_presence_hub"
	},
	mission = {
		hud_localization = "loc_hud_presence_mission"
	},
	end_of_round = {
		hud_localization = "loc_hud_presence_end_of_round"
	}
}

return settings("PresenceSettings", presence_settings)
