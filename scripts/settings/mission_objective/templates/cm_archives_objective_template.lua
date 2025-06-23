-- chunkname: @scripts/settings/mission_objective/templates/cm_archives_objective_template.lua

local mission_objective_templates = {
	cm_archives = {
		objectives = {
			objective_cm_archives_outside = {
				description = "loc_objective_cm_archives_outside_desc",
				music_wwise_state = "None",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_outside_header"
			},
			objective_cm_archives_basement_start = {
				description = "loc_objective_cm_archives_basement_start_desc",
				music_wwise_state = "None",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_basement_start_header"
			},
			objective_cm_archives_basement = {
				description = "loc_objective_cm_archives_basement_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_cm_archives_basement_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_basement_mid_section = {
				description = "loc_objective_cm_archives_basement_mid_section_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_cm_archives_basement_mid_section_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_basement_first_lockdown = {
				description = "loc_objective_cm_archives_basement_first_lockdown_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_cm_archives_basement_first_lockdown_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_basement_second_mid_section = {
				description = "loc_objective_cm_archives_basement_second_mid_section_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_cm_archives_basement_second_mid_section_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_basement_second_lockdown = {
				description = "loc_objective_cm_archives_basement_second_lockdown_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_cm_archives_basement_second_lockdown_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_basement_deactivate_alarm = {
				description = "loc_objective_cm_archives_basement_deactivate_alarm_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_basement_deactivate_alarm_header"
			},
			objective_cm_archives_archives_upper = {
				description = "loc_objective_cm_archives_archives_upper_desc",
				music_wwise_state = "None",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_archives_upper_header"
			},
			objective_cm_archives_archives_deep = {
				description = "loc_objective_cm_archives_archives_deep_desc",
				music_wwise_state = "None",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_archives_deep_header"
			},
			objective_cm_archives_control_end_event = {
				description = "loc_objective_cm_archives_control_end_event_desc",
				music_wwise_state = "scanning_event",
				header = "loc_objective_cm_archives_control_end_event_header",
				turn_off_backfill = true,
				mission_objective_type = "scanning",
				mission_giver_voice_profile = "tech_priest_a",
				has_second_progression = true,
				event_type = "end_event",
				progress_bar = true,
				music_ignore_start_event = true
			},
			objective_cm_archives_absconditum_start_printing = {
				description = "loc_objective_cm_archives_absconditum_start_printing_desc",
				music_wwise_state = "scanning_event",
				header = "loc_objective_cm_archives_absconditum_start_printing_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_absconditum_printing_progress = {
				description = "loc_objective_cm_archives_absconditum_printing_progress_desc",
				progress_bar = true,
				music_wwise_state = "scanning_event",
				header = "loc_objective_cm_archives_absconditum_printing_progress_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_cm_archives_absconditum_collect_data = {
				description = "loc_objective_cm_archives_absconditum_collect_data_desc",
				music_wwise_state = "scanning_event",
				header = "loc_objective_cm_archives_absconditum_collect_data_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_cm_archives_absconditum_escape = {
				description = "loc_objective_cm_archives_absconditum_escape_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_cm_archives_absconditum_escape_header"
			}
		}
	}
}

return mission_objective_templates
