local mission_templates = {
	km_enforcer = {
		mission_name = "loc_mission_name_km_enforcer",
		wwise_state = "zone_2",
		zone_id = "watertown",
		texture_small = "content/ui/textures/missions/km_enforcer_small",
		texture_medium = "content/ui/textures/missions/km_enforcer_medium",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		coordinates = "loc_mission_coordinates_km_enforcer",
		texture_big = "content/ui/textures/missions/km_enforcer_big",
		mission_type_name = "loc_mission_type_02_name",
		level = "content/levels/watertown/missions/mission_km_enforcer",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "km_enforcer",
		mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_02",
		mission_description = "loc_mission_board_main_objective_enforcer_description",
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
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		terror_event_templates = {
			"terror_events_km_enforcer"
		},
		health_station = {},
		testify_flags = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_enforcer_briefing_a",
				"mission_enforcer_briefing_b",
				"mission_enforcer_briefing_c"
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
