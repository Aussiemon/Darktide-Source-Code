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
			use_ability_charge = true,
			refill_toughness = false,
			start_input = "stance_pressed",
			anim = "reload_end",
			kind = "stance_change",
			sprint_ready_up_time = 0.5,
			auto_wield_slot = "slot_secondary",
			uninterruptible = true,
			stop_reload = true,
			vo_tag = "ability_ranger",
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			block_weapon_actions = false,
			total_time = 0.8
		}
	},
	fx_sources = {},
	ability_meta_data = {
		activation = {
			action_input = "stance_pressed"
		}
	}
}

return ability_template
