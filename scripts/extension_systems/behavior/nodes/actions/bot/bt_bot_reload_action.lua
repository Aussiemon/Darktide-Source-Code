require("scripts/extension_systems/behavior/nodes/bt_node")

local BtBotReloadAction = class("BtBotReloadAction", "BtNode")

BtBotReloadAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.is_reloading = true
	local action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	scratchpad.action_input_extension = action_input_extension
end

BtBotReloadAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.is_reloading = false

	scratchpad.action_input_extension:bot_queue_clear_requests("weapon_action")
end

BtBotReloadAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local action_input_extension = scratchpad.action_input_extension
	local reload_request_id = scratchpad.reload_request_id

	if not reload_request_id or action_input_extension:bot_queue_request_is_consumed("weapon_action", reload_request_id) then
		scratchpad.reload_request_id = action_input_extension:bot_queue_action_input("weapon_action", "reload")
	end

	local should_evaluate = true

	return "running", should_evaluate
end

return BtBotReloadAction
