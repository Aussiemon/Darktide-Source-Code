-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_fall_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavQueries = require("scripts/utilities/nav_queries")
local BtCompanionFallAction = class("BtCompanionFallAction", "BtNode")
local FALLING_NAV_MESH_ABOVE = 0.5
local FALLING_NAV_MESH_BELOW = 30
local FALLING_NAV_MESH_LATERAL = 5
local FALLING_NAV_MESH_BORDER_DISTANCE = 0.01

BtCompanionFallAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.physics_world = blackboard.spawn.physics_world

	local pounce_component = Blackboard.write_component(blackboard, "pounce")

	scratchpad.pounce_component = pounce_component

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.set_fall = true
end

local SPEED_THRESHOLD = 0.01

BtCompanionFallAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.set_fall then
		local unit_position = POSITION_LOOKUP[unit]
		local above, below, lateral, nav_world, traverse_logic = 1, 30, 0.3, scratchpad.nav_world, scratchpad.traverse_logic
		local landing_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, unit_position, above, below, lateral)

		if not landing_position then
			scratchpad.behavior_component.is_out_of_bound = true

			return "failed"
		end

		scratchpad.locomotion_extension:set_movement_type("constrained_by_mover")
		scratchpad.locomotion_extension:set_gravity(nil)
		scratchpad.locomotion_extension:set_affected_by_gravity(true, 0)

		scratchpad.set_fall = false
		scratchpad.fall = true

		return "running"
	elseif scratchpad.fall then
		local mover = Unit.mover(unit)

		if Mover.collides_down(mover) then
			local unit_position = POSITION_LOOKUP[unit]
			local above, below, lateral, nav_world, traverse_logic = 0.2, 0.2, 0.3, scratchpad.nav_world, scratchpad.traverse_logic
			local landing_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, unit_position, above, below, lateral)

			if landing_position then
				scratchpad.locomotion_extension:set_affected_by_gravity(false)
				scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

				return "done"
			else
				local locomotion_extension = scratchpad.locomotion_extension
				local velocity = Vector3.flat(locomotion_extension:current_velocity())
				local speed = Vector3.length(velocity)

				if speed < SPEED_THRESHOLD then
					scratchpad.behavior_component.is_out_of_bound = true

					return "failed"
				end

				return "running"
			end
		end
	end

	return "running"
end

BtCompanionFallAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local pounce_component = scratchpad.pounce_component

	pounce_component.pounce_target = nil
	pounce_component.has_pounce_target = false
	pounce_component.has_jump_off_direction = true
	pounce_component.pounce_cooldown = t + action_data.leap_cooldown
end

return BtCompanionFallAction
