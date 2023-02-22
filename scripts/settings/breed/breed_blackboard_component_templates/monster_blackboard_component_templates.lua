local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
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

table.merge(monster, base_template)

local chaos_spawn = table.clone(monster)
chaos_spawn.behavior = {
	wants_to_catapult_grabbed_unit = "boolean",
	move_state = "string",
	grabbed_unit = "Unit",
	grab_cooldown = "number",
	leap_velocity = "Vector3Box",
	should_leap = "boolean"
}
local templates = {
	monster = monster,
	chaos_spawn = chaos_spawn
}

return templates
