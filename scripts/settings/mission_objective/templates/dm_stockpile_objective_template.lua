-- chunkname: @scripts/settings/mission_objective/templates/dm_stockpile_objective_template.lua

local mission_objective_templates = {
	dm_stockpile = {
		objectives = {
			objective_dm_stockpile_enter_hq = {
				description = "loc_objective_dm_stockpile_enter_hq_desc",
				header = "loc_objective_dm_stockpile_enter_hq_header",
				mission_objective_type = "goal",
			},
			objective_dm_stockpile_reach_elevator = {
				description = "loc_objective_dm_stockpile_reach_elevator_desc",
				header = "loc_objective_dm_stockpile_reach_elevator_header",
				mission_objective_type = "goal",
			},
			objective_dm_stockpile_wait_elevator = {
				description = "loc_objective_dm_stockpile_wait_elevator_desc",
				duration = 118,
				event_type = "mid_event",
				header = "loc_objective_dm_stockpile_wait_elevator_header",
				mission_objective_type = "timed",
				music_wwise_state = "fortification_event",
				progress_bar = false,
			},
			objective_dm_stockpile_ride_elevator = {
				description = "loc_objective_dm_stockpile_ride_elevator_desc",
				header = "loc_objective_dm_stockpile_ride_elevator_header",
				mission_objective_type = "goal",
			},
			objective_dm_stockpile_enter_stockpile = {
				description = "loc_objective_dm_stockpile_enter_stockpile_desc",
				header = "loc_objective_dm_stockpile_enter_stockpile_header",
				mission_objective_type = "goal",
			},
			objective_dm_stockpile_initiate_clean = {
				description = "loc_objective_dm_stockpile_initiate_clean_desc",
				header = "loc_objective_dm_stockpile_initiate_clean_header",
				mission_objective_type = "goal",
			},
			objective_dm_stockpile_purge_system = {
				description = "loc_objective_dm_stockpile_purge_system_desc",
				event_type = "end_event",
				header = "loc_objective_dm_stockpile_purge_system_header",
				mission_objective_type = "goal",
				music_wwise_state = "demolition_event",
			},
			objective_dm_stockpile_corruptor_event = {
				description = "loc_objective_dm_stockpile_corruptor_event_desc",
				event_type = "end_event",
				header = "loc_objective_dm_stockpile_corruptor_event_header",
				mission_objective_type = "demolition",
				music_wwise_state = "demolition_event",
				turn_off_backfill = true,
			},
			objective_dm_stockpile_wait_purge = {
				description = "loc_objective_dm_stockpile_wait_purge_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_dm_stockpile_wait_purge_header",
				mission_objective_type = "timed",
				music_wwise_state = "demolition_event",
				progress_bar = false,
			},
			objective_dm_stockpile_escape = {
				description = "loc_objective_dm_stockpile_escape_desc",
				header = "loc_objective_dm_stockpile_escape_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
