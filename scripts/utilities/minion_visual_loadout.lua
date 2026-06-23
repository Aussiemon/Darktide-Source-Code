-- chunkname: @scripts/utilities/minion_visual_loadout.lua

local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local MinionVisualLoadout = {}
local _attach_settings = {
	attach_pose = nil,
	character_unit = nil,
	extension_manager = nil,
	from_script_component = false,
	from_ui_profile_spawner = false,
	is_minion = true,
	item_definitions = nil,
	lod_group = nil,
	lod_shadow_group = nil,
	spawn_with_extensions = nil,
	unit_spawner = nil,
	world = nil,
}

MinionVisualLoadout.create_visual_loadout_slot_entry = function (unit, lod_group, lod_shadow_group, world, item_slot_data, random_seed, item_definitions)
	local items = item_slot_data.items
	local num_items = #items
	local new_seed, item_index = math.next_random(random_seed, 1, num_items)
	local item_name = items[item_index]
	local item_data = item_definitions[item_name]
	local attach_node_name = item_data.unwielded_attach_node or item_data.attach_node
	local attach_node

	if tonumber(attach_node_name) ~= nil then
		attach_node = tonumber(attach_node_name)
	else
		attach_node = Unit.node(unit, item_data.unwielded_attach_node or item_data.attach_node)
	end

	local item_unit, attachments

	if DEDICATED_SERVER and not item_slot_data.is_weapon then
		item_unit = nil
		attachments = nil
	else
		_attach_settings.world = world
		_attach_settings.unit_spawner = Managers.state.unit_spawner
		_attach_settings.character_unit = unit
		_attach_settings.item_definitions = item_definitions
		_attach_settings.attach_pose = Unit.world_pose(unit, attach_node)
		_attach_settings.lod_group = lod_group
		_attach_settings.lod_shadow_group = lod_shadow_group

		if item_slot_data.spawn_with_extensions then
			_attach_settings.extension_manager = Managers.state.extension
			_attach_settings.spawn_with_extensions = true
		else
			_attach_settings.extension_manager = nil
			_attach_settings.spawn_with_extensions = nil
		end

		local mission_template, equipment

		item_unit, attachments = VisualLoadoutCustomization.spawn_item(item_data, _attach_settings, unit, false, false, false, mission_template, equipment)
		_attach_settings.world = nil
		_attach_settings.unit_spawner = nil
		_attach_settings.character_unit = nil
		_attach_settings.item_definitions = nil
		_attach_settings.attach_pose = nil
		_attach_settings.lod_group = nil
		_attach_settings.lod_shadow_group = nil
		_attach_settings.extension_manager = nil
		_attach_settings.spawn_with_extensions = nil
	end

	local drop_on_death = item_slot_data.drop_on_death
	local shield_settings = item_slot_data.shield_settings

	if shield_settings then
		shield_settings = table.create_copy(nil, shield_settings)
		shield_settings.current_state = 0
	end

	local slot_entry = {
		state = "unwielded",
		visible = true,
		unit = item_unit,
		attachments = attachments and attachments[item_unit],
		item_data = item_data,
		drop_on_death = drop_on_death,
		starts_invisible = item_slot_data.starts_invisible,
		shield_settings = shield_settings,
	}

	return slot_entry, new_seed
end

MinionVisualLoadout.attachment_unit_and_node_from_node_name = function (item, fx_source_name, optional_lookup_fx_sources)
	local node_name = fx_source_name
	local lookup_fx_sources = optional_lookup_fx_sources == nil and true or optional_lookup_fx_sources

	if lookup_fx_sources then
		local fx_sources = item.item_data.fx_sources

		node_name = fx_sources[fx_source_name]
	end

	if Unit.has_node(item.unit, node_name) then
		local node = Unit.node(item.unit, node_name)

		return item.unit, node, node_name
	end

	local attachments = item.attachments
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local unit = attachments[ii]

		if Unit.has_node(unit, node_name) then
			local node = Unit.node(unit, node_name)

			return unit, node, node_name
		end
	end

	return nil, nil, nil
end

MinionVisualLoadout.resolve = function (inventory_template, optional_zone_id, optional_used_weapon_slot_names, breed_name, inventory_seed)
	local inventory = inventory_template[optional_zone_id] or inventory_template.default
	local inventory_index

	inventory_seed, inventory_index = math.next_random(inventory_seed, 1, #inventory)
	inventory = inventory[inventory_index]

	if optional_used_weapon_slot_names then
		inventory = table.clone(inventory)

		local inventory_slots = inventory.slots

		for slot_name, slot_data in pairs(inventory_slots) do
			if slot_data.is_weapon and not optional_used_weapon_slot_names[slot_name] then
				inventory_slots[slot_name] = nil
			end
		end
	end

	return inventory, inventory_seed
end

return MinionVisualLoadout
