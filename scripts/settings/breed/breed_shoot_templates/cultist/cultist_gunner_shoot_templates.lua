local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local damage_types = DamageSettings.damage_types
local cultist_gunner_default = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.gunner_bullet_sweep,
	spread = math.degrees_to_radians(1.5),
	effect_template = EffectTemplates.cultist_gunner_stubber,
	damage_type = damage_types.minion_auto_bullet,
	line_effect = LineEffects.cultist_autogun_bullet
}
local cultist_gunner_sweep = table.clone(cultist_gunner_default)
cultist_gunner_sweep.hit_scan_template = HitScanTemplates.gunner_bullet
cultist_gunner_sweep.spread = math.degrees_to_radians(1.5)
local cultist_gunner_aimed = table.clone(cultist_gunner_default)
cultist_gunner_aimed.hit_scan_template = HitScanTemplates.gunner_bullet
cultist_gunner_aimed.spread = math.degrees_to_radians(1.75)
local cultist_gunner_shoot_close = table.clone(cultist_gunner_default)
cultist_gunner_shoot_close.hit_scan_template = HitScanTemplates.gunner_bullet
cultist_gunner_shoot_close.spread = math.degrees_to_radians(2)
local cultist_gunner_shoot_spray_n_pray = table.clone(cultist_gunner_default)
cultist_gunner_shoot_spray_n_pray.hit_scan_template = HitScanTemplates.gunner_spray_n_pray
cultist_gunner_shoot_spray_n_pray.spread = math.degrees_to_radians(3)
local shoot_templates = {
	cultist_gunner_default = cultist_gunner_default,
	cultist_gunner_sweep = cultist_gunner_sweep,
	cultist_gunner_aimed = cultist_gunner_aimed,
	cultist_gunner_shoot_close = cultist_gunner_shoot_close,
	cultist_gunner_shoot_spray_n_pray = cultist_gunner_shoot_spray_n_pray
}

return shoot_templates
