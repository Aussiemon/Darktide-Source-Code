local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SLOT_POCKETABLE = "slot_pocketable"
local Pocketable = {}
local _drop_pickup = nil

Pocketable.drop_pocketable = function (t, is_server, player_unit, inventory_component, visual_loadout_extension)
	if not PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, SLOT_POCKETABLE) then
		return
	end

	local item_name = inventory_component[SLOT_POCKETABLE]

	if is_server then
		local position = Unit.world_position(player_unit, 1)
		local rotation = Unit.world_rotation(player_unit, 1)
		local navigation_extension = ScriptUnit.has_extension(player_unit, "navigation_system")

		if navigation_extension then
			local nav_position = navigation_extension:latest_position_on_nav_mesh()

			if nav_position then
				position = nav_position
			end
		end

		_drop_pickup(item_name, position, rotation)
	end

	PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, SLOT_POCKETABLE, t)
end

Pocketable.equip_pocketable = function (t, is_server, player_unit, pickup_unit, inventory_item)
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pocketable_wielded = inventory_component.wielded_slot == SLOT_POCKETABLE
	local item_name = inventory_component[SLOT_POCKETABLE]
	local swap_item = item_name ~= "not_equipped"

	if swap_item then
		if is_server then
			local position = Unit.world_position(pickup_unit, 1)
			local rotation = Unit.world_rotation(pickup_unit, 1)
			local spawned_unit = _drop_pickup(item_name, position, rotation)
			local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

			if spawned_unit and pickup_animation_system then
				pickup_animation_system:start_animation_from_unit(spawned_unit, player_unit)
			end
		end

		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, SLOT_POCKETABLE, t)
	end

	PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, inventory_item, SLOT_POCKETABLE, nil, t)

	if swap_item and pocketable_wielded then
		PlayerUnitVisualLoadout.wield_slot(SLOT_POCKETABLE, player_unit, t)
	end
end

function _drop_pickup(item_name, spawn_pos, spawn_rot)
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local swap_pickup_name = weapon_template and weapon_template.swap_pickup_name

	if not swap_pickup_name then
		return nil
	end

	local pickup_system = Managers.state.extension:system("pickup_system")
	local disable_time = 0.5
	local spawned_unit, _ = pickup_system:spawn_pickup(swap_pickup_name, spawn_pos, spawn_rot, nil, nil, disable_time)
	local equipped_pickup_data = Pickups.by_name[swap_pickup_name]

	if equipped_pickup_data and equipped_pickup_data.on_drop_func then
		equipped_pickup_data.on_drop_func(spawned_unit)
	end

	return spawned_unit, swap_pickup_name
end

return Pocketable
