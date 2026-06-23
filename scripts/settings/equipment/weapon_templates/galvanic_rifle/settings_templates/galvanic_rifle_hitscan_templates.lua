-- chunkname: @scripts/settings/equipment/weapon_templates/galvanic_rifle/settings_templates/galvanic_rifle_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_galvanic_rifle_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autogun_assault,
		},
	},
}
hitscan_templates.galvanic_rifle_p1_m1_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.galvanic_rifle_p1_m1,
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
			radius = 0.02,
			test = "sphere",
		},
	},
}

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
