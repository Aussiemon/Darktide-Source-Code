-- chunkname: @scripts/settings/mission/templates/operations_mission_templates.lua

local mission_templates = {
	op_train = {
		mission_name = "loc_mission_name_op_train",
		mission_type = "operations",
		texture_small = "content/ui/textures/pj_missions/op_train_small",
		texture_medium = "content/ui/textures/pj_missions/op_train_medium",
		minigame_type = "balance",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_op_train_01",
		texture_big = "content/ui/textures/pj_missions/op_train_big",
		not_needed_for_penance = true,
		coordinates = "loc_mission_coordinates_op_train",
		level = "content/levels/operations/train/missions/mission_op_train",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "op_train",
		zone_id = "operations",
		mission_description = "loc_mission_board_main_objective_train_description",
		pickup_pool = "operations_distribution_pool",
		testify_flags = {},
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
		pickup_settings = {
			secondary = {
				ammo = {
					ammo_cache_pocketable = {
						1
					}
				},
				stimms = {
					syringe_generic_pocketable = {
						2
					}
				}
			}
		},
		terror_event_templates = {
			"terror_events_op_train"
		},
		health_station = {},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_state = "None",
			wwise_route_key = 1,
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
					"commissar",
					"cargo_pilot"
				},
				enginseer_a = {
					"enginseer",
					"commissar",
					"cargo_pilot"
				}
			},
			vo_events = {
				"mission_train_briefing_a",
				"mission_train_briefing_b",
				"mission_train_briefing_c"
			}
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	}
}

return mission_templates
