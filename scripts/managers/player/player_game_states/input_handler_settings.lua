local input_handler_settings = {
	buffered_frames = 20,
	client_input_buffer_size = 600,
	actions = {
		"move_forward",
		"move_left",
		"move_backward",
		"move_right",
		"crouching",
		"sprinting",
		"action_one_hold",
		"action_two_hold",
		"weapon_reload_hold",
		"interact_hold",
		"combat_ability_hold",
		"grenade_ability_hold",
		"weapon_inspect_hold",
		"weapon_extra_hold",
		"jump_held"
	},
	ephemeral_actions = {
		"jump",
		"action_one_pressed",
		"action_one_release",
		"action_two_pressed",
		"action_two_release",
		"crouch",
		"sprint",
		"dodge",
		"quick_wield",
		"wield_scroll_down",
		"wield_scroll_up",
		"wield_1",
		"wield_2",
		"wield_3",
		"wield_4",
		"weapon_reload",
		"interact_pressed",
		"combat_ability_pressed",
		"combat_ability_release",
		"grenade_ability_pressed",
		"grenade_ability_release",
		"weapon_extra_pressed",
		"weapon_extra_release"
	},
	ui_interaction_actions = {
		"finished_interaction",
		"emote_1",
		"emote_2",
		"emote_3",
		"emote_4",
		"emote_5"
	},
	input_settings = {
		"hold_to_sprint",
		"hold_to_crouch",
		"stationary_dodge",
		"diagonal_forward_dodge"
	},
	action_network_type = {
		move_left = "float_input",
		move_forward = "float_input",
		move_backward = "float_input",
		move_right = "float_input"
	},
	pack_unpack_actions = {
		"move_forward",
		"move_left",
		"move_backward",
		"move_right"
	}
}

return settings("InputHandlerSettings", input_handler_settings)
