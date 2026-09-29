-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.ogryn_thumper_p1_m3_bfg = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m3_bfg
		}
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray"
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.25,
			test = "sphere"
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
