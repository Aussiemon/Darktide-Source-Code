local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_rifleman_default = {
	shoot_vfx_name = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_enemy",
	shoot_sound_event = "wwise/events/weapon/play_weapon_lasgun_chaos",
	scope_reflection_vfx_name = "content/fx/particles/enemies/riflemen_scope_flash",
	collision_filter = "filter_minion_shooting",
	scope_reflection_timing = 0.4,
	scope_reflection_distance = 10,
	hit_scan_template = HitScanTemplates.renegade_rifleman_single_shot,
	spread = math.degrees_to_radians(0.5),
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_lasbeam,
	damage_falloff = {
		falloff_range = 20,
		max_range = 20,
		max_power_reduction = 0.5
	}
}
local shoot_templates = {
	renegade_rifleman_default = renegade_rifleman_default
}

return shoot_templates
