-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_beast_of_nurgle_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_beast_of_nurgle = {
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		consume_cooldown = "number",
		consume_minion_cooldown = "number",
		consumed_unit = "Unit",
		enter_combat_range_flag = "boolean",
		force_spit_out = "boolean",
		lock_combat_range_switch = "boolean",
		melee_aoe_cooldown = "number",
		melee_cooldown = "number",
		move_state = "string",
		movement_liquid_paint_id = "number",
		vomit_cooldown = "number",
		vomit_liquid_paint_id = "number",
		wants_to_catapult_consumed_unit = "boolean",
		wants_to_eat = "boolean",
		wants_to_play_alerted = "boolean",
	},
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
	nearby_units_broadphase = {
		next_broadphase_t = "number",
		num_units = "number",
	},
	combat_vector = {
		combat_vector_is_closer = "boolean",
		distance = "number",
		has_position = "boolean",
		position = "Vector3Box",
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_combat_range = "string",
		wanted_weapon_slot = "string",
	},
	statistics = {
		num_attacks_done = "number",
		num_in_liquid = "number",
	},
}

table.merge(chaos_beast_of_nurgle, base_template)

local templates = {
	chaos_beast_of_nurgle = chaos_beast_of_nurgle,
}

return templates
