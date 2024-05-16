-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_interact_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtBotInteractAction = class("BtBotInteractAction", "BtNode")
local try_again_time = 3

BtBotInteractAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local interaction_unit = behavior_component.interaction_unit

	behavior_component.current_interaction_unit = interaction_unit
	scratchpad.behavior_component = behavior_component

	local interaction_type = action_data and action_data.interaction_type

	if interaction_type == nil then
		local interactee_extension = ScriptUnit.extension(interaction_unit, "interactee_system")

		interaction_type = interactee_extension:interaction_type()
	end

	local interactor_extension = ScriptUnit.extension(unit, "interactor_system")

	interactor_extension:set_bot_interaction_unit(interaction_unit, nil, interaction_type)

	scratchpad.interactor_extension = interactor_extension

	local input_extension = ScriptUnit.extension(unit, "input_system")
	local bot_unit_input = input_extension:bot_unit_input()
	local soft_aiming, use_rotation = true, false

	bot_unit_input:set_aiming(true, soft_aiming, use_rotation)

	scratchpad.bot_unit_input = bot_unit_input
	self._reset_t = t + try_again_time

	if action_data and Unit.has_node(interaction_unit, action_data.aim_node) then
		scratchpad.aim_node = Unit.node(interaction_unit, action_data.aim_node)
	else
		scratchpad.aim_node = 1
	end
end

BtBotInteractAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local behavior_component = scratchpad.behavior_component

	behavior_component.current_interaction_unit = nil

	local interactor_extension = scratchpad.interactor_extension

	interactor_extension:set_bot_interaction_unit(nil, nil, nil)

	local bot_unit_input = scratchpad.bot_unit_input

	bot_unit_input:set_aiming(false, false, false)
end

BtBotInteractAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local interaction_unit = behavior_component.current_interaction_unit

	if interaction_unit ~= behavior_component.interaction_unit then
		return "failed"
	end

	local bot_unit_input = scratchpad.bot_unit_input
	local reset = t > self._reset_t

	if reset then
		bot_unit_input:interact(true)

		self._reset_t = t + try_again_time
	else
		bot_unit_input:interact()
	end

	local aim_node = scratchpad.aim_node
	local aim_position = Unit.world_position(interaction_unit, aim_node)

	bot_unit_input:set_aim_position(aim_position)

	return "running"
end

return BtBotInteractAction
