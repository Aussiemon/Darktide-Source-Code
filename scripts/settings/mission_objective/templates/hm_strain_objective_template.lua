-- chunkname: @scripts/settings/mission_objective/templates/hm_strain_objective_template.lua

local mission_objective_templates = {
	hm_strain = {
		objectives = {
			objective_hm_strain_leave_start = {
				description = "loc_objective_hm_strain_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_strain_leave_start_header"
			},
			objective_hm_strain_start_machine = {
				description = "loc_objective_hm_strain_start_machine_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_strain_start_machine_header"
			},
			objective_hm_strain_demo_one = {
				description = "loc_objective_hm_strain_demo_one_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_hm_strain_demo_one_header",
				event_type = "mid_event",
				mission_objective_type = "demolition"
			},
			objective_hm_strain_demo_two = {
				description = "loc_objective_hm_strain_demo_two_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_hm_strain_demo_two_header",
				event_type = "mid_event",
				mission_objective_type = "demolition"
			},
			objective_hm_strain_survive = {
				description = "loc_objective_hm_strain_survive_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_hm_strain_survive_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_hm_strain_call_elevator = {
				description = "loc_objective_hm_strain_call_elevator_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_hm_strain_call_elevator_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_hm_strain_wait_elevator = {
				description = "loc_objective_hm_strain_wait_elevator_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_hm_strain_wait_elevator_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_hm_strain_reach_fuel_depot = {
				description = "loc_objective_hm_strain_reach_fuel_depot_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_strain_reach_fuel_depot_header"
			},
			objective_hm_strain_override_pressure = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				music_wwise_state = "hacking_event",
				turn_off_backfill = true,
				header = "loc_objective_hm_strain_override_pressure_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_strain_override_pressure_2 = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_strain_override_pressure_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_strain_override_pressure_3 = {
				description = "loc_objective_hm_strain_override_pressure_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_strain_override_pressure_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_strain_extract = {
				description = "loc_objective_hm_strain_extract_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_hm_strain_extract_header"
			}
		}
	}
}

return mission_objective_templates
