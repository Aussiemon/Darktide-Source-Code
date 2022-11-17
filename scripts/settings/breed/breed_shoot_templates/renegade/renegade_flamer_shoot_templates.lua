local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local renegade_flamer_default = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.renegade_flamer,
	spread = math.degrees_to_radians(0),
	damage_type = damage_types.fire
}
local shoot_templates = {
	renegade_flamer_default = renegade_flamer_default
}

return shoot_templates
