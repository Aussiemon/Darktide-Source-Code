﻿-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.stub_revolver_p1_m1 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_stub_pistol_bfg,
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
hitscan_templates.stub_revolver_p1_m2 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stub_pistol_p1_m2,
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
			radius = 0.05,
			test = "sphere",
		},
	},
}
hitscan_templates.stub_revolver_p1_m2_hip = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stub_pistol_p1_m2,
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
hitscan_templates.stub_revolver_p1_m3 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stub_pistol_p1_m3,
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
