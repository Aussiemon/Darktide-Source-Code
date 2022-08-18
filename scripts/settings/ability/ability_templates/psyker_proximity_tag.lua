local ability_template = {
	action_inputs = {
		tag_pressed = {
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
		tag_pressed = "stay"
	},
	actions = {
		action_stance_change = {
			use_ability_charge = true,
			radius = 25,
			start_input = "tag_pressed",
			uninterruptible = true,
			kind = "proximity_tag",
			sprint_ready_up_time = 0.5,
			vo_tag = "ability_gunslinger",
			allowed_during_sprint = false,
			ability_type = "combat_ability",
			anim = "ability_shout",
			total_time = 0.1
		}
	},
	fx_sources = {}
}

return ability_template
