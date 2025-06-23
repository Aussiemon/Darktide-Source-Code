-- chunkname: @scripts/settings/mission_objective/templates/fm_cargo_objective_template.lua

local mission_objective_templates = {
	fm_cargo = {
		objectives = {
			objective_fm_cargo_leave_start = {
				description = "loc_objective_fm_cargo_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_cargo_leave_start_header"
			},
			objective_fm_cargo_maintenance = {
				description = "loc_objective_fm_cargo_maintenance_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_cargo_maintenance_header"
			},
			objective_fm_cargo_decode = {
				description = "loc_objective_fm_cargo_decode_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_fm_cargo_decode_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_fm_cargo_proceed = {
				description = "loc_objective_fm_cargo_proceed_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_cargo_proceed_header"
			},
			objective_fm_cargo_open_door = {
				description = "loc_objective_fm_cargo_open_door_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_cargo_open_door_header"
			},
			objective_fm_cargo_destroy_aa_guns = {
				description = "loc_objective_fm_cargo_destroy_aa_guns_desc",
				music_wwise_state = "fortification_event",
				turn_off_backfill = true,
				header = "loc_objective_fm_cargo_destroy_aa_guns_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_fm_cargo_activate_beacon = {
				description = "loc_objective_fm_cargo_activate_beacon_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_cargo_activate_beacon_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_fm_cargo_survive_final = {
				description = "loc_objective_fm_cargo_survive_final_desc",
				progress_bar = true,
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_cargo_survive_final_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_fm_cargo_clear_area = {
				description = "loc_objective_fm_cargo_clear_area_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_cargo_clear_area_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_fm_cargo_reach_valkyrie = {
				description = "loc_objective_fm_cargo_reach_valkyrie_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_fm_cargo_reach_valkyrie_header"
			}
		}
	}
}

return mission_objective_templates
