-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/veteran_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.shout_stagger_veteran = {
	gibbing_power = 0,
	stagger_category = "melee",
	stagger_duration_modifier = 1.5,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 0,
		impact = 15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 5,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 5,
			[armor_types.berserker] = 5,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 5,
			[armor_types.void_shield] = 5,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.veteran_invisibility_suppression = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	stagger_category = "killshot",
	stagger_duration_modifier = 1.5,
	stagger_override = "killshot",
	suppression_type = "ability",
	suppression_value = 200,
	power_distribution = {
		attack = 0,
		impact = 15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
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

return {
	base_templates = damage_templates,
	overrides = overrides,
}
