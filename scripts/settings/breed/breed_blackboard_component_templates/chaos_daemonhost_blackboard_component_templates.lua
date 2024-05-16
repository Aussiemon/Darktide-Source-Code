-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_daemonhost_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_daemonhost = {
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		move_state = "string",
		warp_sweep_cooldown = "number",
	},
	slot = {
		has_ghost_slot = "boolean",
		has_slot = "boolean",
		is_waiting_on_slot = "boolean",
		slot_distance = "number",
		wait_slot_distance = "number",
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_combat_range = "string",
		wanted_weapon_slot = "string",
	},
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
	suppression = {
		direction = "Vector3Box",
		is_suppressed = "boolean",
		suppress_value = "number",
	},
	nearby_units_broadphase = {
		next_broadphase_t = "number",
		num_units = "number",
	},
	statistics = {
		player_deaths = "number",
	},
}

table.merge(chaos_daemonhost, base_template)

local templates = {
	chaos_daemonhost = chaos_daemonhost,
}

return templates
