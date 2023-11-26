-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/monster_blackboard_component_templates.lua

local BaseBlackboardComponentTemplate = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local monster = {
	behavior = {
		move_state = "string"
	},
	slot = {
		has_ghost_slot = "boolean",
		is_waiting_on_slot = "boolean",
		has_slot = "boolean",
		wait_slot_distance = "number",
		slot_distance = "number"
	}
}

table.merge(monster, BaseBlackboardComponentTemplate)

local chaos_spawn = table.clone(monster)

chaos_spawn.behavior = {
	wants_to_catapult_grabbed_unit = "boolean",
	grabbed_unit = "Unit",
	move_state = "string",
	grab_cooldown = "number",
	should_leap = "boolean"
}

local templates = {
	monster = monster,
	chaos_spawn = chaos_spawn
}

return templates
