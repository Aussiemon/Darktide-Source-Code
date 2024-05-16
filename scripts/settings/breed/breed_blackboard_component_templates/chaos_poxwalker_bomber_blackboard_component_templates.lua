-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_poxwalker_bomber_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_poxwalker_bomber = {
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		move_state = "string",
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_combat_range = "string",
		wanted_weapon_slot = "string",
	},
}

table.merge(chaos_poxwalker_bomber, base_template)

chaos_poxwalker_bomber.death = {
	attack_direction = "Vector3Box",
	damage_profile_name = "string",
	force_instant_ragdoll = "boolean",
	fuse_timer = "number",
	herding_template_name = "string",
	hit_during_death = "boolean",
	hit_zone_name = "string",
	is_dead = "boolean",
	killing_damage_type = "string",
	staggered_during_lunge = "boolean",
}

local templates = {
	chaos_poxwalker_bomber = chaos_poxwalker_bomber,
}

return templates
