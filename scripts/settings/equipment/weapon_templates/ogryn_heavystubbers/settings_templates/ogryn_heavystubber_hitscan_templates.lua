-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_ogryn_heavystubber_full_auto = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_heavystubber_assault_snp
		}
	}
}
hitscan_templates.default_ogryn_heavystubber_full_auto_m2 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_heavystubber_assault_snp_m2
		}
	}
}
hitscan_templates.default_ogryn_heavystubber_full_auto_m3 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_heavystubber_assault_snp_m3
		}
	}
}

local ogryn_heavy_stubber_p2_collision_tests = {
	{
		against = "statics",
		test = "ray",
		collision_filter = "filter_player_character_shooting_raycast_statics"
	},
	{
		against = "dynamics",
		test = "sphere",
		radius = 0.05,
		collision_filter = "filter_player_character_shooting_raycast_dynamics"
	}
}

hitscan_templates.ogryn_heavystubber_p2_m1 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.ogryn_heavystubber_damage_p2_m1
		}
	}
}
hitscan_templates.ogryn_heavystubber_p2_m1_braced = table.clone(hitscan_templates.ogryn_heavystubber_p2_m1)
hitscan_templates.ogryn_heavystubber_p2_m1_braced.collision_tests = ogryn_heavy_stubber_p2_collision_tests
hitscan_templates.ogryn_heavystubber_p2_m2 = table.clone(hitscan_templates.ogryn_heavystubber_p2_m1)
hitscan_templates.ogryn_heavystubber_p2_m2.damage.impact.damage_profile = DamageProfileTemplates.ogryn_heavystubber_damage_p2_m2
hitscan_templates.ogryn_heavystubber_p2_m2.damage.penetration = {
	target_index_increase = 3,
	depth = 0.75
}
hitscan_templates.ogryn_heavystubber_p2_m2_braced = table.clone(hitscan_templates.ogryn_heavystubber_p2_m2)
hitscan_templates.ogryn_heavystubber_p2_m2_braced.collision_tests = ogryn_heavy_stubber_p2_collision_tests
hitscan_templates.ogryn_heavystubber_p2_m3 = table.clone(hitscan_templates.ogryn_heavystubber_p2_m2)
hitscan_templates.ogryn_heavystubber_p2_m3.damage.impact.damage_profile = DamageProfileTemplates.ogryn_heavystubber_damage_p2_m3
hitscan_templates.ogryn_heavystubber_p2_m3_braced = table.clone(hitscan_templates.ogryn_heavystubber_p2_m3)
hitscan_templates.ogryn_heavystubber_p2_m3_braced.collision_tests = ogryn_heavy_stubber_p2_collision_tests

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
