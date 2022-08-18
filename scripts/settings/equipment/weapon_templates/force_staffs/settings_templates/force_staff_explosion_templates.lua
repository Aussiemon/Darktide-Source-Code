local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.default_force_staff_demolition = {
	damage_falloff = true,
	scalable_radius = true,
	static_power_level = 500,
	collision_filter = "filter_player_character_explosion",
	charge_wwise_parameter_name = "charge_level",
	min_close_radius = 1.5,
	radius = {
		2,
		10
	},
	min = {
		2,
		4
	},
	close_radius = {
		1,
		3
	},
	close_damage_profile = DamageProfileTemplates.close_force_staff_demolition,
	close_damage_type = damage_types.force_staff_single_target,
	damage_profile = DamageProfileTemplates.default_force_staff_demolition,
	damage_type = damage_types.force_staff_single_target,
	scalable_vfx = {
		{
			radius_variable_name = "radius",
			min_radius = 0.5,
			effects = {
				"content/fx/particles/weapons/force_staff/force_staff_explosion"
			}
		}
	},
	sfx = {
		{
			event_name = "wwise/events/weapon/play_explosion_force_med",
			has_husk_events = true
		}
	}
}
explosion_templates.default_force_staff_assault = {
	static_power_level = 200,
	radius = 1.5,
	collision_filter = "filter_player_character_explosion",
	close_damage_profile = DamageProfileTemplates.psyker_smite_heavy,
	close_damage_type = damage_types.force_staff_single_target,
	damage_profile = DamageProfileTemplates.psyker_smite_heavy,
	damage_type = damage_types.force_staff_single_target,
	vfx = {
		"content/fx/particles/abilities/psyker_smite_projectile_impact_01"
	},
	sfx = {
		"wwise/events/weapon/play_explosion_force_med"
	}
}

return {
	base_templates = explosion_templates,
	overrides = overrides
}
