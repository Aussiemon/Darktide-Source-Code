-- chunkname: @scripts/settings/damage/damage_profiles/trap_damage_profile_templates.lua

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

local TRAP_BASE_ADM = {
	attack = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 1.5,
		[armor_types.resistant] = 1.75,
		[armor_types.player] = 0,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 1.2,
		[armor_types.disgustingly_resilient] = 1.75,
		[armor_types.void_shield] = 1.75,
	},
	impact = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 1.5,
		[armor_types.resistant] = 1.75,
		[armor_types.player] = 0,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 1.2,
		[armor_types.disgustingly_resilient] = 1.75,
		[armor_types.void_shield] = 1.75,
	},
}
local TRAP_EXPLOSIVE_ATTACK = 2400
local TRAP_EXPLOSIVE_IMPACT = 480
local TRAP_EXPLOSIVE_SURPRESSION_VALUE = 24
local TRAP_EXPLOSIVE_RAGDOLL_PUSH_FORCE = 850

damage_templates.expedition_trap_explosive_close = {
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier = TRAP_BASE_ADM,
	power_distribution = {
		attack = TRAP_EXPLOSIVE_ATTACK,
		impact = TRAP_EXPLOSIVE_IMPACT,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	suppression_value = TRAP_EXPLOSIVE_SURPRESSION_VALUE,
	damage_type = damage_types.grenade_frag,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.infinite,
	gib_push_force = GibbingSettings.gib_push_force.explosive_heavy,
	ragdoll_push_force = TRAP_EXPLOSIVE_RAGDOLL_PUSH_FORCE,
}
overrides.expedition_trap_explosive = {
	parent_template_name = "expedition_trap_explosive_close",
	overrides = {
		{
			"power_distribution",
			"attack",
			TRAP_EXPLOSIVE_ATTACK / 2,
		},
		{
			"power_distribution",
			"impact",
			TRAP_EXPLOSIVE_IMPACT / 4,
		},
		{
			"suppression_value",
			TRAP_EXPLOSIVE_SURPRESSION_VALUE / 2,
		},
		{
			"gibbing_power",
			GibbingPower.heavy,
		},
		{
			"gib_push_force",
			GibbingSettings.gib_push_force.explosive,
		},
		{
			"ragdoll_push_force",
			TRAP_EXPLOSIVE_RAGDOLL_PUSH_FORCE / 2,
		},
	},
}

local TRAP_FIRE_ATTACK = 10
local TRAP_FIRE_IMPACT = 240

overrides.expedition_trap_fire = {
	parent_template_name = "expedition_trap_explosive_close",
	overrides = {
		{
			"power_distribution",
			"attack",
			TRAP_FIRE_ATTACK,
		},
		{
			"power_distribution",
			"impact",
			TRAP_FIRE_IMPACT,
		},
		{
			"gibbing_power",
			GibbingPower.always,
		},
		{
			"gib_push_force",
			GibbingSettings.gib_push_force.explosive,
		},
		{
			"ragdoll_push_force",
			0,
		},
	},
}

local TRAP_SHOCK_ATTACK = 10
local TRAP_SHOCK_IMPACT = 240

overrides.expedition_trap_shock = {
	parent_template_name = "expedition_trap_explosive_close",
	overrides = {
		{
			"power_distribution",
			"attack",
			TRAP_SHOCK_ATTACK,
		},
		{
			"power_distribution",
			"impact",
			TRAP_SHOCK_IMPACT,
		},
		{
			"stagger_category",
			"electrocuted",
		},
		{
			"gibbing_power",
			GibbingPower.always,
		},
		{
			"gib_push_force",
			GibbingSettings.gib_push_force.explosive,
		},
		{
			"ragdoll_push_force",
			0,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
