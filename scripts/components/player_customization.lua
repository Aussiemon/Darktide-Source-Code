local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local MasterItems = require("scripts/backend/master_items")
local LocalLoader = require("scripts/settings/equipment/local_items_loader")
local PlayerCustomization = component("PlayerCustomization")

PlayerCustomization.editor_init = function (self, unit)
	local in_editor = true
	local world = Unit.world(unit)
	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
	self._units_by_slot_name = {}
end

PlayerCustomization.init = function (self, unit)
	if self:get_data(unit, "editor_only") then
		return
	end

	local in_editor = false
	local world = Unit.world(unit)
	self._unit = unit
	self._world = world
	self._in_editor = in_editor
	self._attach_settings = self:_construct_attach_settings(unit, world, in_editor)
	self._units_by_slot_name = {}

	if not DEDICATED_SERVER then
		self:_customize(unit)
	end
end

PlayerCustomization._construct_attach_settings = function (self, unit, world, in_editor)
	local is_first_person = self:get_data(unit, "is_first_person")
	local attach_settings = {
		from_script_component = true,
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
			Log.error("PlayerCustomization", "EditorMasterItems not defined, missing master_items plugin?")
		end

		attach_settings.item_definitions = item_definitions
	end

	return attach_settings
end

PlayerCustomization._customize = function (self, unit, item_definitions)
	if not Unit.is_valid(unit) then
		Log.error("PlayerCustomization", "Unit was destroyed before customize could be called", tostring(unit))

		return
	end

	local attach_settings = self._attach_settings
	local item_names = self:get_data(unit, "attachment_items")
	local face_item_name = self:get_data(unit, "face_item")
	local face_attachment_items = self:get_data(unit, "face_attachments")
	local global_material_override_table = self:get_data(unit, "global_material_override")
	local item_defs = item_definitions or attach_settings.item_definitions
	attach_settings.item_definitions = item_defs
	local item_table = {}

	for _, item_name in pairs(item_names) do
		local item = rawget(item_defs, item_name)
		item = item or false
		item_table[#item_table + 1] = item
	end

	self:spawn_items(item_table)

	local face_item_index = #item_table + 1
	local face_unit = self:_spawn_facial_items(face_item_name, face_attachment_items, face_item_index)

	if face_unit then
		local face_sm_override = self:get_data(unit, "face_sm_override")
		local face_sm_init_event = self:get_data(unit, "face_sm_init_event")

		self:_override_face_anim(face_unit, face_sm_override, face_sm_init_event)
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

	for i, material_override in pairs(global_material_override_table) do
		VisualLoadoutCustomization.apply_material_override(unit, unit, false, material_override, self._in_editor)
	end

	local disable_all_culling = self:get_data(unit, "disable_all_culling")

	if disable_all_culling then
		Unit.set_unit_culling(unit, false, true)
	end

	local force_highest_lod = self:get_data(unit, "force_highest_lod")

	if force_highest_lod then
		if Unit.has_lod_group(unit, "lod") then
			local lod_group = Unit.lod_group(unit, "lod")

			LODGroup.set_static_select(lod_group, 0)
		else
			if Unit.has_lod_object(unit, "lod") then
				local lod = Unit.lod_object(unit, "lod")

				LODObject.set_static_select(lod, 0)
			end

			local unit_array_size = Unit.data_table_size(unit, "attached_items") or 0

			for i = 1, unit_array_size do
				local attachment = Unit.get_data(unit, "attached_items", i)

				if Unit.has_lod_object(attachment, "lod") then
					local lod = Unit.lod_object(attachment, "lod")

					LODObject.set_static_select(lod, 0)
				end
			end
		end
	end
end

PlayerCustomization.spawn_items = function (self, items, optional_mission_template)
	local unit = self._unit
	local attach_settings = self._attach_settings
	local is_first_person = attach_settings.is_first_person
	local in_editor = self._in_editor

	for i = 1, #items do
		local item = items[i]

		if item then
			local item_data_clone = table.clone_instance(item)

			if not is_first_person or item_data_clone.show_in_1p then
				local item_unit, attachment_units = VisualLoadoutCustomization.spawn_item(item_data_clone, attach_settings, unit, nil, optional_mission_template)

				if item_unit then
					Unit.set_data(unit, "attached_items", i, item_unit)
				end

				local slots = item_data_clone.slots

				if slots then
					local units_by_slot_name = self._units_by_slot_name
					local slot_name = slots[1]

					if slot_name then
						units_by_slot_name[slot_name] = item_unit
					end
				end

				if attachment_units then
					local num_attachments = #attachment_units

					for j = 1, num_attachments do
						Unit.set_data(item_unit, "attached_items", num_attachments - j + 1, attachment_units[j])
					end
				end

				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_1", i), in_editor)
				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_2", i), in_editor)
				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_3", i), in_editor)
				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_4", i), in_editor)
				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_5", i), in_editor)
				VisualLoadoutCustomization.apply_material_override(item_unit, unit, false, self:get_data(unit, "attachment_material_override_6", i), in_editor)
			end
		end
	end
end

PlayerCustomization._spawn_facial_items = function (self, face_item_name, face_attachment_items, face_item_index)
	local face_unit, face_attachment_units = nil

	if self._attach_settings.is_first_person then
		return
	end

	local face_item_data = rawget(self._attach_settings.item_definitions, face_item_name)

	if face_item_data then
		local face_item_data_clone = table.clone(face_item_data)

		if face_item_data_clone.attachments == nil then
			face_item_data_clone.attachments = {}
		end

		for k, item in pairs(face_attachment_items) do
			face_item_data_clone.attachments[k] = {
				item = item
			}
		end

		face_unit, face_attachment_units = VisualLoadoutCustomization.spawn_item(face_item_data_clone, self._attach_settings, self._unit)

		if face_unit then
			Unit.set_data(self._unit, "attached_items", face_item_index, face_unit)
		end

		if face_attachment_units then
			local num_attachments = #face_attachment_units

			for j = 1, num_attachments do
				Unit.set_data(face_unit, "attached_items", num_attachments - j + 1, face_attachment_units[j])
			end
		end

		local face_slots = face_item_data.slots

		if face_slots then
			local face_slot = face_slots[1]
			local units_by_slot_name = self._units_by_slot_name
			units_by_slot_name[face_slot] = face_unit
		end

		local face_material_overrides = self:get_data(self._unit, "face_material_overrides")

		for i = 1, #face_material_overrides do
			VisualLoadoutCustomization.apply_material_override(face_unit, self._unit, false, face_material_overrides[i], self._in_editor)
		end
	end

	return face_unit
end

PlayerCustomization._override_face_anim = function (self, face_unit, resource, init_event)
	if resource ~= nil and resource ~= "" then
		Unit.set_animation_state_machine(face_unit, resource)
		Unit.enable_animation_state_machine(face_unit)
	end

	if Unit.has_animation_state_machine(face_unit) and Unit.has_animation_event(face_unit, init_event) then
		Unit.animation_event(face_unit, init_event)
	end
end

PlayerCustomization.unspawn_items = function (self)
	local unit = self._unit
	local in_editor = self._in_editor

	self:destroy(unit, in_editor)
end

PlayerCustomization.enable = function (self, unit)
	return
end

PlayerCustomization.disable = function (self, unit)
	return
end

PlayerCustomization.editor_destroy = function (self, unit)
	self:destroy(unit, true)
end

PlayerCustomization.destroy = function (self, unit, is_editor)
	local world = self._world
	local i = 1
	local array_size = 0
	local attachment = Unit.get_data(unit, "attached_items", i)
	local unit_array_size = Unit.data_table_size(unit, "attached_items") or 0

	while array_size < unit_array_size do
		if attachment ~= nil then
			self:destroy(attachment, is_editor)

			local units_by_slot_name = self._units_by_slot_name

			for slot_name, slot_unit in pairs(units_by_slot_name) do
				if slot_unit == unit then
					units_by_slot_name[slot_name] = nil
				end
			end

			World.destroy_unit(world, attachment)
			Unit.set_data(unit, "attached_items", i, nil)

			array_size = array_size + 1
		end

		i = i + 1
		attachment = Unit.get_data(unit, "attached_items", i)
	end
end

PlayerCustomization.unit_in_slot = function (self, slot_name)
	local units_by_slot_name = self._units_by_slot_name

	return units_by_slot_name[slot_name]
end

PlayerCustomization.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true
}
PlayerCustomization.component_data = {
	editor_only = {
		ui_type = "check_box",
		value = false,
		ui_name = "Editor Only",
		category = "Settings"
	},
	disable_all_culling = {
		ui_type = "check_box",
		value = false,
		ui_name = "Disable All Culling",
		category = "Settings"
	},
	force_highest_lod = {
		ui_type = "check_box",
		value = false,
		ui_name = "Force Highest LOD",
		category = "Settings"
	},
	is_first_person = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is First Person",
		category = "Settings"
	},
	face_item = {
		ui_type = "resource",
		category = "Facial Attachments",
		value = "",
		ui_name = "Face Item",
		filter = "item"
	},
	face_attachments = {
		category = "Facial Attachments",
		ui_type = "resource_array",
		size = 3,
		ui_name = "Face Attachment",
		filter = "item"
	},
	face_material_overrides = {
		validator = "contentpathsallowed",
		category = "Facial Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Face Material Overrides"
	},
	face_sm_override = {
		ui_type = "resource",
		category = "Facial Attachments",
		value = "",
		ui_name = "Face State Machine Override",
		filter = "state_machine"
	},
	face_sm_init_event = {
		ui_type = "text_box",
		value = "",
		ui_name = "Face State Machine Init Event",
		category = "Facial Attachments"
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
	attachment_material_override_4 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 4 for Item"
	},
	attachment_material_override_5 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 5 for Item"
	},
	attachment_material_override_6 = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Material Override 6 for Item"
	},
	global_material_override = {
		validator = "contentpathsallowed",
		category = "Attachments",
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Global Material Override"
	}
}

return PlayerCustomization
