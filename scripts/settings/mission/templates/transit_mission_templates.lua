local mission_templates = {
	lm_rails = {
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "lm_rails",
		mission_name = "loc_mission_name_lm_rails",
		zone_id = "transit",
		wwise_state = "zone_1",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		level = "content/levels/transit/missions/mission_lm_rails",
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
			"terror_events_lm_rails"
		},
		health_station = {
			charges_to_distribute = 5
		},
		testify_flags = {
			performance = true
		},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_rails_briefing_a",
				"mission_rails_briefing_b",
				"mission_rails_briefing_c"
			}
		}
	}
}

return mission_templates
