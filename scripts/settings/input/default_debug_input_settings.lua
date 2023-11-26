-- chunkname: @scripts/settings/input/default_debug_input_settings.lua

local DefaultDebugInputFilters = require("scripts/settings/input/default_debug_input_filters")
local default_debug_input_settings = {
	service_type = "Debug",
	filters = DefaultDebugInputFilters,
	default_devices = {
		"keyboard",
		"mouse",
		"xbox_controller"
	},
	settings = {
		left_key_pressed = {
			raw = "keyboard_left",
			type = "pressed"
		},
		left_key_hold = {
			hold_threshold = 0.8,
			raw = "keyboard_left",
			type = "held"
		},
		right_key_pressed = {
			raw = "keyboard_right",
			type = "pressed"
		},
		right_key_hold = {
			hold_threshold = 0.8,
			raw = "keyboard_right",
			type = "held"
		},
		up_key_pressed = {
			raw = "keyboard_up",
			type = "pressed"
		},
		up_key_hold = {
			hold_threshold = 0.8,
			raw = "keyboard_up",
			type = "held"
		},
		down_key_pressed = {
			raw = "keyboard_down",
			type = "pressed"
		},
		down_key_hold = {
			hold_threshold = 0.5,
			raw = "keyboard_down",
			type = "held"
		},
		toggle_breed_picker = {
			raw = "keyboard_o",
			type = "pressed"
		},
		toggle_timer_picker = {
			raw = "keyboard_home",
			type = "pressed"
		},
		timer_speed_change_toggle = {
			hold_threshold = 0.5,
			raw = "keyboard_left shift",
			type = "held"
		},
		timer_speed_change = {
			raw = "mouse_wheel",
			type = "axis"
		},
		toggle_time_pause = {
			raw = "keyboard_pause-keyboard_right shift",
			type = "pressed"
		},
		spawn_unit = {
			raw = "keyboard_p",
			type = "pressed"
		},
		spawn_multiple_units = {
			raw = "keyboard_left ctrl+keyboard_p",
			type = "pressed"
		},
		spawn_patrol = {
			raw = "keyboard_left alt+keyboard_left ctrl+keyboard_p",
			type = "pressed"
		},
		despawn_all_units = {
			type = "pressed",
			raw = {
				"keyboard_left ctrl+keyboard_i",
				"xbox_controller_back"
			}
		},
		despawn_all_deselected_units = {
			raw = "keyboard_left ctrl+keyboard_left alt+keyboard_i",
			type = "pressed"
		},
		despawn_nearby_units = {
			raw = "keyboard_i",
			type = "pressed"
		},
		despawn_nearby_deselected_units = {
			raw = "keyboard_left alt+keyboard_i",
			type = "pressed"
		},
		left_mouse_buttton_pressed = {
			raw = "mouse_left",
			type = "pressed"
		},
		alert_selected_minion = {
			raw = "mouse_left",
			type = "pressed"
		},
		regenerate_roamers = {
			raw = "keyboard_left shift+keyboard_g",
			type = "pressed"
		},
		regenerate_specials = {
			raw = "keyboard_left shift+keyboard_s",
			type = "pressed"
		},
		regenerate_toxic_fog = {
			raw = "keyboard_left shift+keyboard_t",
			type = "pressed"
		},
		restart_twin_ambushes = {
			raw = "keyboard_left shift+keyboard_o",
			type = "pressed"
		},
		toggle_minion_perception = {
			raw = "keyboard_left shift+keyboard_z",
			type = "pressed"
		},
		toggle_pacing = {
			raw = "keyboard_left shift+keyboard_x",
			type = "pressed"
		},
		aggro_nearby_roamers = {
			raw = "keyboard_left shift+keyboard_k",
			type = "pressed"
		},
		minion_auto_stagger_start = {
			raw = "keyboard_left shift+keyboard_l",
			type = "pressed"
		},
		regenerate_monsters = {
			raw = "keyboard_left shift+keyboard_m",
			type = "pressed"
		},
		trigger_next_horde_pacing_wave = {
			raw = "keyboard_left shift+keyboard_e",
			type = "pressed"
		},
		remove_monster_warning = {
			raw = "keyboard_left shift+keyboard_v",
			type = "pressed"
		},
		select_self_unit_toggle = {
			hold_threshold = 0.5,
			raw = "keyboard_left shift",
			type = "held"
		},
		select_unit = {
			raw = "keyboard_v",
			type = "pressed"
		},
		replenish_ability_charge = {
			raw = "keyboard_9",
			type = "pressed"
		},
		toggle_paint_liquid = {
			raw = "keyboard_left shift+keyboard_u",
			type = "pressed"
		},
		paint_liquid = {
			raw = "keyboard_left shift+keyboard_y",
			type = "pressed"
		},
		deselect_unit = {
			raw = "keyboard_left ctrl+keyboard_v",
			type = "pressed"
		},
		toggle_move_order_mode = {
			raw = "keyboard_oem_period",
			type = "pressed"
		},
		give_move_order = {
			raw = "keyboard_oem_minus",
			type = "pressed"
		},
		sweep_point_forward = {
			raw = "keyboard_numpad 6",
			type = "pressed"
		},
		sweep_point_backward = {
			raw = "keyboard_numpad 4",
			type = "pressed"
		},
		sweep_point_axis_cycle = {
			raw = "keyboard_numpad 5",
			type = "pressed"
		},
		sweep_anchor_point_toggle = {
			raw = "keyboard_numpad 8",
			type = "pressed"
		},
		sweep_editor_dump = {
			raw = "keyboard_enter",
			type = "pressed"
		},
		sweep_editor_exit = {
			raw = "keyboard_esc",
			type = "pressed"
		},
		reset_quick_drawer_stay = {
			raw = "keyboard_x",
			type = "pressed"
		},
		deal_damage = {
			type = "pressed",
			raw = {
				"keyboard_b",
				"xbox_controller_d_right"
			}
		},
		heal_damage = {
			type = "pressed",
			raw = {
				"keyboard_left shift+keyboard_b",
				"xbox_controller_d_left"
			}
		},
		permanent_damage_modifier = {
			type = "held",
			raw = {
				"keyboard_left ctrl",
				"xbox_controller_d_down"
			}
		},
		kill_unit = {
			raw = "keyboard_j",
			type = "pressed"
		},
		kill_all_enemy_minions = {
			raw = "keyboard_left shift+keyboard_j",
			type = "pressed"
		},
		kill_all_deselected_enemy_minions = {
			raw = "keyboard_left shift+keyboard_left alt+keyboard_j",
			type = "pressed"
		},
		kill_nearby_enemy_minions = {
			raw = "keyboard_left ctrl+keyboard_j",
			type = "pressed"
		},
		kill_nearby_deselected_enemy_minions = {
			raw = "keyboard_left ctrl+keyboard_left alt+keyboard_j",
			type = "pressed"
		},
		add_pacing_tension = {
			raw = "keyboard_l",
			type = "pressed"
		},
		toggle_behavior_tree = {
			raw = "keyboard_t-keyboard_left shift",
			type = "pressed"
		},
		behavior_tree_pan_toggle = {
			hold_threshold = 0.5,
			raw = "keyboard_left alt",
			type = "held"
		},
		behavior_tree_pan = {
			raw = "mouse_mouse",
			type = "axis"
		},
		reload_level = {
			raw = "keyboard_left ctrl+keyboard_left shift+keyboard_l",
			type = "pressed"
		},
		toggle_pickup_picker = {
			raw = "keyboard_left shift+keyboard_n",
			type = "pressed"
		},
		spawn_pickup = {
			raw = "keyboard_n",
			type = "pressed"
		},
		terror_event_pan_toggle = {
			hold_threshold = 0.5,
			raw = "keyboard_left ctrl",
			type = "held"
		},
		terror_event_pan = {
			raw = "mouse_mouse",
			type = "axis"
		},
		toggle_horde_picker = {
			raw = "keyboard_left shift+keyboard_h",
			type = "pressed"
		},
		trigger_horde = {
			raw = "keyboard_h",
			type = "pressed"
		},
		side_picker_up_hold = {
			hold_threshold = 0.8,
			raw = "keyboard_numpad 7",
			type = "held"
		},
		side_picker_down_hold = {
			hold_threshold = 0.5,
			raw = "keyboard_numpad 4",
			type = "held"
		},
		target_side_picker_up_hold = {
			hold_threshold = 0.8,
			raw = "keyboard_numpad 8",
			type = "held"
		},
		target_side_picker_down_hold = {
			hold_threshold = 0.5,
			raw = "keyboard_numpad 5",
			type = "held"
		},
		stall_game = {
			raw = "keyboard_right shift+keyboard_pause",
			type = "pressed"
		},
		pixeldistance_1 = {
			raw = "keyboard_left shift",
			type = "held"
		},
		pixeldistance_2 = {
			raw = "mouse_right",
			type = "held"
		},
		cursor = {
			raw = "mouse_cursor",
			type = "axis"
		},
		refresh_ladder_smart_objects = {
			raw = "keyboard_right ctrl+keyboard_l",
			type = "pressed"
		},
		toggle_third_person_mode = {
			raw = "keyboard_left ctrl+mouse_middle",
			type = "pressed"
		},
		self_assist = {
			hold_threshold = 0.8,
			type = "pressed",
			raw = {
				"keyboard_c",
				"xbox_controller_right_thumb+xbox_controller_d_down"
			}
		},
		catapult_self = {
			hold_threshold = 0.8,
			raw = "keyboard_k",
			type = "held"
		},
		catapult_self_forward = {
			hold_threshold = 0.8,
			raw = "keyboard_k+keyboard_up",
			type = "held"
		},
		catapult_self_left = {
			hold_threshold = 0.8,
			raw = "keyboard_k+keyboard_left",
			type = "held"
		},
		catapult_self_right = {
			hold_threshold = 0.8,
			raw = "keyboard_k+keyboard_right",
			type = "held"
		},
		player_speed_change_toggle = {
			hold_threshold = 0.5,
			raw = "keyboard_left alt",
			type = "held"
		},
		player_speed_change = {
			raw = "mouse_wheel",
			type = "axis"
		},
		play_debug_vo = {
			raw = "keyboard_left alt+keyboard_1",
			type = "pressed"
		},
		cinematic_fast_track_prev_track = {
			raw = "keyboard_right ctrl+keyboard_up",
			type = "pressed"
		},
		cinematic_fast_track_next_track = {
			raw = "keyboard_right ctrl+keyboard_down",
			type = "pressed"
		},
		cinematic_fast_track_prev_key = {
			raw = "keyboard_right ctrl+keyboard_left",
			type = "pressed"
		},
		cinematic_fast_track_next_key = {
			raw = "keyboard_right ctrl+keyboard_right",
			type = "pressed"
		},
		cinematic_fast_track_pause_unpause = {
			raw = "keyboard_right shift+keyboard_space",
			type = "pressed"
		},
		cinematic_fast_track_slow_down = {
			raw = "keyboard_right shift+keyboard_left",
			type = "pressed"
		},
		cinematic_fast_track_speed_up = {
			raw = "keyboard_right shift+keyboard_right",
			type = "pressed"
		},
		trigger_stagger_left = {
			raw = "keyboard_left",
			type = "pressed"
		},
		trigger_stagger_right = {
			raw = "keyboard_right",
			type = "pressed"
		},
		trigger_stagger_fwd = {
			raw = "keyboard_up",
			type = "pressed"
		},
		trigger_stagger_bwd = {
			raw = "keyboard_down",
			type = "pressed"
		},
		trigger_stagger_dwn = {
			raw = "keyboard_left shift+keyboard_down",
			type = "pressed"
		},
		disconnect_lost_session = {
			raw = "keyboard_left shift+keyboard_0",
			type = "pressed"
		}
	}
}

return settings("DefaultDebugInputSettings", default_debug_input_settings)
