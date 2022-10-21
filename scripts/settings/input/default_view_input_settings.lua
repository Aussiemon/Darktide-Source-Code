local DefaultViewInputFilters = require("scripts/settings/input/default_view_input_filters")
local default_view_input_settings = {
	service_type = "View",
	supported_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller"
	},
	default_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller"
	},
	filters = DefaultViewInputFilters,
	aliases = {
		close_view = {
			"keyboard_esc",
			"xbox_controller_start",
			"ps4_controller_options",
			description = "loc_alias_view_close_view"
		},
		back = {
			"keyboard_esc",
			"xbox_controller_b",
			"ps4_controller_circle",
			description = "loc_alias_view_back"
		},
		next = {
			"keyboard_space",
			"xbox_controller_x",
			"ps4_controller_triangle",
			description = "loc_alias_view_next"
		},
		hotkey_system = {
			"keyboard_esc",
			"xbox_controller_start",
			"ps4_controller_options",
			description = "loc_alias_view_hotkey_system",
			group = "input_group_hotkeys"
		},
		hotkey_inventory = {
			"keyboard_i",
			"xbox_controller_back",
			"ps4_controller_touch",
			description = "loc_alias_view_hotkey_inventory",
			group = "input_group_hotkeys"
		},
		hotkey_loadout = {
			"keyboard_l",
			"xbox_controller_y",
			"ps4_controller_triangle",
			description = "loc_alias_view_hotkey_loadout"
		},
		hotkey_item_discard = {
			"keyboard_x",
			"xbox_controller_right_thumb",
			"ps4_controller_d_down",
			description = "loc_alias_view_hotkey_item_discard"
		},
		hotkey_character_delete = {
			"keyboard_x",
			"xbox_controller_y",
			"ps4_controller_triangle",
			description = "loc_alias_view_hotkey_character_delete"
		},
		hotkey_item_inspect = {
			"keyboard_v",
			"xbox_controller_x",
			"ps4_controller_triangle",
			description = "loc_alias_view_hotkey_item_inspect"
		},
		hotkey_item_sort = {
			"keyboard_o",
			"xbox_controller_left_thumb",
			"ps4_controller_left",
			description = ""
		},
		hotkey_item_customize = {
			"keyboard_c",
			"xbox_controller_y",
			"ps4_controller_triangle",
			description = "loc_alias_view_hotkey_item_customize"
		},
		hotkey_menu_special_1 = {
			"keyboard_e",
			"xbox_controller_x",
			"ps4_controller_square",
			description = "loc_alias_view_hotkey_menu_special_1"
		},
		hotkey_menu_special_2 = {
			"keyboard_q",
			"xbox_controller_y",
			"ps4_controller_triangle",
			description = "loc_alias_view_hotkey_menu_special_2"
		},
		confirm = {
			"keyboard_enter",
			"xbox_controller_a",
			"ps4_controller_cross",
			description = "loc_alias_view_confirm"
		},
		secondary_action = {
			"mouse_right",
			"xbox_controller_x",
			"ps4_controller_square",
			description = "loc_alias_view_secondary_action"
		},
		left = {
			"mouse_left",
			description = "loc_alias_view_left"
		},
		right = {
			"mouse_right",
			description = "loc_alias_view_right"
		},
		navigate_up = {
			"keyboard_up",
			"xbox_controller_d_up",
			description = "loc_alias_view_navigate_up"
		},
		navigate_down = {
			"keyboard_down",
			"xbox_controller_d_down",
			description = "loc_alias_view_navigate_down"
		},
		navigate_left = {
			"keyboard_left",
			"xbox_controller_d_left",
			description = "loc_alias_view_navigate_left"
		},
		navigate_right = {
			"keyboard_right",
			"xbox_controller_d_right",
			description = "loc_alias_view_navigate_right"
		},
		navigate_controller = {
			"xbox_controller_left",
			"ps4_controller_left",
			description = "loc_alias_view_navigate_controller"
		},
		navigate_controller_right = {
			"xbox_controller_right",
			"ps4_controller_right",
			description = "loc_alias_view_navigate_controller_right"
		},
		cycle_list_primary = {
			"keyboard_tab",
			"xbox_controller_left_thumb",
			"ps4_controller_l3",
			description = "loc_alias_view_cycle_list_primary"
		},
		cycle_list_secondary = {
			"xbox_controller_right_thumb",
			"ps4_controller_r3",
			description = "loc_alias_view_cycle_list_secondary"
		},
		send_chat_message = {
			"keyboard_enter",
			"keyboard_numpad enter",
			description = "loc_alias_view_open_chat",
			group = "input_group_interface"
		},
		cycle_chat_channel = {
			"keyboard_tab",
			description = "loc_alias_view_open_chat",
			group = "input_group_interface"
		},
		navigate_primary_left = {
			"keyboard_z",
			"xbox_controller_left_shoulder",
			"ps4_controller_l1",
			description = "loc_alias_view_navigate_primary_left"
		},
		navigate_primary_right = {
			"keyboard_c",
			"xbox_controller_right_shoulder",
			"ps4_controller_r1",
			description = "loc_alias_view_navigate_primary_right"
		},
		navigate_secondary_up = {
			"keyboard_w",
			description = "loc_alias_view_navigate_secondary_up"
		},
		navigate_secondary_down = {
			"keyboard_s",
			description = "loc_alias_view_navigate_secondary_down"
		},
		navigate_secondary_left = {
			"keyboard_a",
			"xbox_controller_left_trigger",
			"ps4_controller_l2",
			description = "loc_alias_view_navigate_secondary_left"
		},
		navigate_secondary_right = {
			"keyboard_d",
			"xbox_controller_right_trigger",
			"ps4_controller_r2",
			description = "loc_alias_view_navigate_secondary_right"
		},
		scroll_axis = {
			"mouse_wheel",
			"xbox_controller_right",
			"ps4_controller_right",
			description = "loc_alias_view_navigate_controller_right"
		},
		select_text = {
			"keyboard_left shift",
			"keyboard_right shift",
			description = ""
		},
		navigate_text_modifier = {
			"keyboard_left ctrl",
			"keyboard_right ctrl",
			description = ""
		},
		title_screen_start = {
			"keyboard_space",
			"xbox_controller_a",
			"ps4_controller_cross",
			description = ""
		}
	},
	settings = {
		close_view = {
			key_alias = "close_view",
			type = "pressed"
		},
		back = {
			key_alias = "back",
			type = "pressed"
		},
		next = {
			key_alias = "next",
			type = "pressed"
		},
		next_hold = {
			key_alias = "next",
			type = "held"
		},
		hotkey_system = {
			key_alias = "hotkey_system",
			type = "pressed"
		},
		hotkey_inventory = {
			key_alias = "hotkey_inventory",
			type = "pressed"
		},
		hotkey_loadout = {
			key_alias = "hotkey_loadout",
			type = "pressed"
		},
		hotkey_item_discard = {
			key_alias = "hotkey_item_discard",
			type = "held"
		},
		hotkey_item_inspect = {
			key_alias = "hotkey_item_inspect",
			type = "pressed"
		},
		hotkey_item_sort = {
			key_alias = "hotkey_item_sort",
			type = "pressed"
		},
		hotkey_character_delete = {
			key_alias = "hotkey_character_delete",
			type = "pressed"
		},
		hotkey_item_customize = {
			key_alias = "hotkey_item_customize",
			type = "pressed"
		},
		hotkey_menu_special_1 = {
			key_alias = "hotkey_menu_special_1",
			type = "pressed"
		},
		hotkey_menu_special_2 = {
			key_alias = "hotkey_menu_special_2",
			type = "pressed"
		},
		title_screen_start = {
			key_alias = "title_screen_start",
			type = "pressed"
		},
		confirm_pressed = {
			key_alias = "confirm",
			type = "pressed"
		},
		confirm_released = {
			key_alias = "confirm",
			type = "released"
		},
		confirm_hold = {
			key_alias = "confirm",
			type = "held"
		},
		secondary_action_pressed = {
			key_alias = "secondary_action",
			type = "pressed"
		},
		secondary_action_released = {
			key_alias = "secondary_action",
			type = "released"
		},
		secondary_action_hold = {
			key_alias = "secondary_action",
			type = "held"
		},
		left_pressed = {
			key_alias = "left",
			type = "pressed"
		},
		left_released = {
			key_alias = "left",
			type = "released"
		},
		left_hold = {
			key_alias = "left",
			type = "held"
		},
		right_pressed = {
			key_alias = "right",
			type = "pressed"
		},
		right_released = {
			key_alias = "right",
			type = "released"
		},
		right_hold = {
			key_alias = "right",
			type = "held"
		},
		send_chat_message = {
			key_alias = "send_chat_message",
			type = "pressed"
		},
		cycle_chat_channel = {
			key_alias = "cycle_chat_channel",
			type = "pressed"
		},
		cursor = {
			raw = "mouse_cursor",
			type = "axis"
		},
		mouse_move = {
			raw = "mouse_mouse",
			type = "axis"
		},
		scroll_axis = {
			key_alias = "scroll_axis",
			type = "axis"
		},
		debug_test_button = {
			raw = "keyboard_z",
			type = "pressed"
		},
		debug_test_button2 = {
			raw = "keyboard_x",
			type = "pressed"
		},
		navigate_primary_left_pressed = {
			key_alias = "navigate_primary_left",
			type = "pressed"
		},
		navigate_primary_right_pressed = {
			key_alias = "navigate_primary_right",
			type = "pressed"
		},
		navigate_secondary_up_pressed = {
			key_alias = "navigate_secondary_up",
			type = "pressed"
		},
		navigate_secondary_up_held = {
			key_alias = "navigate_secondary_up",
			type = "held"
		},
		navigate_secondary_up_released = {
			key_alias = "navigate_secondary_up",
			type = "released"
		},
		navigate_secondary_down_pressed = {
			key_alias = "navigate_secondary_down",
			type = "pressed"
		},
		navigate_secondary_down_held = {
			key_alias = "navigate_secondary_down",
			type = "held"
		},
		navigate_secondary_down_released = {
			key_alias = "navigate_secondary_down",
			type = "released"
		},
		navigate_secondary_left_pressed = {
			key_alias = "navigate_secondary_left",
			type = "pressed"
		},
		navigate_secondary_left_held = {
			key_alias = "navigate_secondary_left",
			type = "held"
		},
		navigate_secondary_left_released = {
			key_alias = "navigate_secondary_left",
			type = "released"
		},
		navigate_secondary_right_pressed = {
			key_alias = "navigate_secondary_right",
			type = "pressed"
		},
		navigate_secondary_right_held = {
			key_alias = "navigate_secondary_right",
			type = "held"
		},
		navigate_secondary_right_released = {
			key_alias = "navigate_secondary_right",
			type = "released"
		},
		navigate_up_pressed = {
			key_alias = "navigate_up",
			type = "pressed"
		},
		navigate_up_hold = {
			key_alias = "navigate_up",
			type = "held"
		},
		navigate_up_raw = {
			key_alias = "navigate_up",
			type = "button"
		},
		navigate_down_pressed = {
			key_alias = "navigate_down",
			type = "pressed"
		},
		navigate_down_hold = {
			key_alias = "navigate_down",
			type = "held"
		},
		navigate_down_raw = {
			key_alias = "navigate_down",
			type = "button"
		},
		navigate_left_pressed = {
			key_alias = "navigate_left",
			type = "pressed"
		},
		navigate_left_hold = {
			key_alias = "navigate_left",
			type = "held"
		},
		navigate_left_raw = {
			key_alias = "navigate_left",
			type = "button"
		},
		navigate_right_pressed = {
			key_alias = "navigate_right",
			type = "pressed"
		},
		navigate_right_hold = {
			key_alias = "navigate_right",
			type = "held"
		},
		navigate_right_raw = {
			key_alias = "navigate_right",
			type = "button"
		},
		ping = {
			raw = "keyboard_t",
			type = "pressed"
		},
		navigate_controller = {
			key_alias = "navigate_controller",
			type = "axis"
		},
		navigate_controller_right = {
			key_alias = "navigate_controller_right",
			type = "axis"
		},
		cycle_list_primary = {
			key_alias = "cycle_list_primary",
			type = "pressed"
		},
		cycle_list_secondary = {
			key_alias = "cycle_list_secondary",
			type = "pressed"
		},
		select_text = {
			key_alias = "select_text",
			type = "held"
		},
		navigate_text_modifier = {
			key_alias = "navigate_text_modifier",
			type = "held"
		},
		select_all_text = {
			raw = "keyboard_left ctrl+keyboard_a",
			type = "pressed"
		},
		clipboard_cut = {
			raw = "keyboard_left ctrl+keyboard_x",
			type = "pressed"
		},
		clipboard_copy = {
			raw = "keyboard_left ctrl+keyboard_c",
			type = "pressed"
		},
		clipboard_paste = {
			raw = "keyboard_left ctrl+keyboard_v",
			type = "pressed"
		},
		navigate_beginning = {
			raw = "keyboard_home",
			type = "pressed"
		},
		navigate_end = {
			raw = "keyboard_end",
			type = "pressed"
		},
		toggle_rtx = {
			raw = "keyboard_left shift+keyboard_0",
			type = "pressed"
		}
	}
}

return settings("DefaultViewInputSettings", default_view_input_settings)
