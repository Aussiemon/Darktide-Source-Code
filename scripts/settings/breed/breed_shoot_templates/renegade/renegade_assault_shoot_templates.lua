-- chunkname: @scripts/settings/breed/breed_shoot_templates/renegade/renegade_assault_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_assault_default = {
	collision_filter = "filter_minion_shooting",
	scope_reflection_distance = 3,
	scope_reflection_timing = 0.5,
	scope_reflection_vfx_name = "content/fx/particles/enemies/riflemen_scope_flash",
	shoot_vfx_name = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_enemy",
	hit_scan_template = HitScanTemplates.assaulter_las_burst,
	spread = math.degrees_to_radians(0.25),
	effect_template = EffectTemplates.renegade_assault_lasgun_smg,
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_assault_lasbeam,
	damage_falloff = {
		falloff_range = 7,
		max_power_reduction = 0.5,
		max_range = 7,
	},
}
local shoot_templates = {
	renegade_assault_default = renegade_assault_default,
}

return shoot_templates
