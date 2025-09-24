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
	aliases = {
		hotkey_dev_parameters_gui = {
			"keyboard_end",
			"keyboard_numpad 1",
			"xbox_controller_right_thumb+xbox_controller_d_left",
			"ps4_controller_l3+ps4_controller_d_left",
		},
		hotkey_debug_functions_gui = {
			"keyboard_delete",
			"xbox_controller_right_thumb+xbox_controller_d_right",
			"ps4_controller_l3+ps4_controller_d_right",
		},
		hotkey_input_gui = {
			"keyboard_right shift+keyboard_i",
		},
		hotkey_simple_graph_gui = {
			"keyboard_right shift+keyboard_k",
		},
		hotkey_package_gui = {
			"keyboard_left shift+keyboard_p",
		},
		hotkey_flamegraph_gui = {
			"keyboard_left alt+keyboard_f",
		},
		hotkey_lua_inspector_gui = {
			"keyboard_left ctrl+keyboard_left alt+keyboard_s",
		},
		hotkey_culling_gui = {
			"keyboard_f3",
		},
		hotkey_feedback_streamer_gui = {
			"keyboard_f2",
		},
		hotkey_resource_events_gui = {
			"keyboard_left shift+keyboard_f3",
		},
		hotkey_particle_world_gui = {
			"keyboard_left shift+keyboard_f4",
		},
		hotkey_mesh_streamer_gui = {
			"keyboard_right shift+keyboard_r",
			"xbox_controller_right_thumb+xbox_controller_d_up",
			"ps4_controller_l3+ps4_controller_d_up",
		},
		hotkey_behavior_tree_gui = {
			"keyboard_right shift+keyboard_t",
		},
		hotkey_denoising_gui = {
			"keyboard_f11",
		},
		hotkey_weapon_trait_debug_gui = {
			"keyboard_right shift+keyboard_m",
		},
		hotkey_minion_gibbing_gui = {
			"keyboard_right shift+keyboard_y",
		},
		toggle_input = {
			"keyboard_f6",
			bindable = false,
		},
		toggle_main_view = {
			"keyboard_f7",
			bindable = false,
		},
		hotkey_ui_tool_gui = {
			"keyboard_left ctrl+keyboard_f4",
		},
		hotkey_group_finder_gui = {
			"keyboard_left shift+keyboard_f2",
		},
	},
	settings = {
		hotkey_dev_parameters_gui = {
			key_alias = "hotkey_dev_parameters_gui",
			type = "pressed",
		},
		hotkey_debug_functions_gui = {
			key_alias = "hotkey_debug_functions_gui",
			type = "pressed",
		},
		hotkey_input_gui = {
			key_alias = "hotkey_input_gui",
			type = "pressed",
		},
		hotkey_simple_graph = {
			key_alias = "hotkey_simple_graph_gui",
			type = "pressed",
		},
		hotkey_package_gui = {
			key_alias = "hotkey_package_gui",
			type = "pressed",
		},
		hotkey_flamegraph_gui = {
			key_alias = "hotkey_flamegraph_gui",
			type = "pressed",
		},
		hotkey_lua_inspector_gui = {
			key_alias = "hotkey_lua_inspector_gui",
			type = "pressed",
		},
		hotkey_culling_gui = {
			key_alias = "hotkey_culling_gui",
			type = "pressed",
		},
		hotkey_feedback_streamer_gui = {
			key_alias = "hotkey_feedback_streamer_gui",
			type = "pressed",
		},
		hotkey_resource_events_gui = {
			key_alias = "hotkey_resource_events_gui",
			type = "pressed",
		},
		hotkey_particle_world_gui = {
			key_alias = "hotkey_particle_world_gui",
			type = "pressed",
		},
		hotkey_mesh_streamer_gui = {
			key_alias = "hotkey_mesh_streamer_gui",
			type = "pressed",
		},
		hotkey_behavior_tree_gui = {
			key_alias = "hotkey_behavior_tree_gui",
			type = "pressed",
		},
		hotkey_denoising_gui = {
			key_alias = "hotkey_denoising_gui",
			type = "pressed",
		},
		hotkey_weapon_trait_debug_gui = {
			key_alias = "hotkey_weapon_trait_debug_gui",
			type = "pressed",
		},
		hotkey_minion_gibbing_gui = {
			key_alias = "hotkey_minion_gibbing_gui",
			type = "pressed",
		},
		toggle_input = {
			key_alias = "toggle_input",
			type = "pressed",
		},
		toggle_main_view = {
			key_alias = "toggle_main_view",
			type = "pressed",
		},
		hotkey_ui_tool_gui = {
			key_alias = "hotkey_ui_tool_gui",
			type = "pressed",
		},
		hotkey_group_finder_gui = {
			key_alias = "hotkey_group_finder_gui",
			type = "pressed",
		},
	},
}

return settings("DefaultImguiInputSettings", default_imgui_input_settings)
