﻿-- chunkname: @scripts/components/minion_customization.lua

local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local MasterItems = require("scripts/backend/master_items")
local LocalLoader = require("scripts/settings/equipment/local_items_loader")
local MinionCustomization = component("MinionCustomization")

MinionCustomization.editor_init = function (self, unit)
	local in_editor = true
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._is_corpse = self:get_data(unit, "is_corpse")
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
end

MinionCustomization.editor_validate = function (self, unit)
	return true, ""
end

MinionCustomization.init = function (self, unit)
	if self:get_data(unit, "editor_only") then
		return
	end

	local in_editor = false
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._is_corpse = self:get_data(unit, "is_corpse")
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)

	if not DEDICATED_SERVER then
		self:_customize(unit)
	end
end

MinionCustomization._construct_attach_settings = function (self, unit, world, in_editor)
	local is_first_person = self:get_data(unit, "is_first_person")
	local attach_settings = {
		from_script_component = true,
		is_minion = true,
		world = world,
		character_unit = unit,
		in_editor = in_editor,
		is_first_person = is_first_person,
		lod_group = Unit.has_lod_group(unit, "lod") and Unit.lod_group(unit, "lod"),
		lod_shadow_group = Unit.has_lod_group(unit, "lod_shadow") and Unit.lod_group(unit, "lod_shadow")
	}

	if not in_editor then
		attach_settings.item_definitions = MasterItems.get_cached()
	else
		local item_definitions = {}

		if EditorMasterItems then
			EditorMasterItems.memoize(LocalLoader.get_items_from_metadata_db):next(function (data)
				self:_customize(unit, data)
			end)
		else
			Log.error("MinionCustomization", "EditorMasterItems not defined, missing master_items plugin?")
		end

		attach_settings.item_definitions = item_definitions
	end

	return attach_settings
end

MinionCustomization._customize = function (self, unit, item_definitions)
	if not Unit.is_valid(unit) then
		Log.error("MinionCustomization", "Unit was destroyed before customize could be called", tostring(unit))

		return
	end

	local attach_settings = self._attach_settings
	local item_table = self:get_data(unit, "attachment_items")
	local global_material_override_table = self:get_data(unit, "global_material_override")

	attach_settings.item_definitions = item_definitions or attach_settings.item_definitions

	self:spawn_items(item_table)

	if attach_settings.lod_group then
		local bv = LODGroup.compile_time_bounding_volume(attach_settings.lod_group)

		if bv then
			LODGroup.override_bounding_volume(attach_settings.lod_group, bv)
		end
	end

	if attach_settings.lod_shadow_group then
		local bv = LODGroup.compile_time_bounding_volume(attach_settings.lod_shadow_group)

		if bv then
			LODGroup.override_bounding_volume(attach_settings.lod_shadow_group, bv)
		end
	end

	for i, material_override in pairs(global_material_override_table) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self.in_editor)
	end
end

MinionCustomization.spawn_items = function (self, items)
	local unit = self._unit
	local attach_settings = self._attach_settings
	local item_definitions = attach_settings.item_definitions
	local is_first_person = attach_settings.is_first_person
	local in_editor = self._in_editor
	local is_corpse = self._is_corpse

	for i, item_name in pairs(items) do
		if item_name ~= "" then
			local item_data = rawget(item_definitions, item_name)

			if item_data then
				if not is_first_person or item_data.show_in_1p then
					local item_unit, attachment_units = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit, nil, nil, nil)

					if item_unit then
						Unit.set_data(unit, "attached_items", i, item_unit)
					end

					if attachment_units then
						local num_attachments = #attachment_units

						for j = 1, num_attachments do
							Unit.set_data(item_unit, "attached_items", #attachment_units - j + 1, attachment_units[j])
						end
					end

					VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_1", i), in_editor)
					VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_2", i), in_editor)
					VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_3", i), in_editor)

					if is_corpse then
						local num_lights = Unit.num_lights(item_unit)

						for jj = 1, num_lights do
							local light = Unit.light(item_unit, jj)

							Light.set_enabled(light, false)
						end

						Unit.set_vector4_for_materials(item_unit, "emissive_color_intensity", Color(0, 0, 0, 0), true)
					end
				end
			else
				Log.error("MinionCustomization", "Item definition for %s missing", item_name)
			end
		end
	end
end

MinionCustomization.enable = function (self, unit)
	return
end

MinionCustomization.disable = function (self, unit)
	return
end

MinionCustomization.editor_destroy = function (self, unit)
	self:destroy(unit)
end

MinionCustomization.destroy = function (self, unit)
	local i = 1
	local array_size = 0
	local attachment = Unit.get_data(unit, "attached_items", i)
	local unit_array_size = Unit.data_table_size(unit, "attached_items") or 0

	while array_size < unit_array_size do
		if attachment ~= nil then
			self:destroy(attachment)
			World.destroy_unit(self._world, attachment)
			Unit.set_data(unit, "attached_items", i, nil)

			array_size = array_size + 1
		end

		i = i + 1
		attachment = Unit.get_data(unit, "attached_items", i)
	end
end

MinionCustomization.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true
}
MinionCustomization.component_data = {
	editor_only = {
		ui_type = "check_box",
		value = false,
		ui_name = "Editor Only",
		category = "Settings"
	},
	is_first_person = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is First Person",
		category = "Settings"
	},
	is_corpse = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is Corpse",
		category = "Settings"
	},
	attachment_items = {
		category = "Attachments",
		ui_type = "resource_array",
		size = 3,
		ui_name = "Item",
		filter = "item"
	},
	attachment_material_override_1 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 1 for Item"
	},
	attachment_material_override_2 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 2 for Item"
	},
	attachment_material_override_3 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 3 for Item"
	},
	global_material_override = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Global Material Override"
	}
}

return MinionCustomization
