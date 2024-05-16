-- chunkname: @scripts/extension_systems/interaction/interactions/luggable_socket_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local LuggableSocketInteraction = class("LuggableSocketInteraction", "BaseInteraction")

LuggableSocketInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local is_wielding_luggable = inventory_component.wielded_slot == "slot_luggable"
	local socket_is_interactable = false

	if is_wielding_luggable then
		local inventory_slot_component = unit_data_extension:read_component(wielded_slot)
		local luggable_to_socket = inventory_slot_component.existing_unit_3p
		local luggable_socket_extension = ScriptUnit.has_extension(interactee_unit, "luggable_socket_system")

		socket_is_interactable = luggable_socket_extension:is_socketable(luggable_to_socket)
	end

	return socket_is_interactable and is_wielding_luggable and not self:_interactor_disabled(interactor_unit)
end

LuggableSocketInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, is_server)
	if is_server and result == "success" then
		local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot
		local inventory_slot_component = unit_data_extension:read_component(wielded_slot)
		local luggable_to_socket = inventory_slot_component.existing_unit_3p

		PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, wielded_slot, t)
		PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, interactor_unit, t)

		local interactee_unit = unit_data_component.target_unit
		local luggable_socket_extension = ScriptUnit.extension(interactee_unit, "luggable_socket_system")

		luggable_socket_extension:add_overlapping_unit(luggable_to_socket)
	end
end

LuggableSocketInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return LuggableSocketInteraction:interactor_condition_func(interactor_unit, interactee_unit)
end

return LuggableSocketInteraction
