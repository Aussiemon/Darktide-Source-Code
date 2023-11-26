-- chunkname: @scripts/settings/damage/damage_profiles/tank_damage_profile_templates.lua

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

damage_templates.heavy_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.4,
		impact = 0.5
	},
	gibbing_power = GibbingPower.heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1.8,
					[armor_types.resistant] = 3,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 1.5,
					[armor_types.void_shield] = 1.5
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 1.5,
					[armor_types.void_shield] = 1.5
				}
			},
			power_distribution = {
				attack = 0.5,
				impact = 1.75
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0.1,
				impact = 1.5
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0.05,
				impact = 1.5
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 1.5
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
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1
				}
			},
			power_distribution = {
				attack = 0,
				impact = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

local heavy_tank_shotgun = table.clone(damage_templates.heavy_tank)

damage_templates.heavy_tank_shotgun = heavy_tank_shotgun
damage_templates.shotgun_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.1,
		impact = 1
	},
	gibbing_power = GibbingPower.heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.8,
					[armor_types.resistant] = 3,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0.8,
					[armor_types.disgustingly_resilient] = 0.5,
					[armor_types.void_shield] = 0.5
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 1,
					[armor_types.disgustingly_resilient] = 1.5,
					[armor_types.void_shield] = 1.5
				}
			},
			power_distribution = {
				attack = 0.2,
				impact = 1.75
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 1.5
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 1.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 0.75
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
				attack = 0,
				impact = 0.5
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_powersword_heavy = {
	ragdoll_push_force = 750,
	stagger_category = "melee",
	ignore_gib_push = true,
	cleave_distribution = {
		attack = 0.75,
		impact = 0.75
	},
	gibbing_power = GibbingPower.heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1,
					[armor_types.resistant] = 3,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 0.75,
					[armor_types.void_shield] = 0.75
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 1.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1
				}
			},
			power_distribution = {
				attack = 0.3,
				impact = 1
			}
		},
		{
			power_distribution = {
				attack = 0.15,
				impact = 0.75
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
					[armor_types.void_shield] = 0.75
				},
				impact = {
					[armor_types.unarmored] = 1,
					[armor_types.armored] = 0.5,
					[armor_types.resistant] = 1,
					[armor_types.player] = 1,
					[armor_types.berserker] = 0.5,
					[armor_types.super_armor] = 0,
					[armor_types.disgustingly_resilient] = 1,
					[armor_types.void_shield] = 1
				}
			},
			power_distribution = {
				attack = 0.1,
				impact = 0.5
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
