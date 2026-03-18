-- chunkname: @scripts/settings/damage/damage_profiles/artillery_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local GRENADE_IMPACT_ADM = {
	near = {
		attack = {
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 2,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 2.5,
			[armor_types.void_shield] = 2.5,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 2,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 2,
			[armor_types.disgustingly_resilient] = 2.5,
			[armor_types.void_shield] = 2.5,
		},
	},
}

damage_templates.expedition_artillery_strike_grenade_impact = {
	gibbing_power = 0,
	gibbing_type = 0,
	ignore_shield = false,
	ignore_stagger_reduction = false,
	ragdoll_push_force = 150,
	shield_override_stagger_strength = 0,
	stagger_category = "ranged",
	suppression_value = 4,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = GRENADE_IMPACT_ADM,
	power_distribution = {
		attack = 2,
		impact = 3,
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}

local ARTILLERY_STRIKE_ADM = {
	attack = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 0.5,
		[armor_types.resistant] = 0.75,
		[armor_types.player] = 1,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 2,
		[armor_types.player] = 2,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 2,
		[armor_types.void_shield] = 2,
	},
}
local ARTILLERY_STRIKE_ATTACK = 3200
local ARTILLERY_STRIKE_IMPACT = 128
local ARTILLERY_STRIKE_SUPPRESSION_VALUE = 32

damage_templates.expedition_artillery_strike_close = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier = ARTILLERY_STRIKE_ADM,
	power_distribution = {
		attack = ARTILLERY_STRIKE_ATTACK,
		impact = ARTILLERY_STRIKE_IMPACT,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	suppression_value = ARTILLERY_STRIKE_SUPPRESSION_VALUE,
	damage_type = damage_types.grenade_frag,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.infinite,
	gib_push_force = GibbingSettings.gib_push_force.explosive_heavy,
}
overrides.expedition_artillery_strike = {
	parent_template_name = "expedition_artillery_strike_close",
	overrides = {
		{
			"power_distribution",
			"attack",
			ARTILLERY_STRIKE_ATTACK / 2,
		},
		{
			"power_distribution",
			"impact",
			ARTILLERY_STRIKE_IMPACT / 4,
		},
		{
			"suppression_value",
			ARTILLERY_STRIKE_SUPPRESSION_VALUE / 2,
		},
		{
			"gibbing_power",
			GibbingPower.heavy,
		},
		{
			"gib_push_force",
			GibbingSettings.gib_push_force.explosive,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
