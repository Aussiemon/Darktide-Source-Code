local DefaultFreeFlightInputFilters = require("scripts/settings/input/default_free_flight_input_filters")
local default_free_flight_input_settings = {
	service_type = "FreeFlight",
	supported_devices = {
		"keyboard",
		"mouse",
		"xbox_controller"
	},
	default_devices = {
		"keyboard",
		"mouse",
		"xbox_controller"
	},
	filters = DefaultFreeFlightInputFilters,
	settings = {
		frustum_toggle = {
			type = "pressed",
			raw = {
				"keyboard_f10",
				"xbox_controller_x"
			}
		},
		global_toggle = {
			type = "pressed",
			raw = {
				"keyboard_f9",
				"xbox_controller_left_thumb+xbox_controller_right_thumb",
				"xbox_controller_right_thumb+xbox_controller_left_thumb"
			}
		},
		toggle_dof = {
			raw = "keyboard_f",
			type = "pressed"
		},
		reset_dof = {
			raw = "keyboard_left ctrl+keyboard_f",
			type = "pressed"
		},
		inc_dof_distance = {
			raw = "keyboard_g",
			type = "pressed"
		},
		dec_dof_distance = {
			raw = "keyboard_b",
			type = "pressed"
		},
		look = {
			type = "axis",
			raw = {
				"mouse_mouse",
				"xbox_controller_right"
			}
		},
		toggle_look_input = {
			raw = "keyboard_tab",
			type = "pressed"
		},
		move_controller = {
			raw = "xbox_controller_left",
			type = "axis"
		},
		top_down_toggle = {
			raw = "keyboard_f8",
			type = "pressed"
		},
		keyboard_move_left = {
			raw = "keyboard_a",
			type = "button"
		},
		keyboard_move_right = {
			raw = "keyboard_d",
			type = "button"
		},
		keyboard_move_forward = {
			raw = "keyboard_w",
			type = "button"
		},
		keyboard_move_backward = {
			raw = "keyboard_s",
			type = "button"
		},
		move_up = {
			raw = "keyboard_e",
			type = "button"
		},
		move_down = {
			raw = "keyboard_q",
			type = "button"
		},
		increase_fov = {
			raw = "keyboard_numpad plus",
			type = "pressed"
		},
		decrease_fov = {
			raw = "keyboard_num minus",
			type = "pressed"
		},
		pick = {
			raw = "keyboard_l",
			type = "pressed"
		},
		inc_dof_region = {
			raw = "keyboard_h",
			type = "pressed"
		},
		dec_dof_region = {
			raw = "keyboard_n",
			type = "pressed"
		},
		alt_action = {
			raw = "keyboard_left ctrl",
			type = "pressed"
		},
		inc_dof_padding = {
			raw = "keyboard_j",
			type = "pressed"
		},
		dec_dof_padding = {
			raw = "keyboard_m",
			type = "pressed"
		},
		inc_dof_scale = {
			raw = "keyboard_k",
			type = "pressed"
		},
		dec_dof_scale = {
			raw = "keyboard_oem_comma",
			type = "pressed"
		},
		mouse_wheel = {
			raw = "mouse_wheel-keyboard_left shift",
			type = "axis"
		},
		teleport_player_to_camera = {
			type = "pressed",
			raw = {
				"keyboard_enter",
				"xbox_controller_left_trigger+xbox_controller_right_trigger"
			}
		}
	}
}

return settings("DefaultFreeFlightInputSettings", default_free_flight_input_settings)
