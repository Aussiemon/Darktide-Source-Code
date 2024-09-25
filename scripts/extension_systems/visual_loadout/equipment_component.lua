﻿-- chunkname: @scripts/extension_systems/visual_loadout/equipment_component.lua

local Component = require("scripts/utilities/component")
local VisualLoadoutLodGroup = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_lod_group")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local unit_alive = Unit.alive
local unit_set_unit_visibility = Unit.set_unit_visibility
local unit_set_visibility = Unit.set_visibility
local unit_flow_event = Unit.flow_event
local ATTACHMENT_SPAWN_STATUS = table.enum("waiting_for_load", "fully_spawned")
local FACIAL_HAIR_VISIBILITY_GROUPS = table.enum("eyebrows", "beard")
local _should_spawn_3p, _should_spawn_1p
local EquipmentComponent = class("EquipmentComponent")

EquipmentComponent.init = function (self, world, item_definitions, unit_spawner, unit_3p, optional_extension_manager, optional_item_streaming_settings, optional_force_highest_lod_step)
	self._world = world
	self._item_definitions = item_definitions
	self._unit_spawner = unit_spawner
	self.lod_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod")
	self.lod_shadow_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod_shadow")
	self._extension_manager = optional_extension_manager
	self._force_highest_lod_step = optional_force_highest_lod_step

	local has_slot_package_streaming = optional_item_streaming_settings ~= nil

	self._has_slot_package_streaming = has_slot_package_streaming

	if has_slot_package_streaming then
		self._package_synchronizer_client = optional_item_streaming_settings.package_synchronizer_client
		self._player = optional_item_streaming_settings.player
	end
end

local function _create_slot_from_configuration(configuration, slot_options)
	local slot_name = configuration.name
	local slot = {}

	slot.name = slot_name
	slot.equipped = false
	slot.item = nil
	slot.unit_3p = nil
	slot.unit_1p = nil
	slot.parent_unit_3p = nil
	slot.parent_unit_1p = nil
	slot.attachments_3p = nil
	slot.attachments_1p = nil
	slot.hidden_3p = nil
	slot.hidden_1p = nil
	slot.wants_hidden_by_gameplay_1p = false
	slot.wants_hidden_by_gameplay_3p = false
	slot.buffable = configuration.buffable
	slot.wieldable = configuration.wieldable
	slot.wield_inputs = configuration.wield_inputs
	slot.use_existing_unit_3p = configuration.use_existing_unit_3p
	slot.item_loaded = nil
	slot.attachment_spawn_status = nil
	slot.equipped_t = nil
	slot.deform_overrides = nil
	slot.breed_name = nil
	slot.hide_unit_in_slot = configuration.hide_unit_in_slot
	slot.skip_link_children = slot_options.skip_link_children or false
	slot.cached_nodes = {}

	return slot
end

local NO_OPTIONS = {}
local NO_SLOT_OPTIONS = {}

EquipmentComponent.initialize_equipment = function (slot_configuration, optional_slot_options)
	local equipment = {}
	local slot_options = optional_slot_options or NO_SLOT_OPTIONS

	for slot_name, config in pairs(slot_configuration) do
		local slot = _create_slot_from_configuration(config, slot_options[slot_name] or NO_OPTIONS)

		equipment[slot_name] = slot
	end

	return equipment
end

local temp = {}

EquipmentComponent._attach_settings = function (self)
	table.clear(temp)

	local extension_manager = self._extension_manager

	temp.world = self._world
	temp.unit_spawner = self._unit_spawner
	temp.from_script_component = false
	temp.item_definitions = self._item_definitions
	temp.extension_manager = extension_manager
	temp.spawn_with_extensions = extension_manager ~= nil
	temp.force_highest_lod_step = self._force_highest_lod_step

	return temp
end

EquipmentComponent._fill_attach_settings_3p = function (self, attach_settings, slot)
	attach_settings.is_first_person = false
	attach_settings.lod_group = self.lod_group_3p
	attach_settings.lod_shadow_group = self.lod_shadow_group_3p
	attach_settings.skip_link_children = slot.skip_link_children
end

EquipmentComponent._fill_attach_settings_1p = function (self, attach_settings, breed_name_or_nil)
	attach_settings.is_first_person = true
	attach_settings.lod_group = false
	attach_settings.lod_shadow_group = false
	attach_settings.breed_name = breed_name_or_nil
