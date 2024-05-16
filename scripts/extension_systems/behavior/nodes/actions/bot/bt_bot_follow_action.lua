-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_follow_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtBotFollowAction = class("BtBotFollowAction", "BtNode")

BtBotFollowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local follow_component = Blackboard.write_component(blackboard, "follow")

	follow_component.has_teleported = false
	follow_component.needs_destination_refresh = true
end

BtBotFollowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local should_evaluate = true

	return "running", should_evaluate
end

return BtBotFollowAction
