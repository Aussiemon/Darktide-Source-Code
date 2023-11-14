local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.stub_revolver_p1_m1 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_stub_pistol_bfg
		}
	},
	collision_tests = {
		{
			against = "statics",
			test = "ray",
			collision_filter = "filter_player_character_shooting_raycast_statics"
		},
		{
			against = "dynamics",
			test = "sphere",
			radius = 0.025,
			collision_filter = "filter_player_character_shooting_raycast_dynamics"
		}
	}
}
hitscan_templates.stub_revolver_p1_m2 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stub_pistol_p1_m2
		}
	},
	collision_tests = {
		{
			against = "statics",
			test = "ray",
			collision_filter = "filter_player_character_shooting_raycast_statics"
		},
		{
			against = "dynamics",
			test = "sphere",
			radius = 0.025,
			collision_filter = "filter_player_character_shooting_raycast_dynamics"
		}
	}
}
hitscan_templates.stub_revolver_p1_m3 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stub_pistol_p1_m3
		}
	},
	collision_tests = {
		{
			against = "statics",
			test = "ray",
			collision_filter = "filter_player_character_shooting_raycast_statics"
		},
		{
			against = "dynamics",
			test = "sphere",
			radius = 0.025,
			collision_filter = "filter_player_character_shooting_raycast_dynamics"
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
