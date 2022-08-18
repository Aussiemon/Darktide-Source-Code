local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_shocktrooper_default = {
	shoot_vfx_name = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
	shoot_sound_event = "wwise/events/weapon/play_weapon_shotgun_chaos",
	scope_reflection_vfx_name = "content/fx/particles/enemies/assault_scope_flash",
	collision_filter = "filter_minion_shooting",
	scope_reflection_timing = 1,
	scope_reflection_distance = 3,
	hit_scan_template = HitScanTemplates.shocktrooper_shotgun_bullet,
	spread = math.degrees_to_radians(2),
	damage_type = damage_types.minion_pellet,
	line_effect = LineEffects.renegade_pellet
}
local shoot_templates = {
	renegade_shocktrooper_default = renegade_shocktrooper_default
}

return shoot_templates
