-- chunkname: @scripts/settings/mission_objective/templates/dm_stockpile_objective_template.lua

local mission_objective_templates = {
	dm_stockpile = {
		main_objective_type = "demolition_objective",
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
				progress_bar = false,
				use_music_event = "fortification_event",
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
				use_music_event = "demolition_event",
			},
			objective_dm_stockpile_corruptor_event = {
				description = "loc_objective_dm_stockpile_corruptor_event_desc",
				event_type = "end_event",
				header = "loc_objective_dm_stockpile_corruptor_event_header",
				mission_objective_type = "demolition",
				turn_off_backfill = true,
				use_music_event = "demolition_event",
			},
			objective_dm_stockpile_wait_purge = {
				description = "loc_objective_dm_stockpile_wait_purge_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_dm_stockpile_wait_purge_header",
				mission_objective_type = "timed",
				progress_bar = false,
				use_music_event = "demolition_event",
			},
			objective_dm_stockpile_escape = {
				description = "loc_objective_dm_stockpile_escape_desc",
				header = "loc_objective_dm_stockpile_escape_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
