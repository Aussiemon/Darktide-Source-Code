-- chunkname: @scripts/settings/mission/templates/expedition_mission_templates.lua

local mission_templates = {
	exp_wastes = {
		coordinates = "loc_mission_coordinates_exp_wastes",
		expedition_template = "wastes",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "expedition",
		level = "content/levels/expeditions/start/world",
		mechanism_name = "expedition",
		minigame_type = "decode_search",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_expedition_01",
		mission_description = "loc_mission_board_main_objective_exp_wastes_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_exp_wastes",
		mission_type = "expeditions",
		not_needed_for_penance = true,
		objectives = "expedition_loading",
		pacing_template = "expedition",
		path_type = "open",
		pickup_pool = "expedition_distribution_pool",
		texture_big = "content/ui/textures/missions/exp_wastes_big",
		texture_medium = "content/ui/textures/missions/exp_wastes_medium",
		texture_small = "content/ui/textures/missions/exp_wastes_small",
		wwise_state = "expeditions",
		zone_id = "expeditions",
		testify_flags = {
			circumstances = false,
			memory_usage = false,
			mission_server = true,
			performance = true,
			run_through_mission = true,
			screenshot = false,
			side_missions = false,
			validate_minion_pathing_on_mission = true,
		},
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
		min_chest_spawner_ratios = {
			primary = 1,
			secondary = 1,
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_expedition_loading",
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "tech_priest_a",
			wwise_route_key = 1,
			vo_events = {
				"expeditions_briefing_alpha_phase_a",
				"expeditions_briefing_alpha_phase_b",
				"expeditions_briefing_alpha_phase_c",
				"expeditions_briefing_alpha_phase_d",
			},
			mission_giver_packs = {
				tech_priest_a = {
					"tech_priest",
					"travelling_salesman",
					"pilot",
					"dreg_lector",
					"dreg_report",
				},
			},
		},
		dialogue_settings = {
			npc_story_tick_time = 37,
			npc_story_ticker_enabled = true,
			npc_story_ticker_start_delay = 157,
			short_story_start_delay = 83,
			short_story_tick_time = 11,
			short_story_ticker_enabled = true,
			story_start_delay = 211,
			story_tick_time = 29,
			story_ticker_enabled = true,
		},
		spawn_settings = {
			next_mission = "recent_expedition_mission",
		},
	},
}

return mission_templates
