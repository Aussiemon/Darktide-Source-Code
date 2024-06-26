-- chunkname: @scripts/settings/mission/templates/dust_mission_templates.lua

local mission_templates = {
	lm_scavenge = {
		coordinates = "loc_mission_coordinates_lm_scavenge",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/dust/missions/mission_lm_scavenge",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_lm_scavenge_01",
		mission_description = "loc_mission_board_main_objective_scavenge_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_lm_scavenge",
		mission_type = "investigation",
		objectives = "lm_scavenge",
		texture_big = "content/ui/textures/missions/lm_scavenge_big",
		texture_medium = "content/ui/textures/missions/lm_scavenge_medium",
		texture_small = "content/ui/textures/missions/lm_scavenge_small",
		wwise_state = "zone_4",
		zone_id = "dust",
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
		terror_event_templates = {
			"terror_events_lm_scavenge",
		},
		health_station = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_scavenge_briefing_one",
				"mission_scavenge_briefing_two",
				"mission_scavenge_briefing_three",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		testify_flags = {},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	dm_propaganda = {
		coordinates = "loc_mission_coordinates_dm_propaganda",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/dust/missions/mission_dm_propaganda",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_dm_propaganda_01",
		mission_description = "loc_mission_board_main_objective_propaganda_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_dm_propaganda",
		mission_type = "disruption",
		objectives = "dm_propaganda",
		texture_big = "content/ui/textures/missions/dm_propaganda_big",
		texture_medium = "content/ui/textures/missions/dm_propaganda_medium",
		texture_small = "content/ui/textures/missions/dm_propaganda_small",
		wwise_state = "zone_4",
		zone_id = "dust",
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
			"terror_events_dm_propaganda",
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_propaganda_briefing_a",
				"mission_propaganda_briefing_b",
				"mission_propaganda_briefing_c",
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		testify_flags = {},
		health_station = {},
		spawn_settings = {
			next_mission = "recent_mission",
		},
	},
	hm_strain = {
		coordinates = "loc_mission_coordinates_hm_strain",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/dust/missions/mission_hm_strain",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_hm_strain_01",
		mission_description = "loc_mission_board_main_objective_strain_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_hm_strain",
		mission_type = "disruption",
		objectives = "hm_strain",
		texture_big = "content/ui/textures/missions/hm_strain_big",
		texture_medium = "content/ui/textures/missions/hm_strain_medium",
		texture_small = "content/ui/textures/missions/hm_strain_small",
		wwise_state = "zone_4",
		zone_id = "dust",
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
			"terror_events_hm_strain",
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_strain_briefing_a",
				"mission_strain_briefing_b",
				"mission_strain_briefing_c",
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
