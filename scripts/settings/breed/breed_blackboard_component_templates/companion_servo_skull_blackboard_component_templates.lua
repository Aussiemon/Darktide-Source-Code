-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/companion_servo_skull_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local companion_servo_skull = {
	behavior = {
		can_shoot = "boolean",
		current_state = "string",
		has_move_to_position = "boolean",
		has_target_rotation = "boolean",
		is_out_of_bound = "boolean",
		max_speed = "number",
		move_state = "string",
		move_to_position = "Vector3Box",
		owner_unit = "Unit",
		target_rotation = "QuaternionBox",
		target_unit = "Unit",
	},
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
	whistle = {
		current_hack_target = "Unit",
		current_target = "Unit",
	},
}

table.merge(companion_servo_skull, base_template)

companion_servo_skull.stagger = nil
companion_servo_skull.death = nil
companion_servo_skull.nav_smart_object = nil

local templates = {
	companion_servo_skull = companion_servo_skull,
}

return templates
