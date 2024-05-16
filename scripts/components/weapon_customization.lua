-- chunkname: @scripts/components/weapon_customization.lua

local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local MasterItems = require("scripts/backend/master_items")
local LocalLoader = require("scripts/settings/equipment/local_items_loader")
local WeaponCustomization = component("WeaponCustomization")

WeaponCustomization.editor_init = function (self, unit)
	local in_editor = true
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
	self._slot_name_by_unit = {}
end

WeaponCustomization.editor_validate = function (self, unit)
	return true, ""
end

WeaponCustomization.init = function (self, unit)
	if self:get_data(unit, "editor_only") then
		return
	end

	local in_editor = false
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
	self._slot_name_by_unit = {}

	if not DEDICATED_SERVER then
		self:_customize(unit)
	end
end

WeaponCustomization._construct_attach_settings = function (self, unit, world, in_editor)
	local attach_settings = {
		from_script_component = true,
		is_first_person = false,
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
			EditorMasterItems.memoize(LocalLoader.get_items_from_metadata_db):next(function (data)
				self:_customize(unit, data)
			end)
		else
			Log.error("WeaponCustomization", "EditorMasterItems not defined, missing master_items plugin?")
		end

		attach_settings.item_definitions = item_definitions
	end

	return attach_settings
end

WeaponCustomization._customize = function (self, unit, item_definitions)
	if not Unit.is_valid(unit) then
		Log.error("WeaponCustomization", "Unit was destroyed before customize could be called", tostring(unit))

		return
	end

	local item = self:get_data(unit, "item")

	if item == "" then
		Log.error("WeaponCustomization", "Item definition: %s missing for unit: %s", item, unit)

		return
	end

	local attach_settings = self._attach_settings

	attach_settings.item_definitions = item_definitions or attach_settings.item_definitions

	local item_data = rawget(attach_settings.item_definitions, item)

	if not item_data then
		Log.error("WeaponCustomization", "Invalid item definition: %s for unit: %s", item, unit)

		return
	end

	local weapon_skin_item = self:get_data(unit, "weapon_skin_item")

	weapon_skin_item = weapon_skin_item or item_data.slot_weapon_skin

	local skin_data = weapon_skin_item and weapon_skin_item ~= "" and rawget(attach_settings.item_definitions, weapon_skin_item)

	self:spawn_item_attachments(unit, item_data, skin_data)

	for i, material_override in pairs(item_data.material_overrides) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
	end

	if skin_data then
		for i, material_override in pairs(skin_data.material_overrides) do
			VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
		end
	end

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

	local unit_material_overrides = self:get_data(unit, "material_override")

	for i, material_override in pairs(unit_material_overrides) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
	end
end

WeaponCustomization.spawn_item_attachments = function (self, unit, item_data, skin_data)
	local attach_settings = self._attach_settings
	local attachments = item_data.attachments
	local attachment_units = {}
	local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item_data, skin_data)

	if unit and attachments then
		local sorted_attachments = table.keys(attachments)

		table.sort(sorted_attachments)

		for i = 1, #sorted_attachments do
			local key = sorted_attachments[i]
			local attachment_slot_data = attachments[key]

			attachment_units = VisualLoadoutCustomization.attach_hierarchy(attachment_slot_data, skin_overrides, attach_settings, unit, attachment_units)

			if attachment_units then
				local num_attachments = #attachment_units

				for j = 1, num_attachments do
					Unit.set_data(unit, "attached_items", #attachment_units - j + 1, attachment_units[j])
				end
			end
		end
	end
end

WeaponCustomization.unspawn_items = function (self)
	local unit = self._unit
	local in_editor = self._in_editor

	self:destroy(unit, in_editor)
end

WeaponCustomization.enable = function (self, unit)
	return
end

WeaponCustomization.disable = function (self, unit)
	return
end

WeaponCustomization.editor_destroy = function (self, unit)
	self:destroy(unit, true)
end

WeaponCustomization.destroy = function (self, unit, is_editor)
	local world = self._world
	local i = 1
	local array_size = 0
	local attachment = Unit.get_data(unit, "attached_items", i)
	local unit_array_size = Unit.data_table_size(unit, "attached_items") or 0

	while array_size < unit_array_size do
		if attachment ~= nil then
			self:destroy(attachment, is_editor)

			if self._slot_name_by_unit[unit] then
				self._slot_name_by_unit[unit] = nil
			end

			World.destroy_unit(world, attachment)
			Unit.set_data(unit, "attached_items", i, nil)

			array_size = array_size + 1
		end

		i = i + 1
		attachment = Unit.get_data(unit, "attached_items", i)
	end
end

WeaponCustomization.unit_in_slot = function (self, slot_name)
	local slot_name_by_unit = self._slot_name_by_unit

	for item_unit, item_slot_name in pairs(slot_name_by_unit) do
		if item_slot_name == slot_name then
			return item_unit
		end
	end

	return nil
end

WeaponCustomization.update = function (self, unit, dt, t)
	return
end

WeaponCustomization.changed = function (self, unit)
	return
end

WeaponCustomization.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true,
}
WeaponCustomization.component_data = {
	editor_only = {
		ui_name = "Editor Only",
		ui_type = "check_box",
		value = true,
	},
	item = {
		filter = "item",
		ui_name = "Item",
		ui_type = "resource",
		value = "",
	},
	weapon_skin_item = {
		filter = "item",
		ui_name = "Weapon Skin Item",
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

return WeaponCustomization
