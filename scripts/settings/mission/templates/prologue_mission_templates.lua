local mission_templates = {
	prologue = {
		zone_id = "prologue",
		mission_name = "loc_mission_name_prologue",
		wwise_state = "prologue",
		objectives = "prologue",
		game_mode_name = "prologue",
		mechanism_name = "onboarding",
		face_state_machine_key = "state_machine_prologue",
		level = "content/levels/prologue/missions/prologue",
		gameplay_modifiers = {
			"unkillable",
			"infinite_ammo_reserve"
		},
		terror_event_templates = {
			"terror_events_prologue"
		},
		testify_flags = {
			run_through_mission = false,
			screenshots = true,
			mission_server = false
		},
		cinematics = {
			intro_abc = {
				"c_cam"
			},
			cutscene_2 = {
				"cs_02_part_1",
				"cs_02_part_2",
				"cs_02_part_3"
			},
			cutscene_3 = {
				"cs_03"
			},
			cutscene_4 = {
				"cs_04"
			},
			cutscene_5 = {
				"cs_05",
				"cs_05_exterior"
			}
		}
	}
}

return mission_templates
