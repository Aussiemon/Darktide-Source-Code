﻿-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/ranged_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local ranged_base = {
	blocked = {
		is_blocked = "boolean"
	},
	slot = {
		has_ghost_slot = "boolean",
		is_waiting_on_slot = "boolean",
		has_slot = "boolean",
		wait_slot_distance = "number",
		slot_distance = "number"
	},
	behavior = {
		combat_range = "string",
		enter_combat_range_flag = "boolean",
		move_state = "string",
		lock_combat_range_switch = "boolean",
		combat_range_sticky_time = "number"
	},
	suppression = {
		suppress_value = "number",
		direction = "Vector3Box",
		is_suppressed = "boolean"
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
	},
	aim = {
		lean_dot = "number",
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean"
	}
}

table.merge(ranged_base, base_template)

local ranged_cover_user = table.clone(ranged_base)

ranged_cover_user.cover = {
	has_cover = "boolean",
	navmesh_position = "Vector3Box",
	direction = "Vector3Box",
	type = "string",
	is_in_cover = "boolean",
	position = "Vector3Box",
	peek_type = "string",
	distance_to_cover = "number"
}

local netgunner = table.clone(ranged_base)

netgunner.behavior = {
	is_dragging = "boolean",
	combat_range_sticky_time = "number",
	move_state = "string",
	enter_combat_range_flag = "boolean",
	combat_range = "string",
	net_is_ready = "boolean",
	shoot_net_cooldown = "number",
	hit_target = "boolean",
	lock_combat_range_switch = "boolean"
}
netgunner.record_state = {
	has_disabled_player = "boolean"
}
netgunner.slot = nil
netgunner.blocked = nil
netgunner.suppression = nil

local cultist_flamer = table.clone(ranged_base)

cultist_flamer.slot = nil
cultist_flamer.blocked = nil
cultist_flamer.suppression = nil

local grenadier = table.clone(ranged_base)

grenadier.throw_grenade = {
	anim_event = "string",
	throw_position = "Vector3Box",
	wanted_rotation = "QuaternionBox",
	throw_direction = "Vector3Box",
	next_throw_at_t = "number"
}
grenadier.slot = nil
grenadier.blocked = nil
grenadier.suppression = nil

local sniper = table.clone(ranged_cover_user)

sniper.perception.has_good_last_los_position = "boolean"
sniper.slot = nil
sniper.blocked = nil
sniper.suppression = nil

local riflemen = table.clone(ranged_cover_user)

riflemen.patrol = {
	patrol_leader_unit = "Unit",
	patrol_index = "number",
	should_patrol = "boolean",
	patrol_id = "number",
	walk_position = "Vector3Box",
	auto_patrol = "boolean"
}

local ranged_patroller = table.clone(ranged_base)

ranged_patroller.patrol = {
	patrol_leader_unit = "Unit",
	patrol_index = "number",
	should_patrol = "boolean",
	patrol_id = "number",
	walk_position = "Vector3Box",
	auto_patrol = "boolean"
}

local ranged_patroller_no_suppression = table.clone(ranged_base)

ranged_patroller_no_suppression.patrol = {
	patrol_leader_unit = "Unit",
	patrol_index = "number",
	should_patrol = "boolean",
	patrol_id = "number",
	walk_position = "Vector3Box",
	auto_patrol = "boolean"
}
ranged_patroller_no_suppression.suppression = nil

local renegade_flamer = table.clone(ranged_patroller)

renegade_flamer.slot = nil
renegade_flamer.blocked = nil
renegade_flamer.suppression = nil

local templates = {
	cultist_flamer = cultist_flamer,
	grenadier = grenadier,
	netgunner = netgunner,
	ranged_base = ranged_base,
	ranged_cover_user = ranged_cover_user,
	ranged_patroller = ranged_patroller,
	renegade_flamer = renegade_flamer,
	ranged_patroller_no_suppression = ranged_patroller_no_suppression,
	riflemen = riflemen,
	sniper = sniper
}

return templates
