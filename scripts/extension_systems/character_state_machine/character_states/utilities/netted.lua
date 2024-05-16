-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/netted.lua

local CharacterStateNettedSettings = require("scripts/settings/character_state/character_state_netted_settings")
local Interrupt = require("scripts/utilities/attack/interrupt")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local anim_settings = CharacterStateNettedSettings.anim_settings
local Netted = {}

Netted.enter = function (unit, animation_extension, fx_extension, breed, attacker_breed, locomotion_steering_component, movement_state_component, t)
	Interrupt.ability_and_action(t, unit, "netted", nil)
	PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)

	local cached_items, breed_name = MasterItems.get_cached(), breed.name
	local target_breed_items = attacker_breed.target_breed_items
	local net_item_name = target_breed_items.netted[breed_name]
	local net_item = cached_items[net_item_name]

	PlayerUnitVisualLoadout.equip_item_to_slot(unit, net_item, "slot_net", nil, t)
	animation_extension:anim_event(anim_settings.netted_3p_anim_event)
	animation_extension:anim_event_1p(anim_settings.netted_1p_anim_event)

	locomotion_steering_component.move_method = "script_driven"
	locomotion_steering_component.velocity_wanted = Vector3.zero()
	locomotion_steering_component.calculate_fall_velocity = false
	movement_state_component.method = "idle"
end

Netted.try_exit = function (unit, inventory_component, visual_loadout_extension, unit_data_extension, t)
	if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_net") then
		Netted.exit(unit, unit_data_extension, t)
	end
end

Netted.exit = function (unit, unit_data_extension, t)
	local slot_name = "slot_net"

	PlayerUnitVisualLoadout.unequip_item_from_slot(unit, slot_name, t)

	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	disabled_character_state_component.disabling_type = "none"
	disabled_character_state_component.has_reached_drag_position = false
end

Netted.calculate_drag_position = function (locomotion_component, navigation_extension, netting_unit, nav_world)
	local unit_position = locomotion_component.position
	local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()

	if not latest_position_on_nav_mesh then
		return unit_position
	end

	if not netting_unit or not ALIVE[netting_unit] then
		return unit_position
	end

	local netting_unit_position = POSITION_LOOKUP[netting_unit]
	local direction = Vector3.normalize(unit_position - netting_unit_position)
	local FRONTAL_OFFSET = 2
	local sample_position = netting_unit_position + direction * FRONTAL_OFFSET

	sample_position.z = unit_position.z

	local traverse_logic = navigation_extension:traverse_logic()
	local _, end_position = GwNavQueries.raycast(nav_world, latest_position_on_nav_mesh, sample_position, traverse_logic)

	return end_position
end

return Netted
