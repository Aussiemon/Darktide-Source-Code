require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local Vo = require("scripts/utilities/vo")
local BtRenegadeNetgunnerApproachAction = class("BtRenegadeNetgunnerApproachAction", "BtNode")
local VO_MOVE_EVENT_FREQUENCY_RANGE = {
	3,
	6
}

BtRenegadeNetgunnerApproachAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		scratchpad.fx_system = fx_system
		scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
	end

	if action_data.vo_event then
		scratchpad.next_vo_event_t = 0
	end
end

BtRenegadeNetgunnerApproachAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

local UPDATE_TARGET_DISTANCE_SQ = 1

BtRenegadeNetgunnerApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_distance = perception_component.target_distance
	local leave_distance = action_data.leave_distance

	if target_distance <= leave_distance then
		local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
		local has_clear_shot = scratchpad.perception_extension:has_line_of_sight_by_id(target_unit, clear_shot_line_of_sight_id)

		if has_clear_shot then
			return "done"
		end
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local destination = scratchpad.navigation_extension:destination()
	local target_to_destination_distance_sq = Vector3.distance_squared(target_position, destination)

	if UPDATE_TARGET_DISTANCE_SQ < target_to_destination_distance_sq then
		self:_move_to_target(scratchpad, target_unit)
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

	if move_state ~= "moving" then
		self:_start_move_anim(scratchpad, action_data)
	end

	if scratchpad.next_vo_event_t <= t then
		Vo.enemy_generic_vo_event(unit, action_data.vo_event, breed.name, target_distance)

		scratchpad.next_vo_event_t = t + math.random_range(VO_MOVE_EVENT_FREQUENCY_RANGE[1], VO_MOVE_EVENT_FREQUENCY_RANGE[2])
	end

	return "running"
end

local DEFAULT_MOVE_ANIM_EVENT = "assault_fwd"

BtRenegadeNetgunnerApproachAction._start_move_anim = function (self, scratchpad, action_data)
	local move_event = Animation.random_event(action_data.move_anim_events or DEFAULT_MOVE_ANIM_EVENT)

	scratchpad.animation_extension:anim_event(move_event)

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
end

local ABOVE = 1
local BELOW = 2

BtRenegadeNetgunnerApproachAction._move_to_target = function (self, scratchpad, target_unit)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local wanted_position = POSITION_LOOKUP[target_unit]
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, ABOVE, BELOW)

	if goal_position then
		navigation_extension:move_to(goal_position)
	end
end

return BtRenegadeNetgunnerApproachAction
