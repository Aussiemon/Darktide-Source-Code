require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
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

		self:_equip_and_replace_current_pocketable(interactor_is_server, interactor_unit, interactee_unit, inventory_item, t)

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

PocketableInteraction._equip_and_replace_current_pocketable = function (self, interactor_is_server, interactor_unit, interactee_unit, inventory_item, t)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pocketable_wielded = inventory_component.wielded_slot == SLOT_NAME
	local item_name = inventory_component[SLOT_NAME]
	local swap_item = item_name ~= "not_equipped"

	if swap_item then
		if interactor_is_server then
			local item = item_definitions[item_name]
			local weapon_template = WeaponTemplate.weapon_template_from_item(item)
			local swap_pickup_name = weapon_template and weapon_template.swap_pickup_name
			local position = Unit.world_position(interactee_unit, 1)
			local rotation = Unit.world_rotation(interactee_unit, 1)
			local pickup_system = Managers.state.extension:system("pickup_system")
			local disable_time = 0.5
			local spawned_unit, _ = pickup_system:spawn_pickup(swap_pickup_name, position, rotation, nil, nil, disable_time)
			local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

			if pickup_animation_system then
				pickup_animation_system:start_animation_from_unit(spawned_unit, interactor_unit)
			end

			local equipped_pickup_data = Pickups.by_name[swap_pickup_name]

			if equipped_pickup_data and equipped_pickup_data.on_drop_func then
				equipped_pickup_data.on_drop_func(spawned_unit)
			end
		end

		PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, SLOT_NAME, t)
	end

	PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, inventory_item, SLOT_NAME, nil, t)

	if swap_item and pocketable_wielded then
		PlayerUnitVisualLoadout.wield_slot(SLOT_NAME, interactor_unit, t)
	end
end

return PocketableInteraction
