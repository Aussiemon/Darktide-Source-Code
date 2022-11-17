local mission_templates = {
	dm_stockpile = {
		mission_name = "loc_mission_name_dm_stockpile",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/dm_stockpile_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_stockpile_01",
		texture_medium = "content/ui/textures/missions/dm_stockpile_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/dm_stockpile_big",
		coordinates = "loc_mission_coordinates_dm_stockpile",
		mission_type = "05",
		level = "content/levels/watertown/missions/mission_dm_stockpile",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "dm_stockpile",
		mission_description = "loc_mission_board_main_objective_waterstockpile_description",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		terror_event_templates = {
			"terror_events_dm_stockpile"
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_stockpile_briefing_a",
				"mission_stockpile_briefing_b",
				"mission_stockpile_briefing_c"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		}
	},
	hm_cartel = {
		mission_name = "loc_mission_name_hm_cartel",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/hm_cartel_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_cartel_01",
		texture_medium = "content/ui/textures/missions/hm_cartel_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/hm_cartel_big",
		coordinates = "loc_mission_coordinates_hm_cartel",
		mission_type = "06",
		level = "content/levels/watertown/missions/mission_hm_cartel",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 25,
		objectives = "hm_cartel",
		mission_description = "loc_mission_board_main_objective_cartel_description",
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
			"terror_events_hm_cartel"
		},
		testify_flags = {
			screenshots = true
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "explicator_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_cartel_brief_one",
				"mission_cartel_brief_two",
				"mission_cartel_brief_three"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		}
	},
	km_enforcer = {
		mission_name = "loc_mission_name_km_enforcer",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/km_enforcer_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_enforcer_01",
		texture_medium = "content/ui/textures/missions/km_enforcer_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/km_enforcer_big",
		coordinates = "loc_mission_coordinates_km_enforcer",
		mission_type = "02",
		level = "content/levels/watertown/missions/mission_km_enforcer",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "km_enforcer",
		mission_description = "loc_mission_board_main_objective_enforcer_description",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		terror_event_templates = {
			"terror_events_km_enforcer"
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_enforcer_briefing_a",
				"mission_enforcer_briefing_b",
				"mission_enforcer_briefing_c"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		}
	}
}

return mission_templates
