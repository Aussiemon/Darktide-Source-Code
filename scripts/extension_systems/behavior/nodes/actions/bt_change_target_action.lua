require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtChangeTargetAction = class("BtChangeTargetAction", "BtNode")

BtChangeTargetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = blackboard.perception
	scratchpad.target_unit = perception_component.target_unit
	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	self:_start_change_target_anim(unit, breed, t, scratchpad, action_data)
end

BtChangeTargetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

BtChangeTargetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local target_unit = scratchpad.target_unit

	if not ALIVE[target_unit] then
		return "done"
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.change_target_start_rotation_timing and scratchpad.change_target_start_rotation_timing <= t then
		local target_position = POSITION_LOOKUP[target_unit]

		MinionMovement.update_anim_driven_change_target_rotation(unit, scratchpad, action_data, t, target_position)
	end

	if scratchpad.change_target_event_anim_speed_duration and t < scratchpad.change_target_event_anim_speed_duration then
		local navigation_extension = scratchpad.navigation_extension

		MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
	end

	local fwd_exit_t = scratchpad.fwd_exit_t

	if fwd_exit_t then
		local rotate_towards_target_on_fwd = action_data.rotate_towards_target_on_fwd

		if rotate_towards_target_on_fwd then
			local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

			scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
		end

		if fwd_exit_t < t then
			scratchpad.fwd_exit_t = nil
		end
	end

	local is_changing_target = is_anim_driven or scratchpad.fwd_exit_t

	if not is_changing_target then
		return "done"
	end

	return "running"
end

BtChangeTargetAction._start_change_target_anim = function (self, unit, breed, t, scratchpad, action_data)
	local target_unit = scratchpad.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local moving_direction_name = MinionMovement.get_change_target_direction(unit, target_position)
	scratchpad.moving_direction_name = moving_direction_name
	local change_target_anim_events = action_data.change_target_anim_events[moving_direction_name]
	local change_target_anim_event = Animation.random_event(change_target_anim_events)
	local animation_extension = scratchpad.animation_extension

	animation_extension:anim_event(change_target_anim_event)

	if moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local change_target_rotation_timings = action_data.change_target_rotation_timings
		local change_target_start_rotation_timing = change_target_rotation_timings[change_target_anim_event]
		scratchpad.change_target_start_rotation_timing = t + change_target_start_rotation_timing
		scratchpad.change_target_anim_event_name = change_target_anim_event
	else
		scratchpad.change_target_start_rotation_timing = nil
		scratchpad.change_target_anim_event_name = nil
		scratchpad.fwd_exit_t = t + (action_data.change_target_rotation_durations[change_target_anim_event] or 0)
	end

	local change_target_event_anim_speed_duration = action_data.change_target_event_anim_speed_durations and action_data.change_target_event_anim_speed_durations[change_target_anim_event]

	if change_target_event_anim_speed_duration then
		scratchpad.change_target_event_anim_speed_duration = t + change_target_event_anim_speed_duration
	end

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
end

return BtChangeTargetAction
