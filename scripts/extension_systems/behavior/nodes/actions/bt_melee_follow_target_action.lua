-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_melee_follow_target_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtMeleeFollowTargetAction = class("BtMeleeFollowTargetAction", "BtNode")

BtMeleeFollowTargetAction.TIME_TO_FIRST_EVALUATE = 0.5
BtMeleeFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL = 0.25

BtMeleeFollowTargetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception

	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	scratchpad.buff_extension = buff_extension

	local stat_buffs = buff_extension:stat_buffs()
	local movement_speed = stat_buffs.movement_speed or 1
	local animation_variable_init = breed.animation_variable_init

	if animation_variable_init then
		scratchpad.can_scale_movementspeed = true
	end

	if movement_speed > 1 and (not animation_variable_init or not animation_variable_init.anim_move_speed) then
		movement_speed = 1
	end

	local animation_move_speed_modifier = breed.animation_move_speed_modifier

	if animation_move_speed_modifier then
		movement_speed = movement_speed + animation_move_speed_modifier - 1
	end

	scratchpad.modified_movement_speed = movement_speed

	local speed = (action_data.move_speed or breed.run_speed) * movement_speed

	navigation_extension:set_enabled(true, speed)

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	scratchpad.time_to_next_evaluate = t + BtMeleeFollowTargetAction.TIME_TO_FIRST_EVALUATE

	if action_data.force_move_anim_event and scratchpad.behavior_component.move_state == "moving" then
		scratchpad.animation_extension:anim_event(action_data.force_move_anim_event)
	end

	local follow_vo_interval_t = action_data.follow_vo_interval_t

	if follow_vo_interval_t then
		scratchpad.next_follow_vo_t = t
	end

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")

		scratchpad.fx_system = fx_system
	end

	scratchpad.walk_anim_switch_duration = 0
end

BtMeleeFollowTargetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

local MOVE_CHECK_DISTANCE_SQ = 9

BtMeleeFollowTargetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if action_data.running_stagger_duration then
		MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)
	end

	local next_follow_vo_t = scratchpad.next_follow_vo_t

	if next_follow_vo_t and next_follow_vo_t < t then
		local vo_event = action_data.vo_event

		if vo_event then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end

		scratchpad.next_follow_vo_t = t + action_data.follow_vo_interval_t
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle and t > scratchpad.time_to_next_evaluate then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.time_to_next_evaluate = t + BtMeleeFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL
		elseif should_be_idling and scratchpad.state ~= nil then
			self:_rotate_towards_target_unit(unit, target_unit, scratchpad)
		end

		local evaluate = not scratchpad.running_stagger_block_evaluate and t > scratchpad.time_to_next_evaluate

		return "running", evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, breed, t, scratchpad, action_data)
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if scratchpad.can_scale_movementspeed then
		self:_update_scaled_movementspeed(unit, breed, t, scratchpad, action_data)
	end

	if not is_anim_driven then
		local state = scratchpad.state

		if state == "walking" then
			self:_update_walking(unit, breed, t, dt, scratchpad, action_data, target_unit)
		elseif state == "running" then
			self:_update_running(unit, breed, dt, scratchpad, action_data, target_unit)
		end
	end

	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			self:_set_state_max_speed(breed, scratchpad, action_data)
		end
	end

	local lean_variable_name = action_data.lean_variable_name

	if lean_variable_name then
		self:_update_anim_lean_variable(unit, scratchpad, action_data, lean_variable_name, dt)
	end

	local effect_template = action_data.effect_template

	if effect_template then
		self:_update_effect_template(unit, scratchpad, action_data, target_unit)
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local destination = navigation_extension:destination()
	local distance_to_destination_sq = Vector3.distance_squared(destination, target_position)
	local target_is_near_destination = distance_to_destination_sq < MOVE_CHECK_DISTANCE_SQ
	local should_evaluate = not scratchpad.running_stagger_block_evaluate and (t > scratchpad.time_to_next_evaluate or target_is_near_destination)

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + BtMeleeFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL
	end

	if scratchpad.modified_movement_speed and breed.animation_variable_init then
		local animation_extension = scratchpad.animation_extension

		animation_extension:set_variable("anim_move_speed", scratchpad.modified_movement_speed)
	end

	return "running", should_evaluate
end

BtMeleeFollowTargetAction._update_scaled_movementspeed = function (self, unit, breed, t, scratchpad, action_data)
	local buff_extension = scratchpad.buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local movement_speed = stat_buffs.movement_speed or 1

	if movement_speed > 1 then
		local animation_variable_init = breed.animation_variable_init

		if not animation_variable_init or not animation_variable_init.anim_move_speed then
			movement_speed = 1
		end
	end

	local animation_move_speed_modifier = breed.animation_move_speed_modifier

	if animation_move_speed_modifier then
		movement_speed = movement_speed + animation_move_speed_modifier - 1
	end

	if scratchpad.modified_movement_speed ~= movement_speed then
		scratchpad.modified_movement_speed = movement_speed

		local speed = (action_data.move_speed or breed.run_speed) * movement_speed

		scratchpad.navigation_extension:set_max_speed(speed)
	end
