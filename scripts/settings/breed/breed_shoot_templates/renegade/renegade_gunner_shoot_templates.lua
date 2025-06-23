-- chunkname: @scripts/settings/breed/breed_shoot_templates/renegade/renegade_gunner_shoot_templates.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local renegade_gunner_default = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.gunner_bullet_sweep,
	spread = math.degrees_to_radians(1.5),
	effect_template = EffectTemplates.renegade_gunner_hellgun,
	damage_type = damage_types.minion_laser,
	line_effect = LineEffects.renegade_gunner_lasbeam,
	damage_falloff = {
		falloff_range = 35,
		max_range = 35,
		max_power_reduction = 0.5
	}
}
local renegade_gunner_sweep = table.clone(renegade_gunner_default)

renegade_gunner_sweep.hit_scan_template = HitScanTemplates.gunner_bullet
renegade_gunner_sweep.spread = math.degrees_to_radians(1.5)

local renegade_gunner_aimed = table.clone(renegade_gunner_default)

renegade_gunner_aimed.hit_scan_template = HitScanTemplates.gunner_bullet
renegade_gunner_aimed.spread = math.degrees_to_radians(0.25)

local renegade_gunner_shoot_close = table.clone(renegade_gunner_default)

renegade_gunner_shoot_close.hit_scan_template = HitScanTemplates.gunner_bullet
renegade_gunner_shoot_close.spread = math.degrees_to_radians(2)

local renegade_gunner_shoot_spray_n_pray = table.clone(renegade_gunner_default)

renegade_gunner_shoot_spray_n_pray.hit_scan_template = HitScanTemplates.gunner_spray_n_pray
renegade_gunner_shoot_spray_n_pray.spread = math.degrees_to_radians(0.5)

local shoot_templates = {
	renegade_gunner_default = renegade_gunner_default,
	renegade_gunner_sweep = renegade_gunner_sweep,
	renegade_gunner_aimed = renegade_gunner_aimed,
	renegade_gunner_shoot_close = renegade_gunner_shoot_close,
	renegade_gunner_shoot_spray_n_pray = renegade_gunner_shoot_spray_n_pray
}

return shoot_templates
