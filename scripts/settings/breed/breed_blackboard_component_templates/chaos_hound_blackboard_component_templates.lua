-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_hound_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_hound = {
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		move_state = "string",
	},
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
	pounce = {
		pounce_cooldown = "number",
		pounce_target = "Unit",
		started_leap = "boolean",
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
	record_state = {
		has_disabled_player = "boolean",
	},
	summon_unit = {
		last_owner_position = "Vector3Box",
		owner = "Unit",
	},
}

table.merge(chaos_hound, base_template)

local templates = {
	chaos_hound = chaos_hound,
}

return templates