end

BtMeleeFollowTargetAction._start_move_anim = function (self, unit, breed, t, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local distance_to_destination = navigation_extension:distance_to_destination()
	local enter_walk_distance = action_data.enter_walk_distance

	if distance_to_destination < enter_walk_distance then
		scratchpad.state = "walking"
	else
		scratchpad.state = "running"
	end

	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

	scratchpad.moving_direction_name = moving_direction_name

	local start_move_event
	local state = scratchpad.state

	if state == "walking" then
		start_move_event = self:_start_walk_anim(scratchpad, action_data, moving_direction_name)
	else
		local using_anim_driven = false

		if action_data.start_move_anim_events and action_data.start_move_anim_events[state] then
			local start_move_anim_events = action_data.start_move_anim_events[state]

			start_move_event = Animation.random_event(start_move_anim_events[moving_direction_name])
			using_anim_driven = true
		end

		scratchpad.animation_extension:anim_event(start_move_event or action_data.run_anim_event)

		if using_anim_driven and moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_move_rotation_timings = action_data.start_move_rotation_timings
			local start_rotation_timing = start_move_rotation_timings[start_move_event]

			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	end

	self:_set_state_max_speed(breed, scratchpad, action_data)

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
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

local WALK_ANIM_SWITCH_DURATION = 0.25

BtMeleeFollowTargetAction._update_walking = function (self, unit, breed, t, dt, scratchpad, action_data, target_unit)
	self:_rotate_towards_target_unit(unit, target_unit, scratchpad)

	local leave_walk_distance = action_data.leave_walk_distance
	local distance_to_destination, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local should_leave_walk = leave_walk_distance < distance_to_destination and leave_walk_distance < distance_to_target

	if should_leave_walk then
		self:_change_state(unit, breed, scratchpad, action_data, "running")
	elseif action_data.start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		if moving_direction_name ~= scratchpad.moving_direction_name and t >= scratchpad.walk_anim_switch_duration then
			self:_start_walk_anim(scratchpad, action_data, moving_direction_name)
			self:_set_state_max_speed(breed, scratchpad, action_data)

			scratchpad.walk_anim_switch_duration = t + WALK_ANIM_SWITCH_DURATION
			scratchpad.moving_direction_name = moving_direction_name
		end
	end
end

BtMeleeFollowTargetAction._update_running = function (self, unit, breed, dt, scratchpad, action_data, target_unit)
	local enter_walk_distance = action_data.enter_walk_distance

	if not enter_walk_distance then
		return
	end

	local distance_to_destination, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local should_leave_running = distance_to_destination < enter_walk_distance and distance_to_target < enter_walk_distance

	if should_leave_running then
		self:_change_state(unit, breed, scratchpad, action_data, "walking")
	end
end

BtMeleeFollowTargetAction._start_walk_anim = function (self, scratchpad, action_data, optional_moving_direction_name)
	local start_move_anim_events, walking_anim_event = action_data.start_move_anim_events

	if start_move_anim_events and start_move_anim_events.walking then
		local start_walking_anim_events = start_move_anim_events.walking

		walking_anim_event = Animation.random_event(start_walking_anim_events[optional_moving_direction_name])
	else
		walking_anim_event = action_data.walk_anim_event
	end

	scratchpad.animation_extension:anim_event(walking_anim_event)

	scratchpad.current_walk_anim_event = walking_anim_event

	return walking_anim_event
end

BtMeleeFollowTargetAction._change_state = function (self, unit, breed, scratchpad, action_data, wanted_state)
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

BtMeleeFollowTargetAction._set_state_max_speed = function (self, breed, scratchpad, action_data)
	local state, new_speed = scratchpad.state

	if state == "walking" then
		local walk_speeds = action_data.walk_speeds

		new_speed = walk_speeds and walk_speeds[scratchpad.current_walk_anim_event] or action_data.walk_speed or breed.walk_speed
	elseif state == "running" then
		new_speed = (action_data.move_speed or breed.run_speed) * scratchpad.modified_movement_speed
	end

	scratchpad.navigation_extension:set_max_speed(new_speed)

	scratchpad.start_move_event_anim_speed_duration = nil
end

BtMeleeFollowTargetAction._update_effect_template = function (self, unit, scratchpad, action_data, target_unit)
	local self_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local distance = Vector3.distance(self_position, target_position)
	local fx_system = scratchpad.fx_system

	if scratchpad.global_effect_id then
		local stop_distance = action_data.effect_template_stop_distance

		if stop_distance <= distance then
			fx_system:stop_template_effect(scratchpad.global_effect_id)

			scratchpad.global_effect_id = nil
		end
	else
		local start_distance = action_data.effect_template_start_distance

		if distance <= start_distance then
			scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
		end
	end
end

BtMeleeFollowTargetAction._rotate_towards_target_unit = function (self, unit, target_unit, scratchpad)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
end

BtMeleeFollowTargetAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, lean_variable_name, dt)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, action_data, dt)

	scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
end

return BtMeleeFollowTargetAction
