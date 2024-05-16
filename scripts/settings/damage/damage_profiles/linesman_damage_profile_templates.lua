-- chunkname: @scripts/settings/damage/damage_profiles/linesman_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local armor_types = ArmorSettings.types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.heavy_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 750,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 1,
		impact = 0.5,
	},
	gibbing_power = GibbingPower.heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.75,
					[armor_types.resistant] = 3,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1,
				},
			},
			power_distribution = {
				attack = 1,
				impact = 1,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0.4,
				impact = 0.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0.35,
				impact = 0.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0.25,
				impact = 0.25,
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.75,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.75,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1,
				},
			},
			power_distribution = {
				attack = 0.15,
				impact = 0.25,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_linesman = {
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	gibbing_power = GibbingPower.medium,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
			},
			power_distribution = {
				attack = 0.225,
				impact = 0.5,
			},
		},
		{
			power_distribution = {
				attack = 0.1,
				impact = 0.25,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.75,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.2,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_powersword = {
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	gibbing_power = GibbingPower.medium,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
			},
			power_distribution = {
				attack = 0.225,
				impact = 0.5,
			},
		},
		{
			power_distribution = {
				attack = 0.1,
				impact = 0.25,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
				},
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.2,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
