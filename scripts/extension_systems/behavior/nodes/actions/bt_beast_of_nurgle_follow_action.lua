require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Component = require("scripts/utilities/component")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtBeastOfNurgleFollowAction = class("BtBeastOfNurgleFollowAction", "BtNode")
BtBeastOfNurgleFollowAction.TIME_TO_FIRST_EVALUATE = 0.5
BtBeastOfNurgleFollowAction.CONSECUTIVE_EVALUATE_INTERVAL = 0.25

BtBeastOfNurgleFollowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception

	navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	scratchpad.time_to_next_evaluate = t + BtBeastOfNurgleFollowAction.TIME_TO_FIRST_EVALUATE

	self:_set_spline_blend(unit, 1)
end

BtBeastOfNurgleFollowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		self:_set_anim_driven(unit, scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

local MOVE_CHECK_DISTANCE_SQ = 9

BtBeastOfNurgleFollowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		scratchpad.time_to_next_evaluate = t + BtBeastOfNurgleFollowAction.CONSECUTIVE_EVALUATE_INTERVAL

		return "running", true
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, breed, t, scratchpad, action_data)
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		self:_update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if not is_anim_driven then
		local state = scratchpad.state

		if state == "walking" then
			self:_update_walking(unit, breed, dt, scratchpad, action_data, target_unit)
		elseif state == "running" then
			self:_update_running(unit, breed, dt, scratchpad, action_data, target_unit)
		end
	end

	local navigation_extension = scratchpad.navigation_extension
	local target_position = POSITION_LOOKUP[target_unit]
	local destination = navigation_extension:destination()
	local distance_to_destination_sq = Vector3.distance_squared(destination, target_position)
	local target_is_near_destination = distance_to_destination_sq < MOVE_CHECK_DISTANCE_SQ
	local should_evaluate = scratchpad.time_to_next_evaluate < t or target_is_near_destination

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + BtBeastOfNurgleFollowAction.CONSECUTIVE_EVALUATE_INTERVAL
	end

	return "running", should_evaluate
end

BtBeastOfNurgleFollowAction._start_move_anim = function (self, unit, breed, t, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local distance_to_destination = navigation_extension:distance_to_destination()
	local enter_walk_distance = action_data.enter_walk_distance

	if distance_to_destination < enter_walk_distance then
		scratchpad.state = "walking"
	else
		scratchpad.state = "running"
	end

	self:_set_state_max_speed(breed, scratchpad, action_data)

	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	scratchpad.moving_direction_name = moving_direction_name
	local start_move_event = nil
	local state = scratchpad.state

	if state == "walking" then
		self:_start_walk_anim(scratchpad, action_data, moving_direction_name)
	else
		local using_anim_driven = false

		if action_data.start_move_anim_events then
			local start_move_anim_events = action_data.start_move_anim_events[state]
			start_move_event = Animation.random_event(start_move_anim_events[moving_direction_name])
			using_anim_driven = true
		end

		scratchpad.animation_extension:anim_event(start_move_event or action_data.run_anim_event)

		if using_anim_driven and moving_direction_name ~= "fwd" then
			self:_set_anim_driven(unit, scratchpad, true)

			local start_move_rotation_timings = action_data.start_move_rotation_timings
			local start_rotation_timing = start_move_rotation_timings[start_move_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	end

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
end

local function _calculate_distances(unit, scratchpad, target_unit, dt)
	local target_position, target_current_velocity = MinionMovement.target_position_with_velocity(unit, target_unit)
	local self_position = POSITION_LOOKUP[unit]
	local distance_to_target = Vector3.distance(self_position, target_position)
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination() + target_current_velocity * dt
	local distance_to_destination = Vector3.distance(self_position, destination)

	return distance_to_destination, distance_to_target
end

BtBeastOfNurgleFollowAction._update_walking = function (self, unit, breed, dt, scratchpad, action_data, target_unit)
	local leave_walk_distance = action_data.leave_walk_distance
	local _, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local should_leave_walk = leave_walk_distance < distance_to_target

	if should_leave_walk then
		self:_change_state(unit, breed, scratchpad, action_data, "running")
	end
end

BtBeastOfNurgleFollowAction._start_walk_anim = function (self, scratchpad, action_data, optional_moving_direction_name)
	local start_move_anim_events = action_data.start_move_anim_events
	local walking_anim_event = nil

	if start_move_anim_events and start_move_anim_events.walking then
		local start_walking_anim_events = start_move_anim_events.walking
		walking_anim_event = Animation.random_event(start_walking_anim_events[optional_moving_direction_name])
	else
		walking_anim_event = action_data.walk_anim_event
	end

	scratchpad.animation_extension:anim_event(walking_anim_event)

	return walking_anim_event
end

BtBeastOfNurgleFollowAction._update_running = function (self, unit, breed, dt, scratchpad, action_data, target_unit)
	local _, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local enter_walk_distance = action_data.enter_walk_distance
	local should_enter_walk = distance_to_target <= enter_walk_distance

	if should_enter_walk then
		self:_change_state(unit, breed, scratchpad, action_data, "walking")
	end
end

BtBeastOfNurgleFollowAction._change_state = function (self, unit, breed, scratchpad, action_data, wanted_state)
	if wanted_state == "walking" then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		self:_start_walk_anim(scratchpad, action_data, moving_direction_name)

		scratchpad.moving_direction_name = moving_direction_name
	elseif wanted_state == "running" then
		local run_anim = action_data.run_anim_event

		scratchpad.animation_extension:anim_event(run_anim)
	end

	scratchpad.state = wanted_state

	self:_set_state_max_speed(breed, scratchpad, action_data)
end

BtBeastOfNurgleFollowAction._set_state_max_speed = function (self, breed, scratchpad, action_data)
	local state = scratchpad.state
	local new_speed = nil

	if state == "walking" then
		new_speed = breed.walk_speed
	elseif state == "running" then
		new_speed = action_data.move_speed or breed.run_speed
	end

	scratchpad.navigation_extension:set_max_speed(new_speed)
end

BtBeastOfNurgleFollowAction._rotate_towards_target_unit = function (self, unit, target_unit, scratchpad)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
end

BtBeastOfNurgleFollowAction._update_anim_driven_start_rotation = function (self, unit, scratchpad, action_data, t)
	if not scratchpad.rotation_duration then
		local navigation_extension = scratchpad.navigation_extension
		local current_node, next_node_in_path = navigation_extension:current_and_next_node_positions_in_path()
		local destination = next_node_in_path or current_node
		local start_move_event_name = scratchpad.move_start_anim_event_name
		local start_move_anim_data = action_data.start_move_anim_data[start_move_event_name]
		local rotation_sign = start_move_anim_data.sign
		local rotation_radians = start_move_anim_data.rad
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		scratchpad.locomotion_extension:set_anim_rotation_scale(rotation_scale)

		local rotation_duration = action_data.start_rotation_durations[start_move_event_name]
		scratchpad.rotation_duration = t + rotation_duration
	elseif scratchpad.rotation_duration <= t then
		scratchpad.start_rotation_timing = nil
		scratchpad.rotation_duration = nil

		self:_set_anim_driven(unit, scratchpad, false)
	end
end

BtBeastOfNurgleFollowAction._set_spline_blend = function (self, unit, value)
	Component.event(unit, "set_spline_blend", value)
end

BtBeastOfNurgleFollowAction._set_anim_driven = function (self, unit, scratchpad, set_anim_driven)
	MinionMovement.set_anim_driven(scratchpad, set_anim_driven)
	self:_set_spline_blend(unit, (set_anim_driven and 0) or 1)
end

return BtBeastOfNurgleFollowAction
