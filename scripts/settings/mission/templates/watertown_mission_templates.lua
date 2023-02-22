local mission_templates = {
	dm_stockpile = {
		mission_name = "loc_mission_name_dm_stockpile",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/dm_stockpile_small",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_stockpile_01",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/dm_stockpile_medium",
		texture_big = "content/ui/textures/missions/dm_stockpile_big",
		objectives = "dm_stockpile",
		coordinates = "loc_mission_coordinates_dm_stockpile",
		level = "content/levels/watertown/missions/mission_dm_stockpile",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		mission_type = "05",
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
		circumstances = {
			more_resistance_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			ventilation_purge_01 = true
		},
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
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	hm_cartel = {
		mission_name = "loc_mission_name_hm_cartel",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/hm_cartel_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_cartel_01",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/hm_cartel_medium",
		texture_big = "content/ui/textures/missions/hm_cartel_big",
		objectives = "hm_cartel",
		coordinates = "loc_mission_coordinates_hm_cartel",
		level = "content/levels/watertown/missions/mission_hm_cartel",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 25,
		mission_type = "06",
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
		circumstances = {
			more_resistance_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			ventilation_purge_01 = true
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
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	km_enforcer = {
		mission_name = "loc_mission_name_km_enforcer",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/km_enforcer_small",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_enforcer_01",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/km_enforcer_medium",
		texture_big = "content/ui/textures/missions/km_enforcer_big",
		objectives = "km_enforcer",
		coordinates = "loc_mission_coordinates_km_enforcer",
		level = "content/levels/watertown/missions/mission_km_enforcer",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		mission_type = "02",
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
		circumstances = {
			more_resistance_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			ventilation_purge_01 = true
		},
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
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	}
}

return mission_templates
