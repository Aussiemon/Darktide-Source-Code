-- chunkname: @scripts/settings/mission/templates/entertainment_mission_templates.lua

local mission_templates = {
	cm_raid = {
		coordinates = "loc_mission_coordinates_cm_raid",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/entertainment/missions/mission_cm_raid",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_cm_raid_01",
		mission_description = "loc_mission_board_main_objective_raid_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_cm_raid",
		mission_type = "disruption",
		objectives = "cm_raid",
		texture_big = "content/ui/textures/missions/cm_raid_big",
		texture_medium = "content/ui/textures/missions/cm_raid_medium",
		texture_small = "content/ui/textures/missions/cm_raid_small",
		wwise_state = "zone_6",
		zone_id = "entertainment",
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
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_cm_raid",
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "tech_priest_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_raid_briefing_a",
				"mission_raid_briefing_b",
				"mission_raid_briefing_c",
			},
			mission_giver_packs = {
				sergeant_a = {
					"sergeant",
					"interrogator",
				},
				explicator_a = {
					"explicator",
					"barber",
				},
				tech_priest_a = {
					"tech_priest",
					"enginseer",
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
	fm_armoury = {
		coordinates = "loc_mission_coordinates_fm_armoury",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/entertainment/missions/mission_fm_armoury",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_armoury_01",
		mission_description = "loc_mission_board_main_objective_armoury_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_fm_armoury",
		mission_type = "raid",
		objectives = "fm_armoury",
		texture_big = "content/ui/textures/missions/fm_armoury_big",
		texture_medium = "content/ui/textures/missions/fm_armoury_medium",
		texture_small = "content/ui/textures/missions/fm_armoury_small",
		wwise_state = "zone_6",
		zone_id = "entertainment",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		terror_event_templates = {
			"terror_events_fm_armoury",
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_b",
			wwise_route_key = 1,
			vo_events = {
				"mission_armoury_briefing_a",
				"mission_armoury_briefing_b",
				"mission_armoury_briefing_c",
			},
			mission_giver_packs = {
				sergeant_b = {
					"sergeant",
					"enemy_nemesis_wolfer",
					"enemy_wolfer_adjutant",
				},
				explicator_a = {
					"explicator",
					"purser",
					"contract_vendor",
				},
				tech_priest_a = {
					"tech_priest",
					"shipmistress",
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
