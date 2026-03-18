-- chunkname: @scripts/settings/input/default_debug_input_settings.lua

local DefaultDebugInputFilters = require("scripts/settings/input/default_debug_input_filters")
local default_debug_input_settings = {
	service_type = "Debug",
	filters = DefaultDebugInputFilters,
	default_devices = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller",
	},
	aliases = {
		add_pacing_heat = {
			"shift+keyboard_u",
		},
		add_pacing_tension = {
			"keyboard_l",
		},
		aggro_nearby_roamers = {
			"keyboard_left shift+keyboard_k",
		},
		alert_selected_minion = {
			"mouse_left",
		},
		behavior_tree_pan = {
			"mouse_mouse",
		},
		behavior_tree_pan_toggle = {
			"keyboard_left alt",
		},
		catapult_self = {
			"keyboard_k",
		},
		catapult_self_forward = {
			"keyboard_k+keyboard_up",
		},
		catapult_self_left = {
			"keyboard_k+keyboard_left",
		},
		catapult_self_right = {
			"keyboard_k+keyboard_right",
		},
		cinematic_fast_track_next_key = {
			"keyboard_right ctrl+keyboard_right",
		},
		cinematic_fast_track_next_track = {
			"keyboard_right ctrl+keyboard_down",
		},
		cinematic_fast_track_pause_unpause = {
			"keyboard_right shift+keyboard_space",
		},
		cinematic_fast_track_prev_key = {
			"keyboard_right ctrl+keyboard_left",
		},
		cinematic_fast_track_prev_track = {
			"keyboard_right ctrl+keyboard_up",
		},
		cinematic_fast_track_slow_down = {
			"keyboard_right shift+keyboard_left",
		},
		cinematic_fast_track_speed_up = {
			"keyboard_right shift+keyboard_right",
		},
		cursor = {
			"mouse_cursor",
			bindable = false,
		},
		deal_damage = {
			"keyboard_b",
			"xbox_controller_d_right+xbox_controller_d_up",
			"ps4_controller_d_right+ps4_controller_d_up",
		},
		deselect_unit = {
			"keyboard_left ctrl+keyboard_v",
		},
		despawn_all_deselected_units = {
			"keyboard_left ctrl+keyboard_left alt+keyboard_i",
		},
		despawn_all_units = {
			"keyboard_left ctrl+keyboard_i",
			"xbox_controller_back",
			"ps4_controller_touch",
		},
		despawn_nearby_deselected_units = {
			"keyboard_left alt+keyboard_i",
		},
		despawn_nearby_units = {
			"keyboard_i",
		},
		disconnect_lost_session = {
			"keyboard_left shift+keyboard_0",
		},
		down_key_hold = {
			"keyboard_down",
		},
		down_key_pressed = {
			"keyboard_down",
		},
		give_move_order = {
			"keyboard_oem_minus",
		},
		heal_damage = {
			"keyboard_left shift+keyboard_b",
			"xbox_controller_d_left+xbox_controller_d_up",
			"ps4_controller_d_left+ps4_controller_d_up",
		},
		kill_all_deselected_enemy_minions = {
			"keyboard_left shift+keyboard_left alt+keyboard_j",
		},
		kill_all_enemy_minions = {
			"keyboard_left shift+keyboard_j",
		},
		kill_nearby_deselected_enemy_minions = {
			"keyboard_left ctrl+keyboard_left alt+keyboard_j",
		},
		kill_nearby_enemy_minions = {
			"keyboard_left ctrl+keyboard_j",
		},
		kill_unit = {
			"keyboard_j",
		},
		left_key_hold = {
			"keyboard_left",
		},
		left_key_pressed = {
			"keyboard_left",
		},
		left_mouse_buttton_pressed = {
			"mouse_left",
		},
		minion_auto_stagger_start = {
			"keyboard_left shift+keyboard_l",
		},
		mission_buffs_buff_choice_one = {
			"keyboard_left alt+keyboard_left ctrl+keyboard_1",
			"xbox_controller_left_thumb+xbox_controller_d_left",
			"ps4_controller_l3+ps4_controller_d_left",
		},
		mission_buffs_buff_choice_three = {
			"keyboard_left alt+keyboard_left ctrl+keyboard_3",
			"xbox_controller_left_thumb+xbox_controller_d_right",
			"ps4_controller_l3+ps4_controller_d_right",
		},
		mission_buffs_buff_choice_two = {
			"keyboard_left alt+keyboard_left ctrl+keyboard_2",
			"xbox_controller_left_thumb+xbox_controller_d_up",
			"ps4_controller_l3+ps4_controller_d_up",
		},
		mission_buffs_family_buff_for_all = {
			"keyboard_left shift+keyboard_left ctrl+keyboard_m",
		},
		mission_buffs_legendary_buff_choice = {
			"keyboard_left alt+keyboard_left ctrl+keyboard_m",
		},
		mission_buffs_trigger_catchup_for_player = {
			"keyboard_left shift+keyboard_left ctrl+keyboard_k",
		},
		open_selected = {
			"keyboard_f5",
		},
		paint_liquid = {
			"keyboard_left shift+keyboard_y",
		},
		permanent_damage_modifier = {
			"keyboard_left ctrl",
			"xbox_controller_d_down",
			"ps4_controller_d_down",
		},
		pixeldistance_1 = {
			"keyboard_left shift",
		},
		pixeldistance_2 = {
			"mouse_right",
		},
		play_debug_vo = {
			"keyboard_left alt+keyboard_1",
		},
		player_speed_change = {
			"mouse_wheel",
		},
		player_speed_change_reset = {
			"mouse_middle",
		},
		player_speed_change_toggle = {
			"keyboard_left alt",
		},
		refresh_ladder_smart_objects = {
			"keyboard_right ctrl+keyboard_l",
		},
		regenerate_monsters = {
			"keyboard_left shift+keyboard_m",
		},
		regenerate_roamers = {
			"keyboard_left shift+keyboard_g",
		},
		regenerate_specials = {
			"keyboard_left shift+keyboard_s",
		},
		regenerate_toxic_fog = {
			"keyboard_left shift+keyboard_t",
		},
		reload_level = {
			"keyboard_left ctrl+keyboard_left shift+keyboard_l",
		},
		remove_monster_warning = {
			"keyboard_esc",
			bindable = false,
		},
		replenish_ability_charge = {
			"keyboard_9",
		},
		request_auto_event = {
			"keyboard_left shift+keyboard_y",
		},
		request_auto_event_end = {
			"keyboard_left shift+keyboard_t",
		},
		reset_quick_drawer_stay = {
			"keyboard_x",
		},
		restart_twin_ambushes = {
			"keyboard_left shift+keyboard_o",
		},
		right_key_hold = {
			"keyboard_right",
		},
		right_key_pressed = {
			"keyboard_right",
		},
		select_companion_unit_toggle = {
			"keyboard_left alt",
		},
		select_self_unit_toggle = {
			"keyboard_left shift",
		},
		select_unit = {
			"keyboard_v",
		},
		self_assist = {
			"keyboard_c",
			"xbox_controller_right_thumb+xbox_controller_d_down",
			"ps4_controller_r3+ps4_controller_d_down",
		},
		side_picker_down_hold = {
			"keyboard_numpad 4",
		},
		side_picker_up_hold = {
			"keyboard_numpad 7",
		},
		spawn_liquid = {
			"keyboard_left ctrl+keyboard_y",
		},
		spawn_multiple_units = {
			"keyboard_left ctrl+keyboard_p",
		},
		spawn_patrol = {
			"keyboard_left alt+keyboard_left ctrl+keyboard_p",
		},
		spawn_pickup = {
			"keyboard_n",
		},
		spawn_unit = {
			"keyboard_p",
		},
		stall_game = {
			"keyboard_right shift+keyboard_pause",
		},
		target_side_picker_down_hold = {
			"keyboard_numpad 5",
		},
		target_side_picker_up_hold = {
			"keyboard_numpad 8",
		},
		teleport_to_next_mutator_spawner = {
			"keyboard_left shift+keyboard_k",
		},
		terror_event_pan = {
			"mouse_mouse",
		},
		terror_event_pan_toggle = {
			"keyboard_left ctrl",
		},
		timer_speed_change = {
			"mouse_wheel",
		},
		timer_speed_change_reset = {
			"mouse_middle",
		},
		timer_speed_change_toggle = {
			"keyboard_left shift",
		},
		toggle_behavior_tree = {
			"keyboard_t-keyboard_left shift",
		},
		toggle_breed_picker = {
			"keyboard_o",
		},
		toggle_companion_perception = {
			"keyboard_right shift+keyboard_z",
		},
		toggle_horde_picker = {
			"keyboard_left shift+keyboard_h",
		},
		toggle_minion_perception = {
			"keyboard_left shift+keyboard_z",
		},
		toggle_move_order_mode = {
			"keyboard_oem_period",
		},
		toggle_pacing = {
			"keyboard_left shift+keyboard_x",
		},
		toggle_paint_liquid = {
			"keyboard_left shift+keyboard_u",
		},
		toggle_pickup_picker = {
			"keyboard_left shift+keyboard_n",
		},
		toggle_third_person_mode = {
			"keyboard_left ctrl+mouse_middle",
		},
		toggle_time_pause = {
			"keyboard_pause-keyboard_right shift",
		},
		toggle_timer_picker = {
			"keyboard_home",
		},
		trigger_horde = {
			"keyboard_h",
		},
		trigger_next_horde_pacing_wave = {
			"keyboard_left shift+keyboard_e",
		},
		trigger_stagger_bwd = {
			"keyboard_down",
		},
		trigger_stagger_dwn = {
			"keyboard_left shift+keyboard_down",
		},
		trigger_stagger_fwd = {
			"keyboard_up",
		},
		trigger_stagger_left = {
			"keyboard_left",
		},
		trigger_stagger_right = {
			"keyboard_right",
		},
		up_key_hold = {
			"keyboard_up",
		},
		up_key_pressed = {
			"keyboard_up",
		},
	},
	settings = {
		add_pacing_heat = {
			key_alias = "add_pacing_heat",
			type = "pressed",
		},
		add_pacing_tension = {
			key_alias = "add_pacing_tension",
			type = "pressed",
		},
		aggro_nearby_roamers = {
			key_alias = "aggro_nearby_roamers",
			type = "pressed",
		},
		alert_selected_minion = {
			key_alias = "alert_selected_minion",
			type = "pressed",
		},
		behavior_tree_pan = {
			key_alias = "behavior_tree_pan",
			type = "axis",
		},
		behavior_tree_pan_toggle = {
			key_alias = "behavior_tree_pan_toggle",
			type = "held",
		},
		catapult_self = {
			key_alias = "catapult_self",
			type = "held",
		},
		catapult_self_forward = {
			key_alias = "catapult_self_forward",
			type = "held",
		},
		catapult_self_left = {
			key_alias = "catapult_self_left",
			type = "held",
		},
		catapult_self_right = {
			key_alias = "catapult_self_right",
			type = "held",
		},
		cinematic_fast_track_next_key = {
			key_alias = "cinematic_fast_track_next_key",
			type = "pressed",
		},
		cinematic_fast_track_next_track = {
			key_alias = "cinematic_fast_track_next_track",
			type = "pressed",
		},
		cinematic_fast_track_pause_unpause = {
			key_alias = "cinematic_fast_track_pause_unpause",
			type = "pressed",
		},
		cinematic_fast_track_prev_key = {
			key_alias = "cinematic_fast_track_prev_key",
			type = "pressed",
		},
		cinematic_fast_track_prev_track = {
			key_alias = "cinematic_fast_track_prev_track",
			type = "pressed",
		},
		cinematic_fast_track_slow_down = {
			key_alias = "cinematic_fast_track_slow_down",
			type = "pressed",
		},
		cinematic_fast_track_speed_up = {
			key_alias = "cinematic_fast_track_speed_up",
			type = "pressed",
		},
		cursor = {
			key_alias = "cursor",
			type = "axis",
		},
		deal_damage = {
			key_alias = "deal_damage",
			type = "pressed",
		},
		deselect_unit = {
			key_alias = "deselect_unit",
			type = "pressed",
		},
		despawn_all_deselected_units = {
			key_alias = "despawn_all_deselected_units",
			type = "pressed",
		},
		despawn_all_units = {
			key_alias = "despawn_all_units",
			type = "pressed",
		},
		despawn_nearby_deselected_units = {
			key_alias = "despawn_nearby_deselected_units",
			type = "pressed",
		},
		despawn_nearby_units = {
			key_alias = "despawn_nearby_units",
			type = "pressed",
		},
		disconnect_lost_session = {
			key_alias = "disconnect_lost_session",
			type = "pressed",
		},
		down_key_hold = {
			key_alias = "down_key_hold",
			type = "held",
		},
		down_key_pressed = {
			key_alias = "down_key_pressed",
			type = "pressed",
		},
		give_move_order = {
			key_alias = "give_move_order",
			type = "pressed",
		},
		heal_damage = {
			key_alias = "heal_damage",
			type = "pressed",
		},
		kill_all_deselected_enemy_minions = {
			key_alias = "kill_all_deselected_enemy_minions",
			type = "pressed",
		},
		kill_all_enemy_minions = {
			key_alias = "kill_all_enemy_minions",
			type = "pressed",
		},
		kill_nearby_deselected_enemy_minions = {
			key_alias = "kill_nearby_deselected_enemy_minions",
			type = "pressed",
		},
		kill_nearby_enemy_minions = {
			key_alias = "kill_nearby_enemy_minions",
			type = "pressed",
		},
		kill_unit = {
			key_alias = "kill_unit",
			type = "pressed",
		},
		left_key_hold = {
			key_alias = "left_key_hold",
			type = "held",
		},
		left_key_pressed = {
			key_alias = "left_key_pressed",
			type = "pressed",
		},
		left_mouse_buttton_pressed = {
			key_alias = "left_mouse_buttton_pressed",
			type = "pressed",
		},
		minion_auto_stagger_start = {
			key_alias = "minion_auto_stagger_start",
			type = "pressed",
		},
		mission_buffs_buff_choice_one = {
			key_alias = "mission_buffs_buff_choice_one",
			type = "pressed",
		},
		mission_buffs_buff_choice_three = {
			key_alias = "mission_buffs_buff_choice_three",
			type = "pressed",
		},
		mission_buffs_buff_choice_two = {
			key_alias = "mission_buffs_buff_choice_two",
			type = "pressed",
		},
		mission_buffs_family_buff_for_all = {
			key_alias = "mission_buffs_family_buff_for_all",
			type = "pressed",
		},
		mission_buffs_legendary_buff_choice = {
			key_alias = "mission_buffs_legendary_buff_choice",
			type = "pressed",
		},
		mission_buffs_trigger_catchup_for_player = {
			key_alias = "mission_buffs_trigger_catchup_for_player",
			type = "pressed",
		},
		open_selected = {
			key_alias = "open_selected",
			type = "pressed",
		},
		paint_liquid = {
			key_alias = "paint_liquid",
			type = "pressed",
		},
		permanent_damage_modifier = {
			key_alias = "permanent_damage_modifier",
			type = "held",
		},
		pixeldistance_1 = {
			key_alias = "pixeldistance_1",
			type = "held",
		},
		pixeldistance_2 = {
			key_alias = "pixeldistance_2",
			type = "held",
		},
		play_debug_vo = {
			key_alias = "play_debug_vo",
			type = "pressed",
		},
		player_speed_change = {
			key_alias = "player_speed_change",
			type = "axis",
		},
		player_speed_change_reset = {
			key_alias = "player_speed_change_reset",
			type = "pressed",
		},
		player_speed_change_toggle = {
			key_alias = "player_speed_change_toggle",
			type = "held",
		},
		refresh_ladder_smart_objects = {
			key_alias = "refresh_ladder_smart_objects",
			type = "pressed",
		},
		regenerate_monsters = {
			key_alias = "regenerate_monsters",
			type = "pressed",
		},
		regenerate_roamers = {
			key_alias = "regenerate_roamers",
			type = "pressed",
		},
		regenerate_specials = {
			key_alias = "regenerate_specials",
			type = "pressed",
		},
		regenerate_toxic_fog = {
			key_alias = "regenerate_toxic_fog",
			type = "pressed",
		},
		reload_level = {
			key_alias = "reload_level",
			type = "pressed",
		},
		remove_monster_warning = {
			key_alias = "remove_monster_warning",
			type = "pressed",
		},
		replenish_ability_charge = {
			key_alias = "replenish_ability_charge",
			type = "pressed",
		},
		request_auto_event = {
			key_alias = "request_auto_event",
			type = "pressed",
		},
		request_auto_event_end = {
			key_alias = "request_auto_event_end",
			type = "pressed",
		},
		reset_quick_drawer_stay = {
			key_alias = "reset_quick_drawer_stay",
			type = "pressed",
		},
		restart_twin_ambushes = {
			key_alias = "restart_twin_ambushes",
			type = "pressed",
		},
		right_key_hold = {
			key_alias = "right_key_hold",
			type = "held",
		},
		right_key_pressed = {
			key_alias = "right_key_pressed",
			type = "pressed",
		},
		select_companion_unit_toggle = {
			key_alias = "select_companion_unit_toggle",
			type = "held",
		},
		select_self_unit_toggle = {
			key_alias = "select_self_unit_toggle",
			type = "held",
		},
		select_unit = {
			key_alias = "select_unit",
			type = "pressed",
		},
		self_assist = {
			key_alias = "self_assist",
			type = "pressed",
		},
		side_picker_down_hold = {
			key_alias = "side_picker_down_hold",
			type = "held",
		},
		side_picker_up_hold = {
			key_alias = "side_picker_up_hold",
			type = "held",
		},
		spawn_liquid = {
			key_alias = "spawn_liquid",
			type = "pressed",
		},
		spawn_multiple_units = {
			key_alias = "spawn_multiple_units",
			type = "pressed",
		},
		spawn_patrol = {
			key_alias = "spawn_patrol",
			type = "pressed",
		},
		spawn_pickup = {
			key_alias = "spawn_pickup",
			type = "pressed",
		},
		spawn_unit = {
			key_alias = "spawn_unit",
			type = "pressed",
		},
		stall_game = {
			key_alias = "stall_game",
			type = "pressed",
		},
		target_side_picker_down_hold = {
			key_alias = "target_side_picker_down_hold",
			type = "held",
		},
		target_side_picker_up_hold = {
			key_alias = "target_side_picker_up_hold",
			type = "held",
		},
		teleport_to_next_mutator_spawner = {
			key_alias = "teleport_to_next_mutator_spawner",
			type = "pressed",
		},
		terror_event_pan = {
			key_alias = "terror_event_pan",
			type = "axis",
		},
		terror_event_pan_toggle = {
			key_alias = "terror_event_pan_toggle",
			type = "held",
		},
		timer_speed_change = {
			key_alias = "timer_speed_change",
			type = "axis",
		},
		timer_speed_change_reset = {
			key_alias = "timer_speed_change_reset",
			type = "pressed",
		},
		timer_speed_change_toggle = {
			key_alias = "timer_speed_change_toggle",
			type = "held",
		},
		toggle_behavior_tree = {
			key_alias = "toggle_behavior_tree",
			type = "pressed",
		},
		toggle_breed_picker = {
			key_alias = "toggle_breed_picker",
			type = "pressed",
		},
		toggle_companion_perception = {
			key_alias = "toggle_companion_perception",
			type = "pressed",
		},
		toggle_horde_picker = {
			key_alias = "toggle_horde_picker",
			type = "pressed",
		},
		toggle_minion_perception = {
			key_alias = "toggle_minion_perception",
			type = "pressed",
		},
		toggle_move_order_mode = {
			key_alias = "toggle_move_order_mode",
			type = "pressed",
		},
		toggle_pacing = {
			key_alias = "toggle_pacing",
			type = "pressed",
		},
		toggle_paint_liquid = {
			key_alias = "toggle_paint_liquid",
			type = "pressed",
		},
		toggle_pickup_picker = {
			key_alias = "toggle_pickup_picker",
			type = "pressed",
		},
		toggle_third_person_mode = {
			key_alias = "toggle_third_person_mode",
			type = "pressed",
		},
		toggle_time_pause = {
			key_alias = "toggle_time_pause",
			type = "pressed",
		},
		toggle_timer_picker = {
			key_alias = "toggle_timer_picker",
			type = "pressed",
		},
		trigger_horde = {
			key_alias = "trigger_horde",
			type = "pressed",
		},
		trigger_next_horde_pacing_wave = {
			key_alias = "trigger_next_horde_pacing_wave",
			type = "pressed",
		},
		trigger_stagger_bwd = {
			key_alias = "trigger_stagger_bwd",
			type = "pressed",
		},
		trigger_stagger_dwn = {
			key_alias = "trigger_stagger_dwn",
			type = "pressed",
		},
		trigger_stagger_fwd = {
			key_alias = "trigger_stagger_fwd",
			type = "pressed",
		},
		trigger_stagger_left = {
			key_alias = "trigger_stagger_left",
			type = "pressed",
		},
		trigger_stagger_right = {
			key_alias = "trigger_stagger_right",
			type = "pressed",
		},
		up_key_hold = {
			key_alias = "up_key_hold",
			type = "held",
		},
		up_key_pressed = {
			key_alias = "up_key_pressed",
			type = "pressed",
		},
	},
}

return settings("DefaultDebugInputSettings", default_debug_input_settings)
