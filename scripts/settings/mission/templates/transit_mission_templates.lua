local mission_templates = {
	cm_habs = {
		mission_name = "loc_mission_name_cm_habs",
		wwise_state = "zone_1",
		zone_id = "transit",
		texture_small = "content/ui/textures/missions/cm_habs_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_cm_habs_01",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/cm_habs_medium",
		texture_big = "content/ui/textures/missions/cm_habs_big",
		objectives = "cm_habs",
		coordinates = "loc_mission_coordinates_cm_habs",
		level = "content/levels/transit/missions/mission_cm_habs",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 25,
		mission_type = "03",
		mission_description = "loc_mission_board_main_objective_habblock_description",
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
			"terror_events_cm_habs"
		},
		circumstances = {
			more_resistance_01 = true,
			ventilation_purge_with_snipers_01 = true,
			ventilation_purge_01 = true,
			ventilation_purge_with_snipers_less_resistance_01 = true,
			ventilation_purge_with_snipers_more_resistance_01 = true,
			darkness_less_resistance_01 = true,
			darkness_hunting_grounds_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			darkness_more_resistance_01 = true
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_brief_control_mission_one",
				"mission_brief_control_mission_two",
				"mission_brief_control_mission_three"
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
	lm_rails = {
		mission_name = "loc_mission_name_lm_rails",
		wwise_state = "zone_1",
		zone_id = "transit",
		texture_small = "content/ui/textures/missions/lm_rails_small",
		objectives = "lm_rails",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_lm_rails_01",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/lm_rails_medium",
		texture_big = "content/ui/textures/missions/lm_rails_big",
		mechanism_name = "adventure",
		coordinates = "loc_mission_coordinates_lm_rails",
		level = "content/levels/transit/missions/mission_lm_rails",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		mission_type = "01",
		mission_description = "loc_mission_board_main_objective_rails_description",
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
			"terror_events_lm_rails"
		},
		health_station = {},
		circumstances = {
			more_resistance_01 = true,
			ventilation_purge_with_snipers_01 = true,
			ventilation_purge_01 = true,
			ventilation_purge_with_snipers_less_resistance_01 = true,
			ventilation_purge_with_snipers_more_resistance_01 = true,
			darkness_less_resistance_01 = true,
			darkness_hunting_grounds_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			darkness_more_resistance_01 = true
		},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_rails_briefing_a",
				"mission_rails_briefing_b",
				"mission_rails_briefing_c"
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
	km_station = {
		mission_name = "loc_mission_name_km_station",
		wwise_state = "zone_1",
		zone_id = "transit",
		texture_small = "content/ui/textures/missions/km_station_small",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_station_01",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/km_station_medium",
		texture_big = "content/ui/textures/missions/km_station_big",
		objectives = "km_station",
		coordinates = "loc_mission_coordinates_km_station",
		level = "content/levels/transit/missions/mission_km_station",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		mission_type = "02",
		mission_description = "loc_mission_board_main_objective_trainstation_description",
		cinematics = {
			intro_abc = {
				"c_cam"
			},
			outro_fail = {
				"outro_fail"
			},
			outro_win = {
				"outro_win"
			},
			traitor_captain_intro = {
				"traitor_captain_intro"
			}
		},
		pickup_settings = {},
		health_station = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		terror_event_templates = {
			"terror_events_km_station"
		},
		circumstances = {
			more_resistance_01 = true,
			ventilation_purge_with_snipers_01 = true,
			ventilation_purge_01 = true,
			ventilation_purge_with_snipers_less_resistance_01 = true,
			ventilation_purge_with_snipers_more_resistance_01 = true,
			darkness_less_resistance_01 = true,
			darkness_hunting_grounds_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			darkness_01 = true,
			darkness_more_resistance_01 = true
		},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "explicator_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_station_briefing_a",
				"mission_station_briefing_b",
				"mission_station_briefing_c"
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
