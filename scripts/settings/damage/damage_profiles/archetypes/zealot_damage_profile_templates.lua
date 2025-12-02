-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/zealot_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local default_armor_mod = DamageProfileSettings.default_armor_mod
local flat_one_armor_mod = DamageProfileSettings.flat_one_armor_mod
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod

damage_templates.zealot_channel_stagger = {
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	stagger_override = "light",
	suppression_type = "ability",
	suppression_value = 200,
	power_distribution = {
		attack = 0,
		impact = 1,
	},
	no_stagger_breed_tags = {
		"ogryn",
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_dash_impact = {
	ignore_stagger_reduction = true,
	is_push = true,
	stagger_category = "hatchet",
	stagger_override = "killshot",
	power_distribution = {
		attack = 0,
		impact = 8,
	},
	cleave_distribution = {
		attack = 0,
		impact = 0.01,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_dash_health_to_damage_transfer = {
	is_push = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 0.5,
		impact = 0,
	},
	cleave_distribution = {
		impact = 0,
		attack = math.huge,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_preacher_ability_close = {
	damage_type = "kinetic",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	power_distribution = {
		attack = 75,
		impact = 75,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.zealot_preacher_ability_far = {
	damage_type = "kinetic",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 50,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.zealot_throwing_knives = {
	stagger_category = "killshot",
	vo_no_headshot = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_75,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
	},
	cleave_distribution = {
		attack = 2,
		impact = 1.25,
	},
	power_distribution = {
		attack = 585,
		impact = 5,
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75,
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
