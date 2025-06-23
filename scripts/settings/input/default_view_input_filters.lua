-- chunkname: @scripts/settings/input/default_view_input_filters.lua

local default_view_input_filters = {
	navigate_up_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_up_pressed",
			"navigate_up_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			0,
			1,
			0
		}
	},
	navigate_down_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_down_pressed",
			"navigate_down_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	navigate_left_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_left_pressed",
			"navigate_left_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	navigate_right_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_right_pressed",
			"navigate_right_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			1,
			0,
			0
		}
	},
	navigate_up_continuous_fast = {
		filter_type = "navigate_filter_continuous_fast",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_up_pressed",
			"navigate_up_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			0,
			1,
			0
		}
	},
	navigate_down_continuous_fast = {
		filter_type = "navigate_filter_continuous_fast",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_down_pressed",
			"navigate_down_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	navigate_left_continuous_fast = {
		filter_type = "navigate_filter_continuous_fast",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_left_pressed",
			"navigate_left_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	navigate_right_continuous_fast = {
		filter_type = "navigate_filter_continuous_fast",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"navigate_right_pressed",
			"navigate_right_hold"
		},
		axis_mappings = {
			"navigate_controller"
		},
		axis = {
			1,
			0,
			0
		}
	},
	scroll_up_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {},
		axis_mappings = {
			"scroll_axis"
		},
		axis = {
			0,
			1,
			0
		}
	},
	scroll_down_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {},
		axis_mappings = {
			"scroll_axis"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	scroll_left_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {},
		axis_mappings = {
			"scroll_axis"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	scroll_right_continuous = {
		filter_type = "navigate_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {},
		axis_mappings = {
			"scroll_axis"
		},
		axis = {
			1,
			0,
			0
		}
	},
	mouse_angle = {
		filter_type = "mouse_angle_constrained",
		input_mappings = "mouse_move",
		constraint = 100
	},
	navigation_keys_virtual_axis = {
		filter_type = "virtual_axis",
		input_mappings = {
			right = "navigate_right_raw",
			back = "navigate_down_raw",
			left = "navigate_left_raw",
			forward = "navigate_up_raw"
		}
	},
	navigation_axis = {
		filter_type = "navigate_axis_filter_continuous",
		initial_cooldown = 1,
		input_mappings = {
			source2 = "navigate_controller",
			source1 = "navigation_keys_virtual_axis"
		}
	}
}

return settings("DefaultViewInputFilters", default_view_input_filters)
