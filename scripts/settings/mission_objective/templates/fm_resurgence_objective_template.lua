-- chunkname: @scripts/settings/mission_objective/templates/fm_resurgence_objective_template.lua

local mission_objective_templates = {
	fm_resurgence = {
		main_objective_type = "fortification_objective",
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
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_lower = {
				description = "loc_objective_fm_resurgence_lower_desc",
				header = "loc_objective_fm_resurgence_lower_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_survive_mid = {
				description = "loc_objective_fm_resurgence_survive_mid_desc",
				duration = 75,
				header = "loc_objective_fm_resurgence_survive_mid_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "fortification_event",
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
				turn_off_backfill = true,
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_survive_end = {
				description = "loc_objective_fm_resurgence_survive_end_desc",
				duration = 120,
				header = "loc_objective_fm_resurgence_survive_end_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_activate_beacon = {
				description = "loc_objective_fm_resurgence_activate_beacon_desc",
				header = "loc_objective_fm_resurgence_activate_beacon_header",
				mission_objective_type = "goal",
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_clear = {
				description = "loc_objective_fm_resurgence_clear_desc",
				header = "loc_objective_fm_resurgence_clear_header",
				mission_objective_type = "goal",
				use_music_event = "fortification_event",
			},
			objective_fm_resurgence_extract = {
				description = "loc_objective_fm_resurgence_extract_desc",
				header = "loc_objective_fm_resurgence_extract_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
