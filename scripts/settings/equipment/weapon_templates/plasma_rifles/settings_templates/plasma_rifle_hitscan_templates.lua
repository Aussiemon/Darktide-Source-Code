-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_hitscan_templates.lua

local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local hitscan_templates = {}
local overrides = {}
local armor_types = ArmorSettings.types

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_plasma_rifle_killshot = {
	range = 100,
	damage = {
		impact = {
			destroy_on_impact = false,
			damage_profile = DamageProfileTemplates.default_plasma_killshot,
			armor_explosion = {
				[armor_types.super_armor] = ExplosionTemplates.plasma_rifle_exit,
			},
		},
		penetration = {
			depth = 0.5,
			destroy_on_exit = false,
			target_index_increase = 2,
			exit_explosion_template = ExplosionTemplates.plasma_rifle_exit,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}
hitscan_templates.default_plasma_rifle_bfg = {
	range = 100,
	damage = {
		impact = {
			destroy_on_impact = false,
			damage_profile = DamageProfileTemplates.default_plasma_bfg,
			armor_explosion = {
				[armor_types.super_armor] = ExplosionTemplates.plasma_rifle_exit,
			},
		},
		penetration = {
			depth = 1.25,
			destroy_on_exit = false,
			target_index_increase = 2,
			exit_explosion_template = ExplosionTemplates.plasma_rifle_exit,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}
hitscan_templates.default_plasma_rifle_demolition = {
	range = 100,
	damage = {
		impact = {
			destroy_on_impact = false,
			damage_profile = DamageProfileTemplates.default_plasma_bfg,
			explosion_template = ExplosionTemplates.plasma_rifle,
		},
		penetration = {
			depth = 2,
			destroy_on_exit = false,
			target_index_increase = 2,
			exit_explosion_template = ExplosionTemplates.plasma_rifle,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
