-- chunkname: @scripts/settings/mission_objective/templates/fm_resurgence_objective_template.lua

local mission_objective_templates = {
	fm_resurgence = {
		main_objective_type = "fortification_objective",
		objectives = {
			objective_fm_resurgence_start = {
				description = "loc_objective_fm_resurgence_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_start_header"
			},
			objective_fm_resurgence_bridge = {
				use_music_event = "fortification_event",
				description = "loc_objective_fm_resurgence_bridge_desc",
				header = "loc_objective_fm_resurgence_bridge_header",
				mission_objective_type = "luggable",
				music_ignore_start_event = true
			},
			objective_fm_resurgence_lower = {
				use_music_event = "fortification_event",
				description = "loc_objective_fm_resurgence_lower_desc",
				header = "loc_objective_fm_resurgence_lower_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true
			},
			objective_fm_resurgence_survive_mid = {
				description = "loc_objective_fm_resurgence_survive_mid_desc",
				progress_bar = true,
				use_music_event = "fortification_event",
				header = "loc_objective_fm_resurgence_survive_mid_header",
				duration = 75,
				mission_objective_type = "timed"
			},
			objective_fm_resurgence_approach = {
				description = "loc_objective_fm_resurgence_approach_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_approach_header"
			},
			objective_fm_resurgence_end_event = {
				description = "loc_objective_fm_resurgence_end_event_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_end_event_header"
			},
			objective_fm_resurgence_destroy_aa_guns = {
				description = "loc_objective_fm_resurgence_destroy_aa_guns_desc",
				use_music_event = "fortification_event",
				header = "loc_objective_fm_resurgence_destroy_aa_guns_header",
				turn_off_backfill = true,
				mission_objective_type = "goal"
			},
			objective_fm_resurgence_survive_end = {
				description = "loc_objective_fm_resurgence_survive_end_desc",
				progress_bar = true,
				use_music_event = "fortification_event",
				header = "loc_objective_fm_resurgence_survive_end_header",
				duration = 120,
				mission_objective_type = "timed"
			},
			objective_fm_resurgence_activate_beacon = {
				description = "loc_objective_fm_resurgence_activate_beacon_desc",
				use_music_event = "fortification_event",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_activate_beacon_header"
			},
			objective_fm_resurgence_clear = {
				description = "loc_objective_fm_resurgence_clear_desc",
				use_music_event = "fortification_event",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_clear_header"
			},
			objective_fm_resurgence_extract = {
				description = "loc_objective_fm_resurgence_extract_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_fm_resurgence_extract_header"
			}
		}
	}
}

return mission_objective_templates
