-- chunkname: @scripts/settings/breed/breed_shoot_templates/cultist/cultist_flamer_shoot_templates.lua

local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local cultist_flamer_default = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.cultist_flamer,
	spread = math.degrees_to_radians(0),
	damage_type = damage_types.minion_direct_flamer
}
local shoot_templates = {
	cultist_flamer_default = cultist_flamer_default
}

return shoot_templates
