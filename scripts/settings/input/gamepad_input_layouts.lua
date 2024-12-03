-- chunkname: @scripts/settings/input/gamepad_input_layouts.lua

local default_ingame_settings = require("scripts/settings/input/default_ingame_input_settings")
local default_view_settings = require("scripts/settings/input/default_view_input_settings")
local layouts = {
	default = {
		display_name = "loc_setting_controller_layout_default",
		haptic_trigger_effects_allowed = true,
		sort_order = 1,
		input_settings = {
			Ingame = default_ingame_settings.aliases,
			View = default_view_settings.aliases,
		},
	},
	advanced = {
		display_name = "loc_setting_controller_layout_advanced_new",
		haptic_trigger_effects_allowed = true,
		sort_order = 2,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				action_two = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				weapon_extra = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_1 = StrictNil,
				wield_2 = StrictNil,
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_scroll_down = StrictNil,
				wield_scroll_up = StrictNil,
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				combat_ability = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				smart_tag = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				com_wheel = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				voip_push_to_talk = StrictNil,
				keyboard_move_forward = StrictNil,
				keyboard_move_backward = StrictNil,
				keyboard_move_left = StrictNil,
				keyboard_move_right = StrictNil,
				dodge = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw = StrictNil,
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	BlitzFocus = {
		display_name = "loc_setting_controller_layout_blitz_focus",
		haptic_trigger_effects_allowed = true,
		sort_order = 4,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				action_two = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				weapon_extra = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_3 = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				combat_ability = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				smart_tag = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				com_wheel = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				dodge = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	BumperAttackerBlocker = {
		display_name = "loc_setting_controller_layout_bumper_attacker",
		haptic_trigger_effects_allowed = false,
		sort_order = 5,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				action_two = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				weapon_extra = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_3 = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				combat_ability = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				smart_tag = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				com_wheel = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				dodge = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	TriggerDodgerBumperAttacker = {
		display_name = "loc_setting_controller_layout_bumper_attacker_dodger",
		haptic_trigger_effects_allowed = false,
		sort_order = 6,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				action_two = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				weapon_extra = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				combat_ability = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				smart_tag = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				com_wheel = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				dodge = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	v2 = {
		display_name = "loc_setting_controller_layout_v2",
		haptic_trigger_effects_allowed = true,
		sort_order = 7,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				action_two = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				weapon_extra = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_3 = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				combat_ability = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				smart_tag = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				com_wheel = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				dodge = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	toms = {
		display_name = "loc_setting_controller_layout_toms",
		haptic_trigger_effects_allowed = true,
		sort_order = 3,
		input_settings = {
			Ingame = {
				action_one = {
					"ps4_controller_r2",
					"xbox_controller_right_trigger",
				},
				action_two = {
					"ps4_controller_l2",
					"xbox_controller_left_trigger",
				},
				weapon_extra = {
					"ps4_controller_l1",
					"xbox_controller_left_shoulder",
				},
				interact = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				interact_inspect = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"ps4_controller_d_left",
					"xbox_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				quick_wield = {
					"ps4_controller_triangle",
					"xbox_controller_y",
				},
				weapon_reload = {
					"ps4_controller_square",
					"xbox_controller_x",
				},
				grenade_ability = {
					"ps4_controller_d_down",
					"xbox_controller_d_down",
				},
				combat_ability = {
					"ps4_controller_r1",
					"xbox_controller_right_shoulder",
				},
				smart_tag = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				com_wheel = {
					"ps4_controller_d_up",
					"xbox_controller_d_up",
				},
				tactical_overlay = {
					"ps4_controller_touch",
					"xbox_controller_back",
				},
				menu = {
					"ps4_controller_options",
					"xbox_controller_start",
				},
				weapon_inspect = {
					"ps4_controller_d_right",
					"xbox_controller_d_right",
				},
				spectate_next = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				dodge = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				jump = {
					"ps4_controller_cross",
					"xbox_controller_a",
				},
				crouch = {
					"ps4_controller_r3",
					"xbox_controller_right_thumb",
				},
				slide = {
					"ps4_controller_circle",
					"xbox_controller_b",
				},
				sprint = {
					"ps4_controller_l3",
					"xbox_controller_left_thumb",
				},
				look_raw_controller = {
					"ps4_controller_right",
					"xbox_controller_right",
				},
				move_controller = {
					"ps4_controller_left",
					"xbox_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
}

return layouts
