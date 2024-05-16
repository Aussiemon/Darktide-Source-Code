-- chunkname: @scripts/extension_systems/interaction/interactions/setup_breach_charge_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SetupBreachChargeInteraction = class("SetupBreachChargeInteraction", "BaseInteraction")

SetupBreachChargeInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	if interactor_is_server then
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		self:_unequip_slot(t, interactor_unit, "slot_device")
		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
	end
end

SetupBreachChargeInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local can_interact = PlayerUnitStatus.can_interact_with_objective(interactor_unit)

	return can_interact
end

return SetupBreachChargeInteraction
