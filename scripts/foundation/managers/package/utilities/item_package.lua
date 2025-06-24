-- chunkname: @scripts/foundation/managers/package/utilities/item_package.lua

local WeaponTemplateResourceDependencies = require("scripts/utilities/weapon_template_resource_dependencies")
local ItemPackage = {}
local dynamic_data_path = {}
local component_item_data_fields = {}
local next = next

ItemPackage._require_level_items = function (level_name, item_data)
	local num_nested_levels = LevelResource.nested_level_count(level_name)

	for i = 1, num_nested_levels do
		local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)

		ItemPackage._require_level_items(nested_level_name, item_data)
	end

	local components = rawget(_G, "Components") or require("scripts/components/components")

	if next(component_item_data_fields) == nil then
		for component_name, component in pairs(components) do
			if component.component_data then
				for data_name, data_info in pairs(component.component_data) do
					if data_info.filter == "item" then
						component_item_data_fields[component_name] = component_item_data_fields[component_name] or {}
						component_item_data_fields[component_name][data_name] = data_info.ui_type
					end

					if data_name == "editor_only" then
						component_item_data_fields[component_name] = component_item_data_fields[component_name] or {}
						component_item_data_fields[component_name][data_name] = data_info.value or false
					end
				end
			end
		end
	end

	local num_units = LevelResource.unit_count(level_name)

	for unit_i = 1, num_units do
		local unit_data = LevelResource.unit_data(level_name, unit_i)
		local num_components = DynamicData.get_table_size(unit_data, "component_guids") or 0

		for guid_i = 1, num_components do
			local component_id = DynamicData.get(unit_data, "component_guids", guid_i)
			local component_name = DynamicData.get(unit_data, "components", component_id, "name")

			table.clear(dynamic_data_path)

			dynamic_data_path[1] = "components"
			dynamic_data_path[2] = component_id
			dynamic_data_path[3] = "component_data"

			if component_item_data_fields[component_name] then
				for data_field, data_type in pairs(component_item_data_fields[component_name]) do
					dynamic_data_path[4] = data_field

					local editor_only_component_default = component_item_data_fields[component_name].editor_only

					if data_type == "resource" then
						ItemPackage._get_item_data_from_component(item_data, unit_data, editor_only_component_default, dynamic_data_path)
					elseif data_type == "resource_array" then
						ItemPackage._get_items_data_from_component(item_data, unit_data, editor_only_component_default, dynamic_data_path)
					end
				end
			end
		end
	end

	return item_data
end

