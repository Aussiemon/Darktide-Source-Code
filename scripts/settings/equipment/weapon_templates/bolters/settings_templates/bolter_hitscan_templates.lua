-- chunkname: @scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_bolter_boltshell = {
	range = 100,
	damage = {
		explosion_arming_distance = 5,
		impact = {
			damage_profile = DamageProfileTemplates.default_bolter_killshot,
			hitmass_consumed_explosion = {
				kill_explosion_template = ExplosionTemplates.bolt_shell_kill,
				stop_explosion_template = ExplosionTemplates.bolt_shell_stop,
			},
		},
		penetration = {
			depth = 0.75,
			target_index_increase = 2,
			stop_explosion_template = ExplosionTemplates.bolt_shell_stop,
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
hitscan_templates.bolter_m2_boltshell = {
	range = 100,
	damage = {
		explosion_arming_distance = 3,
		impact = {
			damage_profile = DamageProfileTemplates.bolter_m2_killshot,
			hitmass_consumed_explosion = {
				kill_explosion_template = ExplosionTemplates.bolt_shell_kill_m2,
				stop_explosion_template = ExplosionTemplates.bolt_shell_stop_m2,
			},
		},
		penetration = {
			depth = 0.1,
			target_index_increase = 2,
			stop_explosion_template = ExplosionTemplates.bolt_shell_stop_m2,
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
