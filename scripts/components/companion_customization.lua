-- chunkname: @scripts/components/companion_customization.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local LocalItemsLoader = require("scripts/settings/equipment/local_items_loader")
local MasterItems = require("scripts/backend/master_items")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local CompanionCustomization = component("CompanionCustomization")

CompanionCustomization.editor_init = function (self, unit)
	local in_editor = true
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
	self._disable_fur_shells = self:get_data(unit, "disable_fur_shells")
end

CompanionCustomization.editor_validate = function (self, unit)
	return true, ""
end

CompanionCustomization.init = function (self, unit)
	if self:get_data(unit, "editor_only") then
		return
	end

	local in_editor = false
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)

	if not DEDICATED_SERVER then
		self:_customize(unit)
	end
end

CompanionCustomization._construct_attach_settings = function (self, unit, world, in_editor)
	local attach_settings = {
		from_script_component = true,
		from_ui_profile_spawner = false,
		is_first_person = false,
		is_minion = true,
		world = world,
		character_unit = unit,
		in_editor = in_editor,
		lod_group = Unit.has_lod_group(unit, "lod") and Unit.lod_group(unit, "lod"),
		lod_shadow_group = Unit.has_lod_group(unit, "lod_shadow") and Unit.lod_group(unit, "lod_shadow"),
	}

	if not in_editor then
		attach_settings.item_definitions = MasterItems.get_cached()
	else
		local item_definitions = {}

		if EditorMasterItems then
			EditorMasterItems.memoize(LocalItemsLoader.get_items_from_metadata_db):next(function (data)
				self:_customize(unit, data)
			end)
		else
			Log.error("CompanionCustomization", "EditorMasterItems not defined, missing master_items plugin?")
		end

		attach_settings.item_definitions = item_definitions
	end

	return attach_settings
end

CompanionCustomization._customize = function (self, unit, item_definitions)
	if not Unit.is_valid(unit) then
		Log.error("CompanionCustomization", "Unit was destroyed before customize could be called", tostring(unit))

		return
	end

	local item = self:get_data(unit, "item")

	if item == "" then
		Log.error("CompanionCustomization", "Item definition: %s missing for unit: %s", item, unit)

		return
	end

	local attach_settings = self._attach_settings

	attach_settings.item_definitions = item_definitions or attach_settings.item_definitions

	local item_data = rawget(attach_settings.item_definitions, item)

	if not item_data then
		Log.error("CompanionCustomization", "Invalid item definition: %s for unit: %s", item, unit)

		return
	end

	self:_spawn_item_attachments(item_data)

	if item_data.material_overrides then
		for _, material_override in pairs(item_data.material_overrides) do
			VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
		end
	end

	if attach_settings.lod_group then
		local bounding_volume = LODGroup.compile_time_bounding_volume(attach_settings.lod_group)

		if bounding_volume then
			LODGroup.override_bounding_volume(attach_settings.lod_group, bounding_volume)
		end
	end

	if attach_settings.lod_shadow_group then
		local bounding_volume = LODGroup.compile_time_bounding_volume(attach_settings.lod_shadow_group)

		if bounding_volume then
			LODGroup.override_bounding_volume(attach_settings.lod_shadow_group, bounding_volume)
		end
	end

	local material_override_table = self:get_data(unit, "material_override")

	for _, material_override in pairs(material_override_table) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
	end
end

CompanionCustomization._spawn_item_attachments = function (self, item_data)
	local unit = self._unit
	local attach_settings = self._attach_settings
	local attachments = item_data.attachments
	local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item_data)

	if unit and attachments then
		local sorted_attachments = table.keys(attachments)

		table.sort(sorted_attachments)

		local num_item_names = 1
		local num_attached_units = 0

		for ii = 1, #sorted_attachments do
			local key = sorted_attachments[ii]
			local attachment_slot_data = attachments[key]
			local map_attachments, map_bind_poses, map_item_names, mission_template = false, false, false
			local attachments_units_by_unit, _, _, _, _ = VisualLoadoutCustomization.attach_hierarchy(attachment_slot_data, skin_overrides, attach_settings, unit, item_data.name, key, map_attachments, map_bind_poses, map_item_names, mission_template)
			local all_attachment_units = attachments_units_by_unit[unit]
			local num_attachments = #all_attachment_units

			for jj = 1, num_attachments do
				Unit.set_data(unit, "attached_items", num_attached_units + (num_attachments - jj + 1), all_attachment_units[jj])
			end

			if not self._disable_fur_shells then
				CompanionVisualLoadout.assign_fur_material(unit, attachments_units_by_unit)
			end

			local item_name = attachment_slot_data.item

			if item_name ~= nil and item_name ~= "" then
				Unit.set_data(unit, "attached_item_names", num_item_names, item_name)

				for jj = 1, num_attachments do
					Unit.set_data(unit, "attached_units_lookup", num_item_names, jj, all_attachment_units[jj])
				end

				num_item_names = num_item_names + 1
			end

			num_attached_units = num_attached_units + num_attachments
		end
	end
end

CompanionCustomization.unspawn_items = function (self)
	local unit = self._unit
	local in_editor = self._in_editor

	self:destroy(unit, in_editor)
end

CompanionCustomization.enable = function (self, unit)
	return
end

CompanionCustomization.disable = function (self, unit)
	return
end

CompanionCustomization.editor_destroy = function (self, unit)
	self:destroy(unit, true)
end

CompanionCustomization.destroy = function (self, unit, is_editor)
	local world = self._world
	local index = 1
	local array_size = 0
	local attachment = Unit.get_data(unit, "attached_items", index)
	local unit_array_size = Unit.data_table_size(unit, "attached_items") or 0

	while array_size < unit_array_size do
		if attachment ~= nil then
			self:destroy(attachment, is_editor)
			World.destroy_unit(world, attachment)
			Unit.set_data(unit, "attached_items", index, nil)

			array_size = array_size + 1
		end

		index = index + 1
		attachment = Unit.get_data(unit, "attached_items", index)
	end
end

CompanionCustomization.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true,
}
CompanionCustomization.component_data = {
	editor_only = {
		ui_name = "Editor Only",
		ui_type = "check_box",
		value = true,
	},
	disable_fur_shells = {
		ui_name = "Disable Fur Shells",
		ui_type = "check_box",
		value = false,
	},
	item = {
		filter = "item",
		ui_name = "Item",
		ui_type = "resource",
		value = "",
	},
	material_override = {
		size = 1,
		ui_name = "Material Override",
		ui_type = "text_box_array",
		validator = "contentpathsallowed",
	},
}

return CompanionCustomization
