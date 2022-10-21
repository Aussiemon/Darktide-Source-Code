local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local ability_template = {
	action_inputs = {
		charge_pressed = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		charge_pressed = "base"
	},
	actions = {
		action_state_change = {
			allowed_during_sprint = true,
			state_name = "lunging",
			start_input = "charge_pressed",
			kind = "character_state_change",
			sprint_ready_up_time = 0,
			vo_tag = "ability_bonebreaker",
			uninterruptible = true,
			use_ability_charge = true,
			ability_type = "combat_ability",
			total_time = 0.1,
			sensitivity_settings = {
				sensitivity_modifier = 0.1
			},
			state_params = {
				lunge_template_name = LungeTemplates.ogryn_charge.name
			},
			ability_interrupted_reasons = {
				started_sprint = true
			}
		}
	},
	fx_sources = {}
}

return ability_template
