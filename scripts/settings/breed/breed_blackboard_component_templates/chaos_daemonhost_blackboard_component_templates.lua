-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_daemonhost_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local chaos_daemonhost = {
	behavior = {
		move_state = "string",
		combat_range = "string",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		combat_range_sticky_time = "number",
		warp_sweep_cooldown = "number"
	},
	slot = {
		has_ghost_slot = "boolean",
		is_waiting_on_slot = "boolean",
		has_slot = "boolean",
		wait_slot_distance = "number",
		slot_distance = "number"
	},
	weapon_switch = {
		is_switching_weapons = "boolean",
		last_weapon_switch_t = "number",
		wanted_weapon_slot = "string",
		wanted_combat_range = "string"
	},
	aim = {
		lean_dot = "number",
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean"
	},
	suppression = {
		suppress_value = "number",
		direction = "Vector3Box",
		is_suppressed = "boolean"
	},
	nearby_units_broadphase = {
		next_broadphase_t = "number",
		num_units = "number"
	},
	statistics = {
		player_deaths = "number"
	}
}

table.merge(chaos_daemonhost, base_template)

local templates = {
	chaos_daemonhost = chaos_daemonhost
}

return templates
