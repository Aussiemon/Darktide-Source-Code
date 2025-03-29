-- chunkname: @scripts/utilities/pocketable.lua

local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Pocketable = {}
local abort_data = {}
local _drop_pickup

Pocketable.drop_pocketable = function (t, physics_world, is_server, player_unit, inventory_component, visual_loadout_extension, slot_name)
	if not PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, slot_name) then
		return
	end

	local item_name = inventory_component[slot_name]

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

		local random_rotation = math.pi * 2 * math.random()
		local random_length = math.random() * 0.25 + 0.75
		local x = math.sin(random_rotation) * random_length
		local y = math.cos(random_rotation) * random_length

		position.x = position.x + x
		position.y = position.y + y

		local hit, hit_position = PhysicsWorld.raycast(physics_world, position + Vector3.up() * 0.5, Vector3.down(), 1, "closest", "collision_filter", "filter_player_place_deployable")

		if hit then
			position = hit_position
		end

		_drop_pickup(item_name, position, rotation, player_unit)
	end

	PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, slot_name, t)
end

Pocketable.equip_pocketable = function (t, is_server, player_unit, pickup_unit, inventory_item, slot_name)
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local pocketable_wielded = inventory_component.wielded_slot == slot_name
	local item_name = inventory_component[slot_name]
	local swap_item = item_name ~= "not_equipped"
	local inventory_slot_component = unit_data_extension:write_component(slot_name)
	local want_to_swap_item = true

	if pocketable_wielded then
		local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")

		weapon_extension:stop_action("aborted", abort_data, t)

		want_to_swap_item = not inventory_slot_component.unequip_slot
	end

	if swap_item then
		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, slot_name, t)
	end

	PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, inventory_item, slot_name, nil, t)

	if swap_item and is_server and want_to_swap_item then
		local position = Unit.world_position(pickup_unit, 1)
		local rotation = Unit.world_rotation(pickup_unit, 1)
		local spawned_unit = _drop_pickup(item_name, position, rotation, player_unit)
		local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

		if spawned_unit and pickup_animation_system then
			pickup_animation_system:start_animation_from_unit(spawned_unit, player_unit)
		end
	end

	if swap_item and pocketable_wielded then
		PlayerUnitVisualLoadout.wield_slot(slot_name, player_unit, t)
	end
end

Pocketable.item_from_name = function (item_name)
	local item_definitions = MasterItems.get_cached()
	local inventory_item = item_definitions[item_name]

	if not inventory_item then
		inventory_item = MasterItems.find_fallback_item("slot_pocketable")

		Log.error("PocketableInteraction", "[_fetch_pocketable_item] missing item '%s'", item_name)
	end

	return inventory_item
end

local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"
local SHOOTING_RANGE_GAME_MODE_NAME = "shooting_range"

function _drop_pickup(item_name, spawn_pos, spawn_rot, interactor_unit)
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local swap_pickup_name = weapon_template and weapon_template.swap_pickup_name

	if not swap_pickup_name then
		return nil, nil
	end

	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name ~= TRAINING_GROUNDS_GAME_MODE_NAME and game_mode_name ~= SHOOTING_RANGE_GAME_MODE_NAME then
		local pickup_system = Managers.state.extension:system("pickup_system")
		local disable_time = 0.5
		local spawned_unit, _ = pickup_system:spawn_pickup(swap_pickup_name, spawn_pos, spawn_rot, nil, nil, disable_time)
		local equipped_pickup_data = Pickups.by_name[swap_pickup_name]

		if equipped_pickup_data and equipped_pickup_data.on_drop_func then
			equipped_pickup_data.on_drop_func(spawned_unit, interactor_unit)
		end

		pickup_system:dropped(spawned_unit)

		return spawned_unit, swap_pickup_name
	end

	return nil, nil
end

return Pocketable
