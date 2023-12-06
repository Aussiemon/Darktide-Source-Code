local mission_objective_templates = {
	common = {
		objectives = {
			default = {
				description = "loc_objective_common_default_desc",
				use_music_event = "None",
				mission_objective_type = "goal",
				header = "loc_objective_common_default_header"
			},
			objective_test = {
				description = "loc_objective_common_default_desc",
				use_music_event = "None",
				mission_objective_type = "goal",
				header = "loc_objective_common_default_header"
			},
			timed_test = {
				description = "loc_objective_common_timed_test_desc",
				progress_bar = true,
				use_music_event = "last_stand",
				header = "loc_objective_common_timed_test_header",
				duration = 60,
				mission_objective_type = "timed"
			},
			demolition_objective = {
				description = "loc_objective_common_demolition_desc",
				use_music_event = "purge_mission",
				mission_objective_type = "demolition",
				header = "loc_objective_common_demolition_header"
			},
			decoding_objective = {
				use_music_event = "control_mission",
				description = "loc_objective_common_decoding_desc",
				header = "loc_objective_common_decoding_header",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			control_objective = {
				description = "loc_objective_common_control_desc",
				use_music_event = "control_mission",
				collect_amount = 3,
				header = "loc_objective_common_control_header",
				mission_objective_type = "collect"
			},
			captain_kill_target = {
				description = "loc_objective_common_captain_kill_desc",
				use_music_event = "kill_mission",
				mission_objective_type = "kill",
				header = "loc_objective_common_captain_kill_header"
			},
			luggable_objective = {
				description = "loc_objective_common_luggable_desc",
				use_music_event = "control_mission",
				mission_objective_type = "luggable",
				header = "loc_objective_common_luggable_header"
			},
			objective_twins_ambush = {
				use_music_event = "twins_event",
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				hidden = true,
				header = "loc_objective_km_enforcer_eliminate_target_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			}
		}
	}
}

return mission_objective_templates
