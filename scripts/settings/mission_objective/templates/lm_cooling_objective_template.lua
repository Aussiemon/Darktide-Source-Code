-- chunkname: @scripts/settings/mission_objective/templates/lm_cooling_objective_template.lua

local mission_objective_templates = {
	lm_cooling = {
		main_objective_type = "luggable_objective",
		objectives = {
			objective_lm_cooling_leave_start = {
				description = "loc_objective_lm_cooling_leave_start_desc",
				header = "loc_objective_lm_cooling_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_lm_cooling_locate = {
				description = "loc_objective_lm_cooling_locate_desc",
				header = "loc_objective_lm_cooling_locate_header",
				mission_objective_type = "goal",
			},
			objective_lm_cooling_decrypt = {
				description = "loc_objective_lm_cooling_decrypt_desc",
				event_type = "mid_event",
				header = "loc_objective_lm_cooling_decrypt_header",
				mission_objective_type = "decode",
				progress_bar = true,
				use_music_event = "hacking_event",
			},
			objective_lm_cooling_send_elevator = {
				description = "loc_objective_lm_cooling_send_elevator_desc",
				header = "loc_objective_lm_cooling_send_elevator_header",
				mission_objective_type = "goal",
			},
			objective_lm_cooling_descend = {
				description = "loc_objective_lm_cooling_descend_desc",
				header = "loc_objective_lm_cooling_descend_header",
				mission_objective_type = "goal",
			},
			objective_lm_cooling_unlock = {
				description = "loc_objective_lm_cooling_unlock_desc",
				header = "loc_objective_lm_cooling_unlock_header",
				mission_objective_type = "goal",
			},
			objective_lm_cooling_reactor = {
				description = "loc_objective_lm_cooling_reactor_desc",
				event_type = "end_event",
				header = "loc_objective_lm_cooling_reactor_header",
				mission_objective_type = "luggable",
				turn_off_backfill = true,
				use_music_event = "collect_event",
			},
			objective_lm_cooling_machine = {
				description = "loc_objective_lm_cooling_machine_desc",
				event_type = "end_event",
				header = "loc_objective_lm_cooling_machine_header",
				mission_objective_type = "goal",
				use_music_event = "collect_event",
			},
			objective_lm_cooling_wait = {
				description = "loc_objective_lm_cooling_wait_desc",
				duration = 30,
				event_type = "end_event",
				header = "loc_objective_lm_cooling_wait_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "collect_event",
			},
			objective_lm_cooling_clear = {
				description = "loc_objective_lm_cooling_clear_desc",
				event_type = "end_event",
				header = "loc_objective_lm_cooling_clear_header",
				mission_objective_type = "goal",
				use_music_event = "collect_event",
			},
			objective_lm_cooling_escape = {
				description = "loc_objective_lm_cooling_escape_desc",
				header = "loc_objective_lm_cooling_escape_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
