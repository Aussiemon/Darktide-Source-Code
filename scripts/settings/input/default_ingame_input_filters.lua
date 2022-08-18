local default_ingame_input_filters = {
	move_keys = {
		filter_type = "virtual_axis",
		input_mappings = {
			right = "keyboard_move_right",
			back = "keyboard_move_backward",
			left = "keyboard_move_left",
			forward = "keyboard_move_forward"
		}
	},
	axis_virtual_move_forward = {
		filter_type = "vector_y",
		input_mappings = "move_controller"
	},
	axis_virtual_move_backward = {
		filter_type = "vector_y",
		input_mappings = "move_controller",
		multiplier = -1
	},
	axis_virtual_move_right = {
		filter_type = "vector_x",
		input_mappings = "move_controller"
	},
	axis_virtual_move_left = {
		filter_type = "vector_x",
		input_mappings = "move_controller",
		multiplier = -1
	},
	move_forward = {
		filter_type = "scalar_combine",
		to_bool = false,
		max_value = 1,
		min_value = 0,
		input_mappings = {
			button_1 = "axis_virtual_move_forward",
			button_2 = "keyboard_move_forward"
		}
	},
	move_backward = {
		filter_type = "scalar_combine",
		to_bool = false,
		max_value = 1,
		min_value = 0,
		input_mappings = {
			button_1 = "axis_virtual_move_backward",
			button_2 = "keyboard_move_backward"
		}
	},
	move_right = {
		filter_type = "scalar_combine",
		to_bool = false,
		max_value = 1,
		min_value = 0,
		input_mappings = {
			button_1 = "axis_virtual_move_right",
			button_2 = "keyboard_move_right"
		}
	},
	move_left = {
		filter_type = "scalar_combine",
		to_bool = false,
		max_value = 1,
		min_value = 0,
		input_mappings = {
			button_1 = "axis_virtual_move_left",
			button_2 = "keyboard_move_left"
		}
	},
	move = {
		filter_type = "axis_combine",
		input_mappings = {
			source2 = "move_controller",
			source1 = "move_keys"
		}
	},
	look_controller = {
		input_threshold = "controller_look_dead_zone",
		multiplier = "controller_look_scale",
		acceleration_delay = 0.2,
		accelerate_time_ref = 0.5,
		threshold = 0.925,
		multiplier_min_x = 2,
		multiplier_x = 7,
		input_mappings = "look_raw_controller",
		multiplier_y = 0.75,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		power_of = 1.75,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y"
	},
	look_controller_lunging = {
		input_threshold = "controller_look_dead_zone",
		multiplier = "controller_look_scale",
		acceleration_delay = 0,
		accelerate_time_ref = 0.5,
		threshold = 0.925,
		multiplier_min_x = 1,
		multiplier_x = 2.2,
		input_mappings = "look_raw_controller",
		multiplier_y = 0.75,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		power_of = 1,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y"
	},
	look_controller_ranged = {
		turnaround_multiplier_x = 12,
		multiplier = "controller_look_scale",
		acceleration_delay = 0.05,
		turnaround_time_ref = 0.75,
		multiplier_min_x = 1.9,
		accelerate_time_ref = 0.6,
		multiplier_x = 4.6,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		turnaround_delay = 0.01,
		power_of = 2,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y",
		input_threshold = "controller_look_dead_zone",
		input_mappings = "look_raw_controller",
		threshold = 0.925,
		multiplier_y = 0.9,
		turnaround_threshold = 0.925,
		turnaround_power_of = 2
	},
	look_controller_ranged_alternate_fire = {
		input_threshold = "controller_look_dead_zone",
		multiplier = "controller_look_scale",
		acceleration_delay = 0,
		accelerate_time_ref = 0.3,
		threshold = 0.8,
		multiplier_min_x = 0.45,
		multiplier_x = 1.9,
		input_mappings = "look_raw_controller",
		multiplier_y = 0.8,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		power_of = 1.1,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y"
	},
	look_controller_melee = {
		turnaround_multiplier_x = 3,
		multiplier = "controller_look_scale",
		acceleration_delay = 0.01,
		turnaround_time_ref = 0.75,
		multiplier_min_x = 2.5,
		accelerate_time_ref = 0.15,
		multiplier_x = 3.6,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		turnaround_delay = 0.01,
		power_of = 1.5,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y",
		input_threshold = "controller_look_dead_zone",
		input_mappings = "look_raw_controller",
		threshold = 0.65,
		multiplier_y = 1,
		turnaround_threshold = 0.925,
		turnaround_power_of = 2
	},
	look_controller_melee_sticky = {
		turnaround_multiplier_x = 3,
		multiplier = "controller_look_scale",
		acceleration_delay = 0,
		turnaround_time_ref = 0.75,
		multiplier_min_x = 1,
		accelerate_time_ref = 0.3,
		multiplier_x = 1,
		filter_type = "scale_vector3_xy_accelerated_x_dev_params",
		turnaround_delay = 0.01,
		power_of = 1,
		enable_acceleration = "controller_enable_acceleration",
		invert_look_y = "controller_invert_look_y",
		input_threshold = "controller_look_dead_zone",
		input_mappings = "look_raw_controller",
		threshold = 0.65,
		multiplier_y = 1,
		turnaround_threshold = 0.925,
		turnaround_power_of = 2
	}
}

return settings("DefaultIngameInputFilters", default_ingame_input_filters)
