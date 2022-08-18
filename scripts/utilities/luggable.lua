local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Luggable = {}
local SLOT_LUGGABLE = "slot_luggable"

Luggable.drop_luggable = function (t, unit, inventory_component, visual_loadout_extension, enable_physics)
	if not PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_luggable") then
		return
	end

	local unit_data_extension, existing_unit = nil

	if enable_physics then
		unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(SLOT_LUGGABLE)
		existing_unit = inventory_slot_component.existing_unit_3p
	end

	PlayerUnitVisualLoadout.unequip_item_from_slot(unit, SLOT_LUGGABLE, t)

	local default_wielded_slot_name = Managers.state.game_mode:default_wielded_slot_name()

	PlayerUnitVisualLoadout.wield_slot(default_wielded_slot_name, unit, t)

	if existing_unit and Managers.state.game_session:is_server() then
		local first_person_component = unit_data_extension:read_component("first_person")
		local locomotion_component = unit_data_extension:read_component("locomotion")

		Luggable.enable_physics(first_person_component, locomotion_component, existing_unit)
	end
end

Luggable.enable_physics = function (first_person_component, locomotion_component, existing_unit)
	local look_position = first_person_component.position
	local look_rotation = first_person_component.rotation
	local look_direction = Quaternion.forward(look_rotation)
	local locomotion_extension = ScriptUnit.extension(existing_unit, "locomotion_system")
	local projectile_locomotion_template = locomotion_extension:locomotion_template()
	local throw_configuration = projectile_locomotion_template.throw_parameters.drop
	local inherit_owner_velocity_percentage = throw_configuration.inherit_owner_velocity_percentage
	local player_velocity = locomotion_component.velocity_current
	local player_velocity_contribution = player_velocity * inherit_owner_velocity_percentage
	local throw_speed = throw_configuration.speed
	local throw_velocity = throw_speed * look_direction
	local new_velocity = player_velocity_contribution + throw_velocity
	local angular_velocity = Vector3.zero()

	locomotion_extension:switch_to_engine(look_position, look_rotation, new_velocity, angular_velocity)
end

Luggable.equip_to_player_unit = function (player_unit, luggable_unit, t)
	local locomotion_extension = ScriptUnit.extension(luggable_unit, "locomotion_system")

	locomotion_extension:switch_to_carried(player_unit)

	local item_definitions = MasterItems.get_cached()
	local pickup_name = Unit.get_data(luggable_unit, "pickup_type")
	local pickup_data = Pickups.by_name[pickup_name]
	local inventory_item = item_definitions[pickup_data.inventory_item]

	PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, inventory_item, SLOT_LUGGABLE, luggable_unit, t)
	PlayerUnitVisualLoadout.wield_slot(SLOT_LUGGABLE, player_unit, t)
end

Luggable.link_to_player_unit = function (world, player_unit, luggable_unit, item)
	local attach_node = item.attach_node
	local breed_attach_node = item.breed_attach_node
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local breed_name = unit_data_extension:breed_name()
	local attach_node_to_use = breed_attach_node[breed_name] or attach_node
	local node = Unit.node(player_unit, attach_node_to_use)
	local map_nodes = false

	World.link_unit(world, luggable_unit, 1, player_unit, node, map_nodes)

	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")

	visual_loadout_extension:force_update_item_visibility()
end

Luggable.unlink_from_player_unit = function (world, luggable_unit)
	local reset_scene_graph = false

	World.unlink_unit(world, luggable_unit, reset_scene_graph)
	Unit.set_unit_visibility(luggable_unit, true, true)
end

return Luggable
