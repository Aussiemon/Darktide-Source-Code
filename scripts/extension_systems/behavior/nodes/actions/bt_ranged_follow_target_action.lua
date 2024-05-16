-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_ranged_follow_target_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtRangedFollowTargetAction = class("BtRangedFollowTargetAction", "BtNode")

BtRangedFollowTargetAction.TIME_TO_FIRST_EVALUATE = {
	0.25,
	0.75,
}
BtRangedFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	0.25,
	0.75,
}

BtRangedFollowTargetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local perception_component = blackboard.perception

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local run_speed = action_data.speed

	navigation_extension:set_enabled(true, run_speed)

	scratchpad.is_assaulting = action_data.is_assaulting
	scratchpad.time_to_next_evaluate = t + math.random_range(BtRangedFollowTargetAction.TIME_TO_FIRST_EVALUATE[1], BtRangedFollowTargetAction.TIME_TO_FIRST_EVALUATE[2])

	MinionMovement.init_find_ranged_position(scratchpad, action_data)

	local vo_event = action_data.vo_event

	if vo_event then
		local breed_name = breed.name

		Vo.enemy_generic_vo_event(unit, vo_event, breed_name)
	end
end

BtRangedFollowTargetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

BtRangedFollowTargetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	MinionMovement.update_move_to_ranged_position(unit, t, scratchpad, action_data, target_unit)

	if action_data.running_stagger_duration then
		MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)
	end

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)
	local should_evaluate = not scratchpad.running_stagger_block_evaluate and t >= scratchpad.time_to_next_evaluate

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		MinionMovement.rotate_towards_target_unit(unit, scratchpad)

		if should_evaluate then
			scratchpad.time_to_next_evaluate = t + math.random_range(BtRangedFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtRangedFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
		end

		return "running", should_evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtRangedFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtRangedFollowTargetAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
	end

	return "running", should_evaluate
end

BtRangedFollowTargetAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		local start_move_event = start_move_anim_events[moving_direction_name]

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
		local move_event = action_data.move_anim_event

		animation_extension:anim_event(move_event)
	end

	behavior_component.move_state = "moving"
end

return BtRangedFollowTargetAction
