local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.default_gauntlet_grenade = {
	damage_falloff = true,
	min_radius = 3,
	scalable_radius = true,
	collision_filter = "filter_player_character_explosion",
	static_power_level = 500,
	min_close_radius = 1,
	radius = {
		3,
		6
	},
	close_radius = {
		0.5,
		2.5
	},
	close_damage_profile = DamageProfileTemplates.close_gauntlet_demolitions,
	close_damage_type = damage_types.frag,
	damage_profile = DamageProfileTemplates.default_gauntlet_demolitions,
	damage_type = damage_types.frag,
	explosion_area_suppression = {
		suppression_falloff = true,
		instant_aggro = true,
		distance = 15,
		suppression_value = 20
	},
	scalable_vfx = {
		{
			radius_variable_name = "radius",
			min_radius = 3,
			effects = {
				"content/fx/particles/weapons/rifles/ogryn_gauntlet/ogryn_gauntlet_projectile_explosion_5m"
			}
		}
	},
	sfx = {
		"wwise/events/weapon/play_explosion_grenade_frag",
		"wwise/events/weapon/play_explosion_refl_gen"
	}
}

return {
	base_templates = explosion_templates,
	overrides = overrides
}
