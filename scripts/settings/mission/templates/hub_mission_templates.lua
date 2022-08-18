local mission_templates = {
	hub_ship = {
		zone_id = "hub",
		mission_name = "loc_mission_name_hub_ship",
		wwise_state = "hub",
		objectives = "hub",
		game_mode_name = "hub",
		is_hub = true,
		mechanism_name = "hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		level = "content/levels/hub/hub_ship/missions/hub_ship",
		gameplay_modifiers = {
			"unkillable",
			"invulnerable"
		},
		cinematics = {
			cutscene_9 = {
				"cs_09"
			}
		},
		testify_flags = {
			run_through_mission = false,
			screenshots = true,
			performance = true,
			mission_server = false
		},
		dialogue_settings = {
			story_ticker_enabled = false,
			story_start_delay = 10,
			npc_story_ticker_start_delay = 240,
			short_story_ticker_enabled = false,
			npc_story_ticker_enabled = true
		}
	}
}

return mission_templates
