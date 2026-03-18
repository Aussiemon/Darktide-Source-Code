-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_nil_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtNilAction = class("BtNilAction", "BtNode")

BtNilAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	return
end

BtNilAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "running"
end

BtNilAction.init_values = function (self, blackboard)
	return
end

return BtNilAction