end

EquipmentComponent.equip_item = function (self, unit_3p, unit_1p, slot, item, optional_existing_unit_3p, deform_overrides, optional_breed_name, optional_mission_template, optional_equipment)
	slot.equipped = true
	slot.item = item
	slot.deform_overrides = deform_overrides
	slot.breed_name = optional_breed_name
	slot.parent_unit_3p = unit_3p
	slot.parent_unit_1p = unit_1p

	local attach_settings = self:_attach_settings()

	if self._has_slot_package_streaming then
		slot.item_loaded = self:_slot_is_loaded(slot)
	else
		slot.item_loaded = true
	end

	self:_spawn_item_units(slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment)

	if slot.use_existing_unit_3p then
		slot.unit_3p, slot.attachments_3p = optional_existing_unit_3p

		local smart_tagging_id = Unit.find_actor(optional_existing_unit_3p, "smart_tagging")

		if smart_tagging_id then
			Actor.set_collision_enabled(Unit.actor(optional_existing_unit_3p, smart_tagging_id), false)
		end
	end
end

EquipmentComponent._slot_is_loaded = function (self, slot)
	local player = self._player
	local peer_id, local_player_id = player:peer_id(), player:local_player_id()
	local slot_is_loaded = self._package_synchronizer_client:alias_loaded(peer_id, local_player_id, slot.name)

	return slot_is_loaded
end

EquipmentComponent._spawn_item_units = function (self, slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment)
	local item = slot.item
	local skip_attachments

	if slot.item_loaded then
		skip_attachments = false
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
	else
		skip_attachments = true
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_load
	end

	if _should_spawn_3p(slot) then
		self:_fill_attach_settings_3p(attach_settings, slot)

		local item_unit_3p, attachment_units_3p, attachment_name_to_unit_3p, _
		local item_data = slot.item

		if skip_attachments then
			item_unit_3p = VisualLoadoutCustomization.spawn_base_unit(item_data, attach_settings, unit_3p, optional_mission_template)
		else
			item_unit_3p, attachment_units_3p, _, attachment_name_to_unit_3p = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit_3p, true, nil, optional_mission_template, optional_equipment)
		end

		slot.unit_3p = item_unit_3p
		slot.attachments_3p = attachment_units_3p

		if attachment_name_to_unit_3p then
			local keys = {}

			table.keys(attachment_name_to_unit_3p, keys)

			for ii = 1, #keys do
				local key = keys[ii]
				local unit = attachment_name_to_unit_3p[key]

				attachment_name_to_unit_3p[unit] = key
			end

			slot.attachments_name_lookup_3p = attachment_name_to_unit_3p
		end

		local dynamic_id = Unit.find_actor(item_unit_3p, "dynamic")

		if dynamic_id then
			Unit.destroy_actor(item_unit_3p, dynamic_id)
		end

		local start_target_id = Unit.find_actor(item_unit_3p, "smart_tagging")

		if start_target_id then
			Unit.destroy_actor(item_unit_3p, start_target_id)
		end

		local hide_unit_in_slot = slot.hide_unit_in_slot

		if hide_unit_in_slot then
			unit_set_unit_visibility(item_unit_3p, false, true)
		end

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(slot.unit_3p, unit_3p, false, deform_override, false)
			end
		end
	end

	if _should_spawn_1p(unit_1p, item, slot) then
		self:_fill_attach_settings_1p(attach_settings, slot.breed_name)

		local item_unit_1p, attachment_units_1p, attachment_name_to_unit_1p, _
		local item_data = slot.item

		if skip_attachments then
			item_unit_1p = VisualLoadoutCustomization.spawn_base_unit(item_data, attach_settings, unit_1p, optional_mission_template)
		else
			item_unit_1p, attachment_units_1p, _, attachment_name_to_unit_1p = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit_1p, true, nil, optional_mission_template)
		end

		slot.unit_1p = item_unit_1p
		slot.attachments_1p = attachment_units_1p

		if attachment_name_to_unit_1p then
			local keys = {}

			table.keys(attachment_name_to_unit_1p, keys)

			for ii = 1, #keys do
				local key = keys[ii]
				local unit = attachment_name_to_unit_1p[key]

				attachment_name_to_unit_1p[unit] = key
			end

			slot.attachments_name_lookup_1p = attachment_name_to_unit_1p
		end

		local dynamic_id = Unit.find_actor(item_unit_1p, "dynamic")

		if dynamic_id then
			Unit.destroy_actor(item_unit_1p, dynamic_id)
		end

		local start_target_id = Unit.find_actor(item_unit_1p, "smart_tagging")

		if start_target_id then
			Unit.destroy_actor(item_unit_1p, start_target_id)
		end

		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(unit_1p, "custom_fov", true)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(slot.unit_1p, unit_1p, false, deform_override, false)
			end
		end
	end
