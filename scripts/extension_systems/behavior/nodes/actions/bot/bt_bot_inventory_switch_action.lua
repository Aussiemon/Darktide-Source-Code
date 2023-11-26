-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_inventory_switch_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local BtBotInventorySwitchAction = class("BtBotInventorySwitchAction", "BtNode")

BtBotInventorySwitchAction.TIME_TO_FIRST_EVALUATE = 0.3
BtBotInventorySwitchAction.CONSECUTIVE_EVALUATE_INTERVAL = 0.25
BtBotInventorySwitchAction.ACTION_INPUT_INTERVAL = 0.1

BtBotInventorySwitchAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")

	scratchpad.inventory_component = inventory_component

	local action_input_extension = ScriptUnit.extension(unit, "action_input_system")

	scratchpad.action_input_extension = action_input_extension

	local weapon_extension = ScriptUnit.extension(unit, "weapon_system")

	scratchpad.weapon_extension = weapon_extension
	scratchpad.next_evaluate_t = t + BtBotInventorySwitchAction.TIME_TO_FIRST_EVALUATE
	scratchpad.next_action_input_t = 0
end

BtBotInventorySwitchAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local wanted_slot = action_data.wanted_slot
	local inventory_component = scratchpad.inventory_component

	if inventory_component.wielded_slot == wanted_slot then
		return "done"
	elseif t > scratchpad.next_evaluate_t then
		local should_evaluate = true

		scratchpad.next_evaluate_t = t + BtBotInventorySwitchAction.CONSECUTIVE_EVALUATE_INTERVAL

		return "running", should_evaluate
	elseif t > scratchpad.next_action_input_t then
		local action_input = "wield"
		local wield_input = PlayerUnitVisualLoadout.wield_input_from_slot_name(wanted_slot)
		local weapon_extension = scratchpad.weapon_extension
		local fixed_t = FixedFrame.get_latest_fixed_time()
		local component_name = "weapon_action"

		if weapon_extension:action_input_is_currently_valid(component_name, action_input, wield_input, fixed_t) then
			local action_input_extension = scratchpad.action_input_extension

			action_input_extension:bot_queue_action_input(component_name, action_input, wield_input)

			scratchpad.next_action_input_t = t + BtBotInventorySwitchAction.ACTION_INPUT_INTERVAL
		end

		return "running"
	else
		return "running"
	end
end

return BtBotInventorySwitchAction
