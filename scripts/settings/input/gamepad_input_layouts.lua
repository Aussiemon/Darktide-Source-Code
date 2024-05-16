-- chunkname: @scripts/settings/input/gamepad_input_layouts.lua

local default_ingame_settings = require("scripts/settings/input/default_ingame_input_settings")
local default_view_settings = require("scripts/settings/input/default_view_input_settings")
local layouts = {
	default = {
		display_name = "loc_setting_controller_layout_default",
		sort_order = 1,
		input_settings = {
			Ingame = default_ingame_settings.aliases,
			View = default_view_settings.aliases,
		},
	},
	advanced = {
		display_name = "loc_setting_controller_layout_advanced_new",
		sort_order = 2,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				action_two = {
					"xbox_controller_left_trigger",
					"ps4_controller_l2",
				},
				weapon_extra = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_1 = StrictNil,
				wield_2 = StrictNil,
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				wield_scroll_down = StrictNil,
				wield_scroll_up = StrictNil,
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				combat_ability = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				smart_tag = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				com_wheel = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				voip_push_to_talk = StrictNil,
				keyboard_move_forward = StrictNil,
				keyboard_move_backward = StrictNil,
				keyboard_move_left = StrictNil,
				keyboard_move_right = StrictNil,
				dodge = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw = StrictNil,
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	BlitzFocus = {
		display_name = "loc_setting_controller_layout_blitz_focus",
		sort_order = 4,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				action_two = {
					"xbox_controller_left_trigger",
					"ps4_controller_l2",
				},
				weapon_extra = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_3 = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				combat_ability = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				smart_tag = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				com_wheel = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				dodge = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	BumperAttackerBlocker = {
		display_name = "loc_setting_controller_layout_bumper_attacker",
		sort_order = 5,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				action_two = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				weapon_extra = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_3 = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				combat_ability = {
					"xbox_controller_left_trigger",
					"ps4_controller_r1",
				},
				smart_tag = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				com_wheel = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				dodge = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	TriggerDodgerBumperAttacker = {
		display_name = "loc_setting_controller_layout_bumper_attacker_dodger",
		sort_order = 6,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				action_two = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				weapon_extra = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				combat_ability = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				smart_tag = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				com_wheel = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				dodge = {
					"xbox_controller_left_trigger",
					"ps4_controller_l2",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	v2 = {
		display_name = "loc_setting_controller_layout_v2",
		sort_order = 7,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				action_two = {
					"xbox_controller_left_trigger",
					"ps4_controller_l2",
				},
				weapon_extra = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_3 = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_3_gamepad = {
					hide_in_controller_layout = true,
				},
				wield_4 = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				combat_ability = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				smart_tag = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				com_wheel = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				dodge = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
	toms = {
		display_name = "loc_setting_controller_layout_toms",
		sort_order = 3,
		input_settings = {
			Ingame = {
				action_one = {
					"xbox_controller_right_trigger",
					"ps4_controller_r2",
				},
				action_two = {
					"xbox_controller_left_trigger",
					"ps4_controller_l2",
				},
				weapon_extra = {
					"xbox_controller_left_shoulder",
					"ps4_controller_l1",
				},
				interact = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				wield_3 = {
					hide_in_controller_layout = true,
				},
				wield_3_gamepad = {
					"xbox_controller_d_left",
					"ps4_controller_d_left",
				},
				wield_4 = {
					hide_in_controller_layout = true,
				},
				wield_5 = {
					"xbox_controller_d_right",
					"ps4_controller_d_right",
				},
				quick_wield = {
					"xbox_controller_y",
					"ps4_controller_triangle",
				},
				weapon_reload = {
					"xbox_controller_x",
					"ps4_controller_square",
				},
				grenade_ability = {
					"xbox_controller_d_down",
					"ps4_controller_d_down",
				},
				combat_ability = {
					"xbox_controller_right_shoulder",
					"ps4_controller_r1",
				},
				smart_tag = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				com_wheel = {
					"xbox_controller_d_up",
					"ps4_controller_d_up",
				},
				tactical_overlay = {
					"xbox_controller_back",
					"ps4_controller_touch",
				},
				menu = {
					"xbox_controller_start",
					"ps4_controller_options",
				},
				weapon_inspect = {
					"xbox_controller_d_right",
				},
				spectate_next = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				dodge = {
					"xbox_controller_b",
					"ps4_controller_circle",
				},
				jump = {
					"xbox_controller_a",
					"ps4_controller_cross",
				},
				crouch = {
					"xbox_controller_right_thumb",
					"ps4_controller_right_thumb",
				},
				slide = {
					"xbox_controller_b",
				},
				sprint = {
					"xbox_controller_left_thumb",
					"ps4_controller_l3",
				},
				look_raw_controller = {
					"xbox_controller_right",
					"ps4_controller_right",
				},
				move_controller = {
					"xbox_controller_left",
					"ps4_controller_left",
				},
			},
			View = table.add_missing({}, default_view_settings.aliases),
		},
	},
}

return layouts
