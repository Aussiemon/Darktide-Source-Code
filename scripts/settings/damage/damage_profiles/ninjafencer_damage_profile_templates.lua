local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local armor_types = ArmorSettings.types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local single_cleave = DamageProfileSettings.single_cleave
damage_templates.light_ninjafencer = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 3,
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
					[armor_types.prop_armor] = 0.5
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0
				}
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.1
			},
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		{
			power_distribution = {
				attack = 0.08,
				impact = 0.1
			}
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.25,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
					[armor_types.prop_armor] = 0.25
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0
				}
			},
			power_distribution = {
				attack = 0.05,
				impact = 0.1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_ninjafencer_slash = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 3,
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
					[armor_types.prop_armor] = 0.5
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0
				}
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.1
			},
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		{
			power_distribution = {
				attack = 0.08,
				impact = 0.1
			}
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.25,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
					[armor_types.prop_armor] = 0.25
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0
				}
			},
			power_distribution = {
				attack = 0.05,
				impact = 0.1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.medium_ninjafencer = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.light,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 3,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.75,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75,
					[armor_types.prop_armor] = 0.75
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0
				}
			},
			power_distribution = {
				attack = 0.15,
				impact = 0.25
			},
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		{
			power_distribution = {
				attack = 0.1,
				impact = 0.15
			}
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
					[armor_types.prop_armor] = 0
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5,
					[armor_types.prop_armor] = 0.5
				}
			},
			power_distribution = {
				attack = 0.15,
				impact = 0.2
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
