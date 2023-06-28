local TalentSettings = require("scripts/settings/talent/talent_settings")
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
			anim = "reload_end",
			use_charge_at_start = true,
			start_input = "stance_pressed",
			refill_toughness = false,
			kind = "stance_change",
			sprint_ready_up_time = 0,
			uninterruptible = true,
			vo_tag = "ability_ranger",
			stop_reload = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			block_weapon_actions = false,
			skip_wield_action = true,
			auto_wield_slot = "slot_secondary",
			abort_sprint = true,
			use_ability_charge = true,
			prevent_sprint = true,
			total_time = 1
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
