-- chunkname: @scripts/settings/ability/ability_templates/adamant_shout.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local RADIUS = 8
local talent_settings = TalentSettings.adamant
local ability_template = {}

ability_template.action_inputs = {
	shout_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	shout_released = {
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
		input = "shout_pressed",
		transition = {
			{
				input = "shout_released",
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
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "shout_aim",
		minimum_hold_time = 0.075,
		shout_ready_up_time = 0,
		sprint_ready_up_time = 0,
		start_input = "shout_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		radius = RADIUS,
		allowed_chain_actions = {
			shout_released = {
				action_name = "action_shout",
			},
		},
	},
	action_shout = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		anim = "ability_shout",
		has_husk_sound = true,
		kind = "adamant_shout",
		power_level = 500,
		recover_toughness_effect = "content/fx/particles/abilities/squad_leader_ability_toughness_buff",
		refill_toughness = true,
		shape = "cone",
		shout_dot = 0.75,
		shout_target_template = "adamant_shout",
		sprint_ready_up_time = 0,
		total_time = 0.75,
		toughness_replenish_percent = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "ability_howl_a",
		radius = talent_settings.combat_ability.shout.range,
		far_radius = talent_settings.combat_ability.shout.far_range,
		damage_profile = DamageProfileTemplates.adamant_shout,
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects",
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/adamant/adamant_shout",
}

return ability_template
