local mission_templates = {
	om_hub_01 = {
		zone_id = "hub",
		mission_name = "loc_mission_name_om_hub_01",
		wwise_state = "hub",
		objectives = "onboarding",
		game_mode_name = "prologue_hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		mechanism_name = "onboarding",
		force_third_person_mode = true,
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_01",
		cinematics = {
			cutscene_5_hub = {
				"cs_05_hub"
			},
			cutscene_7 = {
				"cs_07"
			},
			hub_location_intro_training_grounds = {
				"hub_location_intro_training_grounds"
			}
		},
		testify_flags = {
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
			fly_through = false,
			mission_server = false
		}
	},
	om_hub_02 = {
		zone_id = "hub",
		mission_name = "loc_mission_name_om_hub_02",
		wwise_state = "hub",
		objectives = "onboarding",
		game_mode_name = "prologue_hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		mechanism_name = "onboarding",
		force_third_person_mode = true,
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_02",
		testify_flags = {
			cutscenes = false,
			validate_minion_pathing_on_mission = false,
			run_through_mission = false,
			fly_through = false,
			mission_server = false
		}
	},
	om_basic_combat_01 = {
		mission_name = "loc_mission_name_tg_basic_combat_01",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		objectives = "training_grounds",
		game_mode_name = "training_grounds",
		zone_id = "training_grounds",
		mechanism_name = "onboarding",
		level = "content/levels/training_grounds/missions/mission_tg_basic_combat_01",
		cinematics = {
			hub_location_intro_psykhanium = {
				"hub_location_intro_psykhanium"
			}
		},
		terror_event_templates = {
			"terror_events_training_ground"
		},
		testify_flags = {
			performance = false,
			screenshot = false,
			cutscenes = false,
			validate_minion_pathing_on_mission = false,
			run_through_mission = false,
			fly_through = false,
			mission_server = false
		}
	},
	tg_shooting_range = {
		zone_id = "training_grounds",
		mission_name = "loc_sg_enter_sg",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		objectives = "training_grounds",
		game_mode_name = "shooting_range",
		mechanism_name = "onboarding",
		level = "content/levels/training_grounds/missions/mission_tg_basic_combat_01",
		terror_event_templates = {
			"terror_events_training_ground"
		},
		testify_flags = {
			performance = false,
			screenshot = false,
			cutscenes = false,
			validate_minion_pathing_on_mission = false,
			run_through_mission = false,
			fly_through = false,
			mission_server = false
		},
		spawn_settings = {
			next_mission = "tg_shooting_range"
		}
	}
}

return mission_templates
