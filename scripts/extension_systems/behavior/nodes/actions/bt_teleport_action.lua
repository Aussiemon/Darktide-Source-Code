require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtTeleportAction = class("BtTeleportAction", "BtNode")
local WAIT_TIME_PER_DISTANCE = 1
local MIN_WAIT_TIME = 3
local MAX_WAIT_TIME = 5

BtTeleportAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	if navigation_extension:use_smart_object(true) then
		local nav_smart_object_component = blackboard.nav_smart_object
		local entrance_position = nav_smart_object_component.entrance_position:unbox()
		local exit_position = nav_smart_object_component.exit_position:unbox()
		local distance = Vector3.distance(entrance_position, exit_position)
		local min_wait_time = action_data and action_data.min_wait_time or MIN_WAIT_TIME
		local max_wait_time = action_data and action_data.max_wait_time or MAX_WAIT_TIME
		local wait_duration = math.clamp(distance * WAIT_TIME_PER_DISTANCE, min_wait_time, max_wait_time)
		scratchpad.wait_time = t + wait_duration

		navigation_extension:set_nav_bot_position(exit_position)

		scratchpad.navigation_extension = navigation_extension
		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:teleport_to(exit_position)

		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event("idle")

		local has_outline_system = Managers.state.extension:has_system("outline_system")

		if has_outline_system then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:remove_all_outlines(unit)
		end

		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.move_state = "idle"
	else
		scratchpad.failed_to_use_smart_object = true
	end
end

BtTeleportAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.failed_to_use_smart_object then
		scratchpad.navigation_extension:use_smart_object(false)
	end
end

BtTeleportAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.failed_to_use_smart_object then
		return "failed"
	end

	if scratchpad.wait_time < t then
		return "done"
	else
		return "running"
	end
end

return BtTeleportAction
