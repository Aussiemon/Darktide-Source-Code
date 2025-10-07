-- chunkname: @scripts/settings/breed/breed_shoot_templates/renegade/renegade_plasma_gunner_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_plasma_gunner_default = {
	collision_filter = "filter_minion_shooting",
	scope_reflection_distance = 3,
	scope_reflection_timing = 1,
	scope_reflection_vfx_name = "content/fx/particles/enemies/assault_scope_flash",
	shoot_sound_event = "wwise/events/weapon/play_weapon_shotgun_chaos",
	shoot_vfx_name = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
	shotgun_blast = true,
	hit_scan_template = HitScanTemplates.shocktrooper_shotgun_bullet,
	spread = math.degrees_to_radians(1),
	damage_type = damage_types.minion_pellet,
	line_effect = LineEffects.renegade_pellet,
	damage_falloff = {
		falloff_range = 15,
		max_power_reduction = 0.6,
		max_range = 8,
	},
}
local renegade_plasma_gunner_plasma_beam = {
	collision_filter = "filter_minion_shooting",
	shoot_sound_event = "wwise/events/weapon/play_minion_plasmapistol",
	shoot_vfx_name = "content/fx/particles/enemies/renegade_plasma_trooper/renegade_plasma_muzzle",
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_captain_plasma_beam,
	hit_scan_template = HitScanTemplates.renegade_plasma_gunner,
	spread = math.degrees_to_radians(0.1),
	damage_falloff = {
		falloff_range = 18,
		max_power_reduction = 0.6,
		max_range = 18,
	},
}
local shoot_templates = {
	renegade_plasma_gunner_default = renegade_plasma_gunner_default,
	renegade_plasma_gunner_plasma_beam = renegade_plasma_gunner_plasma_beam,
}

return shoot_templates