end

EquipmentComponent._spawn_attachments = function (self, slot, optional_mission_template)
	local item = slot.item

	if _should_spawn_3p(slot) then
		local attach_settings = self:_attach_settings()

		self:_fill_attach_settings_3p(attach_settings, slot)

		local unit_3p = slot.unit_3p
		local weapon_skin_item = item.slot_weapon_skin
		local skin_data = weapon_skin_item and weapon_skin_item ~= "" and rawget(attach_settings.item_definitions, weapon_skin_item)
		local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item, skin_data)
		local attachment_units_3p, attachment_name_to_unit_3p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, unit_3p, true, nil, optional_mission_template)
		local parent_unit = slot.parent_unit_3p

		VisualLoadoutCustomization.apply_material_overrides(item, unit_3p, parent_unit, attach_settings)

		if skin_data then
			VisualLoadoutCustomization.apply_material_overrides(skin_data, unit_3p, parent_unit, attach_settings)
		end

		VisualLoadoutCustomization.add_extensions(nil, attachment_units_3p, attach_settings)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_3p, parent_unit, false, deform_override, false)
			end
		end

		slot.attachments_3p = attachment_units_3p

		if attachment_name_to_unit_3p then
			local keys = {}

			table.keys(attachment_name_to_unit_3p, keys)

			for ii = 1, #keys do
				local key = keys[ii]
				local unit = attachment_name_to_unit_3p[key]

				attachment_name_to_unit_3p[unit] = key
			end

			slot.attachments_name_lookup_3p = attachment_name_to_unit_3p
		end
	end

	local parent_unit_1p = slot.parent_unit_1p

	if _should_spawn_1p(parent_unit_1p, item, slot) then
		local attach_settings = self:_attach_settings()

		self:_fill_attach_settings_1p(attach_settings, slot.breed_name)

		local unit_1p = slot.unit_1p
		local weapon_skin_item = item.slot_weapon_skin
		local skin_data = weapon_skin_item and weapon_skin_item ~= "" and rawget(attach_settings.item_definitions, weapon_skin_item)
		local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item, skin_data)
		local attachment_units_1p, attachment_name_to_unit_1p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, unit_1p, true, nil, optional_mission_template)

		VisualLoadoutCustomization.apply_material_overrides(item, unit_1p, parent_unit_1p, attach_settings)

		if skin_data then
			VisualLoadoutCustomization.apply_material_overrides(skin_data, unit_1p, parent_unit_1p, attach_settings)
		end

		VisualLoadoutCustomization.add_extensions(nil, attachment_units_1p, attach_settings)
		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(unit_1p, "custom_fov", true)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_1p, parent_unit_1p, false, deform_override, false)
			end
		end

		slot.attachments_1p = attachment_units_1p

		if attachment_name_to_unit_1p then
			local keys = {}

			table.keys(attachment_name_to_unit_1p, keys)

			for ii = 1, #keys do
				local key = keys[ii]
				local unit = attachment_name_to_unit_1p[key]

				attachment_name_to_unit_1p[unit] = key
			end

			slot.attachments_name_lookup_1p = attachment_name_to_unit_1p
		end
	end

	slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
end

local function _despawn_item_units(unit_spawner, base_unit, attachments)
	if attachments then
		for i = #attachments, 1, -1 do
			local unit = attachments[i]

			if unit then
				unit_spawner:mark_for_deletion(unit)
			end
		end
	end

	if base_unit then
		unit_spawner:mark_for_deletion(base_unit)
	end
end

