-- chunkname: @scripts/settings/ability/ability_templates/zealot_dash.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local ability_template = {}

ability_template.action_inputs = {
	aim_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	aim_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block_cancel = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "combat_ability_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
}
ability_template.action_input_hierarchy = {
	aim_pressed = {
		aim_released = "base",
		block_cancel = "base",
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "combat_ability",
		aim_ready_up_time = 0,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "targeted_dash_aim",
		minimum_hold_time = 0.075,
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		lunge_template_name = LungeTemplates.zealot_dash.name,
		smart_targeting_template = SmartTargetingTemplates.default_melee,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_state_change",
			},
		},
	},
	action_state_change = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		kind = "character_state_change",
		sprint_ready_up_time = 0,
		state_name = "lunging",
		total_time = 0.1,
		uninterruptible = true,
		use_ability_charge = true,
		vo_tag = "ability_maniac",
		state_params = {
			lunge_template_name = LungeTemplates.zealot_dash.name,
		},
		smart_targeting_template = SmartTargetingTemplates.default_melee,
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"TargetedDashEffects",
	"LungeEffects",
}
ability_template.targeting_fx = {
	effect_name = "content/fx/particles/abilities/zealot_dash_charge",
}

return ability_template
