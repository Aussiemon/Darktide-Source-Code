require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Pocketable = require("scripts/utilities/pocketable")
local SLOT_POCKETABLE_NAME = "slot_pocketable"
local SLOT_POCKETABLE_SMALL_NAME = "slot_pocketable_small"
local PocketableInteraction = class("PocketableInteraction", "PickupInteraction")

PocketableInteraction.stop = function (self, world, interactor_unit, interaction_context, t, result, interactor_is_server)
	if result == "success" then
		local interactee_unit = interaction_context.target_unit
		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]

		if interactor_is_server then
			self:_trigger_sound(interactor_unit, pickup_data)
		end

		if pickup_data.on_pickup_func then
			pickup_data.on_pickup_func(interactee_unit, interactor_unit, pickup_data)
		end

		local inventory_item = Pocketable.item_from_name(pickup_data.inventory_item)
		local inventory_slot_name = pickup_data.inventory_slot_name

		Pocketable.equip_pocketable(t, interactor_is_server, interactor_unit, interactee_unit, inventory_item, inventory_slot_name)

		if interactor_is_server then
			local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

			if not pickup_animation_system:start_animation_to_unit(interactee_unit, interactor_unit) then
				local pickup_system = Managers.state.extension:system("pickup_system")

				pickup_system:despawn_pickup(interactee_unit)
			end

			local player_or_nil = Managers.state.player_unit_spawn:owner(interactor_unit)
			local interactor_session_id_or_nil = player_or_nil and player_or_nil:session_id()

			self:_picked_up(interactee_unit, interactor_session_id_or_nil)
		end
	end
end

PocketableInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pocketable_item_name = inventory_component[SLOT_POCKETABLE_NAME]
	local pocketable_small_item_name = inventory_component[SLOT_POCKETABLE_SMALL_NAME]
	local has_same_item = false
	local pickup_name = Unit.has_data(interactee_unit, "pickup_type") and Unit.get_data(interactee_unit, "pickup_type")

	if pickup_name then
		local pickup_data = Pickups.by_name[pickup_name]
		local inventory_item = Pocketable.item_from_name(pickup_data.inventory_item)
		local wanted_item_name = inventory_item.name
		local inventory_slot_name = pickup_data.inventory_slot_name

		if inventory_slot_name == SLOT_POCKETABLE_NAME then
			has_same_item = pocketable_item_name == wanted_item_name
		elseif inventory_slot_name == SLOT_POCKETABLE_SMALL_NAME then
			has_same_item = pocketable_small_item_name == wanted_item_name
		end
	end

	local slot_is_free = pocketable_item_name == "not_equipped"
	local has_grimoire = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, SLOT_POCKETABLE_NAME, "grimoire")
	local disable_pickup = not slot_is_free and has_grimoire

	return not has_same_item and not disable_pickup and PocketableInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

PocketableInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pickup_name = Unit.has_data(interactee_unit, "pickup_type") and Unit.get_data(interactee_unit, "pickup_type")

	if pickup_name then
		local pickup_data = Pickups.by_name[pickup_name]
		local inventory_item = Pocketable.item_from_name(pickup_data.inventory_item)
		local pocketable_item_name = inventory_component[SLOT_POCKETABLE_NAME]
		local pocketable_small_item_name = inventory_component[SLOT_POCKETABLE_SMALL_NAME]
		local wanted_item_name = inventory_item.name

		if pocketable_item_name == wanted_item_name or pocketable_small_item_name == wanted_item_name then
			return "loc_action_interaction_inactive_pocketable_equipped"
		end
	end

	local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
	local has_grimoire = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, SLOT_POCKETABLE_NAME, "grimoire")

	if has_grimoire then
		return "loc_action_interaction_inactive_grimore_equipped"
	end

	return PocketableInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

return PocketableInteraction
