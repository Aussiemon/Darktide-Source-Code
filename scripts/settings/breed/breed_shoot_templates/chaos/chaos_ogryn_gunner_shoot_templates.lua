-- chunkname: @scripts/settings/breed/breed_shoot_templates/chaos/chaos_ogryn_gunner_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local chaos_ogryn_gunner = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.chaos_ogryn_gunner_bullet,
	spread = math.degrees_to_radians(1.5),
	effect_template = EffectTemplates.chaos_ogryn_gunner_heavy_stubber,
	damage_type = damage_types.minion_large_caliber,
	line_effect = LineEffects.renegade_heavy_stubber_bullet
}
local shoot_templates = {
	chaos_ogryn_gunner = chaos_ogryn_gunner
}

return shoot_templates
