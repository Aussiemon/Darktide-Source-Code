-- chunkname: @scripts/settings/breed/breed_shoot_templates/renegade/renegade_sniper_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_sniper_default = {
	bot_power_level_modifier = 0.5,
	collision_filter = "filter_minion_shooting",
	scope_reflection_vfx_name = "content/fx/particles/enemies/sniper_scope_flash",
	shoot_sound_event = "wwise/events/weapon/play_weapon_longlas_minion",
	shoot_vfx_name = "content/fx/particles/enemies/renegade_sniper/renegade_sniper_muzzle_flash",
	spread = 0,
	hit_scan_template = HitScanTemplates.sniper_bullet,
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_sniper_lasbeam,
	damage_falloff = {
		falloff_range = 20,
		max_power_reduction = 0.5,
		max_range = 60,
	},
}
local shoot_templates = {
	renegade_sniper_default = renegade_sniper_default,
}

return shoot_templates