ItemPackage._get_item_data_from_component = function (items, unit_data, editor_only_component_default, path)
	local data_field = path[#path]

	path[#path] = "editor_only"

	local editor_only = DynamicData.get(unit_data, unpack(path))

	if editor_only == nil then
		editor_only = editor_only_component_default
	end

	path[#path] = data_field

	if not editor_only then
		path[#path + 1] = "resource"

		local field_value = DynamicData.get(unit_data, unpack(path)) or ""

		if field_value ~= "" then
			ItemPackage._add_item_ref(items, field_value)
		end

		table.remove(path, #path)
	end
end

ItemPackage._get_items_data_from_component = function (items, unit_data, editor_only_component_default, path)
	local data_field = path[#path]

	path[#path] = "editor_only"

	local editor_only = DynamicData.get(unit_data, unpack(path))

	if editor_only == nil then
		editor_only = editor_only_component_default
	end

	path[#path] = data_field

	if not editor_only then
		local num_items = DynamicData.get_table_size(unit_data, unpack(path)) or 0
		local i = 1
		local found_items = 0

		while found_items <= num_items do
			path[#path + 1] = i
			path[#path + 1] = "resource"

			local field_value = DynamicData.get(unit_data, unpack(path)) or ""

			if field_value ~= nil then
				if field_value ~= "" then
					ItemPackage._add_item_ref(items, field_value)
				end

				found_items = found_items + 1
			end

			table.remove(path, #path)
			table.remove(path, #path)

			i = i + 1
		end
	end
end

ItemPackage._add_item_ref = function (items, item_name)
	local _item_table = items
	local ref_count = _item_table[item_name]

	if ref_count then
		ref_count = ref_count + 1
	else
		ref_count = 1
	end

	_item_table[item_name] = ref_count
end

local item_data = {}

ItemPackage.level_resource_dependency_packages = function (item_definitions, level_name)
	table.clear(item_data)

	item_data = ItemPackage._require_level_items(level_name, item_data)

	local item_dependencies = ItemPackage.compile_items_dependencies(item_data, item_definitions)

	return item_dependencies
end

ItemPackage.compile_resource_dependencies = function (item_entry_data, resource_dependencies)
	for key, value in pairs(item_entry_data) do
		if key == "vfx_resources" or key == "sfx_resources" then
			for i = 1, #value do
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

	local icon = item_entry_data.icon

	if icon and icon ~= "" then
		resource_dependencies[icon] = true
	end

	local hud_icon = item_entry_data.hud_icon

	if hud_icon and hud_icon ~= "" then
		resource_dependencies[hud_icon] = true
	end

	local resource = item_entry_data.resource or item_entry_data.base_unit

	if resource then
		resource_dependencies[resource] = true
	end

	local resource_by_item = item_entry_data.resource_by_item

	if resource_by_item then
		for _, resource in pairs(resource_by_item) do
			resource_dependencies[resource] = true
		end
	end

	local base_unit_1p = item_entry_data.base_unit_1p

	if base_unit_1p then
		resource_dependencies[base_unit_1p] = true
	end

	local weapon_template = item_entry_data.weapon_template

	if weapon_template and weapon_template ~= "" then
		local resource_list = WeaponTemplateResourceDependencies.generate(weapon_template)

		for i = 1, #resource_list do
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

ItemPackage.compile_item_dependencies = function (item, items_dictionary, out_result, optional_mission_template)
	local result = out_result or {}
	local item_entry = item

	if type(item_entry) == "string" then
		item_entry = rawget(items_dictionary, item_entry)
	end

	if not item_entry then
		Log.error("ItemPackage", "Unable to find item %s", item)

		return
	end

	return ItemPackage.compile_item_instance_dependencies(item_entry, items_dictionary, result, optional_mission_template)
end

ItemPackage.compile_item_instance_dependencies = function (item, items_dictionary, out_result, optional_mission_template)
	local result = out_result or {}
	local dependencies = item.resource_dependencies

	for dependency, _ in pairs(dependencies) do
		result[dependency] = true
	end

	local attachments = item.attachments

	if attachments then
		ItemPackage._resolve_item_packages_recursive(attachments, items_dictionary, result)
	end

	local projectile_items = item.projectile_items

	if projectile_items then
		for key, item_name in pairs(projectile_items) do
			if item_name and item_name ~= "" then
				local item_entry = rawget(items_dictionary, item_name)

				if not item_entry then
					Log.error("ItemPackage", "Unable to find item %s", item_name)

					return
				end

				local resource_dependencies = item_entry.resource_dependencies

				for resource_name, _ in pairs(resource_dependencies) do
					result[resource_name] = true
				end
			end
		end
	end

	local icon = item.icon

	if icon and icon ~= "" then
		result[icon] = true
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

	local traits = item.traits

	if traits then
		for i = 1, #traits do
			local trait = traits[i]
			local trait_id = trait.id
			local item_entry = rawget(items_dictionary, trait_id)

			if item_entry then
				local dependency = item_entry.icon_small

				if dependency and dependency ~= "" then
					result[dependency] = true
				end
			end
		end
	end

	return result
end

ItemPackage._resolve_item_packages_recursive = function (attachments, items_dictionary, result)
	for key, value in pairs(attachments) do
		if key == "item" then
			local item_name = type(value) == "table" and value.name or value

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
