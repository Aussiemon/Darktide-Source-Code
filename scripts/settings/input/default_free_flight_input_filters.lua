local default_free_flight_input_filters = {
	reset_dof = {
		filter_type = "and",
		input_mappings = {
			button_1 = "toggle_dof",
			button_2 = "alt_action"
		}
	},
	speed_change = {
		filter_type = "vector_y",
		input_mappings = "mouse_wheel"
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
	}
}

return settings("DefaultFreeFlightInputFilters", default_free_flight_input_filters)
