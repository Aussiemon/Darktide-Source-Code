-- chunkname: @scripts/settings/mission_objective/templates/hm_complex_objective_template.lua

local mission_objective_templates = {
	hm_complex = {
		main_objective_type = "decode_objective",
		objectives = {
			objective_hm_complex_cross = {
				description = "loc_objective_hm_complex_cross_desc",
				header = "loc_objective_hm_complex_cross_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_locate = {
				description = "loc_objective_hm_complex_locate_desc",
				header = "loc_objective_hm_complex_locate_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_enter = {
				description = "loc_objective_hm_complex_enter_desc",
				header = "loc_objective_hm_complex_enter_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_elevator_event_survive = {
				description = "loc_objective_hm_complex_elevator_event_survive_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_complex_elevator_event_survive_header",
				mission_objective_type = "decode",
				progress_bar = true,
				use_music_event = "hacking_event",
			},
			objective_hm_complex_elevator_up = {
				description = "loc_objective_hm_complex_elevator_up_desc",
				header = "loc_objective_hm_complex_elevator_up_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_elevator_office = {
				description = "loc_objective_hm_complex_elevator_office_desc",
				header = "loc_objective_hm_complex_elevator_office_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_final_event_running = {
				description = "loc_objective_hm_complex_final_event_running_desc",
				event_type = "end_event",
				header = "loc_objective_hm_complex_final_event_running_header",
				mission_objective_type = "decode",
				progress_bar = true,
				turn_off_backfill = true,
				use_music_event = "hacking_event",
			},
			objective_hm_complex_activate_transmission = {
				description = "loc_objective_hm_complex_activate_transmission_desc",
				header = "loc_objective_hm_complex_activate_transmission_header",
				mission_objective_type = "goal",
			},
			objective_hm_complex_escape = {
				description = "loc_objective_hm_complex_escape_desc",
				header = "loc_objective_hm_complex_escape_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
