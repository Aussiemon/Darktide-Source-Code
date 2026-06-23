-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.phosphor_pistol_p1_m1_hitscan = {
	range = 75,
	damage = {
		explosion_arming_distance = 0,
		impact = {
			explode_on_minion_hit = true,
			explode_once = true,
			damage_profile = DamageProfileTemplates.phosphor_pistol_m1_m1_dmg,
			explosion_template = ExplosionTemplates.phosphor_pistol_backblast,
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
			radius = 0.075,
			test = "sphere",
		},
	},
}
hitscan_templates.phosphor_pistol_p1_m2_hitscan = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.phosphor_pistol_m1_m1_dmg,
		},
	},
}

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
