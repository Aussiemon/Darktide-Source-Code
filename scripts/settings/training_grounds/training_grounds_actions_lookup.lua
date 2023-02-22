local actions_lookup = {
	attack_chains = {
		{
			description = "loc_weapon_action_title_light",
			input_action = "action_one_pressed"
		}
	},
	weapon_special_chainsword = {
		{
			description = "loc_tg_weapon_special_chainsword",
			input_action = "weapon_extra_pressed"
		}
	},
	weapon_special_forcesword = {
		{
			description = "loc_tg_input_description_melee_special_force_sword",
			input_action = "weapon_extra_pressed"
		}
	},
	weapon_special_ogrynknife = {
		{
			description = "loc_tg_weapon_special_combatblade",
			input_action = "weapon_extra_pressed"
		}
	},
	attack_chains_heavy = {
		{
			description = "loc_heavy_attack",
			input_action = "action_one_hold"
		}
	},
	wield_psyker_ability = {
		{
			description = "loc_talents_category_tactical",
			input_action = "grenade_ability_pressed"
		}
	},
	wield_grenade = {
		{
			description = "loc_talents_category_tactical",
			input_action = "grenade_ability_pressed"
		}
	},
	activate_combat_ability = {
		{
			description = "loc_combat_ability_input",
			input_action = "combat_ability_pressed"
		}
	},
	health_and_ammo_kits = {
		{
			description = "loc_utility_input_description",
			input_action = "wield_3"
		}
	},
	tag_and_world_markers = {
		{
			description = "loc_tag_input_description",
			input_action = "smart_tag"
		},
		{
			description = "loc_world_marker_input_description",
			input_action = "com_wheel"
		}
	},
	sprint_and_slide = {
		{
			description = "loc_input_sprint",
			input_action = "sprint"
		},
		{
			description = "loc_input_slide",
			input_action = "crouch"
		}
	},
	push = {
		{
			description = "loc_block",
			input_action = "action_two_hold"
		},
		{
			description = "loc_pushf",
			input_action = "action_one_pressed"
		}
	},
	armor_heavy_attack = {
		{
			description = "loc_tg_armor_heavy_attack",
			input_action = "action_one_hold"
		}
	},
	push_follow_up = {
		{
			description = "loc_block",
			input_action = "action_two_hold"
		},
		{
			description = "loc_tg_push_follow",
			input_action = "action_one_hold"
		}
	},
	dodge = {
		{
			description = "loc_training_ground_move_left_description",
			input_action = {
				keyboard = "keyboard_move_left",
				controller = "move_controller"
			}
		},
		{
			description = "loc_training_ground_move_right_description",
			input_action = {
				keyboard = "keyboard_move_right",
				controller = "move_controller"
			}
		},
		{
			description = "loc_training_ground_move_backward_description",
			input_action = {
				keyboard = "keyboard_move_backward",
				controller = "move_controller"
			}
		},
		{
			description = "loc_training_ground_dodge_description",
			input_action = "dodge"
		}
	}
}

return actions_lookup
