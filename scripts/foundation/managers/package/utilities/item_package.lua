local WeaponTemplateResourceDependencies = require("scripts/utilities/weapon_template_resource_dependencies")
local ItemPackage = {}

local function _require_level_items(level_name, item_data)
	local num_nested_levels = LevelResource.nested_level_count(level_name)

	for i = 1, num_nested_levels, 1 do
		local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)

		_require_level_items(nested_level_name, item_data)
	end

	local file_path = level_name .. "_item_dep"

	if Application.can_get_resource("lua", file_path) then
		local file_data = require(file_path)

		table.merge(item_data.minion_items, file_data.minion_items)
		table.merge(item_data.player_items, file_data.player_items)

		if file_data.weapon_items then
			table.merge(item_data.weapon_items, file_data.weapon_items)
		end
	end

	return item_data
end

ItemPackage.level_resource_dependency_packages = function (item_definitions, level_name, item_data)
	item_data = item_data or {
		minion_items = {},
		player_items = {},
		weapon_items = {}
	}
	item_data = _require_level_items(level_name, item_data)
	local packages_to_load = {}

	if item_data.player_items then
		local player_dependencies = ItemPackage.compile_items_dependencies(item_data.player_items, item_definitions)

		table.merge(packages_to_load, player_dependencies)
	end

	if item_data.minion_items then
		local minion_dependencies = ItemPackage.compile_items_dependencies(item_data.minion_items, item_definitions)

		table.merge(packages_to_load, minion_dependencies)
	end

	if item_data.weapon_items then
		local weapon_dependencies = ItemPackage.compile_items_dependencies(item_data.weapon_items, item_definitions)

		table.merge(packages_to_load, weapon_dependencies)
	end

	return packages_to_load
end

ItemPackage.compile_resource_dependencies = function (item_entry_data, resource_dependencies)
	for key, value in pairs(item_entry_data) do
		if key == "vfx_resources" or key == "sfx_resources" then
			for i = 1, #value, 1 do
				local vfx_resource = value[i]
				resource_dependencies[vfx_resource] = true
			end
		elseif type(value) == "table" then
			ItemPackage.compile_resource_dependencies(value, resource_dependencies)
		end
	end

	local material_overrides = item_entry_data.material_overrides

	if material_overrides then
		local ItemMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/item_material_overrides")

		for _, material_override in pairs(material_overrides) do
			if material_override ~= "" then
				local material_override_data = ItemMaterialOverrides[material_override]

				for resource_name, _ in pairs(material_override_data.resource_dependencies) do
					resource_dependencies[resource_name] = true
				end
			end
		end
	end

	local texture_resource = item_entry_data.texture_resource

	if texture_resource and texture_resource ~= "" then
		resource_dependencies[texture_resource] = true
	end

	local resource = item_entry_data.resource or item_entry_data.base_unit

	if resource then
		resource_dependencies[resource] = true
	end

	local base_unit_1p = item_entry_data.base_unit_1p

	if base_unit_1p then
		resource_dependencies[base_unit_1p] = true
	end

	local weapon_template = item_entry_data.weapon_template

	if weapon_template and weapon_template ~= "" then
		local resource_list = WeaponTemplateResourceDependencies.generate(weapon_template)

		for i = 1, #resource_list, 1 do
			local resource_name = resource_list[i]
			resource_dependencies[resource_name] = true
		end
	end
end

ItemPackage.compile_items_dependencies = function (items, items_dictionary, optional_mission_template)
	local result = {}

	for item_name, _ in pairs(items) do
		ItemPackage.compile_item_dependencies(item_name, items_dictionary, result, optional_mission_template)
	end

	return result
end

ItemPackage.compile_item_dependencies = function (item_name, items_dictionary, out_result, optional_mission_template)
	local result = out_result or {}
	local item_entry = rawget(items_dictionary, item_name)

	if not item_entry then
		Log.error("ItemPackage", "Unable to find item %s", item_name)

		return
	end

	return ItemPackage.compile_item_instance_dependencies(item_entry, items_dictionary, result, optional_mission_template)
end

ItemPackage.compile_item_instance_dependencies = function (item, items_dictionary, out_result, optional_mission_template)
	local result = out_result or {}

	fassert(item ~= nil, "Can't resolve dependencies for nil")
	fassert(type(item) == "table", "Item %s was not a table (%s)", item, type(item))

	local dependencies = item.resource_dependencies

	fassert(dependencies, "Dependencies was nil for %s", item.name)

	for dependency, _ in pairs(dependencies) do
		result[dependency] = true
	end

	local attachments = item.attachments

	if attachments then
		ItemPackage._resolve_item_packages_recursive(attachments, items_dictionary, result)
	end

	local weapon_skin_item = item.slot_weapon_skin

	if weapon_skin_item and weapon_skin_item ~= "" then
		ItemPackage.compile_item_dependencies(weapon_skin_item, items_dictionary, result, optional_mission_template)
	end

	if optional_mission_template then
		local face_state_machine_key = optional_mission_template.face_state_machine_key
		local dependency = face_state_machine_key and item[face_state_machine_key]

		if dependency and dependency ~= "" then
			result[dependency] = true
		end
	end

	return result
end

ItemPackage._resolve_item_packages_recursive = function (attachments, items_dictionary, result)
	for key, value in pairs(attachments) do
		if key == "item" then
			local item_name = (type(value) == "table" and value.name) or value

			if item_name ~= "" then
				local item_entry = rawget(items_dictionary, item_name)

				if not item_entry then
					Log.error("ItemPackage", "Unable to find item %s", item_name)

					return
				end

				local child_attachments = item_entry.attachments

				if child_attachments then
					ItemPackage._resolve_item_packages_recursive(child_attachments, items_dictionary, result)
				end

				local resource_dependencies = item_entry.resource_dependencies

				for resource_name, _ in pairs(resource_dependencies) do
					result[resource_name] = true
				end
			end
		elseif type(value) == "table" then
			ItemPackage._resolve_item_packages_recursive(value, items_dictionary, result)
		end
	end
end

return ItemPackage
