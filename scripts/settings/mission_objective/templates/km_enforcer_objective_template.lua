-- chunkname: @scripts/settings/mission_objective/templates/km_enforcer_objective_template.lua

local mission_objective_templates = {
	km_enforcer = {
		objectives = {
			objective_km_enforcer_leave_start = {
				description = "loc_objective_km_enforcer_leave_start_desc",
				header = "loc_objective_km_enforcer_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_leave_flooded_slum = {
				description = "loc_objective_km_enforcer_leave_flooded_slum_desc",
				header = "loc_objective_km_enforcer_leave_flooded_slum_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_power_mechanism = {
				description = "loc_objective_km_enforcer_power_mechanism_desc",
				header = "loc_objective_km_enforcer_power_mechanism_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_activate_mechanism = {
				description = "loc_objective_km_enforcer_activate_mechanism_desc",
				header = "loc_objective_km_enforcer_activate_mechanism_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_wait_for_mechanism = {
				description = "loc_objective_km_enforcer_wait_for_mechanism_desc",
				duration = 90,
				event_type = "mid_event",
				header = "loc_objective_km_enforcer_wait_for_mechanism_header",
				mission_objective_type = "timed",
				music_wwise_state = "fortification_event",
			},
			objective_km_enforcer_enter_acid_street = {
				description = "loc_objective_km_enforcer_enter_acid_street_desc",
				header = "loc_objective_km_enforcer_enter_acid_street_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_find_enforcer = {
				description = "loc_objective_km_enforcer_find_enforcer_desc",
				header = "loc_objective_km_enforcer_find_enforcer_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_navigate_station = {
				description = "loc_objective_km_enforcer_navigate_station_desc",
				header = "loc_objective_km_enforcer_navigate_station_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_elevator = {
				description = "loc_objective_km_enforcer_elevator_desc",
				header = "loc_objective_km_enforcer_elevator_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_eliminate_target = {
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				event_type = "end_event",
				header = "loc_objective_km_enforcer_eliminate_target_header",
				mission_objective_type = "kill",
				music_wwise_state = "kill_event",
				turn_off_backfill = true,
			},
			objective_km_enforcer_twins_elevator = {
				description = "loc_objective_km_enforcer_twins_elevator_desc",
				header = "loc_objective_km_enforcer_twins_elevator_header",
				mission_objective_type = "goal",
			},
			objective_km_enforcer_twins_eliminate_twins = {
				description = "loc_objective_km_enforcer_twins_eliminate_twins_desc",
				event_type = "end_event",
				header = "loc_objective_km_enforcer_twins_eliminate_twins_header",
				mission_objective_type = "goal",
				music_wwise_state = "kill_event_2",
			},
			objective_km_enforcer_twins_ambush = {
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				event_type = "mid_event",
				header = "loc_objective_km_enforcer_eliminate_target_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "twins_event",
			},
		},
	},
}

return mission_objective_templates
