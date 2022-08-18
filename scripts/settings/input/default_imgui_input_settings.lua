local default_imgui_input_settings = {
	service_type = "Imgui",
	supported_devices = {
		"keyboard",
		"mouse",
		"xbox_controller"
	},
	default_devices = {
		"keyboard",
		"xbox_controller"
	},
	settings = {
		hotkey_dev_parameters_gui = {
			type = "pressed",
			raw = {
				"keyboard_end",
				"xbox_controller_right_thumb+xbox_controller_d_left"
			}
		},
		hotkey_debug_functions_gui = {
			type = "pressed",
			raw = {
				"keyboard_delete",
				"xbox_controller_right_thumb+xbox_controller_d_right"
			}
		},
		hotkey_options_gui = {
			type = "pressed",
			raw = {
				"keyboard_insert",
				"xbox_controller_right_thumb+xbox_controller_d_up"
			}
		},
		hotkey_input_gui = {
			raw = "keyboard_left shift+keyboard_i",
			type = "pressed"
		},
		hotkey_package_gui = {
			raw = "keyboard_left shift+keyboard_p",
			type = "pressed"
		},
		hotkey_flamegraph_gui = {
			raw = "keyboard_left alt+keyboard_f",
			type = "pressed"
		},
		hotkey_lua_inspector_gui = {
			raw = "keyboard_left ctrl+keyboard_left alt+keyboard_s",
			type = "pressed"
		},
		hotkey_culling_gui = {
			type = "pressed",
			raw = {
				"keyboard_f3",
				"xbox_controller_right_thumb+xbox_controller_d_down"
			}
		},
		hotkey_feedback_streamer_gui = {
			raw = "keyboard_f2",
			type = "pressed"
		},
		hotkey_mesh_streamer_gui = {
			raw = "keyboard_left shift+keyboard_f2",
			type = "pressed"
		},
		hotkey_behavior_tree = {
			raw = "keyboard_left shift+keyboard_t",
			type = "pressed"
		},
		hotkey_chat = {
			raw = "keyboard_f5",
			type = "pressed"
		},
		hotkey_denoising = {
			raw = "keyboard_f11",
			type = "pressed"
		},
		hotkey_weapon_trait_playground = {
			raw = "keyboard_right shift+keyboard_u",
			type = "pressed"
		},
		hotkey_weapon_trait_debug = {
			raw = "keyboard_right shift+keyboard_m",
			type = "pressed"
		},
		hotkey_player_specialization_imgui = {
			raw = "keyboard_right shift+keyboard_l",
			type = "pressed"
		},
		toggle_input = {
			raw = "keyboard_f6",
			type = "pressed"
		},
		toggle_main_view = {
			raw = "keyboard_f7",
			type = "pressed"
		}
	}
}

return settings("DefaultImguiInputSettings", default_imgui_input_settings)
