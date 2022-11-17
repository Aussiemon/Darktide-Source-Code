local mission_objective_templates = {
	dm_stockpile = {
		main_objective_type = "demolition_objective",
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
				use_music_event = "fortification_event",
				description = "loc_objective_dm_stockpile_wait_elevator_desc",
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
				use_music_event = "demolition_event",
				description = "loc_objective_dm_stockpile_purge_system_desc",
				header = "loc_objective_dm_stockpile_purge_system_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_stockpile_corruptor_event = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_stockpile_corruptor_event_desc",
				turn_off_backfill = true,
				header = "loc_objective_dm_stockpile_corruptor_event_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_stockpile_wait_purge = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_stockpile_wait_purge_desc",
				progress_bar = false,
				header = "loc_objective_dm_stockpile_wait_purge_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_dm_stockpile_escape = {
				description = "loc_objective_dm_stockpile_escape_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_dm_stockpile_escape_header"
			}
		}
	}
}

return mission_objective_templates
