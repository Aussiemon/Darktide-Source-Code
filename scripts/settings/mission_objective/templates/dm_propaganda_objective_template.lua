-- chunkname: @scripts/settings/mission_objective/templates/dm_propaganda_objective_template.lua

local mission_objective_templates = {
	dm_propaganda = {
		main_objective_type = "demolition_objective",
		objectives = {
			objective_dm_propaganda_leave_start = {
				description = "loc_objective_dm_propaganda_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_leave_start_header"
			},
			objective_dm_propaganda_navigate_dunes = {
				description = "loc_objective_dm_propaganda_navigate_dunes_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_navigate_dunes_header"
			},
			objective_dm_propaganda_power_door = {
				use_music_event = "collect_event",
				description = "loc_objective_dm_propaganda_power_door_desc",
				header = "loc_objective_dm_propaganda_power_door_header",
				event_type = "mid_event",
				mission_objective_type = "luggable"
			},
			objective_dm_propaganda_stop_fan = {
				use_music_event = "collect_event",
				description = "loc_objective_dm_propaganda_stop_fan_desc",
				header = "loc_objective_dm_propaganda_stop_fan_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_dm_propaganda_enter_trenches = {
				description = "loc_objective_dm_propaganda_enter_trenches_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_enter_trenches_header"
			},
			objective_dm_propaganda_enter_tower = {
				description = "loc_objective_dm_propaganda_enter_tower_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_enter_tower_header"
			},
			objective_dm_propaganda_start_shaft = {
				description = "loc_objective_dm_propaganda_start_shaft_desc",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_start_shaft_header"
			},
			objective_dm_propaganda_demolition_first = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_demolition_first_desc",
				header = "loc_objective_dm_propaganda_demolition_first_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_propaganda_demolition_a = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_demolition_a_desc",
				header = "loc_objective_dm_propaganda_demolition_a_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_propaganda_activate_first_bridge = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_activate_first_bridge_desc",
				header = "loc_objective_dm_propaganda_activate_first_bridge_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_propaganda_reach_second_floor = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_reach_second_floor_desc",
				header = "loc_objective_dm_propaganda_reach_second_floor_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_propaganda_demolition_b = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_demolition_b_desc",
				header = "loc_objective_dm_propaganda_demolition_b_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_propaganda_activate_second_bridge = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_propaganda_activate_second_bridge_desc",
				header = "loc_objective_dm_propaganda_activate_second_bridge_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_propaganda_demolition_final = {
				description = "loc_objective_dm_propaganda_demolition_final_desc",
				mission_objective_type = "demolition",
				header = "loc_objective_dm_propaganda_demolition_final_header"
			},
			objective_dm_propaganda_enter_dish = {
				description = "loc_objective_dm_propaganda_enter_dish_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_enter_dish_header"
			},
			objective_dm_propaganda_rotate_antenna_one = {
				description = "loc_objective_dm_propaganda_rotate_antenna_one_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_rotate_antenna_one_header"
			},
			objective_dm_propaganda_rotate_antenna_two = {
				description = "loc_objective_dm_propaganda_rotate_antenna_two_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_rotate_antenna_two_header"
			},
			objective_dm_propaganda_rotate_antenna_three = {
				description = "loc_objective_dm_propaganda_rotate_antenna_three_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_rotate_antenna_three_header"
			},
			objective_dm_propaganda_survive = {
				description = "loc_objective_dm_propaganda_survive_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_survive_header"
			},
			objective_dm_propaganda_override_antenna_one = {
				description = "loc_objective_dm_propaganda_override_antenna_one_desc",
				progress_bar = true,
				header = "loc_objective_dm_propaganda_override_antenna_one_header",
				duration = 15,
				mission_objective_type = "timed"
			},
			objective_dm_propaganda_override_antenna_two = {
				description = "loc_objective_dm_propaganda_override_antenna_two_desc",
				progress_bar = true,
				header = "loc_objective_dm_propaganda_override_antenna_two_header",
				duration = 15,
				mission_objective_type = "timed"
			},
			objective_dm_propaganda_extract = {
				description = "loc_objective_dm_propaganda_extract_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_dm_propaganda_extract_header"
			}
		}
	}
}

return mission_objective_templates
