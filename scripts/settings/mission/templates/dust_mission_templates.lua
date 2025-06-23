-- chunkname: @scripts/settings/mission/templates/dust_mission_templates.lua

local mission_templates = {
	lm_scavenge = {
		mission_name = "loc_mission_name_lm_scavenge",
		wwise_state = "zone_4",
		zone_id = "dust",
		texture_small = "content/ui/textures/pj_missions/lm_scavenge_small",
		mechanism_name = "adventure",
		texture_medium = "content/ui/textures/pj_missions/lm_scavenge_medium",
		face_state_machine_key = "state_machine_missions",
		mission_description = "loc_mission_board_main_objective_scavenge_description",
		texture_big = "content/ui/textures/pj_missions/lm_scavenge_big",
		coordinates = "loc_mission_coordinates_lm_scavenge",
		mission_type = "investigation",
		level = "content/levels/dust/missions/mission_lm_scavenge",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "lm_scavenge",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_lm_scavenge_01",
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
		terror_event_templates = {
			"terror_events_lm_scavenge"
		},
		health_station = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_scavenge_briefing_one",
				"mission_scavenge_briefing_two",
				"mission_scavenge_briefing_three"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		testify_flags = {},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	dm_propaganda = {
		mission_name = "loc_mission_name_dm_propaganda",
		wwise_state = "zone_4",
		zone_id = "dust",
		texture_small = "content/ui/textures/pj_missions/dm_propaganda_small",
		texture_medium = "content/ui/textures/pj_missions/dm_propaganda_medium",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		mission_description = "loc_mission_board_main_objective_propaganda_description",
		texture_big = "content/ui/textures/pj_missions/dm_propaganda_big",
		coordinates = "loc_mission_coordinates_dm_propaganda",
		mission_type = "disruption",
		level = "content/levels/dust/missions/mission_dm_propaganda",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "dm_propaganda",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_propaganda_01",
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
			"terror_events_dm_propaganda"
		},
		mission_brief_vo = {
			vo_profile = "explicator_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_propaganda_briefing_a",
				"mission_propaganda_briefing_b",
				"mission_propaganda_briefing_c"
			},
			mission_giver_packs = {
				explicator_a = {
					"explicator",
					"dreg_lector"
				},
				sergeant_a = {
					"sergeant",
					"pilot"
				},
				tech_priest_a = {
					"tech_priest",
					"pilot"
				},
				pilot_a = {
					"pilot"
				}
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		testify_flags = {},
		health_station = {},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	hm_strain = {
		mission_name = "loc_mission_name_hm_strain",
		wwise_state = "zone_4",
		mission_description = "loc_mission_board_main_objective_strain_description",
		texture_small = "content/ui/textures/pj_missions/hm_strain_small",
		mechanism_name = "adventure",
		texture_medium = "content/ui/textures/pj_missions/hm_strain_medium",
		face_state_machine_key = "state_machine_missions",
		zone_id = "dust",
		texture_big = "content/ui/textures/pj_missions/hm_strain_big",
		coordinates = "loc_mission_coordinates_hm_strain",
		mission_type = "disruption",
		level = "content/levels/dust/missions/mission_hm_strain",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "hm_strain",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_strain_01",
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
			"terror_events_hm_strain"
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_strain_briefing_a",
				"mission_strain_briefing_b",
				"mission_strain_briefing_c"
			},
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
					"tech_priest"
				},
				tech_priest_a = {
					"tech_priest"
				},
				pilot_a = {
					"tech_priest",
					"pilot"
				},
				sergeant_b = {
					"sergeant",
					"dreg_lector"
				}
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
