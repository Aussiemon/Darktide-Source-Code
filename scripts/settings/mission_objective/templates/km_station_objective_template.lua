-- chunkname: @scripts/settings/mission_objective/templates/km_station_objective_template.lua

local mission_objective_templates = {
	km_station = {
		objectives = {
			objective_km_station_leave_start = {
				description = "loc_objective_km_station_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_leave_start_header"
			},
			objective_km_station_find_voxarray = {
				description = "loc_objective_km_station_find_voxarray_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_find_voxarray_header"
			},
			objective_km_station_decoder = {
				description = "loc_objective_km_station_decoder_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_km_station_decoder_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_km_station_vox_exit = {
				description = "loc_objective_km_station_vox_exit_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_vox_exit_header"
			},
			objective_km_station_find_target = {
				description = "loc_objective_km_station_find_target_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_find_target_header"
			},
			objective_km_station_reach_platform = {
				description = "loc_objective_km_station_reach_platform_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_reach_platform_header"
			},
			objective_km_station_elevator = {
				description = "loc_objective_km_station_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_km_station_elevator_header"
			},
			objective_km_station_eliminate_target = {
				description = "loc_objective_km_station_eliminate_target_desc",
				music_wwise_state = "kill_event",
				turn_off_backfill = true,
				header = "loc_objective_km_station_eliminate_target_header",
				event_type = "end_event",
				mission_objective_type = "kill"
			}
		}
	}
}

return mission_objective_templates
