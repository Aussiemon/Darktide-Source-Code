-- chunkname: @scripts/extension_systems/interaction/interactions/setup_decoding_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SetupDecodingInteraction = class("SetupDecodingInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

SetupDecodingInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	if interactor_is_server then
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		self:_unequip_slot(t, interactor_unit, "slot_device")
		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
	end
end

SetupDecodingInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local decoder_device_extension = ScriptUnit.extension(target_unit, "decoder_device_system")

		decoder_device_extension:decoder_setup_success(interactor_unit)
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

SetupDecodingInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local can_interact = PlayerUnitStatus.can_interact_with_objective(interactor_unit)

	return can_interact
end

return SetupDecodingInteraction
