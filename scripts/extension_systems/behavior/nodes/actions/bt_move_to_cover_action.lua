require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtMoveToCoverAction = class("BtMoveToCoverAction", "BtNode")
BtMoveToCoverAction.TIME_TO_FIRST_EVALUATE = {
	2,
	2.5
}
BtMoveToCoverAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	2
}

BtMoveToCoverAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	local cover_component = Blackboard.write_component(blackboard, "cover")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.cover_component = cover_component
	scratchpad.perception_component = blackboard.perception
	local run_speed = breed.run_speed

	navigation_extension:set_enabled(true, run_speed)

	local cover_position = cover_component.navmesh_position:unbox()

	navigation_extension:move_to(cover_position)

	scratchpad.cover_position = Vector3Box(cover_position)
	scratchpad.time_to_next_evaluate = t + math.random_range(BtMoveToCoverAction.TIME_TO_FIRST_EVALUATE[1], BtMoveToCoverAction.TIME_TO_FIRST_EVALUATE[2])
	scratchpad.move_type_switch_stickiness = 0
end

BtMoveToCoverAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

local ENTER_COVER_THRESHOLD_SQ = 0.5625

BtMoveToCoverAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local self_position = POSITION_LOOKUP[unit]
	local cover_position = scratchpad.cover_position:unbox()
	local distance_to_cover_sq = Vector3.distance_squared(self_position, cover_position)

	if distance_to_cover_sq <= ENTER_COVER_THRESHOLD_SQ then
		scratchpad.cover_component.is_in_cover = true

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

	local move_state = behavior_component.move_state
	local move_type = self:_get_move_type(scratchpad, action_data)

	if move_state ~= "moving" or move_type ~= scratchpad.current_move_type and scratchpad.move_type_switch_stickiness <= t then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data, move_type)

		scratchpad.current_move_type = move_type
		scratchpad.move_type_switch_stickiness = t + action_data.move_type_switch_stickiness
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	local should_evaluate = scratchpad.time_to_next_evaluate < t

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtMoveToCoverAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtMoveToCoverAction.CONSECUTIVE_EVALUATE_INTERVAL[2])

		return "running", true
	end

	return "running"
end

BtMoveToCoverAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data, move_type)
	local animation_extension = scratchpad.animation_extension
	local path_distance = scratchpad.navigation_extension:remaining_distance_from_progress_to_end_of_path()
	local should_use_anim_driven_event = action_data.anim_driven_min_distance <= path_distance
	local start_move_anim_events = action_data.start_move_anim_events
	local anim_events = start_move_anim_events

	if move_type == "jogging" and anim_events and should_use_anim_driven_event then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		local start_move_event = anim_events[moving_direction_name]

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
	else
		animation_extension:anim_event(action_data.sprint_anim_event)
	end

	local speed = action_data.speeds[move_type]

	scratchpad.navigation_extension:set_max_speed(speed)

	behavior_component.move_state = "moving"
end

BtMoveToCoverAction._get_move_type = function (self, scratchpad, action_data)
	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight
	local target_distance = perception_component.target_distance
	local sprint_target_distance = action_data.sprint_target_distance

	if has_line_of_sight and target_distance <= sprint_target_distance then
		return "sprinting"
	else
		return "jogging"
	end
end

return BtMoveToCoverAction
