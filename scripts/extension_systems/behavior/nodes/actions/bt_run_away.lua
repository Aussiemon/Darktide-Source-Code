require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtRunAwayAction = class("BtRunAwayAction", "BtNode")
BtRunAwayAction.TIME_TO_FIRST_EVALUATE = {
	2,
	2.75
}
BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	1.5
}

BtRunAwayAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.navigation_extension = navigation_extension
	local run_speed = action_data.run_speed

	navigation_extension:set_enabled(true, run_speed)

	scratchpad.time_to_next_evaluate = t + math.random_range(BtRunAwayAction.TIME_TO_FIRST_EVALUATE[1], BtRunAwayAction.TIME_TO_FIRST_EVALUATE[2])
	scratchpad.current_move_to_position = Vector3Box()
	local move_type = action_data.move_type
	scratchpad.move_type = move_type
	local wanted_position = nil

	if move_type == "combat_vector" then
		local combat_vector_component = blackboard.combat_vector
		scratchpad.combat_vector_component = combat_vector_component
		wanted_position = combat_vector_component.position:unbox()
	end

	self:_move_to_position(scratchpad, wanted_position, navigation_extension)
end

BtRunAwayAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

local MIN_MOVE_DISTANCE_CHANGE_SQ = 9

BtRunAwayAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local wanted_position = nil
	local move_type = scratchpad.move_type

	if move_type == "combat_vector" then
		wanted_position = scratchpad.combat_vector_component.position:unbox()
	end

	local navigation_extension = scratchpad.navigation_extension
	local current_move_to_position = scratchpad.current_move_to_position:unbox()
	local distance_sq = Vector3.distance_squared(current_move_to_position, wanted_position)

	if MIN_MOVE_DISTANCE_CHANGE_SQ < distance_sq then
		self:_move_to_position(scratchpad, wanted_position, navigation_extension)
	end

	if action_data.leave_when_reached_destination then
		scratchpad.has_followed_path = scratchpad.has_followed_path or navigation_extension:is_following_path()

		if scratchpad.has_followed_path then
			local has_reached_destination = navigation_extension:has_reached_destination()

			if has_reached_destination then
				return "done"
			end
		end
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	local should_evaluate = scratchpad.time_to_next_evaluate <= t

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
	end

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		local target_unit = scratchpad.perception_component.target_unit

		if ALIVE[target_unit] then
			local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

			scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
		end

		return "running", should_evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	return "running", should_evaluate
end

BtRunAwayAction._move_to_position = function (self, scratchpad, wanted_position, navigation_extension)
	navigation_extension:move_to(wanted_position)
	scratchpad.current_move_to_position:store(wanted_position)
end

BtRunAwayAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event = nil

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
end

return BtRunAwayAction
