-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_beast_of_nurgle_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_beast_of_nurgle = {
	behavior = {
		melee_aoe_cooldown = "number",
		consumed_unit = "Unit",
		enter_combat_range_flag = "boolean",
		movement_liquid_paint_id = "number",
		combat_range = "string",
		move_state = "string",
		vomit_cooldown = "number",
		vomit_liquid_paint_id = "number",
		wants_to_eat = "boolean",
		wants_to_play_alerted = "boolean",
		combat_range_sticky_time = "number",
		melee_cooldown = "number",
		consume_minion_cooldown = "number",
		force_spit_out = "boolean",
		lock_combat_range_switch = "boolean",
		wants_to_catapult_consumed_unit = "boolean",
		consume_cooldown = "number"
	},
	aim = {
		lean_dot = "number",
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean"
	},
	nearby_units_broadphase = {
		next_broadphase_t = "number",
		num_units = "number"
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

table.merge(chaos_beast_of_nurgle, base_template)

local templates = {
	chaos_beast_of_nurgle = chaos_beast_of_nurgle
}

return templates
