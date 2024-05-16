-- chunkname: @scripts/settings/damage/damage_profiles/debug_damage_profile_templates.lua

local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local default_armor_mod = DamageProfileSettings.default_armor_mod
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod

return {
	base_templates = damage_templates,
	overrides = overrides,
}
