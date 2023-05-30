local ability_template = {
	action_inputs = {
		shout_pressed = {
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
		shout_pressed = "stay"
	},
	actions = {
		action_shout = {
			use_ability_charge = true,
			radius = 15,
			start_input = "shout_pressed",
			revive_allies = true,
			kind = "shout",
			sprint_ready_up_time = 0,
			uninterruptible = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			anim = "ability_shout",
			target_allies = true,
			total_time = 0.1
		}
	},
	fx_sources = {}
}

return ability_template
