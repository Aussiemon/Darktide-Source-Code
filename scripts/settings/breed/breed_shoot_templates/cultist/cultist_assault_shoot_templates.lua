local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local cultist_assault_default = {
	shoot_vfx_name = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_3p",
	scope_reflection_vfx_name = "content/fx/particles/enemies/assault_scope_flash",
	collision_filter = "filter_minion_shooting",
	scope_reflection_timing = 0.4,
	scope_reflection_distance = 3,
	hit_scan_template = HitScanTemplates.assaulter_auto_burst,
	spread = math.degrees_to_radians(0.7),
	effect_template = EffectTemplates.cultist_assault_autogun,
	damage_type = damage_types.minion_auto_bullet,
	line_effect = LineEffects.cultist_autogun_bullet
}
local shoot_templates = {
	cultist_assault_default = cultist_assault_default
}

return shoot_templates
