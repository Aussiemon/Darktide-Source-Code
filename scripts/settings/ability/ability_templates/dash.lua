local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local ability_template = {
	action_inputs = {
		aim_pressed = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		aim_released = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "combat_ability_hold",
					time_window = math.huge
				}
			}
		},
		block_cancel = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					hold_input = "combat_ability_hold",
					input = "action_two_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		aim_pressed = {
			aim_released = "base",
			block_cancel = "base"
		}
	},
	actions = {
		action_aim = {
			start_input = "aim_pressed",
			kind = "linear_aim",
			sprint_ready_up_time = 0,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			stop_input = "block_cancel",
			minimum_hold_time = 0.01,
			total_time = math.huge,
			lunge_template_name = LungeTemplates.zealot_dash.name,
			allowed_chain_actions = {
				aim_released = {
					action_name = "action_state_change"
				}
			}
		},
		action_state_change = {
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			use_ability_charge = true,
			uninterruptible = true,
			kind = "character_state_change",
			sprint_ready_up_time = 0,
			vo_tag = "ability_dash",
			state_name = "lunging",
			total_time = 0.1,
			state_params = {
				lunge_template_name = LungeTemplates.zealot_dash.name
			},
			ability_interrupted_reasons = {
				started_sprint = true
			}
		}
	},
	fx_sources = {}
}

return ability_template
