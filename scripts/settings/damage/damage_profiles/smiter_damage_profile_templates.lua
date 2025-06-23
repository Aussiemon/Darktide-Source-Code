-- chunkname: @scripts/settings/damage/damage_profiles/smiter_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.medium_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 350,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 2,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75
				}
			},
			power_distribution = {
				attack = 0.65,
				impact = 1
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.25,
				[armor_types.void_shield] = 0.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5
				}
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.5
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0,
					[armor_types.void_shield] = 0
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0,
					[armor_types.void_shield] = 0
				}
			},
			power_distribution = {
				attack = 0.07,
				impact = 0.2
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			}
		}
	}
}
damage_templates.medium_smiter_pushfollow = table.clone(damage_templates.medium_smiter)
damage_templates.medium_smiter_pushfollow.cleave_distribution = {
	attack = 0.1,
	impact = 0.1
}
damage_templates.medium_smiter_combat_blade = table.clone(damage_templates.medium_smiter)
damage_templates.spell_smiter = {
	ragdoll_push_force = 350,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.crushing,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1
				}
			},
			power_distribution = {
				attack = 0.5,
				impact = 0.4
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
