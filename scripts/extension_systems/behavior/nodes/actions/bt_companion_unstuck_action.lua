-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_unstuck_action.lua

require("scripts/extension_systems/behavior/nodes/actions/bt_idle_action")

local NavQueries = require("scripts/utilities/nav_queries")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtCompanionUnstuckAction = class("BtCompanionUnstuckAction", "BtIdleAction")

BtCompanionUnstuckAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	BtCompanionUnstuckAction.super.enter(self, unit, breed, blackboard, scratchpad, action_data, t)

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.nav_world = navigation_extension:nav_world()

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component
	scratchpad._initial_offset = 0

	self:_find_position_and_teleport(unit, breed, blackboard, scratchpad, action_data, t)
end

BtCompanionUnstuckAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	BtCompanionUnstuckAction.super.run(self, unit, breed, blackboard, scratchpad, action_data, dt, t)

	if not scratchpad.waiting_time then
		self:_find_position_and_teleport(unit, breed, blackboard, scratchpad, action_data, t)
	elseif t > scratchpad.waiting_time then
		local unit_position = POSITION_LOOKUP[unit]
		local above, below, nav_world, traverse_logic = 1, 1, scratchpad.nav_world, scratchpad.traverse_logic
		local valid_position = NavQueries.position_on_mesh(nav_world, unit_position, above, below, traverse_logic)

		if valid_position then
			MinionMovement.set_anim_driven(scratchpad, false)
			scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

			scratchpad.behavior_component.is_out_of_bound = false

			return "done"
		else
			scratchpad.waiting_time = nil

			self:_find_position_and_teleport(unit, breed, blackboard, scratchpad, action_data, t)
		end
	end

	return "running"
end

BtCompanionUnstuckAction.init_values = function (self, blackboard)
	BtCompanionUnstuckAction.super.init_values(self, blackboard)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.is_out_of_bound = false
end

local ABOVE, BELOW = 1, 1

BtCompanionUnstuckAction._find_position_and_teleport = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local owner_unit = blackboard.behavior.owner_unit

	if not owner_unit then
		return "running"
	end

	local owner_position = POSITION_LOOKUP[owner_unit]

	owner_position.z = owner_position.z

	local nav_world, traverse_logic = scratchpad.nav_world, scratchpad.traverse_logic
	local valid_position = NavQueries.position_on_mesh(nav_world, owner_position, ABOVE, BELOW, traverse_logic)

	if valid_position then
		Managers.state.out_of_bounds:unregister_soft_oob_unit(unit, self)
		self:_teleport(unit, breed, blackboard, scratchpad, action_data, t, owner_position)
	end
end

BtCompanionUnstuckAction._teleport = function (self, unit, breed, blackboard, scratchpad, action_data, t, teleport_position)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:teleport_to(teleport_position)

	scratchpad.waiting_time = t + action_data.waiting_time
end

return BtCompanionUnstuckAction
