-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/melee_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local melee_base = {
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		move_state = "string",
	},
	slot = {
		has_ghost_slot = "boolean",
		has_slot = "boolean",
		is_waiting_on_slot = "boolean",
		slot_distance = "number",
		wait_slot_distance = "number",
	},
	blocked = {
		is_blocked = "boolean",
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_combat_range = "string",
		wanted_weapon_slot = "string",
	},
}

table.merge(melee_base, base_template)

local melee_shield = table.clone(melee_base)

melee_shield.shield = {
	is_blocking = "boolean",
}

local melee_shield_patroller = table.clone(melee_shield)

melee_shield_patroller.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local melee_patroller = table.clone(melee_base)

melee_patroller.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local melee_can_be_suppressed = table.clone(melee_base)

melee_can_be_suppressed.suppression = {
	direction = "Vector3Box",
	is_suppressed = "boolean",
	suppress_value = "number",
}

local melee_patroller_can_be_suppressed = table.clone(melee_base)

melee_patroller_can_be_suppressed.suppression = {
	direction = "Vector3Box",
	is_suppressed = "boolean",
	suppress_value = "number",
}
melee_patroller_can_be_suppressed.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local templates = {
	melee_base = melee_base,
	melee_shield = melee_shield,
	melee_patroller = melee_patroller,
	melee_shield_patroller = melee_shield_patroller,
	melee_can_be_suppressed = melee_can_be_suppressed,
	melee_patroller_can_be_suppressed = melee_patroller_can_be_suppressed,
}

return templates
