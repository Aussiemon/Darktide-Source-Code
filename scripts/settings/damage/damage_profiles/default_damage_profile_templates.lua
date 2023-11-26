-- chunkname: @scripts/settings/damage/damage_profiles/default_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_armor_mod = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 0.5,
	[armor_types.resistant] = 1,
	[armor_types.player] = 1,
	[armor_types.berserker] = 0.5,
	[armor_types.super_armor] = 0,
	[armor_types.disgustingly_resilient] = 0.75,
	[armor_types.void_shield] = 0.75
}
damage_templates.crit_armor_mod = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 0.5,
	[armor_types.resistant] = 1.5,
	[armor_types.player] = 1,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 1,
	[armor_types.disgustingly_resilient] = 1,
	[armor_types.void_shield] = 1
}
damage_templates.crit_impact_armor_mod = {
	[armor_types.unarmored] = 2,
	[armor_types.armored] = 0.5,
	[armor_types.resistant] = 1.5,
	[armor_types.player] = 1,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 1,
	[armor_types.disgustingly_resilient] = 1,
	[armor_types.void_shield] = 1
}
damage_templates.single_cleave = {
	attack = 0.01,
	impact = 0.01
}
damage_templates.double_cleave = {
	attack = 0.05,
	impact = 0.05
}
damage_templates.medium_cleave = {
	attack = 0.25,
	impact = 0.25
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
