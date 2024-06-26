-- chunkname: @scripts/settings/mission_objective/templates/dm_propaganda_objective_template.lua

local mission_objective_templates = {
	dm_propaganda = {
		objectives = {
			objective_dm_propaganda_leave_start = {
				description = "loc_objective_dm_propaganda_leave_start_desc",
				header = "loc_objective_dm_propaganda_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_navigate_dunes = {
				description = "loc_objective_dm_propaganda_navigate_dunes_desc",
				header = "loc_objective_dm_propaganda_navigate_dunes_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_power_door = {
				description = "loc_objective_dm_propaganda_power_door_desc",
				event_type = "mid_event",
				header = "loc_objective_dm_propaganda_power_door_header",
				mission_objective_type = "luggable",
				music_wwise_state = "collect_event",
			},
			objective_dm_propaganda_stop_fan = {
				description = "loc_objective_dm_propaganda_stop_fan_desc",
				event_type = "mid_event",
				header = "loc_objective_dm_propaganda_stop_fan_header",
				mission_objective_type = "goal",
				music_wwise_state = "collect_event",
			},
			objective_dm_propaganda_enter_trenches = {
				description = "loc_objective_dm_propaganda_enter_trenches_desc",
				header = "loc_objective_dm_propaganda_enter_trenches_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_enter_tower = {
				description = "loc_objective_dm_propaganda_enter_tower_desc",
				header = "loc_objective_dm_propaganda_enter_tower_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_start_shaft = {
				description = "loc_objective_dm_propaganda_start_shaft_desc",
				header = "loc_objective_dm_propaganda_start_shaft_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_dm_propaganda_demolition_first = {
				description = "loc_objective_dm_propaganda_demolition_first_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_demolition_first_header",
				mission_objective_type = "demolition",
				music_wwise_state = "progression_stage_1",
			},
			objective_dm_propaganda_demolition_a = {
				description = "loc_objective_dm_propaganda_demolition_a_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_demolition_a_header",
				mission_objective_type = "demolition",
				music_wwise_state = "progression_stage_1",
			},
			objective_dm_propaganda_activate_first_bridge = {
				description = "loc_objective_dm_propaganda_activate_first_bridge_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_activate_first_bridge_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_1",
			},
			objective_dm_propaganda_reach_second_floor = {
				description = "loc_objective_dm_propaganda_reach_second_floor_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_reach_second_floor_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_1",
			},
			objective_dm_propaganda_demolition_b = {
				description = "loc_objective_dm_propaganda_demolition_b_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_demolition_b_header",
				mission_objective_type = "demolition",
				music_wwise_state = "progression_stage_2",
			},
			objective_dm_propaganda_activate_second_bridge = {
				description = "loc_objective_dm_propaganda_activate_second_bridge_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_activate_second_bridge_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_2",
			},
			objective_dm_propaganda_demolition_final = {
				description = "loc_objective_dm_propaganda_demolition_final_desc",
				header = "loc_objective_dm_propaganda_demolition_final_header",
				mission_objective_type = "demolition",
			},
			objective_dm_propaganda_enter_dish = {
				description = "loc_objective_dm_propaganda_enter_dish_desc",
				header = "loc_objective_dm_propaganda_enter_dish_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_rotate_antenna_one = {
				description = "loc_objective_dm_propaganda_rotate_antenna_one_desc",
				header = "loc_objective_dm_propaganda_rotate_antenna_one_header",
				mission_objective_type = "goal",
			},
			objective_dm_propaganda_rotate_antenna_two = {
				description = "loc_objective_dm_propaganda_rotate_antenna_two_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_rotate_antenna_two_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_3",
			},
			objective_dm_propaganda_rotate_antenna_three = {
				description = "loc_objective_dm_propaganda_rotate_antenna_three_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_rotate_antenna_three_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_4",
			},
			objective_dm_propaganda_survive = {
				description = "loc_objective_dm_propaganda_survive_desc",
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_survive_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_4",
			},
			objective_dm_propaganda_override_antenna_one = {
				description = "loc_objective_dm_propaganda_override_antenna_one_desc",
				duration = 15,
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_override_antenna_one_header",
				mission_objective_type = "timed",
				music_wwise_state = "progression_stage_3",
				progress_bar = true,
			},
			objective_dm_propaganda_override_antenna_two = {
				description = "loc_objective_dm_propaganda_override_antenna_two_desc",
				duration = 15,
				event_type = "end_event",
				header = "loc_objective_dm_propaganda_override_antenna_two_header",
				mission_objective_type = "timed",
				music_wwise_state = "progression_stage_3",
				progress_bar = true,
			},
			objective_dm_propaganda_extract = {
				description = "loc_objective_dm_propaganda_extract_desc",
				header = "loc_objective_dm_propaganda_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
