-- chunkname: @scripts/settings/mission_objective/templates/hm_strain_objective_template.lua

local mission_objective_templates = {
	hm_strain = {
		objectives = {
			objective_hm_strain_leave_start = {
				description = "loc_objective_hm_strain_leave_start_desc",
				header = "loc_objective_hm_strain_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_hm_strain_start_machine = {
				description = "loc_objective_hm_strain_start_machine_desc",
				header = "loc_objective_hm_strain_start_machine_header",
				mission_objective_type = "goal",
			},
			objective_hm_strain_demo_one = {
				description = "loc_objective_hm_strain_demo_one_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_strain_demo_one_header",
				mission_objective_type = "demolition",
				music_wwise_state = "demolition_event",
			},
			objective_hm_strain_demo_two = {
				description = "loc_objective_hm_strain_demo_two_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_strain_demo_two_header",
				mission_objective_type = "demolition",
				music_wwise_state = "demolition_event",
			},
			objective_hm_strain_survive = {
				description = "loc_objective_hm_strain_survive_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_strain_survive_header",
				mission_objective_type = "goal",
				music_wwise_state = "demolition_event",
			},
			objective_hm_strain_call_elevator = {
				description = "loc_objective_hm_strain_call_elevator_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_strain_call_elevator_header",
				mission_objective_type = "goal",
				music_wwise_state = "demolition_event",
			},
			objective_hm_strain_wait_elevator = {
				description = "loc_objective_hm_strain_wait_elevator_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_strain_wait_elevator_header",
				mission_objective_type = "goal",
				music_wwise_state = "demolition_event",
			},
			objective_hm_strain_reach_fuel_depot = {
				description = "loc_objective_hm_strain_reach_fuel_depot_desc",
				header = "loc_objective_hm_strain_reach_fuel_depot_header",
				mission_objective_type = "goal",
			},
			objective_hm_strain_override_pressure = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				event_type = "end_event",
				header = "loc_objective_hm_strain_override_pressure_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
				turn_off_backfill = true,
			},
			objective_hm_strain_override_pressure_2 = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				event_type = "end_event",
				header = "loc_objective_hm_strain_override_pressure_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_hm_strain_override_pressure_3 = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				event_type = "end_event",
				header = "loc_objective_hm_strain_override_pressure_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_hm_strain_extract = {
				description = "loc_objective_hm_strain_extract_desc",
				header = "loc_objective_hm_strain_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
