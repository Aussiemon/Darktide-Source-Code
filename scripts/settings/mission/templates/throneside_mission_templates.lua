-- chunkname: @scripts/settings/mission/templates/throneside_mission_templates.lua

local mission_templates = {
	cm_archives = {
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/throneside/missions/mission_cm_archives",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_cm_archives_01",
		mission_description = "loc_mission_board_main_objective_archives_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_cm_archives",
		mission_type = "espionage",
		objectives = "cm_archives",
		texture_big = "content/ui/textures/missions/cm_archives_big",
		texture_medium = "content/ui/textures/missions/cm_archives_medium",
		texture_small = "content/ui/textures/missions/cm_archives_small",
		wwise_state = "zone_5",
		zone_id = "throneside",
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
		testify_flags = {},
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
		dialogue_settings = {
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		spawn_settings = {
			next_mission = "recent_mission"
		},
		controllable_object_set_prefixes = {
			"flow"
		}
	},
	fm_resurgence = {
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/throneside/missions/mission_fm_resurgence",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_resurgence_01",
		mission_description = "loc_mission_board_main_objective_resurgence_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_fm_resurgence",
		mission_type = "strike",
		objectives = "fm_resurgence",
		texture_big = "content/ui/textures/missions/fm_resurgence_big",
		texture_medium = "content/ui/textures/missions/fm_resurgence_medium",
		texture_small = "content/ui/textures/missions/fm_resurgence_small",
		wwise_state = "zone_5",
		zone_id = "throneside",
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
			vo_profile = "boon_vendor_s",
			wwise_route_key = 1,
			mission_giver_packs = {
				boon_vendor_s = {
					"shipmistress",
					"boon_vendor",
					"tertium_noble",
					briefing_voice_order = {
						"boon_vendor_s",
						"tertium_noble_male_s",
						"shipmistress_s",
						"tertium_noble_male_s",
						"boon_vendor_s",
						"tertium_noble_male_s"
					},
					skip_voices = {
						boon_vendor_a = true,
						tertium_noble_a = true,
						tertium_noble_b = true
					}
				}
			},
			vo_events = {
				"mission_resurgence_brief_pre_a",
				"mission_resurgence_brief_pre_b",
				"mission_resurgence_brief_pre_c",
				"mission_resurgence_brief_a",
				"mission_resurgence_brief_b",
				"mission_resurgence_brief_c"
			}
		},
		dialogue_settings = {
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		spawn_settings = {
			next_mission = "recent_mission"
		},
		controllable_object_set_prefixes = {
			"flow"
		}
	},
	hm_complex = {
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/throneside/missions/mission_hm_complex",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_complex_01",
		mission_description = "loc_mission_board_main_objective_complex_description",
		mission_intro_minimum_time = 25,
		mission_name = "loc_mission_name_hm_complex",
		mission_type = "espionage",
		objectives = "hm_complex",
		texture_big = "content/ui/textures/missions/hm_complex_big",
		texture_medium = "content/ui/textures/missions/hm_complex_medium",
		texture_small = "content/ui/textures/missions/hm_complex_small",
		wwise_state = "zone_5",
		zone_id = "throneside",
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
		dialogue_settings = {
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		spawn_settings = {
			next_mission = "recent_mission"
		},
		controllable_object_set_prefixes = {
			"flow"
		}
	}
}

return mission_templates
