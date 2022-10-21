require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Pocketable = require("scripts/utilities/pocketable")
local item_definitions = MasterItems.get_cached()
local SLOT_NAME = "slot_pocketable"
local PocketableInteraction = class("PocketableInteraction", "PickupInteraction")

PocketableInteraction.stop = function (self, world, interactor_unit, interaction_context, t, result, interactor_is_server)
	if result == "success" then
		local interactee_unit = interaction_context.target_unit
		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]
		local inventory_item = item_definitions[pickup_data.inventory_item]

		if interactor_is_server then
			self:_trigger_sound(interactor_unit, pickup_data)
		end

		if pickup_data.on_pickup_func then
			pickup_data.on_pickup_func(interactee_unit, interactor_unit, pickup_data)
		end

		Pocketable.equip_pocketable(t, interactor_is_server, interactor_unit, interactee_unit, inventory_item)

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
	local item_name = inventory_component[SLOT_NAME]
	local has_same_item = false
	local pickup_name = Unit.has_data(interactee_unit, "pickup_type") and Unit.get_data(interactee_unit, "pickup_type")

	if pickup_name then
		local pickup_data = Pickups.by_name[pickup_name]
		local inventory_item = item_definitions[pickup_data.inventory_item]
		local wanted_item_name = inventory_item.name
		has_same_item = item_name == wanted_item_name
	end

	local slot_is_free = item_name == "not_equipped"
	local has_grimoire = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, SLOT_NAME, "grimoire")
	local disable_pickup = not slot_is_free and has_grimoire

	return not has_same_item and not disable_pickup and PocketableInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

PocketableInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pickup_name = Unit.has_data(interactee_unit, "pickup_type") and Unit.get_data(interactee_unit, "pickup_type")

	if pickup_name then
		local pickup_data = Pickups.by_name[pickup_name]
		local inventory_item = item_definitions[pickup_data.inventory_item]
		local item_name = inventory_component[SLOT_NAME]
		local wanted_item_name = inventory_item.name

		if item_name == wanted_item_name then
			return "loc_action_interaction_inactive_pocketable_equipped"
		end
	end

	local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
	local has_grimoire = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, SLOT_NAME, "grimoire")

	if has_grimoire then
		return "loc_action_interaction_inactive_grimore_equipped"
	end

	return PocketableInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

return PocketableInteraction
