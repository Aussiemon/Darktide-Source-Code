-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.default_gauntlet_grenade = {
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 1,
	min_radius = 3,
	scalable_radius = true,
	static_power_level = 500,
	radius = {
		3,
		6,
	},
	close_radius = {
		0.5,
		1.75,
	},
	close_damage_profile = DamageProfileTemplates.close_gauntlet_demolitions,
	close_damage_type = damage_types.grenade_frag,
	damage_profile = DamageProfileTemplates.default_gauntlet_demolitions,
	damage_type = damage_types.grenade_frag,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	explosion_area_suppression = {
		distance = 15,
		instant_aggro = true,
		suppression_falloff = true,
		suppression_value = 20,
	},
	scalable_vfx = {
		{
			min_radius = 2.5,
			radius_variable_name = "radius",
			effects = {
				"content/fx/particles/weapons/rifles/ogryn_gauntlet/ogryn_gauntlet_projectile_explosion_5m",
			},
		},
	},
	sfx = {
		"wwise/events/weapon/play_explosion_grenade_frag",
		"wwise/events/weapon/play_explosion_refl_gen",
	},
}
explosion_templates.special_gauntlet_grenade = {
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 1,
	min_radius = 3,
	scalable_radius = true,
	static_power_level = 500,
	weapon_special = true,
	radius = {
		2.5,
		5,
	},
	close_radius = {
		1.5,
		2,
	},
	close_damage_profile = DamageProfileTemplates.close_special_gauntlet_demolitions,
	close_damage_type = damage_types.grenade_frag,
	damage_profile = DamageProfileTemplates.default_gauntlet_demolitions,
	damage_type = damage_types.grenade_frag,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	explosion_area_suppression = {
		distance = 15,
		instant_aggro = true,
		suppression_falloff = true,
		suppression_value = 20,
	},
	scalable_vfx = {
		{
			min_radius = 2.4,
			radius_variable_name = "radius",
			effects = {
				"content/fx/particles/weapons/rifles/ogryn_gauntlet/ogryn_gauntlet_projectile_explosion_5m",
			},
		},
	},
	sfx = {
		"wwise/events/weapon/play_explosion_grenade_frag",
		"wwise/events/weapon/play_explosion_refl_gen",
	},
}

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
