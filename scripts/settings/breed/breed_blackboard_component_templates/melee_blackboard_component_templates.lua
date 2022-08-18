local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local melee_base = {
	behavior = {
		move_state = "string",
		combat_range = "string",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		combat_range_sticky_time = "number"
	},
	suppression = {
		suppress_value = "number",
		direction = "Vector3Box",
		is_suppressed = "boolean"
	},
	slot = {
		has_ghost_slot = "boolean",
		is_waiting_on_slot = "boolean",
		has_slot = "boolean",
		wait_slot_distance = "number",
		slot_distance = "number"
	},
	blocked = {
		is_blocked = "boolean"
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_weapon_slot = "string",
		wanted_combat_range = "string"
	}
}

table.merge(melee_base, base_template)

local melee_shield = table.clone(melee_base)
melee_shield.shield = {
	is_blocking = "boolean"
}
local melee_shield_patroller = table.clone(melee_shield)
melee_shield_patroller.patrol = {
	patrol_leader_unit = "Unit",
	patrol_index = "number",
	should_patrol = "boolean",
	patrol_id = "number",
	walk_position = "Vector3Box",
	auto_patrol = "boolean"
}
local melee_patroller = table.clone(melee_base)
melee_patroller.patrol = {
	patrol_leader_unit = "Unit",
	patrol_index = "number",
	should_patrol = "boolean",
	patrol_id = "number",
	walk_position = "Vector3Box",
	auto_patrol = "boolean"
}
local templates = {
	melee_base = melee_base,
	melee_shield = melee_shield,
	melee_patroller = melee_patroller,
	melee_shield_patroller = melee_shield_patroller
}

return templates
