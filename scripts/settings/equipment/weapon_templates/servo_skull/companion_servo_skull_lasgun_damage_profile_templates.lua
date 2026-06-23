-- chunkname: @scripts/settings/equipment/weapon_templates/servo_skull/companion_servo_skull_lasgun_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local companion_servo_skull_lasgun_armor_mod_default = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_75,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
		},
	},
}

damage_templates.default_companion_servo_skull_lasgun_killshot = {
	crit_boost = 0.25,
	stagger_category = "killshot",
	staggering_headshot = true,
	cleave_distribution = single_cleave,
	ranges = {
		max = 15,
		min = 7,
	},
	wounds_template = WoundsTemplates.laser,
	armor_damage_modifier_ranged = companion_servo_skull_lasgun_armor_mod_default,
	critical_strike = {
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser,
	},
	power_distribution = {
		attack = 160,
		impact = 5,
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		0.4,
		0.6,
	},
	on_kill_area_suppression = {
		suppression_value = {
			0.4,
			0.6,
		},
		distance = {
			2,
			3,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.armored] = 0.75,
				[armor_types.super_armor] = 0.1,
				[armor_types.berserker] = 0.25,
				[armor_types.resistant] = 0.25,
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_2,
		},
	},
	ragdoll_push_force = {
		150,
		250,
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0,
	},
}
damage_templates.improved_companion_servo_skull_lasgun_killshot = table.clone(damage_templates.default_companion_servo_skull_lasgun_killshot)
damage_templates.improved_companion_servo_skull_lasgun_killshot.power_distribution.attack = 160
damage_templates.improved_companion_servo_skull_lasgun_killshot.power_distribution.impact = 5

return {
	base_templates = damage_templates,
	overrides = overrides,
}
