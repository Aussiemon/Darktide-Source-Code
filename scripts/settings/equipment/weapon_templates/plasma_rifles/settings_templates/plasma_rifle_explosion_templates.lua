-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.plasma_rifle = {
	damage_falloff = true,
	radius = 3,
	min_radius = 2,
	close_radius = 1.25,
	scalable_radius = true,
	collision_filter = "filter_player_character_explosion",
	static_power_level = 500,
	min_close_radius = 1.15,
	close_damage_profile = DamageProfileTemplates.default_plasma_demolition,
	close_damage_type = damage_types.laser,
	damage_profile = DamageProfileTemplates.light_plasma_demolition,
	damage_type = damage_types.laser,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles"
	},
	explosion_area_suppression = {
		suppression_falloff = true,
		instant_aggro = true,
		distance = {
			6,
			14
		},
		suppression_value = {
			5,
			15
		}
	},
	scalable_vfx = {
		{
			radius_variable_name = "radius",
			min_radius = 2.9,
			effects = {
				"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_medium"
			}
		}
	}
}
explosion_templates.plasma_rifle_exit = {
	damage_falloff = true,
	radius = 2.5,
	min_radius = 1.5,
	close_radius = 0.5,
	scalable_radius = true,
	collision_filter = "filter_player_character_explosion",
	static_power_level = 500,
	min_close_radius = 0.1,
	close_damage_profile = DamageProfileTemplates.close_light_plasma_demolition,
	close_damage_type = damage_types.plasma,
	damage_profile = DamageProfileTemplates.light_plasma_demolition,
	damage_type = damage_types.plasma,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles"
	},
	scalable_vfx = {}
}

return {
	base_templates = explosion_templates,
	overrides = overrides
}
