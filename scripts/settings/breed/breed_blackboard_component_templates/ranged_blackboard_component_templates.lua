-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/ranged_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local ranged_base = {
	blocked = {
		is_blocked = "boolean",
	},
	slot = {
		has_ghost_slot = "boolean",
		has_slot = "boolean",
		is_waiting_on_slot = "boolean",
		slot_distance = "number",
		wait_slot_distance = "number",
	},
	behavior = {
		combat_range = "string",
		combat_range_sticky_time = "number",
		enter_combat_range_flag = "boolean",
		lock_combat_range_switch = "boolean",
		move_state = "string",
	},
	suppression = {
		direction = "Vector3Box",
		is_suppressed = "boolean",
		suppress_value = "number",
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
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
}

table.merge(ranged_base, base_template)

local ranged_cover_user = table.clone(ranged_base)

ranged_cover_user.cover = {
	direction = "Vector3Box",
	distance_to_cover = "number",
	has_cover = "boolean",
	is_in_cover = "boolean",
	navmesh_position = "Vector3Box",
	peek_type = "string",
	position = "Vector3Box",
	type = "string",
}

local netgunner = table.clone(ranged_base)

netgunner.behavior = {
	combat_range = "string",
	combat_range_sticky_time = "number",
	enter_combat_range_flag = "boolean",
	hit_target = "boolean",
	is_dragging = "boolean",
	lock_combat_range_switch = "boolean",
	move_state = "string",
	net_is_ready = "boolean",
	shoot_net_cooldown = "number",
}
netgunner.record_state = {
	has_disabled_player = "boolean",
}
netgunner.slot = nil
netgunner.blocked = nil
netgunner.suppression = nil

local cultist_flamer = table.clone(ranged_base)

cultist_flamer.slot = nil
cultist_flamer.blocked = nil
cultist_flamer.suppression = nil
cultist_flamer.statistics = {
	num_attacks_done = "number",
	num_in_liquid = "number",
}

local renegade_flamer = table.clone(cultist_flamer)
local grenadier = table.clone(ranged_base)

grenadier.throw_grenade = {
	anim_event = "string",
	next_throw_at_t = "number",
	throw_direction = "Vector3Box",
	throw_position = "Vector3Box",
	wanted_rotation = "QuaternionBox",
}
grenadier.slot = nil
grenadier.blocked = nil
grenadier.suppression = nil
grenadier.statistics = {
	num_attacks_done = "number",
	num_in_liquid = "number",
}

local sniper = table.clone(ranged_cover_user)

sniper.perception.has_good_last_los_position = "boolean"
sniper.slot = nil
sniper.blocked = nil
sniper.suppression = nil

local riflemen = table.clone(ranged_cover_user)

riflemen.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local ranged_patroller = table.clone(ranged_base)

ranged_patroller.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}

local ranged_patroller_no_suppression = table.clone(ranged_base)

ranged_patroller_no_suppression.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}
ranged_patroller_no_suppression.suppression = nil

local renegade_twin_captain = table.clone(grenadier)

renegade_twin_captain.behavior = {
	combat_range = "string",
	combat_range_sticky_time = "number",
	disappear_idle = "boolean",
	disappear_index = "number",
	enter_combat_range_flag = "boolean",
	has_move_to_position = "boolean",
	lock_combat_range_switch = "boolean",
	move_state = "string",
	move_to_position = "Vector3Box",
	other_twin_unit = "Unit",
	remove_toughness_clamp = "boolean",
	should_disappear = "boolean",
	should_disappear_instant = "boolean",
	toughness_broke = "boolean",
}
renegade_twin_captain.statistics = nil
renegade_twin_captain.nearby_units_broadphase = {
	next_broadphase_t = "number",
	num_units = "number",
}

local renegade_twin_captain_two = table.clone(ranged_base)

renegade_twin_captain_two.behavior = {
	combat_range = "string",
	combat_range_sticky_time = "number",
	disappear_idle = "boolean",
	disappear_index = "number",
	enter_combat_range_flag = "boolean",
	has_move_to_position = "boolean",
	lock_combat_range_switch = "boolean",
	move_state = "string",
	move_to_position = "Vector3Box",
	other_twin_unit = "Unit",
	remove_toughness_clamp = "boolean",
	should_disappear = "boolean",
	should_disappear_instant = "boolean",
	toughness_broke = "boolean",
}
renegade_twin_captain_two.suppression = nil
renegade_twin_captain_two.combat_vector = nil
renegade_twin_captain_two.aim = nil
renegade_twin_captain_two.throw_grenade = {
	anim_event = "string",
	next_throw_at_t = "number",
	throw_direction = "Vector3Box",
	throw_position = "Vector3Box",
	wanted_rotation = "QuaternionBox",
}
renegade_twin_captain.toughness = {
	max_toughness = "number",
	toughness_damage = "number",
	toughness_percent = "number",
}
renegade_twin_captain_two.toughness = {
	max_toughness = "number",
	toughness_damage = "number",
	toughness_percent = "number",
}
renegade_twin_captain_two.nearby_units_broadphase = {
	next_broadphase_t = "number",
	num_units = "number",
}

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
	sniper = sniper,
	renegade_twin_captain = renegade_twin_captain,
	renegade_twin_captain_two = renegade_twin_captain_two,
}

return templates
