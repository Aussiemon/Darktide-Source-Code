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
			test = "ray",
			collision_filter = "filter_player_character_shooting_raycast_statics"
		},
		{
			against = "dynamics",
			test = "sphere",
			radius = 0.6,
			collision_filter = "filter_player_character_shooting_raycast_dynamics"
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
