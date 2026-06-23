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
		local interactee_unit = unit_data_component.target_unit
		local minigame_character_state = unit_data_extension:write_component("minigame_character_state")

		minigame_character_state.interface_level_unit_id = Managers.state.unit_spawner:level_index(interactee_unit)
		minigame_character_state.interface_game_object_id = NetworkConstants.invalid_game_object_id
		minigame_character_state.interface_is_level_unit = true

		local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		self:_unequip_slot(t, interactor_unit, "slot_device")
		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
		PlayerUnitVisualLoadout.wield_slot("slot_device", interactor_unit, t)

		local decoder_device_extension = ScriptUnit.extension(interactee_unit, "decoder_device_system")

		decoder_device_extension:interaction_success()
	end
end

DecodingInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local can_interact = PlayerUnitStatus.can_interact_with_objective(interactor_unit)

	return can_interact
end

DecodingInteraction.interactee_condition_func = function (self, interactee_unit)
	local decoder_device_extension = ScriptUnit.has_extension(interactee_unit, "decoder_device_system")

	if decoder_device_extension then
		local interaction_allowed = decoder_device_extension:interaction_allowed()
		local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
		local device_item = interactee_extension:interactor_item_to_equip()

		return interaction_allowed and device_item ~= nil
	else
		Log.error("DecodingInteraction", "[interactee_condition_func][Unit: %s, %s] Check unit setup. Missing 'decoder_device_extension'", Unit.id_string(interactee_unit), tostring(interactee_unit))
	end

	return false
end

DecodingInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return DecodingInteraction:interactee_condition_func(interactee_unit) and DecodingInteraction:interactor_condition_func(interactor_unit, interactee_unit)
end

return DecodingInteraction
