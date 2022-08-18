local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
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
			radius = 10,
			start_input = "shout_pressed",
			target_enemies = true,
			kind = "shout",
			sprint_ready_up_time = 0.5,
			vo_tag = "ability_shout",
			power_level = 1000,
			uninterruptible = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			anim = "ability_shout",
			total_time = 0.1,
			damage_profile = DamageProfileTemplates.shout_stagger
		}
	},
	ability_meta_data = {
		activation = {
			action_input = "shout_pressed"
		}
	},
	fx_sources = {}
}

return ability_template
