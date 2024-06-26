-- chunkname: @scripts/settings/mission_objective/templates/fm_resurgence_objective_template.lua

local mission_objective_templates = {
	fm_resurgence = {
		objectives = {
			objective_fm_resurgence_start = {
				description = "loc_objective_fm_resurgence_start_desc",
				header = "loc_objective_fm_resurgence_start_header",
				mission_objective_type = "goal",
			},
			objective_fm_resurgence_bridge = {
				description = "loc_objective_fm_resurgence_bridge_desc",
				header = "loc_objective_fm_resurgence_bridge_header",
				mission_objective_type = "luggable",
				music_ignore_start_event = true,
				music_wwise_state = "fortification_event",
			},
			objective_fm_resurgence_lower = {
				description = "loc_objective_fm_resurgence_lower_desc",
				header = "loc_objective_fm_resurgence_lower_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				music_wwise_state = "fortification_event",
			},
			objective_fm_resurgence_survive_mid = {
				description = "loc_objective_fm_resurgence_survive_mid_desc",
				duration = 75,
				header = "loc_objective_fm_resurgence_survive_mid_header",
				mission_objective_type = "timed",
				music_wwise_state = "fortification_event",
				progress_bar = true,
			},
			objective_fm_resurgence_approach = {
				description = "loc_objective_fm_resurgence_approach_desc",
				header = "loc_objective_fm_resurgence_approach_header",
				mission_objective_type = "goal",
			},
			objective_fm_resurgence_end_event = {
				description = "loc_objective_fm_resurgence_end_event_desc",
				header = "loc_objective_fm_resurgence_end_event_header",
				mission_objective_type = "goal",
			},
			objective_fm_resurgence_destroy_aa_guns = {
				description = "loc_objective_fm_resurgence_destroy_aa_guns_desc",
				header = "loc_objective_fm_resurgence_destroy_aa_guns_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
				turn_off_backfill = true,
			},
			objective_fm_resurgence_survive_end = {
				description = "loc_objective_fm_resurgence_survive_end_desc",
				duration = 120,
				header = "loc_objective_fm_resurgence_survive_end_header",
				mission_objective_type = "timed",
				music_wwise_state = "fortification_event",
				progress_bar = true,
			},
			objective_fm_resurgence_activate_beacon = {
				description = "loc_objective_fm_resurgence_activate_beacon_desc",
				header = "loc_objective_fm_resurgence_activate_beacon_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_fm_resurgence_clear = {
				description = "loc_objective_fm_resurgence_clear_desc",
				header = "loc_objective_fm_resurgence_clear_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_fm_resurgence_extract = {
				description = "loc_objective_fm_resurgence_extract_desc",
				header = "loc_objective_fm_resurgence_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
