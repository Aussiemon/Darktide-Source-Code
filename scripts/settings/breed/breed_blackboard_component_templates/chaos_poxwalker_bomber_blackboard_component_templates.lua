-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_poxwalker_bomber_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_poxwalker_bomber = {
	behavior = {
		move_state = "string",
		combat_range = "string",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		combat_range_sticky_time = "number"
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_weapon_slot = "string",
		wanted_combat_range = "string"
	}
}

table.merge(chaos_poxwalker_bomber, base_template)

chaos_poxwalker_bomber.death = {
	fuse_timer = "number",
	force_instant_ragdoll = "boolean",
	damage_profile_name = "string",
	herding_template_name = "string",
	is_dead = "boolean",
	hit_during_death = "boolean",
	hit_zone_name = "string",
	staggered_during_lunge = "boolean",
	killing_damage_type = "string",
	attack_direction = "Vector3Box"
}

local templates = {
	chaos_poxwalker_bomber = chaos_poxwalker_bomber
}

return templates
