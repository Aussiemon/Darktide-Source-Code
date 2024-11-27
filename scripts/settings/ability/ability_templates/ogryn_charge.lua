﻿-- chunkname: @scripts/settings/ability/ability_templates/ogryn_charge.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
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
	{
		input = "aim_pressed",
		transition = {
			{
				input = "aim_released",
				transition = "base",
			},
			{
				input = "block_cancel",
				transition = "base",
			},
		},
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		kind = "directional_dash_aim",
		minimum_hold_time = 0.01,
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		lunge_template_name = LungeTemplates.zealot_dash.name,
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
		vo_tag = "ability_bonebreaker",
		sensitivity_settings = {
			sensitivity_modifier = 0.1,
		},
		state_params = {
			lunge_template_name = LungeTemplates.ogryn_charge.name,
		},
		ability_interrupted_reasons = {
			started_sprint = true,
		},
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"LungeEffects",
}

return ability_template
