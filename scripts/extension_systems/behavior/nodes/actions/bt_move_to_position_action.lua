-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_move_to_position_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtMoveToPositionAction = class("BtMoveToPositionAction", "BtNode")

BtMoveToPositionAction.TIME_TO_FIRST_EVALUATE = {
	0.8,
	1.5
}
BtMoveToPositionAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	2
}

BtMoveToPositionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension

	local speed = breed.run_speed

	navigation_extension:set_enabled(true, speed)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local move_to_position = behavior_component.move_to_position:unbox()

	navigation_extension:move_to(move_to_position)

	scratchpad.move_to_position = Vector3Box(move_to_position)
	scratchpad.behavior_component = behavior_component

	local slot_system = Managers.state.extension:system("slot_system")

	if slot_system:is_slot_searching(unit) then
		slot_system:do_slot_search(unit, false)

		scratchpad.reset_slot_system = true
	end
end

BtMoveToPositionAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.has_move_to_position = false

	behavior_component.move_to_position:store(0, 0, 0)
end

BtMoveToPositionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.navigation_extension:set_enabled(false)

	if scratchpad.reset_slot_system then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:do_slot_search(unit, true)
	end
end

local ARRIVED_AT_POSITION_THRESHOLD_SQ = 0.5625

BtMoveToPositionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local self_position, move_to_position = POSITION_LOOKUP[unit], scratchpad.move_to_position:unbox()
	local distance_sq = Vector3.distance_squared(self_position, move_to_position)

	if distance_sq <= ARRIVED_AT_POSITION_THRESHOLD_SQ then
		scratchpad.behavior_component.has_move_to_position = false

		return "done"
	end

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		return "running"
	end

	if scratchpad.start_move_event_anim_speed_duration and t < scratchpad.start_move_event_anim_speed_duration then
		local navigation_extension = scratchpad.navigation_extension

		MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	return "running"
end

BtMoveToPositionAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		start_move_event = start_move_anim_events[moving_direction_name]

		animation_extension:anim_event(start_move_event)

		if moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]

			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	elseif action_data.move_anim_event then
		start_move_event = action_data.move_anim_event

		animation_extension:anim_event(start_move_event)
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	behavior_component.move_state = "moving"

	local new_speed = action_data.speeds[start_move_event]

	scratchpad.navigation_extension:set_max_speed(new_speed)
end

return BtMoveToPositionAction
