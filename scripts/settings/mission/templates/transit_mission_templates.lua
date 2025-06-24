-- chunkname: @scripts/settings/mission/templates/transit_mission_templates.lua

local mission_templates = {
	cm_habs = {
		coordinates = "loc_mission_coordinates_cm_habs",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/transit/missions/mission_cm_habs",
		mechanism_name = "adventure",
		minigame_type = "drill",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_cm_habs_01",
		mission_description = "loc_mission_board_main_objective_habblock_description",
		mission_intro_minimum_time = 25,
		mission_name = "loc_mission_name_cm_habs",
		mission_type = "investigation",
		objectives = "cm_habs",
		texture_big = "content/ui/textures/pj_missions/cm_habs_big",
		texture_medium = "content/ui/textures/pj_missions/cm_habs_medium",
		texture_small = "content/ui/textures/pj_missions/cm_habs_small",
		wwise_state = "zone_1",
		zone_id = "transit",
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
			"terror_events_cm_habs",
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_b",
			wwise_route_key = 1,
			vo_events = {
				"mission_habs_redux_briefing_a",
				"mission_habs_redux_briefing_b",
				"mission_habs_redux_briefing_c",
			},
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
					"boon_vendor",
					"tertium_noble",
					"pilot",
				},
				sergeant_b = {
					"sergeant",
					"enemy_nemesis_wolfer",
					"enemy_wolfer_adjutant",
					"pilot",
				},
				shipmistress_a = {
					"shipmistress",
					"enginseer",
					"pilot",
				},
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
	lm_rails = {
		coordinates = "loc_mission_coordinates_lm_rails",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/transit/missions/mission_lm_rails",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_lm_rails_01",
		mission_description = "loc_mission_board_main_objective_rails_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_lm_rails",
		mission_type = "raid",
		objectives = "lm_rails",
		texture_big = "content/ui/textures/pj_missions/lm_rails_big",
		texture_medium = "content/ui/textures/pj_missions/lm_rails_medium",
		texture_small = "content/ui/textures/pj_missions/lm_rails_small",
		wwise_state = "zone_1",
		zone_id = "transit",
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
			"terror_events_lm_rails",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_rails_briefing_a",
				"mission_rails_briefing_b",
				"mission_rails_briefing_c",
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
	km_station = {
		coordinates = "loc_mission_coordinates_km_station",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/transit/missions/mission_km_station",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_km_station_01",
		mission_description = "loc_mission_board_main_objective_trainstation_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_km_station",
		mission_type = "assassination",
		objectives = "km_station",
		texture_big = "content/ui/textures/pj_missions/km_station_big",
		texture_medium = "content/ui/textures/pj_missions/km_station_medium",
		texture_small = "content/ui/textures/pj_missions/km_station_small",
		wwise_state = "zone_1",
		zone_id = "transit",
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
		pickup_settings = {},
		health_station = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		terror_event_templates = {
			"terror_events_km_station",
		},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_station_briefing_a",
				"mission_station_briefing_b",
				"mission_station_briefing_c",
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
	dm_rise = {
		coordinates = "loc_mission_coordinates_dm_rise",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/transit/missions/mission_dm_rise",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_rise_01",
		mission_description = "loc_mission_board_main_objective_rise_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_dm_rise",
		mission_type = "strike",
		objectives = "dm_rise",
		texture_big = "content/ui/textures/pj_missions/dm_rise_big",
		texture_medium = "content/ui/textures/pj_missions/dm_rise_medium",
		texture_small = "content/ui/textures/pj_missions/dm_rise_small",
		wwise_state = "zone_1",
		zone_id = "transit",
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
			"terror_events_dm_rise",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "purser_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_rise_briefing_a_intro",
				"mission_rise_briefing_a",
				"mission_rise_briefing_b",
				"mission_rise_briefing_c",
			},
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
				},
				purser_a = {
					"purser",
					"contract_vendor",
				},
				training_ground_psyker_a = {
					"training_ground_psyker",
					"barber",
				},
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
}

return mission_templates
