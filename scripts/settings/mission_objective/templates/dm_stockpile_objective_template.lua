-- chunkname: @scripts/settings/mission_objective/templates/dm_stockpile_objective_template.lua

local mission_objective_templates = {
	dm_stockpile = {
		objectives = {
			objective_dm_stockpile_enter_hq = {
				description = "loc_objective_dm_stockpile_enter_hq_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_enter_hq_header"
			},
			objective_dm_stockpile_reach_elevator = {
				description = "loc_objective_dm_stockpile_reach_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_reach_elevator_header"
			},
			objective_dm_stockpile_wait_elevator = {
				description = "loc_objective_dm_stockpile_wait_elevator_desc",
				music_wwise_state = "fortification_event",
				progress_bar = false,
				header = "loc_objective_dm_stockpile_wait_elevator_header",
				event_type = "mid_event",
				duration = 118,
				mission_objective_type = "timed"
			},
			objective_dm_stockpile_ride_elevator = {
				description = "loc_objective_dm_stockpile_ride_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_ride_elevator_header"
			},
			objective_dm_stockpile_enter_stockpile = {
				description = "loc_objective_dm_stockpile_enter_stockpile_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_enter_stockpile_header"
			},
			objective_dm_stockpile_initiate_clean = {
				description = "loc_objective_dm_stockpile_initiate_clean_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_initiate_clean_header"
			},
			objective_dm_stockpile_purge_system = {
				description = "loc_objective_dm_stockpile_purge_system_desc",
				music_wwise_state = "demolition_event",
				header = "loc_objective_dm_stockpile_purge_system_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_stockpile_corruptor_event = {
				description = "loc_objective_dm_stockpile_corruptor_event_desc",
				music_wwise_state = "demolition_event",
				turn_off_backfill = true,
				header = "loc_objective_dm_stockpile_corruptor_event_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_stockpile_wait_purge = {
				description = "loc_objective_dm_stockpile_wait_purge_desc",
				music_wwise_state = "demolition_event",
				progress_bar = false,
				header = "loc_objective_dm_stockpile_wait_purge_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_dm_stockpile_escape = {
				description = "loc_objective_dm_stockpile_escape_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_escape_header"
			}
		}
	}
}

return mission_objective_templates
