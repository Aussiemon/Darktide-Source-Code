-- chunkname: @scripts/settings/input/default_imgui_input_settings.lua

local default_imgui_input_settings = {
	service_type = "Imgui",
	supported_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller",
	},
	default_devices = {
		"keyboard",
		"xbox_controller",
		"ps4_controller",
	},
	settings = {
		hotkey_dev_parameters_gui = {
			type = "pressed",
			raw = {
				"keyboard_end",
				"xbox_controller_right_thumb+xbox_controller_d_left",
				"ps4_controller_l3+ps4_controller_d_left",
			},
		},
		hotkey_debug_functions_gui = {
			type = "pressed",
			raw = {
				"keyboard_delete",
				"xbox_controller_right_thumb+xbox_controller_d_right",
				"ps4_controller_l3+ps4_controller_d_right",
			},
		},
		hotkey_input_gui = {
			raw = "keyboard_left shift+keyboard_i",
			type = "pressed",
		},
		hotkey_simple_graph = {
			raw = "keyboard_right shift+keyboard_k",
			type = "pressed",
		},
		hotkey_package_gui = {
			raw = "keyboard_left shift+keyboard_p",
			type = "pressed",
		},
		hotkey_flamegraph_gui = {
			raw = "keyboard_left alt+keyboard_f",
			type = "pressed",
		},
		hotkey_lua_inspector_gui = {
			raw = "keyboard_left ctrl+keyboard_left alt+keyboard_s",
			type = "pressed",
		},
		hotkey_culling_gui = {
			type = "pressed",
			raw = {
				"keyboard_f3",
			},
		},
		hotkey_feedback_streamer_gui = {
			type = "pressed",
			raw = {
				"keyboard_f2",
			},
		},
		hotkey_resource_events_gui = {
			type = "pressed",
			raw = {
				"keyboard_left shift+keyboard_f3",
			},
		},
		hotkey_particle_world_gui = {
			type = "pressed",
			raw = {
				"keyboard_left shift+keyboard_f4",
			},
		},
		hotkey_mesh_streamer_gui = {
			raw = "keyboard_right shift+keyboard_r",
			type = "pressed",
		},
		hotkey_behavior_tree = {
			raw = "keyboard_right shift+keyboard_t",
			type = "pressed",
		},
		hotkey_denoising = {
			raw = "keyboard_f11",
			type = "pressed",
		},
		hotkey_weapon_trait_playground = {
			raw = "keyboard_right shift+keyboard_u",
			type = "pressed",
		},
		hotkey_weapon_trait_debug = {
			raw = "keyboard_right shift+keyboard_m",
			type = "pressed",
		},
		hotkey_minion_gibbing_imgui = {
			raw = "keyboard_right shift+keyboard_y",
			type = "pressed",
		},
		toggle_input = {
			raw = "keyboard_f6",
			type = "pressed",
		},
		toggle_main_view = {
			raw = "keyboard_f7",
			type = "pressed",
		},
		hotkey_ui_tool_gui = {
			raw = "keyboard_left ctrl+keyboard_f4",
			type = "pressed",
		},
	},
}

return settings("DefaultImguiInputSettings", default_imgui_input_settings)
