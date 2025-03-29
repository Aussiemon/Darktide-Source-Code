-- chunkname: @scripts/settings/ability/ability_templates/psyker_shout.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.psyker_2
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
		allowed_during_explode = true,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "shout_aim",
		minimum_hold_time = 0.075,
		shout_ready_up_time = 0,
		sprint_ready_up_time = 0,
		start_input = "shout_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		allowed_chain_actions = {
			shout_released = {
				action_name = "action_shout",
			},
		},
	},
	action_shout = {
		ability_type = "combat_ability",
		allowed_during_explode = true,
		allowed_during_sprint = true,
		anim = "ability_shout",
		has_husk_sound = true,
		kind = "psyker_shout",
		shout_shape = "cone",
		sound_source = "head",
		sprint_ready_up_time = 0,
		target_allies = true,
		target_enemies = true,
		total_time = 0.75,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vfx = "content/fx/particles/abilities/psyker_warp_charge_shout",
		vo_tag = {
			high = "ability_biomancer_high",
			low = "ability_biomancer_low",
		},
		radius = talent_settings.combat_ability.radius,
		min_radius = talent_settings.combat_ability.min_radius,
		max_radius = talent_settings.combat_ability.max_radius,
		override_radius = talent_settings.combat_ability.override_radius,
		override_min_radius = talent_settings.combat_ability.override_min_radius,
		override_max_radius = talent_settings.combat_ability.override_max_radius,
		damage_profile = DamageProfileTemplates.psyker_biomancer_shout,
		damaging_damage_profile = DamageProfileTemplates.psyker_biomancer_shout_damage,
		initial_damage_profile = DamageProfileTemplates.psyker_biomancer_shout_damage,
		damage_type = damage_types.psyker_biomancer_discharge,
		attack_type = attack_types.shout,
		power_level = talent_settings.combat_ability.power_level,
		shout_range = talent_settings.combat_ability.shout_range,
		shout_dot = talent_settings.combat_ability.shout_dot,
	},
}
ability_template.fx_sources = {}

return ability_template
