-- chunkname: @scripts/settings/mission_objective/templates/fm_cargo_objective_template.lua

local mission_objective_templates = {
	fm_cargo = {
		objectives = {
			objective_fm_cargo_leave_start = {
				description = "loc_objective_fm_cargo_leave_start_desc",
				header = "loc_objective_fm_cargo_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_fm_cargo_maintenance = {
				description = "loc_objective_fm_cargo_maintenance_desc",
				header = "loc_objective_fm_cargo_maintenance_header",
				mission_objective_type = "goal",
			},
			objective_fm_cargo_decode = {
				description = "loc_objective_fm_cargo_decode_desc",
				event_type = "mid_event",
				header = "loc_objective_fm_cargo_decode_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_fm_cargo_proceed = {
				description = "loc_objective_fm_cargo_proceed_desc",
				header = "loc_objective_fm_cargo_proceed_header",
				mission_objective_type = "goal",
			},
			objective_fm_cargo_open_door = {
				description = "loc_objective_fm_cargo_open_door_desc",
				header = "loc_objective_fm_cargo_open_door_header",
				mission_objective_type = "goal",
			},
			objective_fm_cargo_destroy_aa_guns = {
				description = "loc_objective_fm_cargo_destroy_aa_guns_desc",
				event_type = "end_event",
				header = "loc_objective_fm_cargo_destroy_aa_guns_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
				turn_off_backfill = true,
			},
			objective_fm_cargo_activate_beacon = {
				description = "loc_objective_fm_cargo_activate_beacon_desc",
				event_type = "end_event",
				header = "loc_objective_fm_cargo_activate_beacon_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_fm_cargo_survive_final = {
				description = "loc_objective_fm_cargo_survive_final_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_fm_cargo_survive_final_header",
				mission_objective_type = "timed",
				music_wwise_state = "fortification_event",
				progress_bar = true,
			},
			objective_fm_cargo_clear_area = {
				description = "loc_objective_fm_cargo_clear_area_desc",
				event_type = "end_event",
				header = "loc_objective_fm_cargo_clear_area_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_fm_cargo_reach_valkyrie = {
				description = "loc_objective_fm_cargo_reach_valkyrie_desc",
				header = "loc_objective_fm_cargo_reach_valkyrie_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
