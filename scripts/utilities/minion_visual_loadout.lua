local MinionVisualLoadout = {
	attachment_unit_and_node_from_node_name = function (item, fx_source_name, optional_lookup_fx_sources)
		local node_name = fx_source_name
		local lookup_fx_sources = (optional_lookup_fx_sources == nil and true) or optional_lookup_fx_sources

		if lookup_fx_sources then
			local fx_sources = item.item_data.fx_sources
			node_name = fx_sources[fx_source_name]
		end

		if Unit.has_node(item.unit, node_name) then
			local node = Unit.node(item.unit, node_name)

			return item.unit, node
		end

		local attachments = item.attachments
		local num_attachments = #attachments

		for i = 1, num_attachments, 1 do
			local unit = attachments[i]

			if Unit.has_node(unit, node_name) then
				local node = Unit.node(unit, node_name)

				return unit, node
			end
		end

		return nil, nil
	end,
	resolve = function (inventory_template, optional_zone_id, optional_used_weapon_slot_names, breed_name, inventory_seed)
		local inventory = inventory_template[optional_zone_id] or inventory_template.default

		fassert(not inventory_template.has_gib_overrides or #inventory > 0, "[MinionVisualLoadout] Tried to resolve inventory with zone id %q for breed %q but that inventory was empty.", optional_zone_id or "default", breed_name)

		if inventory_template.has_gib_overrides then
			local inventory_index = nil
			inventory_seed, inventory_index = math.next_random(inventory_seed, 1, #inventory)
			inventory = inventory[inventory_index]
		end

		if optional_used_weapon_slot_names then
			inventory = table.clone(inventory)

			for slot_name, slot_data in pairs(inventory) do
				if slot_data.is_weapon and not optional_used_weapon_slot_names[slot_name] then
					inventory[slot_name] = nil
				end
			end
		end

		return inventory, inventory_seed
	end
}

return MinionVisualLoadout
