-- chunkname: @scripts/settings/mission/templates/throneside_mission_templates.lua

local mission_templates = {
	cm_archives = {
		mission_name = "loc_mission_name_cm_archives",
		wwise_state = "zone_5",
		zone_id = "throneside",
		texture_small = "content/ui/textures/missions/cm_archives_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_cm_archives_01",
		texture_medium = "content/ui/textures/missions/cm_archives_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/cm_archives_big",
		coordinates = "loc_mission_coordinates_cm_archives",
		mission_type = "06",
		level = "content/levels/throneside/missions/mission_cm_archives",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "cm_archives",
		mission_description = "loc_mission_board_main_objective_archives_description",
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
		testify_flags = {
			run_through_mission = true
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_cm_archives"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_archives_brief_a",
				"mission_archives_brief_b",
				"mission_archives_brief_c"
			}
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	fm_resurgence = {
		mission_name = "loc_mission_name_fm_resurgence",
		wwise_state = "zone_5",
		zone_id = "throneside",
		texture_small = "content/ui/textures/missions/fm_resurgence_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_resurgence_01",
		texture_medium = "content/ui/textures/missions/fm_resurgence_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/fm_resurgence_big",
		coordinates = "loc_mission_coordinates_fm_resurgence",
		mission_type = "05",
		level = "content/levels/throneside/missions/mission_fm_resurgence",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "fm_resurgence",
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
		texture_medium = "content/ui/textures/missions/hm_complex_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/hm_complex_big",
		coordinates = "loc_mission_coordinates_hm_complex",
		mission_type = "06",
		level = "content/levels/throneside/missions/mission_hm_complex",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 25,
		objectives = "hm_complex",
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
