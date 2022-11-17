local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.bolt_shell_kill = {
	damage_falloff = true,
	radius = 5,
	scalable_radius = false,
	static_power_level = 500,
	collision_filter = "filter_player_character_explosion",
	damage_profile = DamageProfileTemplates.bolter_kill_explosion,
	damage_type = damage_types.boltshell,
	vfx = {
		"content/fx/particles/weapons/rifles/bolter/bolter_burrowed_explode"
	}
}
explosion_templates.bolt_shell_stop = {
	damage_falloff = true,
	radius = 3,
	min_radius = 0.5,
	scalable_radius = false,
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	static_power_level = 500,
	min_close_radius = 0.5,
	close_damage_profile = DamageProfileTemplates.bolter_stop_explosion,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.bolter_stop_explosion,
	damage_type = damage_types.boltshell,
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4
	},
	vfx = {
		"content/fx/particles/weapons/rifles/bolter/bolter_bullet_surface_explode"
	},
	sfx = {
		"wwise/events/weapon/play_bullet_hits_explosive_gen_husk"
	}
}

return {
	base_templates = explosion_templates,
	overrides = overrides
}