EquipmentComponent.unequip_item = function (self, slot)
	slot.equipped = false
	slot.item = nil
	slot.deform_overrides = nil
	slot.breed_name = nil

	local unit_3p, attachments_3p, unit_spawner = slot.unit_3p, slot.attachments_3p, self._unit_spawner

	if slot.use_existing_unit_3p then
		if unit_alive(unit_3p) then
			unit_set_unit_visibility(unit_3p, true, true)

			local smart_tagging_id = Unit.find_actor(unit_3p, "smart_tagging")

			if smart_tagging_id then
				Actor.set_scene_query_enabled(Unit.actor(unit_3p, smart_tagging_id), true)
			end
		end
	else
		_despawn_item_units(unit_spawner, unit_3p, attachments_3p)
	end

	slot.unit_3p = nil
	slot.attachments_3p = nil

	local unit_1p = slot.unit_1p

	if unit_1p then
		_despawn_item_units(unit_spawner, unit_1p, slot.attachments_1p)

		slot.unit_1p = nil
		slot.attachments_1p = nil
	end

	slot.parent_unit_1p = nil
	slot.parent_unit_3p = nil
end

local dependent_items = {}

EquipmentComponent.unequip_slot_dependencies = function (self, slot_config, equipment, slot_equip_order)
	local slot_dependencies = slot_config.slot_dependencies

	if not slot_dependencies then
		return
	end

	table.clear(dependent_items)

	for i = #slot_equip_order, 1, -1 do
		local slot_name = slot_equip_order[i]

		if table.contains(slot_dependencies, slot_name) then
			local slot = equipment[slot_name]

			if slot and slot.equipped then
				dependent_items[slot_name] = slot.item

				self:unequip_item(slot)
			end
		end
	end

	return dependent_items
end

