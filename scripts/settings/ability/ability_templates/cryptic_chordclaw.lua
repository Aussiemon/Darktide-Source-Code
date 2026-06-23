-- chunkname: @scripts/settings/ability/ability_templates/cryptic_chordclaw.lua

local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local ability_template = {}

ability_template.action_inputs = {
	aim_pressed = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	aim_released = {
		buffer_time = 0,
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
	action_charge = {
		ability_type = "combat_ability",
		aim_ready_up_time = 0,
		allowed_during_lunge = false,
		allowed_during_sprint = true,
		block_weapon_actions = true,
		kind = "cryptic_chordclaw_charge",
		minimum_hold_time = 0.075,
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		stop_input = "block_cancel",
		uninterruptible = true,
		total_time = math.huge,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_activate",
			},
		},
	},
	action_activate = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		anim = "ability_shout",
		block_weapon_actions = false,
		kind = "cryptic_chordclaw",
		sprint_ready_up_time = 0,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "cryptic_ability_03_a",
		total_time = math.huge,
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"HideVisibilityGroupEffects",
	"LungeEffects",
}
ability_template.equipped_ability_effect_scripts_tweak_data = {
	hide_visibility_group = {
		target_unit_slot = "slot_body_arms",
		target_wielded_slot = "slot_combat_ability",
		visibility_group_name = "vg_hand",
	},
	targeting_fx = {},
}
ability_template.allowed_during_sprint = true

return ability_template
