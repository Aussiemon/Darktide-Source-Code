-- chunkname: @scripts/settings/breed/breed_shoot_templates/cultist/cultist_assault_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local cultist_assault_default = {
	collision_filter = "filter_minion_shooting",
	effect_template_name = "cultist_assault_autogun",
	scope_reflection_distance = 3,
	scope_reflection_timing = 0.4,
	scope_reflection_vfx_name = "content/fx/particles/enemies/assault_scope_flash",
	shoot_vfx_name = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_3p",
	hit_scan_template = HitScanTemplates.assaulter_auto_burst,
	spread = math.degrees_to_radians(0.7),
	damage_type = damage_types.minion_auto_bullet,
	line_effect = LineEffects.cultist_autogun_bullet,
}
local shoot_templates = {
	cultist_assault_default = cultist_assault_default,
}

return shoot_templates
