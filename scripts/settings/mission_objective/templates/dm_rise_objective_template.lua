-- chunkname: @scripts/settings/mission_objective/templates/dm_rise_objective_template.lua

local mission_objective_templates = {
	dm_rise = {
		objectives = {
			objective_dm_rise_reach_lockdown_command = {
				description = "loc_objective_dm_rise_reach_lockdown_command_desc",
				header = "loc_objective_dm_rise_reach_lockdown_command_header",
				mission_objective_type = "goal",
			},
			objective_dm_rise_open_luggables = {
				description = "loc_objective_dm_rise_power_trains_desc",
				header = "loc_objective_dm_rise_power_trains_header",
				mission_objective_type = "goal",
			},
			objective_dm_rise_power_trains = {
				description = "loc_objective_dm_rise_open_luggables_desc",
				event_type = "mid_event",
				header = "loc_objective_dm_rise_open_luggables_header",
				mission_objective_type = "luggable",
				music_wwise_state = "collect_event",
			},
			objective_dm_rise_lockdown = {
				description = "loc_objective_dm_rise_lockdown_desc",
				event_type = "mid_event",
				header = "loc_objective_dm_rise_lockdown_header",
				mission_objective_type = "decode",
				music_wwise_state = "collect_event",
				progress_bar = true,
			},
			objective_dm_rise_lockdown_two = {
				description = "loc_objective_dm_rise_lockdown_two_desc",
				event_type = "mid_event",
				header = "loc_objective_dm_rise_lockdown_two_header",
				mission_objective_type = "decode",
				music_wwise_state = "collect_event",
				progress_bar = true,
			},
			objective_dm_rise_open_depot_doors = {
				description = "loc_objective_dm_rise_open_depot_doors_desc",
				header = "loc_objective_dm_rise_open_depot_doors_header",
				mission_objective_type = "goal",
			},
			objective_dm_rise_reach_shaft_depot = {
				description = "loc_objective_dm_rise_reach_shaft_depot_desc",
				header = "loc_objective_dm_rise_reach_shaft_depot_header",
				mission_objective_type = "goal",
			},
			objective_dm_rise_enter_platform = {
				description = "loc_objective_dm_rise_enter_platform_desc",
				header = "loc_objective_dm_rise_enter_platform_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_dm_rise_enter_platform_two = {
				description = "loc_objective_dm_rise_enter_platform_two_desc",
				event_type = "end_event",
				header = "loc_objective_dm_rise_enter_platform_two_header",
				mission_objective_type = "goal",
				music_wwise_state = "demolition_event",
			},
			objective_dm_rise_survive = {
				description = "loc_objective_dm_rise_survive_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_dm_rise_survive_header",
				mission_objective_type = "timed",
				music_wwise_state = "demolition_event",
				progress_bar = true,
			},
			objective_dm_rise_survive_two = {
				description = "loc_objective_dm_rise_survive_two_desc",
				duration = 90,
				event_type = "end_event",
				header = "loc_objective_dm_rise_survive_two_header",
				mission_objective_type = "timed",
				music_wwise_state = "demolition_event",
				progress_bar = true,
			},
			objective_dm_rise_demo_floor_one = {
				description = "loc_objective_dm_rise_demo_floor_one_desc",
				event_type = "end_event",
				header = "loc_objective_dm_rise_demo_floor_one_header",
				mission_objective_type = "demolition",
				music_wwise_state = "demolition_event",
			},
			objective_dm_rise_demo_floor_two = {
				description = "loc_objective_dm_rise_demo_floor_two_desc",
				event_type = "end_event",
				header = "loc_objective_dm_rise_demo_floor_two_header",
				mission_objective_type = "demolition",
				music_wwise_state = "demolition_event",
			},
			objective_dm_rise_escape = {
				description = "loc_objective_dm_rise_escape_desc",
				header = "loc_objective_dm_rise_escape_header",
				mission_objective_type = "luggable",
				music_wwise_state = "escape_event",
			},
			objective_dm_rise_luggable_secret_01 = {
				hidden = true,
				mission_objective_type = "luggable",
			},
			objective_dm_rise_luggable_secret_02 = {
				hidden = true,
				mission_objective_type = "luggable",
			},
		},
	},
}

return mission_objective_templates
