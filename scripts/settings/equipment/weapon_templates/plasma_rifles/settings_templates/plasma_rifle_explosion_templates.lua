-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.plasma_rifle = {
	close_radius = 1.25,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 1.15,
	min_radius = 2,
	radius = 3,
	scalable_radius = true,
	static_power_level = 500,
	close_damage_profile = DamageProfileTemplates.default_plasma_demolition,
	close_damage_type = damage_types.laser,
	damage_profile = DamageProfileTemplates.light_plasma_demolition,
	damage_type = damage_types.laser,
	explosion_area_suppression = {
		instant_aggro = true,
		suppression_falloff = true,
		distance = {
			6,
			14,
		},
		suppression_value = {
			5,
			15,
		},
	},
	scalable_vfx = {
		{
			min_radius = 2.9,
			radius_variable_name = "radius",
			effects = {
				"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_medium",
			},
		},
	},
}
explosion_templates.plasma_rifle_exit = {
	close_radius = 0.5,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.1,
	min_radius = 1.5,
	radius = 2.5,
	scalable_radius = true,
	static_power_level = 500,
	close_damage_profile = DamageProfileTemplates.close_light_plasma_demolition,
	close_damage_type = damage_types.plasma,
	damage_profile = DamageProfileTemplates.light_plasma_demolition,
	damage_type = damage_types.plasma,
	scalable_vfx = {},
}

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
