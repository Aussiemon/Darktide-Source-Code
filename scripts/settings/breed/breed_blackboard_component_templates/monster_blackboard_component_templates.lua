-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/monster_blackboard_component_templates.lua

local BaseBlackboardComponentTemplate = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local monster = {
	behavior = {
		move_state = "string",
	},
	slot = {
		has_ghost_slot = "boolean",
		has_slot = "boolean",
		is_waiting_on_slot = "boolean",
		slot_distance = "number",
		wait_slot_distance = "number",
	},
}

table.merge(monster, BaseBlackboardComponentTemplate)

local chaos_spawn = table.clone(monster)

chaos_spawn.behavior = {
	grab_cooldown = "number",
	grabbed_unit = "Unit",
	move_state = "string",
	should_leap = "boolean",
	wants_to_catapult_grabbed_unit = "boolean",
}
chaos_spawn.statistics = {
	num_grabs_done = "number",
}
chaos_spawn.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local templates = {
	monster = monster,
	chaos_spawn = chaos_spawn,
}

return templates
