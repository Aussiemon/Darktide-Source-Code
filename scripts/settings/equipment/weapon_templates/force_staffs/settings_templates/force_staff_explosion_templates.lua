-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.default_force_staff_demolition = {
	charge_wwise_parameter_name = "charge_level",
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 1.5,
	scalable_radius = true,
	static_power_level = 500,
	radius = {
		2,
		10,
	},
	min_radius = {
		2,
		4,
	},
	close_radius = {
		1,
		3,
	},
	close_damage_profile = DamageProfileTemplates.close_force_staff_demolition,
	close_damage_type = damage_types.force_staff_explosion,
	damage_profile = DamageProfileTemplates.default_force_staff_demolition,
	damage_type = damage_types.force_staff_explosion,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	scalable_vfx = {
		{
			min_radius = 0.5,
			radius_variable_name = "radius",
			effects = {
				"content/fx/particles/weapons/force_staff/force_staff_explosion",
			},
		},
	},
	sfx = {
		{
			event_name = "wwise/events/weapon/play_explosion_force_med",
			has_husk_events = true,
		},
	},
}
explosion_templates.force_staff_p4_demolition = {
	charge_wwise_parameter_name = "charge_level",
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 1.5,
	scalable_radius = true,
	static_power_level = 500,
	radius = {
		2,
		4,
	},
	min_radius = {
		1.75,
		2,
	},
	close_radius = {
		1,
		1.5,
	},
	close_damage_profile = DamageProfileTemplates.close_force_staff_p4_demolition,
	close_damage_type = damage_types.force_staff_bfg,
	damage_profile = DamageProfileTemplates.force_staff_p4_demolition,
	damage_type = damage_types.force_staff_bfg,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	scalable_vfx = {
		{
			min_radius = 0.5,
			radius_variable_name = "radius",
			effects = {
				"content/fx/particles/weapons/force_staff/force_staff_explosion",
			},
		},
	},
	sfx = {
		{
			event_name = "wwise/events/weapon/play_explosion_force_med",
			has_husk_events = true,
		},
	},
}
explosion_templates.default_force_staff_assault = {
	collision_filter = "filter_player_character_explosion",
	radius = 1.5,
	static_power_level = 200,
	close_damage_profile = DamageProfileTemplates.psyker_smite_heavy,
	close_damage_type = damage_types.force_staff_explosion,
	damage_profile = DamageProfileTemplates.psyker_smite_heavy,
	damage_type = damage_types.force_staff_explosion,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	vfx = {
		"content/fx/particles/abilities/psyker_smite_projectile_impact_01",
	},
	sfx = {
		"wwise/events/weapon/play_explosion_force_med",
	},
}

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
