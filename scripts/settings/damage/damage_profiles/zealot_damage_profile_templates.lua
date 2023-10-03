local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GIBBING_POWER = GibbingSettings.gibbing_power
local GIBBING_TYPES = GibbingSettings.gibbing_types
local DAMAGE_TYPES = DamageSettings.damage_types
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
damage_templates.zealot_throwing_knives = {
	stagger_category = "killshot",
	vo_no_headshot = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
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
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
		}
	},
	cleave_distribution = {
		attack = 1.25,
		impact = 1.25
	},
	power_distribution = {
		attack = 500,
		impact = 5
	},
	gibbing_power = GIBBING_POWER.always,
	gibbing_type = GIBBING_TYPES.ballistic,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
