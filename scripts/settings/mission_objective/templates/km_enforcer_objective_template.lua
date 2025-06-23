-- chunkname: @scripts/settings/mission_objective/templates/km_enforcer_objective_template.lua

local mission_objective_templates = {
	km_enforcer = {
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
				music_wwise_state = "fortification_event",
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
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				music_wwise_state = "kill_event",
				turn_off_backfill = true,
				header = "loc_objective_km_enforcer_eliminate_target_header",
				event_type = "end_event",
				mission_objective_type = "kill"
			},
			objective_km_enforcer_twins_elevator = {
				description = "loc_objective_km_enforcer_twins_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_enforcer_twins_elevator_header"
			},
			objective_km_enforcer_twins_eliminate_twins = {
				description = "loc_objective_km_enforcer_twins_eliminate_twins_desc",
				music_wwise_state = "kill_event_2",
				header = "loc_objective_km_enforcer_twins_eliminate_twins_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_km_enforcer_twins_ambush = {
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				music_wwise_state = "twins_event",
				hidden = true,
				header = "loc_objective_km_enforcer_eliminate_target_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			}
		}
	}
}

return mission_objective_templates
