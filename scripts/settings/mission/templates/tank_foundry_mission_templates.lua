local mission_templates = {
	lm_cooling = {
		mission_name = "loc_mission_name_lm_cooling",
		wwise_state = "zone_3",
		zone_id = "tank_foundry",
		texture_small = "content/ui/textures/missions/lm_cooling_small",
		texture_medium = "content/ui/textures/missions/lm_cooling_medium",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		coordinates = "loc_mission_coordinates_lm_cooling",
		texture_big = "content/ui/textures/missions/lm_cooling_big",
		mission_type_name = "loc_mission_type_07_name",
		level = "content/levels/tank_foundry/missions/mission_lm_cooling",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 30,
		objectives = "lm_cooling",
		mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_07",
		mission_description = "loc_mission_board_main_objective_cooling_description",
		cinematics = {
			intro_abc = {
				"c_cam"
			},
			outro_fail = {
				"outro_fail"
			},
			outro_win = {
				"outro_win"
			}
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_lm_cooling"
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_cooling_briefing_one",
				"mission_cooling_briefing_two",
				"mission_cooling_briefing_three"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		}
	},
	dm_forge = {
		mission_name = "loc_mission_name_dm_forge",
		wwise_state = "zone_3",
		mechanism_name = "adventure",
		texture_small = "content/ui/textures/missions/dm_forge_small",
		texture_medium = "content/ui/textures/missions/dm_forge_medium",
		zone_id = "tank_foundry",
		face_state_machine_key = "state_machine_missions",
		coordinates = "loc_mission_coordinates_dm_forge",
		texture_big = "content/ui/textures/missions/dm_forge_big",
		mission_type_name = "loc_mission_type_05_name",
		level = "content/levels/tank_foundry/missions/mission_dm_forge",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "dm_forge",
		mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_05",
		mission_description = "loc_mission_board_main_objective_darkforge_description",
		cinematics = {
			intro_abc = {
				"c_cam"
			},
			outro_fail = {
				"outro_fail"
			},
			outro_win = {
				"outro_win"
			}
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_dm_forge"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_forge_briefing_a",
				"mission_forge_briefing_b",
				"mission_forge_briefing_c"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		testify_flags = {}
	}
}

return mission_templates
