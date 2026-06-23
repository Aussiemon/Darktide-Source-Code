-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/settings_templates/arc_rifle_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.arc_rifle_p1_m1_hitscan = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.arc_rifle_p1_m1_damage,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}
hitscan_templates.arc_rifle_p1_m1_hitscan_braced = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.arc_rifle_p1_m1_damage_braced,
		},
	},
	collision_tests = {
		{
			against = "statics",
			collision_filter = "filter_player_character_shooting_raycast_statics",
			test = "ray",
		},
		{
			against = "dynamics",
			collision_filter = "filter_player_character_shooting_raycast_dynamics",
			radius = 0.1,
			test = "sphere",
		},
	},
}

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
