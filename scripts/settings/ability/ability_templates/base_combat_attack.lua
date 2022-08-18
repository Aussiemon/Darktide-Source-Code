local ability_template = {
	action_inputs = {
		combat_ability_pressed = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		combat_ability_pressed = "stay"
	},
	actions = {
		action_wield = {
			kind = "wield",
			start_input = "combat_ability_pressed",
			total_time = 0,
			allowed_chain_actions = {
				light_attack = {
					action_name = "action_left_down_light"
				}
			}
		},
		action_combat_attack = {
			uninterruptible = true,
			kind = "sweep",
			use_ability_charge = true,
			ability_type = "combat_ability",
			total_time = 2
		}
	},
	fx_sources = {}
}

return ability_template
