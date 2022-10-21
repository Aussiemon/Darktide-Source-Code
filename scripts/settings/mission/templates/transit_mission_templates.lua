local mission_templates = {
	lm_rails = {
		mission_name = "loc_mission_name_lm_rails",
		wwise_state = "zone_1",
		zone_id = "transit",
		texture_small = "content/ui/textures/missions/lm_rails_small",
		texture_medium = "content/ui/textures/missions/lm_rails_medium",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		coordinates = "loc_mission_coordinates_lm_rails",
		texture_big = "content/ui/textures/missions/lm_rails_big",
		mission_type_name = "loc_mission_type_01_name",
		level = "content/levels/transit/missions/mission_lm_rails",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "lm_rails",
		mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_01",
		mission_description = "loc_mission_board_main_objective_rails_description",
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
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_rails_briefing_a",
				"mission_rails_briefing_b",
				"mission_rails_briefing_c"
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		}
	}
}

return mission_templates
