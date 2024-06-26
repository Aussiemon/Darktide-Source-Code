-- chunkname: @scripts/settings/mission_objective/templates/km_station_objective_template.lua

local mission_objective_templates = {
	km_station = {
		objectives = {
			objective_km_station_leave_start = {
				description = "loc_objective_km_station_leave_start_desc",
				header = "loc_objective_km_station_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_km_station_find_voxarray = {
				description = "loc_objective_km_station_find_voxarray_desc",
				header = "loc_objective_km_station_find_voxarray_header",
				mission_objective_type = "goal",
			},
			objective_km_station_decoder = {
				description = "loc_objective_km_station_decoder_desc",
				event_type = "mid_event",
				header = "loc_objective_km_station_decoder_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_km_station_vox_exit = {
				description = "loc_objective_km_station_vox_exit_desc",
				header = "loc_objective_km_station_vox_exit_header",
				mission_objective_type = "goal",
			},
			objective_km_station_find_target = {
				description = "loc_objective_km_station_find_target_desc",
				header = "loc_objective_km_station_find_target_header",
				mission_objective_type = "goal",
			},
			objective_km_station_reach_platform = {
				description = "loc_objective_km_station_reach_platform_desc",
				header = "loc_objective_km_station_reach_platform_header",
				mission_objective_type = "goal",
			},
			objective_km_station_elevator = {
				description = "loc_objective_km_station_elevator_desc",
				header = "loc_objective_km_station_elevator_header",
				mission_objective_type = "goal",
			},
			objective_km_station_eliminate_target = {
				description = "loc_objective_km_station_eliminate_target_desc",
				event_type = "end_event",
				header = "loc_objective_km_station_eliminate_target_header",
				mission_objective_type = "kill",
				music_wwise_state = "kill_event",
				turn_off_backfill = true,
			},
		},
	},
}

return mission_objective_templates
