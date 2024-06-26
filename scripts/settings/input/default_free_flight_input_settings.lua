-- chunkname: @scripts/settings/input/default_free_flight_input_settings.lua

local DefaultFreeFlightInputFilters = require("scripts/settings/input/default_free_flight_input_filters")
local default_free_flight_input_settings = {
	service_type = "FreeFlight",
	supported_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller",
	},
	default_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller",
	},
	filters = DefaultFreeFlightInputFilters,
	settings = {
		frustum_toggle = {
			type = "pressed",
			raw = {
				"keyboard_f10",
				"xbox_controller_x",
				"ps4_controller_square",
			},
		},
		global_toggle = {
			type = "pressed",
			raw = {
				"keyboard_f9",
				"xbox_controller_left_thumb+xbox_controller_right_thumb",
				"xbox_controller_right_thumb+xbox_controller_left_thumb",
				"ps4_controller_l3+ps4_controller_r3",
				"ps4_controller_r3+ps4_controller_l3",
			},
		},
		toggle_dof = {
			raw = "keyboard_f",
			type = "pressed",
		},
		reset_dof = {
			raw = "keyboard_left ctrl+keyboard_f",
			type = "pressed",
		},
		inc_dof_distance = {
			raw = "keyboard_g",
			type = "pressed",
		},
		dec_dof_distance = {
			raw = "keyboard_b",
			type = "pressed",
		},
		look = {
			type = "axis",
			raw = {
				"mouse_mouse",
				"xbox_controller_right",
				"ps4_controller_right",
			},
		},
		toggle_look_input = {
			raw = "keyboard_tab",
			type = "pressed",
		},
		toggle_input_in_free_flight = {
			raw = "keyboard_left ctrl+keyboard_space",
			type = "pressed",
		},
		move_controller = {
			raw = "xbox_controller_left",
			type = "axis",
		},
		top_down_toggle = {
			raw = "keyboard_f8",
			type = "pressed",
		},
		keyboard_move_left = {
			raw = "keyboard_a",
			type = "button",
		},
		keyboard_move_right = {
			raw = "keyboard_d",
			type = "button",
		},
		keyboard_move_forward = {
			raw = "keyboard_w",
			type = "button",
		},
		keyboard_move_backward = {
			raw = "keyboard_s",
			type = "button",
		},
		move_up = {
			type = "button",
			raw = {
				"keyboard_e",
				"xbox_controller_right_trigger",
				"ps4_controller_r2",
			},
		},
		move_down = {
			type = "button",
			raw = {
				"keyboard_q",
				"xbox_controller_left_trigger",
				"ps4_controller_l2",
			},
		},
		roll_left = {
			type = "button",
			raw = {
				"xbox_controller_right_shoulder",
				"ps4_controller_r1",
			},
		},
		roll_right = {
			type = "button",
			raw = {
				"xbox_controller_left_shoulder",
				"ps4_controller_l1",
			},
		},
		increase_fov = {
			type = "pressed",
			raw = {
				"keyboard_numpad plus",
				"xbox_controller_d_left",
				"ps4_controller_d_left",
			},
		},
		decrease_fov = {
			type = "pressed",
			raw = {
				"keyboard_num minus",
				"xbox_controller_d_right",
				"ps4_controller_d_right",
			},
		},
		increase_fov_hold = {
			type = "held",
			raw = {
				"keyboard_left ctrl+keyboard_numpad plus",
				"xbox_controller_d_down",
				"ps4_controller_d_down",
			},
		},
		decrease_fov_hold = {
			type = "held",
			raw = {
				"keyboard_left ctrl+keyboard_num minus",
				"xbox_controller_d_up",
				"ps4_controller_d_up",
			},
		},
		pick = {
			raw = "keyboard_l",
			type = "pressed",
		},
		inc_dof_region = {
			raw = "keyboard_h",
			type = "pressed",
		},
		dec_dof_region = {
			raw = "keyboard_n",
			type = "pressed",
		},
		alt_action = {
			raw = "keyboard_left ctrl",
			type = "pressed",
		},
		inc_dof_padding = {
			raw = "keyboard_j",
			type = "pressed",
		},
		dec_dof_padding = {
			raw = "keyboard_m",
			type = "pressed",
		},
		inc_dof_scale = {
			raw = "keyboard_k",
			type = "pressed",
		},
		dec_dof_scale = {
			raw = "keyboard_oem_comma",
			type = "pressed",
		},
		mouse_wheel = {
			raw = "mouse_wheel-keyboard_left shift",
			type = "axis",
		},
		teleport_player_to_camera = {
			type = "pressed",
			raw = {
				"keyboard_enter",
				"xbox_controller_left_trigger+xbox_controller_right_trigger",
				"ps4_controller_l2+ps4_controller_r2",
			},
		},
	},
}

return settings("DefaultFreeFlightInputSettings", default_free_flight_input_settings)
