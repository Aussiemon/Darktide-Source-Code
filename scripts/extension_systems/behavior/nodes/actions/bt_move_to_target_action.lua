-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_move_to_target_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local BtMoveToTargetAction = class("BtMoveToTargetAction", "BtNode")

BtMoveToTargetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.navigation_extension = navigation_extension

	local walk_speed = breed.walk_speed

	navigation_extension:set_enabled(true, walk_speed)

	scratchpad.find_move_position_attempts = 0
end

BtMoveToTargetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)
end

local MOVE_CHECK_DISTANCE_SQ = 9

BtMoveToTargetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination()

	if Vector3.distance_squared(destination, target_position) > MOVE_CHECK_DISTANCE_SQ then
		self:_update_move_to_target_position(scratchpad, navigation_extension, target_position)
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
		self:_start_move_anim(scratchpad, behavior_component, action_data)
	end

	return "running"
end

local NAV_MESH_ABOVE = 0.7
local NAV_MESH_ABOVE_INCREMENT = 0.2
local NAV_MESH_BELOW = 2
local NAV_MESH_BELOW_INCREMENT = 0.2

BtMoveToTargetAction._update_move_to_target_position = function (self, scratchpad, navigation_extension, wanted_position)
	local attempts = scratchpad.find_move_position_attempts
	local above = NAV_MESH_ABOVE + attempts * NAV_MESH_ABOVE_INCREMENT
	local below = NAV_MESH_BELOW + attempts * NAV_MESH_BELOW_INCREMENT
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, above, below)

	if goal_position then
		navigation_extension:move_to(goal_position)

		scratchpad.find_move_position_attempts = 0
	else
		scratchpad.find_move_position_attempts = attempts + 1
	end
end

local DEFAULT_MOVE_ANIM_EVENT = "move_fwd"

BtMoveToTargetAction._start_move_anim = function (self, scratchpad, behavior_component, action_data)
	local move_event = Animation.random_event(action_data.move_anim_events or DEFAULT_MOVE_ANIM_EVENT)

	scratchpad.animation_extension:anim_event(move_event)

	behavior_component.move_state = "moving"
end

return BtMoveToTargetAction
