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
	aliases = {
		frustum_toggle = {
			"keyboard_f10",
			"xbox_controller_x",
			"ps4_controller_square",
		},
		global_toggle = {
			"keyboard_f9",
			"xbox_controller_left_thumb+xbox_controller_right_thumb",
			"xbox_controller_right_thumb+xbox_controller_left_thumb",
			"ps4_controller_l3+ps4_controller_r3",
			"ps4_controller_r3+ps4_controller_l3",
		},
		toggle_dof = {
			"keyboard_f",
		},
		reset_dof = {
			"keyboard_left ctrl+keyboard_f",
		},
		inc_dof_distance = {
			"keyboard_g",
		},
		dec_dof_distance = {
			"keyboard_b",
		},
		look = {
			"mouse_mouse",
			"xbox_controller_right",
			"ps4_controller_right",
			bindable = false,
		},
		toggle_look_input = {
			"keyboard_tab",
		},
		toggle_input_in_free_flight = {
			"keyboard_left ctrl+keyboard_space",
		},
		move_controller = {
			"xbox_controller_left",
		},
		top_down_toggle = {
			"keyboard_f8",
		},
		keyboard_move_left = {
			"keyboard_a",
		},
		keyboard_move_right = {
			"keyboard_d",
		},
		keyboard_move_forward = {
			"keyboard_w",
		},
		keyboard_move_backward = {
			"keyboard_s",
		},
		move_up = {
			"keyboard_e",
			"xbox_controller_right_trigger",
			"ps4_controller_r2",
		},
		move_down = {
			"keyboard_q",
			"xbox_controller_left_trigger",
			"ps4_controller_l2",
		},
		roll_left = {
			"xbox_controller_right_shoulder",
			"ps4_controller_r1",
		},
		roll_right = {
			"xbox_controller_left_shoulder",
			"ps4_controller_l1",
		},
		increase_fov = {
			"keyboard_numpad plus",
			"xbox_controller_d_left",
			"ps4_controller_d_left",
		},
		decrease_fov = {
			"keyboard_num minus",
			"xbox_controller_d_right",
			"ps4_controller_d_right",
		},
		increase_fov_hold = {
			"keyboard_left ctrl+keyboard_numpad plus",
			"xbox_controller_d_down",
			"ps4_controller_d_down",
		},
		decrease_fov_hold = {
			"keyboard_left ctrl+keyboard_num minus",
			"xbox_controller_d_up",
			"ps4_controller_d_up",
		},
		pick = {
			"keyboard_l",
		},
		inc_dof_region = {
			"keyboard_h",
		},
		dec_dof_region = {
			"keyboard_n",
		},
		alt_action = {
			"keyboard_left ctrl",
		},
		inc_dof_padding = {
			"keyboard_j",
		},
		dec_dof_padding = {
			"keyboard_m",
		},
		inc_dof_scale = {
			"keyboard_k",
		},
		dec_dof_scale = {
			"keyboard_oem_comma",
		},
		mouse_wheel = {
			"mouse_wheel-keyboard_left shift",
			bindable = false,
		},
		camera_speed_up = {
			"xbox_controller_y",
			"ps4_controller_triangle",
		},
		camera_speed_down = {
			"xbox_controller_a",
			"ps4_controller_cross",
		},
		teleport_player_to_camera = {
			"keyboard_enter",
			"xbox_controller_left_trigger+xbox_controller_right_trigger",
			"ps4_controller_l2+ps4_controller_r2",
		},
	},
	settings = {
		frustum_toggle = {
			key_alias = "frustum_toggle",
			type = "pressed",
		},
		global_toggle = {
			key_alias = "global_toggle",
			type = "pressed",
		},
		toggle_dof = {
			key_alias = "toggle_dof",
			type = "pressed",
		},
		reset_dof = {
			key_alias = "reset_dof",
			type = "pressed",
		},
		inc_dof_distance = {
			key_alias = "inc_dof_distance",
			type = "pressed",
		},
		dec_dof_distance = {
			key_alias = "dec_dof_distance",
			type = "pressed",
		},
		look = {
			key_alias = "look",
			type = "axis",
		},
		toggle_look_input = {
			key_alias = "toggle_look_input",
			type = "pressed",
		},
		toggle_input_in_free_flight = {
			key_alias = "toggle_input_in_free_flight",
			type = "pressed",
		},
		move_controller = {
			key_alias = "move_controller",
			type = "axis",
		},
		top_down_toggle = {
			key_alias = "top_down_toggle",
			type = "pressed",
		},
		keyboard_move_left = {
			key_alias = "keyboard_move_left",
			type = "button",
		},
		keyboard_move_right = {
			key_alias = "keyboard_move_right",
			type = "button",
		},
		keyboard_move_forward = {
			key_alias = "keyboard_move_forward",
			type = "button",
		},
		keyboard_move_backward = {
			key_alias = "keyboard_move_backward",
			type = "button",
		},
		move_up = {
			key_alias = "move_up",
			type = "button",
		},
		move_down = {
			key_alias = "move_down",
			type = "button",
		},
		roll_left = {
			key_alias = "roll_left",
			type = "button",
		},
		roll_right = {
			key_alias = "roll_right",
			type = "button",
		},
		increase_fov = {
			key_alias = "increase_fov",
			type = "pressed",
		},
		decrease_fov = {
			key_alias = "decrease_fov",
			type = "pressed",
		},
		increase_fov_hold = {
			key_alias = "increase_fov_hold",
			type = "held",
		},
		decrease_fov_hold = {
			key_alias = "decrease_fov_hold",
			type = "held",
		},
		pick = {
			key_alias = "pick",
			type = "pressed",
		},
		inc_dof_region = {
			key_alias = "inc_dof_region",
			type = "pressed",
		},
		dec_dof_region = {
			key_alias = "dec_dof_region",
			type = "pressed",
		},
		alt_action = {
			key_alias = "alt_action",
			type = "pressed",
		},
		inc_dof_padding = {
			key_alias = "inc_dof_padding",
			type = "pressed",
		},
		dec_dof_padding = {
			key_alias = "dec_dof_padding",
			type = "pressed",
		},
		inc_dof_scale = {
			key_alias = "inc_dof_scale",
			type = "pressed",
		},
		dec_dof_scale = {
			key_alias = "dec_dof_scale",
			type = "pressed",
		},
		mouse_wheel = {
			key_alias = "mouse_wheel",
			type = "axis",
		},
		camera_speed_up = {
			key_alias = "camera_speed_up",
			type = "pressed",
		},
		camera_speed_down = {
			key_alias = "camera_speed_down",
			type = "pressed",
		},
		teleport_player_to_camera = {
			key_alias = "teleport_player_to_camera",
			type = "pressed",
		},
	},
}

return settings("DefaultFreeFlightInputSettings", default_free_flight_input_settings)
