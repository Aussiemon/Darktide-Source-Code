-- chunkname: @scripts/settings/breed/breed_shoot_templates/chaos/chaos_beast_of_nurgle_shoot_templates.lua

local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local chaos_beast_of_nurgle_default = {
	collision_filter = "filter_minion_shooting",
	hit_scan_template = HitScanTemplates.chaos_beast_of_nurgle_vomit,
	spread = math.degrees_to_radians(0),
	damage_type = damage_types.minion_vomit
}
local shoot_templates = {
	chaos_beast_of_nurgle_default = chaos_beast_of_nurgle_default
}

return shoot_templates
