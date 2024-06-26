-- chunkname: @scripts/settings/mission/templates/onboarding_mission_templates.lua

local mission_templates = {
	om_hub_01 = {
		force_third_person_mode = true,
		game_mode_name = "prologue_hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_01",
		mechanism_name = "onboarding",
		mission_name = "loc_mission_name_hub_ship",
		not_needed_for_penance = true,
		objectives = "onboarding",
		wwise_state = "hub",
		zone_id = "hub",
		cinematics = {
			cutscene_5_hub = {
				"cs_05_hub",
			},
			cutscene_7 = {
				"cs_07",
			},
			hub_location_intro_training_grounds = {
				"hub_location_intro_training_grounds",
			},
		},
		testify_flags = {
			fly_through = false,
			mission_server = false,
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
		},
	},
	om_hub_02 = {
		force_third_person_mode = true,
		game_mode_name = "prologue_hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_02",
		mechanism_name = "onboarding",
		mission_name = "loc_mission_name_hub_ship",
		not_needed_for_penance = true,
		objectives = "onboarding",
		wwise_state = "hub",
		zone_id = "hub",
		testify_flags = {
			cutscenes = false,
			fly_through = false,
			mission_server = false,
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
		},
	},
	om_basic_combat_01 = {
		game_mode_name = "training_grounds",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		level = "content/levels/training_grounds/missions/mission_tg_basic_combat_01",
		mechanism_name = "onboarding",
		mission_name = "loc_mission_name_tg_basic_combat_01",
		not_needed_for_penance = true,
		objectives = "training_grounds",
		zone_id = "training_grounds",
		cinematics = {
			hub_location_intro_psykhanium = {
				"hub_location_intro_psykhanium",
			},
		},
		terror_event_templates = {
			"terror_events_training_ground",
		},
		testify_flags = {
			cutscenes = false,
			fly_through = false,
			mission_server = false,
			performance = false,
			run_through_mission = false,
			screenshot = false,
			validate_minion_pathing_on_mission = false,
		},
	},
	tg_shooting_range = {
		game_mode_name = "shooting_range",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		level = "content/levels/training_grounds/missions/mission_tg_basic_combat_01",
		mechanism_name = "onboarding",
		mission_name = "loc_mission_name_tg_basic_combat_01",
		not_needed_for_penance = true,
		objectives = "training_grounds",
		zone_id = "training_grounds",
		terror_event_templates = {
			"terror_events_training_ground",
		},
		testify_flags = {
			cutscenes = false,
			fly_through = false,
			mission_server = false,
			performance = false,
			run_through_mission = false,
			screenshot = false,
			validate_minion_pathing_on_mission = false,
		},
		spawn_settings = {
			next_mission = "tg_shooting_range",
		},
		dialogue_settings = {
			npc_story_tick_time = 180,
			npc_story_ticker_enabled = true,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false,
			npc_story_ticker_start_delay = 80 + math.random(0, 120),
		},
		mission_brief_vo = {
			vo_profile = "training_ground_psyker_a",
			mission_giver_packs = {
				training_ground_psyker_a = {
					"training_ground_psyker",
				},
			},
		},
	},
}

return mission_templates
