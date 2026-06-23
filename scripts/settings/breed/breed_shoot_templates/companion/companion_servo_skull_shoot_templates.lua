-- chunkname: @scripts/settings/breed/breed_shoot_templates/companion/companion_servo_skull_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local companion_servo_skull_default = {
	collision_filter = "filter_minion_shooting",
	scope_reflection_distance = 10,
	scope_reflection_timing = 0,
	scope_reflection_vfx_name = "content/fx/particles/abilities/cryptic/companion_servo_skull_scope_flash",
	sfx_shooting_effect_template_name = "companion_servo_skull_shooting_effect",
	shoot_vfx_name = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_skull_yellow",
	hit_scan_template = HitScanTemplates.companion_servo_skull_single_shot,
	spread = math.degrees_to_radians(0.5),
	damage_type = damage_types.minion_laser_yellow,
	line_effect = LineEffects.servo_skull_lasbeam,
	damage_falloff = {
		falloff_range = 15,
		max_power_reduction = 0.6,
		max_range = 15,
	},
}
local companion_servo_skull_improved = {
	collision_filter = "filter_minion_shooting",
	scope_reflection_distance = 10,
	scope_reflection_timing = 0,
	scope_reflection_vfx_name = "content/fx/particles/abilities/cryptic/companion_servo_skull_scope_flash",
	sfx_shooting_effect_template_name = "companion_servo_skull_shooting_effect",
	shoot_vfx_name = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_skull_yellow",
	hit_scan_template = HitScanTemplates.companion_servo_skull_single_shot_improved,
	spread = math.degrees_to_radians(0.5),
	damage_type = damage_types.minion_laser_yellow,
	line_effect = LineEffects.servo_skull_lasbeam,
	damage_falloff = {
		falloff_range = 15,
		max_power_reduction = 0.6,
		max_range = 15,
	},
}
local shoot_templates = {
	companion_servo_skull_default = companion_servo_skull_default,
	companion_servo_skull_improved = companion_servo_skull_improved,
}

return shoot_templates
