local mission_objective_templates = {
	dm_rise = {
		main_objective_type = "demolition_objective",
		objectives = {
			objective_dm_rise_reach_lockdown_command = {
				description = "loc_objective_dm_rise_reach_lockdown_command_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_rise_reach_lockdown_command_header"
			},
			objective_dm_rise_open_luggables = {
				description = "loc_objective_dm_rise_power_trains_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_rise_power_trains_header"
			},
			objective_dm_rise_power_trains = {
				use_music_event = "collect_event",
				description = "loc_objective_dm_rise_open_luggables_desc",
				header = "loc_objective_dm_rise_open_luggables_header",
				event_type = "mid_event",
				mission_objective_type = "luggable"
			},
			objective_dm_rise_lockdown = {
				description = "loc_objective_dm_rise_lockdown_desc",
				use_music_event = "collect_event",
				header = "loc_objective_dm_rise_lockdown_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_dm_rise_lockdown_two = {
				description = "loc_objective_dm_rise_lockdown_two_desc",
				use_music_event = "collect_event",
				header = "loc_objective_dm_rise_lockdown_two_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_dm_rise_open_depot_doors = {
				description = "loc_objective_dm_rise_open_depot_doors_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_rise_open_depot_doors_header"
			},
			objective_dm_rise_reach_shaft_depot = {
				description = "loc_objective_dm_rise_reach_shaft_depot_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_rise_reach_shaft_depot_header"
			},
			objective_dm_rise_enter_platform = {
				description = "loc_objective_dm_rise_enter_platform_desc",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				header = "loc_objective_dm_rise_enter_platform_header"
			},
			objective_dm_rise_enter_platform_two = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_rise_enter_platform_two_desc",
				header = "loc_objective_dm_rise_enter_platform_two_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_rise_survive = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_rise_survive_desc",
				progress_bar = true,
				header = "loc_objective_dm_rise_survive_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_dm_rise_survive_two = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_rise_survive_two_desc",
				progress_bar = true,
				header = "loc_objective_dm_rise_survive_two_header",
				event_type = "end_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_dm_rise_demo_floor_one = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_rise_demo_floor_one_desc",
				header = "loc_objective_dm_rise_demo_floor_one_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_rise_demo_floor_two = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_rise_demo_floor_two_desc",
				header = "loc_objective_dm_rise_demo_floor_two_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_rise_escape = {
				description = "loc_objective_dm_rise_escape_desc",
				use_music_event = "escape_event",
				mission_objective_type = "luggable",
				header = "loc_objective_dm_rise_escape_header"
			}
		}
	}
}

return mission_objective_templates
