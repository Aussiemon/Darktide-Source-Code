-- chunkname: @scripts/settings/mission_objective/templates/hm_complex_objective_template.lua

local mission_objective_templates = {
	hm_complex = {
		main_objective_type = "decode_objective",
		objectives = {
			objective_hm_complex_cross = {
				description = "loc_objective_hm_complex_cross_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_cross_header"
			},
			objective_hm_complex_locate = {
				description = "loc_objective_hm_complex_locate_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_locate_header"
			},
			objective_hm_complex_enter = {
				description = "loc_objective_hm_complex_enter_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_enter_header"
			},
			objective_hm_complex_elevator_event_survive = {
				description = "loc_objective_hm_complex_elevator_event_survive_desc",
				use_music_event = "hacking_event",
				header = "loc_objective_hm_complex_elevator_event_survive_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_complex_elevator_up = {
				description = "loc_objective_hm_complex_elevator_up_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_elevator_up_header"
			},
			objective_hm_complex_elevator_office = {
				description = "loc_objective_hm_complex_elevator_office_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_elevator_office_header"
			},
			objective_hm_complex_final_event_running = {
				description = "loc_objective_hm_complex_final_event_running_desc",
				use_music_event = "hacking_event",
				turn_off_backfill = true,
				header = "loc_objective_hm_complex_final_event_running_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_complex_activate_transmission = {
				description = "loc_objective_hm_complex_activate_transmission_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_activate_transmission_header"
			},
			objective_hm_complex_escape = {
				description = "loc_objective_hm_complex_escape_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_hm_complex_escape_header"
			}
		}
	}
}

return mission_objective_templates
