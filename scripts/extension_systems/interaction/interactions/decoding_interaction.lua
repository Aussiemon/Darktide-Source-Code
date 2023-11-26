-- chunkname: @scripts/extension_systems/interaction/interactions/decoding_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local DecodingInteraction = class("DecodingInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

DecodingInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if result == interaction_results.success then
		local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
		local target_unit = unit_data_component.target_unit
		local minigame_character_state = unit_data_extension:write_component("minigame_character_state")

		minigame_character_state.interface_unit_id = Managers.state.unit_spawner:level_index(target_unit)

		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		self:_unequip_slot(t, interactor_unit, "slot_device")
		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
		PlayerUnitVisualLoadout.wield_slot("slot_device", interactor_unit, t)
	end
end

DecodingInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local can_interact = PlayerUnitStatus.can_interact_with_objective(interactor_unit)

	return can_interact
end

DecodingInteraction.interactee_condition_func = function (self, interactee_unit)
	local decoder_device_extension = ScriptUnit.has_extension(interactee_unit, "decoder_device_system")

	if decoder_device_extension then
		local wait_for_restart = decoder_device_extension:wait_for_restart()
		local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
		local device_item = interactee_extension:interactor_item_to_equip()

		if wait_for_restart and device_item ~= nil then
			return true
		end
	else
		Log.error("DecodingInteraction", "[interactee_condition_func][Unit: %s, %s] Check unit setup. Missing 'decoder_device_extension'", Unit.id_string(interactee_unit), tostring(interactee_unit))
	end

	return false
end

DecodingInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return DecodingInteraction:interactee_condition_func(interactee_unit) and DecodingInteraction:interactor_condition_func(interactor_unit, interactee_unit)
end

return DecodingInteraction
