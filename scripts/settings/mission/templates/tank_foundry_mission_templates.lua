local mission_templates = {
	lm_cooling = {
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 30,
		objectives = "lm_cooling",
		mission_name = "loc_mission_name_lm_cooling",
		zone_id = "tank_foundry",
		wwise_state = "zone_3",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		level = "content/levels/tank_foundry/missions/mission_lm_cooling",
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
		testify_flags = {
			performance = true
		},
		health_station = {
			charges_to_distribute = 3
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_cooling_briefing_one",
				"mission_cooling_briefing_two",
				"mission_cooling_briefing_three"
			}
		}
	},
	dm_forge = {
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "dm_forge",
		mission_name = "loc_mission_name_dm_forge",
		zone_id = "tank_foundry",
		wwise_state = "zone_3",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		level = "content/levels/tank_foundry/missions/mission_dm_forge",
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
		health_station = {
			charges_to_distribute = 3
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_forge_briefing_a",
				"mission_forge_briefing_b",
				"mission_forge_briefing_c"
			}
		},
		testify_flags = {
			performance = true
		}
	}
}

return mission_templates
