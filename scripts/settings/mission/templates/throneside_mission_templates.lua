local mission_templates = {
	fm_resurgence = {
		mission_name = "loc_mission_name_fm_resurgence",
		wwise_state = "zone_5",
		zone_id = "throneside",
		texture_small = "content/ui/textures/missions/fm_resurgence_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_resurgence_01",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/fm_resurgence_medium",
		texture_big = "content/ui/textures/missions/fm_resurgence_big",
		objectives = "fm_resurgence",
		coordinates = "loc_mission_coordinates_fm_resurgence",
		level = "content/levels/throneside/missions/mission_fm_resurgence",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		mission_type = "05",
		mission_description = "loc_mission_board_main_objective_resurgence_description",
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
			explosion = 0.2,
			fire = 0.2,
			none = 0.5
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_fm_resurgence"
		},
		circumstances = {
			more_resistance_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			ventilation_purge_01 = true
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_resurgence_brief_a",
				"mission_resurgence_brief_b",
				"mission_resurgence_brief_c"
			}
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	hm_complex = {
		mission_name = "loc_mission_name_hm_complex",
		wwise_state = "zone_5",
		zone_id = "throneside",
		texture_small = "content/ui/textures/missions/hm_complex_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_complex_01",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/missions/hm_complex_medium",
		texture_big = "content/ui/textures/missions/hm_complex_big",
		objectives = "hm_complex",
		coordinates = "loc_mission_coordinates_hm_complex",
		level = "content/levels/throneside/missions/mission_hm_complex",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 25,
		mission_type = "06",
		mission_description = "loc_mission_board_main_objective_complex_description",
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
			explosion = 0.2,
			fire = 0.2,
			none = 0.5
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_hm_complex"
		},
		circumstances = {
			more_resistance_01 = true,
			hunting_grounds_01 = true,
			less_resistance_01 = true,
			assault_01 = true,
			ventilation_purge_01 = true
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_complex_brief_a",
				"mission_complex_brief_b",
				"mission_complex_brief_c"
			}
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	}
}

return mission_templates
