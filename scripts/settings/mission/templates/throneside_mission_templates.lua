local mission_templates = {
	fm_resurgence = {
		mission_name = "loc_mission_name_fm_resurgence",
		wwise_state = "zone_5",
		zone_id = "throneside",
		texture_small = "content/ui/textures/missions/fm_resurgence_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_resurgence_01",
		texture_medium = "content/ui/textures/missions/fm_resurgence_medium",
		face_state_machine_key = "state_machine_missions",
		mechanism_name = "adventure",
		texture_big = "content/ui/textures/missions/fm_resurgence_big",
		coordinates = "loc_mission_coordinates_fm_resurgence",
		mission_type = "05",
		level = "content/levels/throneside/missions/mission_fm_resurgence",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "fm_resurgence",
		mission_description = "loc_mission_board_main_objective_resurgence_description",
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
			"terror_events_fm_resurgence"
		},
		testify_flags = {},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_resurgence_brief_a",
				"mission_resurgence_brief_b",
				"mission_resurgence_brief_c"
			}
		}
	}
}

return mission_templates
