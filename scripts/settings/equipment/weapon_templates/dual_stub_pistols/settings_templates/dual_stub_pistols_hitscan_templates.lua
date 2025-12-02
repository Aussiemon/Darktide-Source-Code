-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.dual_stub_pistols_base = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.dual_stub_pistols_base,
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
			radius = 0.055,
			test = "sphere",
		},
	},
}
hitscan_templates.dual_stub_pistols_special = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.dual_stub_pistols_special,
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
