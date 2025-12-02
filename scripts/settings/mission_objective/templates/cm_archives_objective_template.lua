-- chunkname: @scripts/settings/mission_objective/templates/cm_archives_objective_template.lua

local mission_objective_templates = {
	cm_archives = {
		objectives = {
			objective_cm_archives_outside = {
				description = "loc_objective_cm_archives_outside_desc",
				header = "loc_objective_cm_archives_outside_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_cm_archives_basement_start = {
				description = "loc_objective_cm_archives_basement_start_desc",
				header = "loc_objective_cm_archives_basement_start_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_cm_archives_basement = {
				description = "loc_objective_cm_archives_basement_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_archives_basement_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_archives_basement_mid_section = {
				description = "loc_objective_cm_archives_basement_mid_section_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_archives_basement_mid_section_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_archives_basement_first_lockdown = {
				description = "loc_objective_cm_archives_basement_first_lockdown_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_archives_basement_first_lockdown_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_archives_basement_second_mid_section = {
				description = "loc_objective_cm_archives_basement_second_mid_section_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_archives_basement_second_mid_section_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_archives_basement_second_lockdown = {
				description = "loc_objective_cm_archives_basement_second_lockdown_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_archives_basement_second_lockdown_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_archives_basement_deactivate_alarm = {
				description = "loc_objective_cm_archives_basement_deactivate_alarm_desc",
				header = "loc_objective_cm_archives_basement_deactivate_alarm_header",
				mission_objective_type = "goal",
			},
			objective_cm_archives_archives_upper = {
				description = "loc_objective_cm_archives_archives_upper_desc",
				header = "loc_objective_cm_archives_archives_upper_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_cm_archives_archives_deep = {
				description = "loc_objective_cm_archives_archives_deep_desc",
				header = "loc_objective_cm_archives_archives_deep_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_cm_archives_control_end_event = {
				description = "loc_objective_cm_archives_control_end_event_desc",
				event_type = "end_event",
				header = "loc_objective_cm_archives_control_end_event_header",
				mission_giver_voice_profile = "tech_priest_a",
				mission_objective_type = "scanning",
				music_ignore_start_event = true,
				music_wwise_state = "scanning_event",
				turn_off_backfill = true,
			},
			objective_cm_archives_absconditum_start_printing = {
				description = "loc_objective_cm_archives_absconditum_start_printing_desc",
				event_type = "end_event",
				header = "loc_objective_cm_archives_absconditum_start_printing_header",
				mission_objective_type = "goal",
				music_wwise_state = "scanning_event",
			},
			objective_cm_archives_absconditum_printing_progress = {
				description = "loc_objective_cm_archives_absconditum_printing_progress_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_cm_archives_absconditum_printing_progress_header",
				mission_objective_type = "timed",
				music_wwise_state = "scanning_event",
				progress_bar = true,
			},
			objective_cm_archives_absconditum_collect_data = {
				description = "loc_objective_cm_archives_absconditum_collect_data_desc",
				event_type = "end_event",
				header = "loc_objective_cm_archives_absconditum_collect_data_header",
				mission_objective_type = "goal",
				music_wwise_state = "scanning_event",
			},
			objective_cm_archives_absconditum_escape = {
				description = "loc_objective_cm_archives_absconditum_escape_desc",
				header = "loc_objective_cm_archives_absconditum_escape_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
