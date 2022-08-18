local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_sniper_default = {
	shoot_vfx_name = "content/fx/particles/enemies/renegade_sniper/renegade_sniper_muzzle_flash",
	shoot_sound_event = "wwise/events/weapon/play_weapon_longlas_minion",
	scope_reflection_vfx_name = "content/fx/particles/enemies/sniper_scope_flash",
	spread = 0,
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.sniper_bullet,
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_sniper_lasbeam
}
local shoot_templates = {
	renegade_sniper_default = renegade_sniper_default
}

return shoot_templates
