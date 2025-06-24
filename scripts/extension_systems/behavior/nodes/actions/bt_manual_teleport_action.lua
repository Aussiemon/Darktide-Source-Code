-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_manual_teleport_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtManualTeleportAction = class("BtManualTeleportAction", "BtNode")

BtManualTeleportAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.wait_time = t + action_data.wait_time

	local teleport_component = Blackboard.write_component(blackboard, "teleport")

	scratchpad.teleport_component = teleport_component

	local teleport_position = blackboard.teleport.teleport_position
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:teleport_to(teleport_position:unbox())

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event("idle")

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "idle"
end

BtManualTeleportAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.teleport_component.has_teleport_position = false
end

BtManualTeleportAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if t > scratchpad.wait_time then
		return "done"
	else
		return "running"
	end
end

BtManualTeleportAction.init_values = function (self, blackboard)
	local teleport_component = Blackboard.write_component(blackboard, "teleport")

	teleport_component.teleport_position:store(Vector3.zero())

	teleport_component.has_teleport_position = false
end

return BtManualTeleportAction