EquipmentComponent.equip_slot_dependencies = function (self, equipment, slot_equip_order, items, body_deform_overrides, breed_name, character_unit_3p, character_unit_1p)
	for i = 1, #slot_equip_order do
		local slot_name = slot_equip_order[i]
		local item = items[slot_name]

		if item then
			local deform_overrides = body_deform_overrides or {}
			local parent_unit_3p = character_unit_3p
			local parent_unit_1p = character_unit_1p
			local parent_slot_names = item.parent_slot_names or {}

			for _, parent_slot_name in pairs(parent_slot_names) do
				local parent_slot = equipment[parent_slot_name]
				local parent_slot_unit_3p = parent_slot.unit_3p
				local parent_item = parent_slot.item
				local parent_item_deform_overrides = parent_item.deform_overrides or {}

				for _, parent_item_deform_override in pairs(parent_item_deform_overrides) do
					deform_overrides[#deform_overrides + 1] = parent_item_deform_override
				end

				if parent_slot_unit_3p then
					parent_unit_3p = parent_slot_unit_3p

					local apply_to_parent = item.material_override_apply_to_parent

					if apply_to_parent then
						local material_overrides = item.material_overrides

						for _, material_override in ipairs(material_overrides) do
							VisualLoadoutCustomization.apply_material_override(parent_unit_3p, nil, false, material_override, false)
						end
					end
				else
					Log.warning("EquipmentComponent", "Item %s cannot attach to unit in slot %s as it is spawned in the wrong order. Fix the slot priority configuration", item.name, parent_slot_name)
				end
			end

			local slot = equipment[slot_name]

			self:equip_item(parent_unit_3p, parent_unit_1p, slot, item, nil, body_deform_overrides, breed_name)
		end
	end
end

local hidden_slot_names = {}

local function _get_hidden_slot_names(equipment, base_unit_name, wielded_slot_name, first_person_mode)
	table.clear(hidden_slot_names)

	for slot_name, slot in pairs(equipment) do
		if slot.equipped and slot[base_unit_name] then
			local item = slot.item
			local hide_slots = item.hide_slots

			if hide_slots then
				for i = 1, #hide_slots do
					local other_slot_name_to_hide = hide_slots[i]

					hidden_slot_names[other_slot_name_to_hide] = true
				end
			end

			local wieldable = slot.wieldable

			if wieldable then
				local slot_is_wielded = slot_name == wielded_slot_name

				if slot_is_wielded then
					local is_force_hidden_by_gameplay = first_person_mode and slot.wants_hidden_by_gameplay_1p or not first_person_mode and slot.wants_hidden_by_gameplay_3p or false

					if is_force_hidden_by_gameplay then
						hidden_slot_names[slot_name] = true
					end
				else
					hidden_slot_names[slot_name] = true
				end
			end
		end
	end

	return hidden_slot_names
end

local function _slot_flow_event_1p(slot, event_name)
	local base_unit = slot.unit_1p

	unit_flow_event(base_unit, event_name)

	local attachment_units = slot.attachments_1p or {}

	for i = 1, #attachment_units do
		local attachment_unit = attachment_units[i]

		unit_flow_event(attachment_unit, event_name)
	end
end

local function _slot_flow_event_3p(slot, event_name)
	local base_unit = slot.unit_3p

	unit_flow_event(base_unit, event_name)

	local attachment_units = slot.attachments_3p or {}

	for i = 1, #attachment_units do
		local attachment_unit = attachment_units[i]

		unit_flow_event(attachment_unit, event_name)
	end
end

local function _set_slot_hidden(slot, hidden_3p, hidden_1p)
	local unit_3p = slot.unit_3p

	if unit_3p and slot.hidden_3p ~= hidden_3p then
		slot.hidden_3p = hidden_3p

		if hidden_3p then
			_slot_flow_event_3p(slot, "lua_hidden")
		else
			_slot_flow_event_3p(slot, "lua_visible")
		end
	end

	local unit_1p = slot.unit_1p

	if unit_1p and slot.hidden_1p ~= hidden_1p then
		slot.hidden_1p = hidden_1p

		if hidden_1p then
			_slot_flow_event_1p(slot, "lua_hidden")
		else
			_slot_flow_event_1p(slot, "lua_visible")
		end
	end
end

local function _mask_base_body_slot(base_body_slot, mask_override, unit_3p)
	if mask_override then
		VisualLoadoutCustomization.apply_material_override(body_unit, unit_3p, false, mask_override, false)
	end
end

local temp_unspawned_attachment_slots = {}

EquipmentComponent.try_spawn_attachments = function (self, equipment, slot_equip_order, optional_mission_template)
	if not self._has_slot_package_streaming then
		return false
	end

	table.clear(temp_unspawned_attachment_slots)

	local has_unspawned_attachments = false

	for slot_name, slot in pairs(equipment) do
		local equipped = slot.equipped

		if equipped then
			local spawned = slot.attachment_spawn_status == ATTACHMENT_SPAWN_STATUS.fully_spawned

			if not spawned then
				has_unspawned_attachments = true
				temp_unspawned_attachment_slots[slot_name] = slot
			end
		end
	end

	local all_unspawned_slots_are_loaded = true

	for _, slot in pairs(temp_unspawned_attachment_slots) do
		if not self:_slot_is_loaded(slot) then
			all_unspawned_slots_are_loaded = false

			break
		end
	end

	local spawned_attachments = false

	if has_unspawned_attachments and all_unspawned_slots_are_loaded then
		spawned_attachments = true

		local slot_equip_order_n = #slot_equip_order

		for i = 1, slot_equip_order_n do
			local slot_name = slot_equip_order[i]
			local slot = temp_unspawned_attachment_slots[slot_name]
			local slot_is_unspawned = slot ~= nil

			if slot_is_unspawned then
				self:_spawn_attachments(slot, optional_mission_template)
			end
		end
	end

	return spawned_attachments, temp_unspawned_attachment_slots
end

EquipmentComponent.resolve_profile_properties = function (equipment, wielded_slot, archetype_property, selected_voice_property)
	local properties = {
		archetype = archetype_property,
		selected_voice = selected_voice_property,
	}

	for slot_name, slot in pairs(equipment) do
		repeat
			if not slot.equipped then
				break
			end

			if slot.wieldable and wielded_slot ~= slot_name then
				break
			end

			local item = slot.item

			if item.weapon_template then
				properties.wielded_weapon_template = item.weapon_template
			end

			local profile_properties = item.profile_properties

			if not profile_properties or type(profile_properties) == "userdata" then
				break
			end

			for name, value in pairs(profile_properties) do
				properties[name] = value
			end
		until true
	end

	return properties
end

EquipmentComponent.update_item_visibility = function (equipment, wielded_slot, unit_3p, unit_1p, first_person_mode)
	local unit_showing = first_person_mode and unit_1p or unit_3p
	local unit_hidden = first_person_mode and unit_3p or unit_1p
	local player_visibility = ScriptUnit.has_extension(unit_3p, "player_visibility_system")
	local player_visible = true

	if player_visibility then
		player_visible = player_visibility:visible()

		if not player_visible then
			player_visibility:show()
		end
	end

	if unit_showing then
		unit_set_unit_visibility(unit_showing, true, true)
	end

	if unit_hidden then
		unit_set_unit_visibility(unit_hidden, false, true)
	end

	local base_unit_name = first_person_mode and "unit_1p" or "unit_3p"
	local slot_names_to_hide = _get_hidden_slot_names(equipment, base_unit_name, wielded_slot, first_person_mode)
	local slot_body_face_unit = equipment.slot_body_face.unit_3p

	for slot_name, slot in pairs(equipment) do
		local is_hidden_3p, is_hidden_1p
		local hide_unit_in_slot = slot.hide_unit_in_slot

		if hide_unit_in_slot and slot[base_unit_name] then
			unit_set_unit_visibility(slot[base_unit_name], false, true)
		end

		if slot_names_to_hide[slot_name] then
			is_hidden_3p, is_hidden_1p = true, true

			if slot[base_unit_name] then
				unit_set_unit_visibility(slot[base_unit_name], false, true)
			end
		else
			is_hidden_3p = first_person_mode
			is_hidden_1p = not first_person_mode
		end

		local item = slot.item

		if slot_body_face_unit then
			if item and item.hide_eyebrows ~= nil then
				local hide_eyebrows = first_person_mode or item.hide_eyebrows or false

				unit_set_visibility(slot_body_face_unit, "eyebrows", not hide_eyebrows, true)
			end

			if item and item.hide_beard ~= nil then
				local hide_beard = first_person_mode or item.hide_beard or false

				unit_set_visibility(slot_body_face_unit, "beard", not hide_beard, true)
			end

			if item and item.mask_facial_hair ~= nil then
				local mask_facial_hair = item.mask_facial_hair

				if mask_facial_hair == "" or mask_facial_hair == nil then
					mask_facial_hair = "facial_hair_no_mask"
				end

				VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, mask_facial_hair, false)
			end

			if item and item.mask_hair ~= nil then
				local mask_hair = item.mask_hair

				if mask_hair == "" or mask_hair == nil then
					mask_hair = "hair_no_mask"
				end

				VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, mask_hair, false)
			end

			if item and item.mask_hair_override ~= nil then
				local mask_hair_override = item.mask_hair_override

				for i = 1, #mask_hair_override do
					local mask_hair_item = item.mask_hair_override[i].HairItem
					local current_hair_item = equipment.slot_body_hair.item

					if current_hair_item and mask_hair_item == current_hair_item.name then
						local mask_hair = item.mask_hair_override[i].HairMaskOverride

						if mask_hair and item.mask_hair_override ~= "" then
							VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, mask_hair, false)
						end
					end
				end
			end

			if item and item.mask_face ~= nil then
				local mask_face = item.mask_face

				if mask_face == "" or mask_face == nil then
					mask_face = "mask_face_none"
				end

				VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, mask_face, false)
			end
		end

		if item and item.stabilize_neck ~= nil and Unit.has_animation_event(unit_3p, "lock_head") and Unit.has_animation_event(unit_3p, "unlock_head") then
			if item.stabilize_neck >= 50 then
				Unit.animation_event(unit_3p, "lock_head")
			else
				Unit.animation_event(unit_3p, "unlock_head")
			end
		end

		_set_slot_hidden(slot, is_hidden_3p, is_hidden_1p)
	end

	if first_person_mode then
		local slot_gear_upperbody = equipment.slot_gear_upperbody
		local gear_upperbody_item = slot_gear_upperbody.item

		if gear_upperbody_item and slot_names_to_hide.slot_body_arms == nil then
			local arms_unit = equipment.slot_body_arms.unit_1p

			if arms_unit then
				local mask_arms = gear_upperbody_item.mask_arms

				if mask_arms == "" or mask_arms == nil then
					mask_arms = "mask_default"
				end

				VisualLoadoutCustomization.apply_material_override(arms_unit, unit_1p, false, mask_arms, false)
			end
		end
	else
		local slot_gear_upperbody = equipment.slot_gear_upperbody
		local gear_upperbody_item = slot_gear_upperbody.item

		if gear_upperbody_item then
			if slot_names_to_hide.slot_body_torso == nil then
				local torso_unit = equipment.slot_body_torso.unit_3p

				if torso_unit then
					local mask_torso = gear_upperbody_item.mask_torso

					if mask_torso == "" or mask_torso == nil then
						mask_torso = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(torso_unit, unit_3p, false, mask_torso, false)
				end
			end

			if slot_names_to_hide.slot_body_arms == nil then
				local arms_unit = equipment.slot_body_arms.unit_3p

				if arms_unit then
					local mask_arms = gear_upperbody_item.mask_arms

					if mask_arms == "" or mask_arms == nil then
						mask_arms = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(arms_unit, unit_3p, false, mask_arms, false)
				end
			end
		else
			local torso_unit = equipment.slot_body_torso.unit_3p
			local arms_unit = equipment.slot_body_arms.unit_3p
			local default_mask = "mask_default"

			if torso_unit then
				VisualLoadoutCustomization.apply_material_override(torso_unit, unit_3p, false, default_mask, false)
			end

			if arms_unit then
				VisualLoadoutCustomization.apply_material_override(arms_unit, unit_3p, false, default_mask, false)
			end
		end

		local slot_gear_lowerbody = equipment.slot_gear_lowerbody
		local gear_lowerbody_item = slot_gear_lowerbody.item

		if gear_lowerbody_item then
			if slot_names_to_hide.slot_body_legs == nil then
				local legs_unit = equipment.slot_body_legs.unit_3p

				if legs_unit then
					local mask_legs = gear_lowerbody_item.mask_legs

					if mask_legs == "" or mask_legs == nil then
						mask_legs = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(legs_unit, unit_3p, false, mask_legs, false)
				end
			end
		else
			local legs_unit = equipment.slot_body_legs.unit_3p
			local default_mask = "mask_default"

			if legs_unit then
				VisualLoadoutCustomization.apply_material_override(legs_unit, unit_3p, false, default_mask, false)
			end
		end
	end

	if not player_visible then
		player_visibility:hide()
	end
