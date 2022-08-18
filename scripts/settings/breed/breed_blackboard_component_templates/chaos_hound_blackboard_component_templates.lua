local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_hound = {
	behavior = {
		move_state = "string",
		combat_range = "string",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		combat_range_sticky_time = "number"
	},
	aim = {
		lean_dot = "number",
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean"
	},
	pounce = {
		pounce_cooldown = "number",
		started_leap = "boolean",
		pounce_target = "Unit"
	},
	combat_vector = {
		has_position = "boolean",
		position = "Vector3Box",
		distance = "number",
		combat_vector_is_closer = "boolean"
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_weapon_slot = "string",
		wanted_combat_range = "string"
	}
}

table.merge(chaos_hound, base_template)

local templates = {
	chaos_hound = chaos_hound
}

return templates
