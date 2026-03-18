-- chunkname: @scripts/extension_systems/interaction/interactions/expedition_loot_converter_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Vo = require("scripts/utilities/vo")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ExpeditionLootConverterInteraction = class("ExpeditionLootConverterInteraction", "BaseInteraction")

ExpeditionLootConverterInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	if not self:_is_interactor_wielding_expedition_loot(interactor_unit) then
		return false
	end

	return not self:_interactor_disabled(interactor_unit)
end

ExpeditionLootConverterInteraction.interactee_condition_func = function (self, interactee_unit)
	local expedition_loot_converter_extension = ScriptUnit.extension(interactee_unit, "expedition_loot_converter_system")

	if expedition_loot_converter_extension:can_interact() then
		return true
	end

	return false
end

ExpeditionLootConverterInteraction.hud_block_text = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local expedition_loot_converter_extension = ScriptUnit.extension(interactee_unit, "expedition_loot_converter_system")
	local block_text = interactee_extension:block_text(interactor_unit)

	if block_text then
		return block_text
	end

	if expedition_loot_converter_extension:can_interact() and not self:_is_interactor_wielding_expedition_loot(interactor_unit) then
		return "loc_expedition_loot_converter_missing_requirement"
	end

	return ExpeditionLootConverterInteraction.super.hud_block_text(self, interactor_unit, interactee_unit)
end

ExpeditionLootConverterInteraction._get_interactor_wielded_pickup_name = function (self, interactor_unit)
	local unit_data_extension = ScriptUnit.has_extension(interactor_unit, "unit_data_system")

	if not unit_data_extension then
		return
	end

	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= "slot_luggable" and wielded_slot ~= "slot_pocketable" then
		return
	end

	local inventory_slot_component = unit_data_extension:read_component(wielded_slot)
	local pickup_name

	if wielded_slot == "slot_luggable" then
		local existing_unit_3p = inventory_slot_component.existing_unit_3p

		if not existing_unit_3p then
			return
		end

		pickup_name = Unit.get_data(existing_unit_3p, "pickup_type")
	elseif wielded_slot == "slot_pocketable" then
		local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot)

		pickup_name = weapon_template.pickup_name
	end

	return pickup_name
end

ExpeditionLootConverterInteraction._is_interactor_wielding_expedition_loot = function (self, unit)
	local pickup_name = self:_get_interactor_wielded_pickup_name(unit)
	local pickup_data = Pickups.by_name[pickup_name]

	if not pickup_data then
		return false
	end

	local loot_data = pickup_data.loot_data

	if not loot_data then
		return false
	end

	if loot_data.is_expedition_loot then
		return true
	end

	return false
end

ExpeditionLootConverterInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	if is_server then
		local target_unit = unit_data_component.target_unit
		local expedition_loot_converter_extension = ScriptUnit.extension(target_unit, "expedition_loot_converter_system")

		expedition_loot_converter_extension:start_converting()
	end
end

ExpeditionLootConverterInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	local success = result == "success"

	if interactor_is_server then
		local target_unit = unit_data_component.target_unit
		local expedition_loot_converter_extension = ScriptUnit.extension(target_unit, "expedition_loot_converter_system")
		local pickup_name

		if success then
			local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot = inventory_component.wielded_slot
			local wielding_correct_slot = wielded_slot == "slot_luggable" or wielded_slot == "slot_pocketable"
			local unit_to_destroy
			local inventory_slot_component = unit_data_extension:read_component(wielded_slot)

			if wielded_slot == "slot_luggable" then
				unit_to_destroy = inventory_slot_component.existing_unit_3p
			end

			pickup_name = self:_get_interactor_wielded_pickup_name(interactor_unit)

			local pickup_data = Pickups.by_name[pickup_name]
			local on_drop_func = pickup_data.on_drop_func

			on_drop_func(nil, interactor_unit)
			PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, wielded_slot, t)
			PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, interactor_unit, t)

			if unit_to_destroy then
				Managers.state.unit_spawner:mark_for_deletion(unit_to_destroy)
			end
		end

		expedition_loot_converter_extension:stop_converting(success, interactor_unit, pickup_name)
	end

	if success then
		local fx_extension = ScriptUnit.extension(interactor_unit, "fx_system")

		fx_extension:trigger_exclusive_wwise_event("wwise/events/ui/play_hud_heal_2d", nil, true)
	end
end

ExpeditionLootConverterInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return not self:_interactor_disabled(interactor_unit)
end

return ExpeditionLootConverterInteraction
