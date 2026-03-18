-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/valkyrie_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local attack_valkyrie = {
	behavior = {
		move_medium = "string",
		move_state = "string",
	},
	rendezvous = {
		has_randezvous_position = "bool",
		rendezvous_position = "Vector3Box",
		rendezvous_reference = "Vector3Box",
	},
	strafe = {
		last_update_strafe_t = "number",
		strafe_delay = "number",
		strafe_timer_started_t = "number",
	},
	flee = {
		flee_position = "Vector3Box",
		wants_flee = "bool",
	},
}

table.merge(attack_valkyrie, base_template)

local templates = {
	attack_valkyrie = attack_valkyrie,
}

return templates
