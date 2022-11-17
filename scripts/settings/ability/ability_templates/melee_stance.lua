local ability_template = {
	action_inputs = {
		stance_pressed = {
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
		stance_pressed = "stay"
	},
	actions = {
		action_stance_change = {
			buff_to_add = "ogryn_melee_stance",
			allowed_during_sprint = true,
			start_input = "stance_pressed",
			uninterruptible = true,
			kind = "stance_change",
			sprint_ready_up_time = 0.5,
			auto_wield_slot = "slot_primary",
			use_ability_charge = true,
			ability_type = "combat_ability",
			total_time = 0.1
		}
	},
	fx_sources = {}
}

return ability_template
