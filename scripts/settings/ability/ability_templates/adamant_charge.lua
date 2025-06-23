-- chunkname: @scripts/settings/ability/ability_templates/adamant_charge.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local ability_template = {}

ability_template.action_inputs = {
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
}
ability_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = {
			{
				transition = "base",
				input = "aim_released"
			},
			{
				transition = "base",
				input = "block_cancel"
			}
		}
	}
}
ability_template.actions = {
	action_aim = {
		start_input = "aim_pressed",
		kind = "directional_dash_aim",
		sprint_ready_up_time = 0,
		aim_ready_up_time = 0,
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		stop_input = "block_cancel",
		minimum_hold_time = 0.01,
		total_time = math.huge,
		lunge_template_name = LungeTemplates.adamant_charge.name,
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
		state_name = "lunging",
		kind = "character_state_change",
		sprint_ready_up_time = 0,
		vo_tag = "ability_charge_a",
		uninterruptible = true,
		total_time = 0.1,
		state_params = {
			lunge_template_name = LungeTemplates.adamant_charge.name
		},
		smart_targeting_template = SmartTargetingTemplates.default_melee
	}
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"TargetedDashEffects",
	"LungeEffects"
}
ability_template.targeting_fx = {
	effect_name = "content/fx/particles/abilities/adamant/adamant_charge_aim"
}

return ability_template
