-- chunkname: @scripts/settings/mission/templates/operations_mission_templates.lua

local mission_templates = {
	op_train = {
		coordinates = "loc_mission_coordinates_op_train",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/operations/train/missions/mission_op_train",
		mechanism_name = "adventure",
		minigame_type = "balance",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_op_train_01",
		mission_description = "loc_mission_board_main_objective_train_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_op_train",
		mission_type = "operations",
		not_needed_for_penance = true,
		objectives = "op_train",
		pickup_pool = "operations_distribution_pool",
		texture_big = "content/ui/textures/pj_missions/op_train_big",
		texture_medium = "content/ui/textures/pj_missions/op_train_medium",
		texture_small = "content/ui/textures/pj_missions/op_train_small",
		zone_id = "operations",
		testify_flags = {},
		cinematics = {
			intro_abc = {
				"c_cam",
			},
			outro_fail = {
				"outro_fail",
			},
			outro_win = {
				"outro_win",
			},
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		pickup_settings = {
			secondary = {
				ammo = {
					ammo_cache_pocketable = {
						1,
					},
				},
				stimms = {
					syringe_generic_pocketable = {
						2,
					},
				},
			},
		},
		terror_event_templates = {
			"terror_events_op_train",
		},
		health_station = {},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false,
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			wwise_state = "None",
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
					"commissar",
					"cargo_pilot",
				},
				enginseer_a = {
					"enginseer",
					"commissar",
					"cargo_pilot",
				},
			},
			vo_events = {
				"mission_train_briefing_a",
				"mission_train_briefing_b",
				"mission_train_briefing_c",
			},
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	op_no_mans_land = {
		coordinates = "loc_mission_coordinates_op_no_mans_land",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/operations/no_mans_land/missions/mission_op_no_mans_land",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_op_no_mans_land_01",
		mission_description = "loc_mission_board_main_objective_no_mans_land_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_op_no_mans_land",
		mission_type = "operations",
		not_needed_for_penance = true,
		objectives = "op_no_mans_land",
		pickup_pool = "operations_distribution_pool",
		texture_big = "content/ui/textures/pj_missions/op_no_mans_land_big",
		texture_medium = "content/ui/textures/pj_missions/op_no_mans_land_medium",
		texture_small = "content/ui/textures/pj_missions/op_no_mans_land_small",
		wwise_state = "operations",
		zone_id = "operations",
		testify_flags = {},
		cinematics = {
			intro_abc = {
				"c_cam",
			},
			outro_fail = {
				"outro_fail",
			},
			outro_win = {
				"outro_win",
			},
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		pickup_settings = {
			end_event = {
				ammo = {
					ammo_cache_pocketable = {
						1,
					},
				},
				grenade = {
					small_grenade = {
						1,
						1,
					},
				},
				health = {
					medical_crate_pocketable = {
						1,
					},
				},
				wounds = {
					syringe_corruption_pocketable = {
						1,
					},
				},
				stimms = {
					syringe_generic_pocketable = {
						1,
					},
				},
			},
		},
		terror_event_templates = {
			"terror_events_op_no_mans_land",
		},
		health_station = {},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false,
		},
		mission_brief_vo = {
			vo_profile = "boon_vendor_a",
			wwise_route_key = 1,
			mission_giver_packs = {
				tech_priest_a = {
					"tech_priest",
					"commissar",
				},
				boon_vendor_a = {
					"boon_vendor",
					"commissar",
				},
			},
			vo_events = {
				"mission_trenches_briefing_a",
				"mission_trenches_briefing_b",
				"mission_trenches_briefing_c",
			},
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
}

return mission_templates
