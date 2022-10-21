local mission_objective_templates = {
	km_enforcer = {
		main_objective_type = "kill_objective",
		objectives = {
			objective_km_enforcer_leave_start = {
				description = "loc_objective_km_enforcer_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_leave_start_header"
			},
			objective_km_enforcer_leave_flooded_slum = {
				description = "loc_objective_km_enforcer_leave_flooded_slum_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_leave_flooded_slum_header"
			},
			objective_km_enforcer_power_mechanism = {
				description = "loc_objective_km_enforcer_power_mechanism_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_power_mechanism_header"
			},
			objective_km_enforcer_activate_mechanism = {
				description = "loc_objective_km_enforcer_activate_mechanism_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_activate_mechanism_header"
			},
			objective_km_enforcer_wait_for_mechanism = {
				description = "loc_objective_km_enforcer_wait_for_mechanism_desc",
				use_music_event = "fortification_event",
				header = "loc_objective_km_enforcer_wait_for_mechanism_header",
				event_type = "mid_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_km_enforcer_enter_acid_street = {
				description = "loc_objective_km_enforcer_enter_acid_street_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_enter_acid_street_header"
			},
			objective_km_enforcer_find_enforcer = {
				description = "loc_objective_km_enforcer_find_enforcer_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_find_enforcer_header"
			},
			objective_km_enforcer_navigate_station = {
				description = "loc_objective_km_enforcer_navigate_station_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_navigate_station_header"
			},
			objective_km_enforcer_elevator = {
				description = "loc_objective_km_enforcer_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_elevator_header"
			},
			objective_km_enforcer_eliminate_target = {
				use_music_event = "kill_event",
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				turn_off_backfill = true,
				header = "loc_objective_km_enforcer_eliminate_target_header",
				event_type = "end_event",
				mission_objective_type = "kill"
			}
		}
	}
}

return mission_objective_templates
