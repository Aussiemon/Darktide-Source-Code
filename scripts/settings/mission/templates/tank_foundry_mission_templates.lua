-- chunkname: @scripts/settings/mission/templates/tank_foundry_mission_templates.lua

local mission_templates = {
	lm_cooling = {
		mission_name = "loc_mission_name_lm_cooling",
		wwise_state = "zone_3",
		zone_id = "tank_foundry",
		texture_small = "content/ui/textures/pj_missions/lm_cooling_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_lm_cooling_01",
		texture_medium = "content/ui/textures/pj_missions/lm_cooling_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/pj_missions/lm_cooling_big",
		coordinates = "loc_mission_coordinates_lm_cooling",
		mission_type = "repair",
		level = "content/levels/tank_foundry/missions/mission_lm_cooling",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 30,
		objectives = "lm_cooling",
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
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	dm_forge = {
		mission_name = "loc_mission_name_dm_forge",
		wwise_state = "zone_3",
		mission_description = "loc_mission_board_main_objective_darkforge_description",
		texture_small = "content/ui/textures/pj_missions/dm_forge_small",
		mechanism_name = "adventure",
		texture_medium = "content/ui/textures/pj_missions/dm_forge_medium",
		face_state_machine_key = "state_machine_missions",
		zone_id = "tank_foundry",
		texture_big = "content/ui/textures/pj_missions/dm_forge_big",
		coordinates = "loc_mission_coordinates_dm_forge",
		mission_type = "repair",
		level = "content/levels/tank_foundry/missions/mission_dm_forge",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "dm_forge",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_forge_01",
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
			vo_profile = "tech_priest_b",
			wwise_route_key = 1,
			mission_giver_packs = {
				explicator_a = {
					"explicator",
					"tech_priest"
				},
				sergeant_a = {
					"sergeant",
					"tech_priest"
				},
				tech_priest_a = {
					"tech_priest"
				},
				tech_priest_b = {
					"tech_priest",
					"enginseer",
					"enemy_nemesis_wolfer",
					"enemy_wolfer_adjutant"
				}
			},
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
		testify_flags = {},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	},
	fm_cargo = {
		mission_name = "loc_mission_name_fm_cargo",
		wwise_state = "zone_3",
		mission_description = "loc_mission_board_main_objective_cargo_description",
		texture_small = "content/ui/textures/pj_missions/fm_cargo_small",
		mechanism_name = "adventure",
		texture_medium = "content/ui/textures/pj_missions/fm_cargo_medium",
		face_state_machine_key = "state_machine_missions",
		zone_id = "tank_foundry",
		texture_big = "content/ui/textures/pj_missions/fm_cargo_big",
		coordinates = "loc_mission_coordinates_fm_cargo",
		mission_type = "raid",
		level = "content/levels/tank_foundry/missions/mission_fm_cargo",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "fm_cargo",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_cargo_01",
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
			"terror_events_fm_cargo"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			mission_giver_packs = {
				explicator_a = {
					"explicator",
					"tech_priest",
					"pilot"
				},
				sergeant_a = {
					"sergeant",
					"tech_priest",
					"pilot"
				},
				tech_priest_a = {
					"tech_priest",
					"pilot"
				},
				tech_priest_b = {
					"tech_priest",
					"interrogator"
				}
			},
			vo_events = {
				"mission_cargo_briefing_a",
				"mission_cargo_briefing_b",
				"mission_cargo_briefing_c"
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
	}
}

return mission_templates
