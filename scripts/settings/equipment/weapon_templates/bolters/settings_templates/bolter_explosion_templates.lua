-- chunkname: @scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.bolt_shell_kill = {
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 3,
	scalable_radius = false,
	static_power_level = 500,
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4,
	},
	close_damage_profile = DamageProfileTemplates.bolter_kill_explosion,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.bolter_kill_explosion,
	damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	vfx = {
		"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
	},
}
explosion_templates.bolt_shell_stop = {
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 3,
	scalable_radius = false,
	static_power_level = 500,
	close_damage_profile = DamageProfileTemplates.bolter_stop_explosion,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.bolter_stop_explosion,
	damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4,
	},
	vfx = {
		"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
	},
}
explosion_templates.boltpistol_shell_kill = {
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 3,
	scalable_radius = false,
	static_power_level = 500,
	damage_profile = DamageProfileTemplates.boltpistol_kill_explosion,
	close_damage_profile = DamageProfileTemplates.boltpistol_kill_explosion,
	damage_type = damage_types.boltshell,
	close_damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	vfx = {
		"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
	},
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4,
	},
}
explosion_templates.boltpistol_shell_stop = {
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 3,
	scalable_radius = false,
	static_power_level = 500,
	close_damage_profile = DamageProfileTemplates.boltpistol_stop_explosion,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.boltpistol_stop_explosion,
	damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4,
	},
	vfx = {
		"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
	},
}
explosion_templates.bolt_close_explosion = {
	close_radius = 0.75,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 3,
	scalable_radius = false,
	static_power_level = 500,
	close_damage_profile = DamageProfileTemplates.boltpistol_stop_explosion,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.boltpistol_stop_explosion,
	damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 4,
	},
	vfx = {
		"content/fx/particles/weapons/pistols/boltpistol/boltpistol_impact",
	},
}
explosion_templates.bolt_close_kill_explosion = table.clone(explosion_templates.bolt_close_explosion)
explosion_templates.bolt_close_kill_explosion.close_damage_profile = DamageProfileTemplates.bolter_kill_explosion
explosion_templates.bolt_close_kill_explosion.damage_profile = DamageProfileTemplates.bolter_kill_explosion

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
