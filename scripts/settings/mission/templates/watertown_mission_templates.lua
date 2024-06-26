-- chunkname: @scripts/settings/mission/templates/watertown_mission_templates.lua

local mission_templates = {
	dm_stockpile = {
		coordinates = "loc_mission_coordinates_dm_stockpile",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/watertown/missions/mission_dm_stockpile",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_stockpile_01",
		mission_description = "loc_mission_board_main_objective_waterstockpile_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_dm_stockpile",
		mission_type = "strike",
		objectives = "dm_stockpile",
		texture_big = "content/ui/textures/missions/dm_stockpile_big",
		texture_medium = "content/ui/textures/missions/dm_stockpile_medium",
		texture_small = "content/ui/textures/missions/dm_stockpile_small",
		wwise_state = "zone_2",
		zone_id = "watertown",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		terror_event_templates = {
			"terror_events_dm_stockpile",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_stockpile_briefing_a",
				"mission_stockpile_briefing_b",
				"mission_stockpile_briefing_c",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	hm_cartel = {
		coordinates = "loc_mission_coordinates_hm_cartel",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/watertown/missions/mission_hm_cartel",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_cartel_01",
		mission_description = "loc_mission_board_main_objective_cartel_description",
		mission_intro_minimum_time = 25,
		mission_name = "loc_mission_name_hm_cartel",
		mission_type = "espionage",
		objectives = "hm_cartel",
		texture_big = "content/ui/textures/missions/hm_cartel_big",
		texture_medium = "content/ui/textures/missions/hm_cartel_medium",
		texture_small = "content/ui/textures/missions/hm_cartel_small",
		wwise_state = "zone_2",
		zone_id = "watertown",
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
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_hm_cartel",
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "explicator_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_cartel_brief_one",
				"mission_cartel_brief_two",
				"mission_cartel_brief_three",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	km_enforcer = {
		coordinates = "loc_mission_coordinates_km_enforcer",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/watertown/missions/mission_km_enforcer",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_enforcer_01",
		mission_description = "loc_mission_board_main_objective_enforcer_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_km_enforcer",
		mission_type = "assassination",
		objectives = "km_enforcer",
		texture_big = "content/ui/textures/missions/km_enforcer_big",
		texture_medium = "content/ui/textures/missions/km_enforcer_medium",
		texture_small = "content/ui/textures/missions/km_enforcer_small",
		wwise_state = "zone_2",
		zone_id = "watertown",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		terror_event_templates = {
			"terror_events_km_enforcer",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_enforcer_briefing_a",
				"mission_enforcer_briefing_b",
				"mission_enforcer_briefing_c",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	km_enforcer_twins = {
		coordinates = "loc_mission_coordinates_km_enforcer",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/watertown_twins/missions/mission_km_enforcer_twins",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_enforcer_twins_01",
		mission_description = "loc_mission_board_main_objective_enforcer_twins_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_km_enforcer_twins",
		mission_type = "assassination",
		not_needed_for_penance = true,
		objectives = "km_enforcer",
		texture_big = "content/ui/textures/missions/km_enforcer_twins_big",
		texture_medium = "content/ui/textures/missions/km_enforcer_twins_medium",
		texture_small = "content/ui/textures/missions/km_enforcer_twins_small",
		wwise_state = "zone_twins",
		zone_id = "watertown",
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
			traitor_captain_intro = {
				"traitor_captain_intro",
			},
		},
		pickup_settings = {
			primary = {
				ammo = {
					ammo_cache_pocketable = {
						-100,
					},
				},
				health = {
					medical_crate_pocketable = {
						-100,
					},
				},
				forge_material = {
					small_metal = {
						-100,
					},
					large_metal = {
						-100,
					},
					small_platinum = {
						-100,
					},
					large_platinum = {
						-100,
					},
				},
			},
			secondary = {
				ammo = {
					ammo_cache_pocketable = {
						-100,
					},
				},
				health = {
					medical_crate_pocketable = {
						-100,
					},
				},
				forge_material = {
					small_metal = {
						-100,
					},
					large_metal = {
						-100,
					},
					small_platinum = {
						-100,
					},
					large_platinum = {
						-100,
					},
				},
			},
			rubberband_pool = {
				ammo = {
					ammo_cache_pocketable = {
						-100,
					},
				},
				health = {
					medical_crate_pocketable = {
						-100,
					},
				},
			},
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		terror_event_templates = {
			"terror_events_km_enforcer_twins",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "explicator_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_twins_briefing_a",
				"mission_twins_briefing_b",
				"mission_twins_briefing_b2",
				"mission_twins_briefing_c",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false,
		},
		narrative_story = {
			chapter = "s1_twins_mission",
			story = "s1_twins",
		},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
}

return mission_templates
