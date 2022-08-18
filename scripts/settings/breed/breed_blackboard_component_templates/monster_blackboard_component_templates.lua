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

local templates = {
	monster = monster
}

return templates
