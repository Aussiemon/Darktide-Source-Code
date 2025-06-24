-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_hub_interaction_with_player_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtCompanionHubInteractionWithPlayerAction = class("BtCompanionHubInteractionWithPlayerAction", "BtNode")

BtCompanionHubInteractionWithPlayerAction.TIME_TO_FIRST_EVALUATE = {
	0.8,
	1.5,
}
BtCompanionHubInteractionWithPlayerAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	2,
}

local _is_looking_at_target, _move_towards_animation_point, _rotate_towards_target_unit

BtCompanionHubInteractionWithPlayerAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension

	if action_data.enable_disable_locomotion_speed then
		local speed = breed.run_speed

		navigation_extension:set_enabled(true, speed)
	end

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local follow_component = Blackboard.write_component(blackboard, "follow")

	scratchpad.follow_component = follow_component

	local owner_unit = behavior_component.owner_unit

	if owner_unit then
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		local movement_state_component = unit_data_extension:read_component("movement_state")

		scratchpad.owner_movement_state_component = movement_state_component
	end

	if action_data.adapt_speed then
		scratchpad.current_speed_timer = 0
	end

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world
	scratchpad.hub_interaction = {
		animate_after_correction = false,
		snap_to_perfect_position = false,
		pose_correction = {
			animation_driven_started = false,
			animation_driven_start_time = t + 1,
		},
	}

	local hub_interaction_component = Blackboard.write_component(blackboard, "hub_interaction_with_player")

	scratchpad.hub_interaction_component = hub_interaction_component

	local player_owner_unit = scratchpad.behavior_component.owner_unit

	Managers.state.companion_interaction:companion_is_in_position_for_interaction(player_owner_unit, unit)
end

BtCompanionHubInteractionWithPlayerAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_to_position:store(0, 0, 0)

	behavior_component.has_move_to_position = false
	behavior_component.current_state = "idle"
	behavior_component.move_state = "idle"
	behavior_component.should_skip_start_anim = false
	behavior_component.is_out_of_bound = false

	local follow_component = Blackboard.write_component(blackboard, "follow")

	follow_component.last_referenced_vector:store(0, 0, 0)

	follow_component.current_owner_cooldown = -1
	follow_component.last_owner_cooldown_time = -1
	follow_component.current_position_cooldown = -1
	follow_component.current_movement_type = "none"
	follow_component.current_movement_animation = "none"

	local pounce_component = Blackboard.write_component(blackboard, "pounce")

	pounce_component.pounce_target = nil
	pounce_component.target_hit_zone_name = ""
	pounce_component.leap_node = ""
	pounce_component.pounce_cooldown = 0
	pounce_component.started_leap = false
	pounce_component.has_pounce_target = false
	pounce_component.has_pounce_started = false
	pounce_component.has_jump_off_direction = true
	pounce_component.use_fast_jump = false

	local hub_interaction_component = Blackboard.write_component(blackboard, "hub_interaction_with_player")

	hub_interaction_component.has_owner_started_interaction = false
end

BtCompanionHubInteractionWithPlayerAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if action_data.enable_disable_locomotion_speed then
		scratchpad.navigation_extension:set_enabled(false)
	end

	local behavior_component = scratchpad.behavior_component

	behavior_component.has_move_to_position = false

	local hub_interaction_component = scratchpad.hub_interaction_component

	hub_interaction_component.has_owner_started_interaction = false

	scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")
	MinionMovement.set_anim_driven(scratchpad, false)
end

local function _check_exit_condition(unit, scratchpad)
	local player_owner_unit = scratchpad.behavior_component.owner_unit
	local player_owner_position = POSITION_LOOKUP[player_owner_unit]
	local self_position = POSITION_LOOKUP[unit]
	local distance_sq = Vector3.distance_squared(self_position, player_owner_position)
	local has_player_moved_away = distance_sq >= 15

	return has_player_moved_away
end

local function _is_at_animation_position(unit, scratchpad)
	local target_position = scratchpad.behavior_component.move_to_position:unbox()
	local current_position = POSITION_LOOKUP[unit]
	local distance_sq = Vector3.distance_squared(current_position, target_position)

	return distance_sq <= 0.1
end

BtCompanionHubInteractionWithPlayerAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local force_exit = _check_exit_condition(unit, scratchpad)

	if force_exit then
		return "done"
	end

	local player_owner_unit = scratchpad.behavior_component.owner_unit

	if t <= scratchpad.hub_interaction.pose_correction.animation_driven_start_time then
		_rotate_towards_target_unit(unit, scratchpad, player_owner_unit)
	elseif not scratchpad.hub_interaction.pose_correction.animation_driven_started then
		MinionMovement.set_anim_driven(scratchpad, true)

		scratchpad.hub_interaction.pose_correction.animation_driven_started = true
	end

	return "running"
end

function _is_looking_at_target(unit, target_unit)
	local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
	local position, target_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[target_unit]
	local to_target = Vector3.normalize(Vector3.flat(target_position - position))
	local dot = Vector3.dot(fwd, to_target)
	local is_in_front = dot > 0.3

	return is_in_front
end

function _rotate_towards_target_unit(unit, scratchpad, target_unit)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtCompanionHubInteractionWithPlayerAction
