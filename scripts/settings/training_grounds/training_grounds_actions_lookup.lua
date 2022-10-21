local actions_lookup = {
	attack = {
		action = "loc_attack",
		inputs = {
			"action_one_pressed",
			"action_one_pressed",
			"action_one_pressed"
		}
	},
	attack_heavy = {
		action = "loc_heavy_attack",
		inputs = {
			"action_one_hold"
		}
	},
	special = {
		action = "loc_special",
		inputs = {
			"weapon_extra_pressed"
		}
	},
	move = {
		action = "loc_move",
		inputs = {
			"keyboard_move_forward",
			"keyboard_move_left",
			"keyboard_move_backward",
			"keyboard_move_right"
		}
	},
	block = {
		action = "loc_block",
		inputs = {
			"action_two_hold"
		}
	},
	push = {
		action = "loc_push",
		inputs = {
			"action_one_pressed"
		}
	},
	push_follow_up = {
		action = "loc_follow_up",
		inputs = {
			"action_one_hold"
		}
	},
	grenade = {
		action = "loc_grenade",
		inputs = {
			"grenade_ability_pressed",
			"action_one_pressed"
		}
	},
	psyker_ability = {
		action = "loc_input_psyker_ability",
		inputs = {
			"grenade_ability_pressed",
			"action_one_hold"
		}
	},
	tagging = {
		type_override = true,
		action = "loc_tag",
		inputs = {
			"smart_tag"
		}
	},
	world_marker = {
		action = "loc_world_marker",
		inputs = {
			"smart_tag"
		}
	},
	strafe = {
		action = "loc_input_strafe",
		inputs = {
			"keyboard_move_left",
			"keyboard_move_backward",
			"keyboard_move_right"
		}
	},
	dodge = {
		action = "loc_input_dodge",
		inputs = {
			"jump"
		}
	},
	sprint = {
		action = "loc_input_sprint",
		inputs = {
			"sprinting"
		}
	},
	slide = {
		action = "loc_input_slide",
		inputs = {
			"crouch"
		}
	},
	combat_ability = {
		action = "loc_combat_ability_input",
		inputs = {
			"combat_ability_pressed"
		}
	},
	pocketable = {
		action = "loc_healing_self_and_others_input",
		inputs = {
			"wield_3",
			"action_one_pressed"
		}
	},
	revive = {
		action = "loc_reviving_input",
		inputs = {
			"interact_pressed"
		}
	},
	ventilate = {
		action = "loc_ventliating_tutorial_input",
		inputs = {
			"weapon_reload_hold"
		}
	},
	charge = {
		action = "loc_force_staff_charge_input",
		inputs = {
			"action_two_hold"
		}
	},
	force_explosion = {
		action = "loc_force_explosion_tutorial_input",
		inputs = {
			"action_one_pressed"
		}
	}
}

return actions_lookup
