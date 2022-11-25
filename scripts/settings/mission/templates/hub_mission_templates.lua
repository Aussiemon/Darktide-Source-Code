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
		force_third_person_mode = true,
		level = "content/levels/hub/hub_ship/missions/hub_ship",
		gameplay_modifiers = {
			"unkillable",
			"invulnerable"
		},
		cinematics = {
			cutscene_9 = {
				"cs_09"
			},
			traitor_captain_intro = {
				"traitor_captain_intro"
			},
			path_of_trust_01 = {
				"path_of_trust_01_part_01",
				"path_of_trust_01_corridor_01",
				"path_of_trust_01_part_02"
			},
			path_of_trust_02 = {
				"path_of_trust_02_part_01",
				"path_of_trust_02_barracks",
				"path_of_trust_02_part_02"
			},
			path_of_trust_03 = {
				"path_of_trust_03_part_01",
				"path_of_trust_03_crafting_station",
				"path_of_trust_03_part_02"
			},
			path_of_trust_04 = {
				"path_of_trust_04_part_01",
				"path_of_trust_04_corridor_02",
				"path_of_trust_04_part_02"
			},
			path_of_trust_05 = {
				"path_of_trust_05_part_01",
				"path_of_trust_05_bar",
				"path_of_trust_05_part_02"
			},
			path_of_trust_06 = {
				"path_of_trust_06_hangar"
			},
			path_of_trust_07 = {
				"path_of_trust_07_part_01",
				"path_of_trust_07_barracks",
				"path_of_trust_07_part_02"
			},
			path_of_trust_08 = {
				"path_of_trust_08_part_01",
				"path_of_trust_08_corridor_01",
				"path_of_trust_08_part_02"
			},
			path_of_trust_09 = {
				"path_of_trust_09_office"
			}
		},
		testify_flags = {
			run_through_mission = false,
			screenshots = true,
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
