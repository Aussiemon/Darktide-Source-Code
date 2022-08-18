require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SetupDecodingInteraction = class("SetupDecodingInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

SetupDecodingInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	if interactor_is_server then
		local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		fassert(item, "Missing scan item for unit(%s)", target_unit)

		if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_device") then
			PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, "slot_device", t)
		end

		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
	end
end

SetupDecodingInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local decoder_device_extension = ScriptUnit.extension(target_unit, "decoder_device_system")

		decoder_device_extension:decoder_setup_success()
	end
end

SetupDecodingInteraction.interactee_condition_func = function (self, interactee_unit)
	local decoder_device_extension = ScriptUnit.has_extension(interactee_unit, "decoder_device_system")

	if decoder_device_extension then
		local wait_for_setup = decoder_device_extension:wait_for_setup()
		local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()
		local can_interact = wait_for_setup and item ~= nil

		return can_interact
	end

	Log.error("SetupDecodingInteraction", "[interactee_condition_func][Unit: %s, %s] Check unit setup. Missing 'decoder_device_extension'", Unit.id_string(interactee_unit), tostring(interactee_unit))

	return false
end

return SetupDecodingInteraction
