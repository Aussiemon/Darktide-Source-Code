local DefaultIngameInputFilters = require("scripts/settings/input/default_ingame_input_filters")
local default_ingame_input_settings = {
	service_type = "Ingame",
	filters = DefaultIngameInputFilters,
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
	aliases = {
		action_one = {
			"mouse_left",
			"ps4_controller_r2",
			"xbox_controller_right_shoulder",
			group = "input_group_combat",
			description = "loc_ingame_action_one",
			sort_order = 1
		},
		action_two = {
			"mouse_right",
			"ps4_controller_l2",
			"xbox_controller_left_shoulder",
			group = "input_group_combat",
			description = "loc_ingame_action_two",
			sort_order = 2
		},
		weapon_extra = {
			"mouse_extra_1",
			"ps4_controller_right_thumb",
			"xbox_controller_right_thumb",
			group = "input_group_combat",
			description = "loc_ingame_weapon_extra",
			sort_order = 3
		},
		interact = {
			"keyboard_e",
			"ps4_controller_circle",
			"xbox_controller_x",
			group = "input_group_combat",
			description = "loc_ingame_interact",
			sort_order = 4
		},
		wield_1 = {
			"keyboard_1",
			group = "input_group_combat",
			description = "loc_ingame_wield_1",
			sort_order = 5
		},
		wield_2 = {
			"keyboard_2",
			group = "input_group_combat",
			description = "loc_ingame_wield_2",
			sort_order = 6
		},
		wield_3 = {
			"keyboard_3",
			"ps4_controller_d_left",
			"xbox_controller_d_left",
			group = "input_group_combat",
			description = "loc_ingame_wield_3",
			sort_order = 7
		},
		wield_4 = {
			"keyboard_4",
			"ps4_controller_d_right",
			"xbox_controller_d_right",
			group = "input_group_combat",
			description = "loc_ingame_wield_4",
			sort_order = 8
		},
		quick_wield = {
			"keyboard_q",
			"ps4_controller_triangle",
			"xbox_controller_y",
			group = "input_group_combat",
			description = "loc_ingame_quick_wield",
			sort_order = 9
		},
		wield_scroll_down = {
			"mouse_wheel_down",
			group = "input_group_combat",
			description = "loc_ingame_wield_prev",
			sort_order = 10
		},
		wield_scroll_up = {
			"mouse_wheel_up",
			group = "input_group_combat",
			description = "loc_ingame_wield_next",
			sort_order = 11
		},
		weapon_reload = {
			"keyboard_r",
			"ps4_controller_square",
			"xbox_controller_x",
			group = "input_group_combat",
			description = "loc_ingame_weapon_reload",
			sort_order = 12
		},
		grenade_ability = {
			"keyboard_g",
			"ps4_controller_d_down",
			"xbox_controller_d_down",
			group = "input_group_combat",
			description = "loc_ingame_grenade_ability",
			sort_order = 13
		},
		combat_ability = {
			"keyboard_f",
			"ps4_controller_r1",
			"xbox_controller_right_trigger",
			group = "input_group_combat",
			description = "loc_ingame_combat_ability",
			sort_order = 14
		},
		smart_tag = {
			"mouse_middle",
			"ps4_controller_l1",
			"xbox_controller_d_up",
			group = "input_group_combat",
			description = "loc_ingame_smart_tag",
			sort_order = 15
		},
		com_wheel = {
			"mouse_middle",
			"ps4_controller_l1",
			"xbox_controller_d_up",
			group = "input_group_combat",
			description = "loc_ingame_com_wheel",
			sort_order = 16
		},
		tactical_overlay = {
			"keyboard_tab",
			"ps4_controller_touch",
			"xbox_controller_back",
			group = "input_group_combat",
			description = "loc_ingame_tactical_overlay",
			sort_order = 17
		},
		menu = {
			"xbox_controller_start",
			"ps4_controller_options",
			group = "input_group_hotkeys",
			bindable = false,
			description = "loc_alias_view_hotkey_system"
		},
		weapon_inspect = {
			"keyboard_x",
			"xbox_controller_d_right",
			group = "input_group_combat",
			description = "loc_ingame_weapon_inspect",
			sort_order = 18
		},
		spectate_next = {
			"mouse_left",
			"ps4_controller_cross",
			"xbox_controller_a",
			group = "input_group_combat",
			description = "loc_ingame_spectate_next",
			sort_order = 19,
			hide_in_controller_layout = true
		},
		voip_push_to_talk = {
			"keyboard_v",
			group = "input_group_combat",
			description = "loc_ingame_voip_push_to_talk",
			sort_order = 20
		},
		keyboard_move_forward = {
			"keyboard_w",
			group = "input_group_movement",
			description = "loc_ingame_keyboard_move_forward",
			sort_order = 1
		},
		keyboard_move_backward = {
			"keyboard_s",
			group = "input_group_movement",
			description = "loc_ingame_keyboard_move_backward",
			sort_order = 2
		},
		keyboard_move_left = {
			"keyboard_a",
			group = "input_group_movement",
			description = "loc_ingame_keyboard_move_left",
			sort_order = 3
		},
		keyboard_move_right = {
			"keyboard_d",
			group = "input_group_movement",
			description = "loc_ingame_keyboard_move_right",
			sort_order = 4
		},
		dodge = {
			"keyboard_space",
			"ps4_controller_cross",
			"xbox_controller_left_trigger",
			group = "input_group_movement",
			description = "loc_ingame_dodge",
			sort_order = 5
		},
		jump = {
			"keyboard_space",
			"ps4_controller_cross",
			"xbox_controller_a",
			group = "input_group_movement",
			description = "loc_ingame_jump",
			sort_order = 6
		},
		crouch = {
			"keyboard_left ctrl",
			"ps4_controller_circle",
			"xbox_controller_b",
			group = "input_group_movement",
			description = "loc_ingame_crouch",
			sort_order = 7
		},
		slide = {
			"xbox_controller_b",
			group = "input_group_movement",
			description = "loc_ingame_slide",
			sort_order = 8
		},
		sprint = {
			"keyboard_left shift",
			"ps4_controller_l3",
			"xbox_controller_left_thumb",
			group = "input_group_movement",
			description = "loc_ingame_sprint",
			sort_order = 9
		},
		look_raw = {
			"mouse_mouse",
			group = "input_group_movement",
			bindable = false,
			sort_order = 10,
			description = "loc_ingame_look_raw"
		},
		look_raw_controller = {
			"xbox_controller_right",
			"ps4_controller_right",
			group = "input_group_movement",
			bindable = false,
			sort_order = 11,
			description = "loc_ingame_look_raw_controller"
		},
		move_controller = {
			"xbox_controller_left",
			"ps4_controller_left",
			group = "input_group_movement",
			bindable = false,
			sort_order = 12,
			description = "loc_ingame_move_controller"
		}
	},
	settings = {
		action_one_pressed = {
			key_alias = "action_one",
			type = "pressed"
		},
		action_one_release = {
			key_alias = "action_one",
			type = "released"
		},
		action_one_hold = {
			key_alias = "action_one",
			type = "held"
		},
		action_two_pressed = {
			key_alias = "action_two",
			type = "pressed"
		},
		action_two_release = {
			key_alias = "action_two",
			type = "released"
		},
		action_two_hold = {
			key_alias = "action_two",
			type = "held"
		},
		combat_ability_pressed = {
			key_alias = "combat_ability",
			type = "pressed"
		},
		combat_ability_release = {
			key_alias = "combat_ability",
			type = "released"
		},
		combat_ability_hold = {
			key_alias = "combat_ability",
			type = "held"
		},
		grenade_ability_pressed = {
			key_alias = "grenade_ability",
			type = "pressed"
		},
		grenade_ability_release = {
			key_alias = "grenade_ability",
			type = "released"
		},
		grenade_ability_hold = {
			key_alias = "grenade_ability",
			type = "held"
		},
		interact_pressed = {
			key_alias = "interact",
			type = "pressed"
		},
		interact_hold = {
			key_alias = "interact",
			type = "held"
		},
		tactical_overlay_pressed = {
			key_alias = "tactical_overlay",
			type = "pressed"
		},
		tactical_overlay_hold = {
			key_alias = "tactical_overlay",
			type = "held"
		},
		jump = {
			key_alias = "jump",
			type = "pressed"
		},
		jump_held = {
			key_alias = "jump",
			type = "held"
		},
		dodge = {
			key_alias = "dodge",
			type = "pressed"
		},
		weapon_reload = {
			key_alias = "weapon_reload",
			type = "pressed"
		},
		weapon_reload_hold = {
			key_alias = "weapon_reload",
			type = "held"
		},
		weapon_extra_pressed = {
			key_alias = "weapon_extra",
			type = "pressed"
		},
		weapon_extra_hold = {
			key_alias = "weapon_extra",
			type = "held"
		},
		weapon_extra_release = {
			key_alias = "weapon_extra",
			type = "released"
		},
		weapon_inspect_hold = {
			key_alias = "weapon_inspect",
			type = "held"
		},
		crouch = {
			key_alias = "crouch",
			type = "pressed"
		},
		crouching = {
			key_alias = "crouch",
			type = "held"
		},
		sprint = {
			key_alias = "sprint",
			type = "pressed"
		},
		sprinting = {
			key_alias = "sprint",
			type = "held"
		},
		quick_wield = {
			key_alias = "quick_wield",
			type = "pressed"
		},
		wield_scroll_down = {
			key_alias = "wield_scroll_down",
			type = "pressed"
		},
		wield_scroll_up = {
			key_alias = "wield_scroll_up",
			type = "pressed"
		},
		wield_1 = {
			key_alias = "wield_1",
			type = "pressed"
		},
		wield_2 = {
			key_alias = "wield_2",
			type = "pressed"
		},
		wield_3 = {
			key_alias = "wield_3",
			type = "pressed"
		},
		wield_4 = {
			key_alias = "wield_4",
			type = "pressed"
		},
		keyboard_move_left = {
			key_alias = "keyboard_move_left",
			type = "button"
		},
		keyboard_move_right = {
			key_alias = "keyboard_move_right",
			type = "button"
		},
		keyboard_move_forward = {
			key_alias = "keyboard_move_forward",
			type = "button"
		},
		keyboard_move_backward = {
			key_alias = "keyboard_move_backward",
			type = "button"
		},
		spectate_next = {
			key_alias = "spectate_next",
			type = "pressed"
		},
		smart_tag = {
			key_alias = "smart_tag",
			type = "pressed"
		},
		com_wheel = {
			key_alias = "com_wheel",
			type = "held"
		},
		voip_push_to_talk = {
			key_alias = "voip_push_to_talk",
			type = "held"
		},
		look_raw = {
			key_alias = "look_raw",
			type = "axis"
		},
		look_raw_controller = {
			key_alias = "look_raw_controller",
			type = "axis"
		},
		move_controller = {
			key_alias = "move_controller",
			type = "axis"
		}
	}
}

if IS_XBS then
	default_ingame_input_settings.aliases.voip_push_to_talk = nil
	default_ingame_input_settings.settings.voip_push_to_talk = nil
end

return settings("TriggerDodgerBumperAttacker", default_ingame_input_settings)