end

EquipmentComponent.wield_slot = function (slot, first_person_mode)
	local base_unit_1p = first_person_mode and slot and slot.unit_1p
	local base_unit_3p = slot and slot.unit_3p ~= nil and unit_alive(slot.unit_3p) and slot.unit_3p
	local base_unit = base_unit_1p or base_unit_3p or nil

	if base_unit then
		unit_flow_event(base_unit, "lua_wield")
	end
end

EquipmentComponent.unwield_slot = function (slot, first_person_mode)
	local base_unit_1p = first_person_mode and slot.unit_1p
	local base_unit_3p = slot.unit_3p ~= nil and unit_alive(slot.unit_3p) and slot.unit_3p
	local base_unit = base_unit_1p or base_unit_3p or nil

	if base_unit then
		unit_flow_event(base_unit, "lua_unwield")
	end
end

local Component_event = Component.event

EquipmentComponent.send_component_event = function (slot, event_name, ...)
	local unit_3p = slot.unit_3p

	Component_event(unit_3p, event_name, ...)

	local attachments_3p = slot.attachments_3p

	for i = 1, #attachments_3p do
		local attachment_unit = attachments_3p[i]

		Component_event(attachment_unit, event_name, ...)
	end

	local unit_1p = slot.unit_1p

	if unit_1p then
		Component_event(unit_1p, event_name, ...)

		local attachments_1p = slot.attachments_1p

		for i = 1, #attachments_1p do
			local attachment_unit = attachments_1p[i]

			Component_event(attachment_unit, event_name, ...)
		end
	end
end

function _should_spawn_3p(slot)
	return not slot.use_existing_unit_3p and (not DEDICATED_SERVER or slot.wieldable)
end

function _should_spawn_1p(unit_1p, item, slot)
	return unit_1p and item.base_unit and item.show_in_1p and (not DEDICATED_SERVER or slot.wieldable)
end

return EquipmentComponent
