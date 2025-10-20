-- chunkname: @scripts/extension_systems/visual_loadout/equipment_component.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local Component = require("scripts/utilities/component")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local VisualLoadoutLodGroup = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_lod_group")
local MasterItems = require("scripts/backend/master_items")
local unit_alive = Unit.alive
local unit_set_unit_visibility = Unit.set_unit_visibility
local unit_set_visibility = Unit.set_visibility
local unit_flow_event = Unit.flow_event
local ATTACHMENT_SPAWN_STATUS = table.enum("waiting_for_companion_unit_spawn", "waiting_for_load", "fully_spawned")
local EquipmentComponent = class("EquipmentComponent")

EquipmentComponent.init = function (self, world, item_definitions, unit_spawner, unit_3p, optional_extension_manager, optional_item_streaming_settings, optional_force_highest_lod_step, optional_from_ui_profile_spawner)
	self._world = world
	self._item_definitions = item_definitions
	self._unit_spawner = unit_spawner
	self.lod_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod")
	self.lod_shadow_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod_shadow")
	self._extension_manager = optional_extension_manager
	self._force_highest_lod_step = optional_force_highest_lod_step
	self._from_ui_profile_spawner = optional_from_ui_profile_spawner

	local has_slot_package_streaming = optional_item_streaming_settings ~= nil

	self._has_slot_package_streaming = has_slot_package_streaming

	if has_slot_package_streaming then
		self._package_synchronizer_client = optional_item_streaming_settings.package_synchronizer_client
		self._player = optional_item_streaming_settings.player
	end
end

local function _create_slot_from_configuration(configuration, breed_settings, slot_options)
	local slot_name = configuration.name
	local slot = Script.new_map(32)

	slot.name = slot_name
	slot.equipped = false
	slot.item = nil
	slot.unit_3p = nil
	slot.unit_1p = nil
	slot.parent_unit_3p = nil
	slot.parent_unit_1p = nil
	slot.attachments_by_unit_3p = nil
	slot.attachments_by_unit_1p = nil
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
	slot.skip_link_children = not not slot_options.skip_link_children
	slot.cached_nodes = {}

	return slot
end

local NO_OPTIONS = {}
local NO_SLOT_OPTIONS = {}

local function _get_unit_3p_and_item_for_wanted_slot(equipment, wanted_slot)
	local data = equipment[wanted_slot]

	if data and data.equipped then
		return {
			unit_3p = data.unit_3p,
			item = data.item,
		}
	end

	for slot_name, slot in pairs(equipment) do
		if slot.attachment_id_lookup_3p then
			for attachment_name, attachment_unit in pairs(slot.attachment_id_lookup_3p) do
				if attachment_name == wanted_slot then
					local item

					if slot.item_name_by_unit_3p then
						for unit, item_name in pairs(slot.item_name_by_unit_3p) do
							if attachment_unit == unit then
								item = MasterItems.get_item(item_name)

								break
							end
						end
					end

					return {
						unit_3p = attachment_unit,
						item = item,
					}
				end
			end
		end
	end

	return {}
end

EquipmentComponent.initialize_equipment = function (slot_configuration, breed_settings, optional_slot_options)
	local equipment = {}
	local slot_options = optional_slot_options or NO_SLOT_OPTIONS

	for slot_name, config in pairs(slot_configuration) do
		local slot = _create_slot_from_configuration(config, breed_settings, slot_options[slot_name] or NO_OPTIONS)

		equipment[slot_name] = slot
	end

	return equipment
end

local _attach_settings = {}

EquipmentComponent._attach_settings = function (self)
	table.clear(_attach_settings)

	local extension_manager = self._extension_manager

	_attach_settings.world = self._world
	_attach_settings.unit_spawner = self._unit_spawner
	_attach_settings.from_script_component = false
	_attach_settings.item_definitions = self._item_definitions
	_attach_settings.extension_manager = extension_manager
	_attach_settings.spawn_with_extensions = extension_manager ~= nil
	_attach_settings.force_highest_lod_step = self._force_highest_lod_step
	_attach_settings.from_ui_profile_spawner = self._from_ui_profile_spawner

	return _attach_settings
end

EquipmentComponent._fill_attach_settings_companion = function (self, owner_unit, companion_unit, attach_settings, slot)
	local lod_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(companion_unit, "lod")
	local lod_shadow_group = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(companion_unit, "lod_shadow")

	attach_settings.is_minion = true
	attach_settings.owner_unit = owner_unit
	attach_settings.character_unit = companion_unit
	attach_settings.is_first_person = false
	attach_settings.lod_group = lod_group
	attach_settings.lod_shadow_group = lod_shadow_group
	attach_settings.breed_name = nil
	attach_settings.skip_link_children = slot.skip_link_children
end

EquipmentComponent._fill_attach_settings_3p = function (self, owner_unit, attach_settings, slot)
	attach_settings.owner_unit = owner_unit
	attach_settings.is_first_person = false
	attach_settings.lod_group = self.lod_group_3p
	attach_settings.lod_shadow_group = self.lod_shadow_group_3p
	attach_settings.breed_name = nil
	attach_settings.skip_link_children = slot.skip_link_children
end

EquipmentComponent._fill_attach_settings_1p = function (self, owner_unit, attach_settings, slot)
	attach_settings.owner_unit = owner_unit
	attach_settings.is_first_person = true
	attach_settings.lod_group = false
	attach_settings.lod_shadow_group = false
	attach_settings.breed_name = slot.breed_name
	attach_settings.skip_link_children = nil
end

EquipmentComponent.equip_item = function (self, unit_3p, unit_1p, slot, item, optional_existing_unit_3p, deform_overrides, optional_breed_name, optional_mission_template, optional_equipment, optional_companion_unit_3p)
	if not item or table.is_empty(item) then
		return
	end

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

	self:_spawn_item_units(slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment, optional_companion_unit_3p)

	if slot.use_existing_unit_3p then
		slot.unit_3p, slot.attachments_by_unit_3p = optional_existing_unit_3p

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

EquipmentComponent._spawn_item_units = function (self, slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment, optional_companion_unit_3p)
	local item = slot.item

	if self:_is_companion_item(item) then
		self:_spawn_companion_item_units(slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment, optional_companion_unit_3p)
	else
		self:_spawn_player_item_units(slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment)
	end
end

EquipmentComponent._spawn_companion_item_units = function (self, slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment, optional_companion_unit_3p)
	local item = slot.item
	local companion_spawner_extension = ScriptUnit.has_extension(unit_3p, "companion_spawner_system")
	local companion_unit_3p = optional_companion_unit_3p or companion_spawner_extension and companion_spawner_extension:companion_unit()

	if not Unit.alive(companion_unit_3p) and not optional_companion_unit_3p then
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_companion_unit_spawn
	else
		local skip_attachments

		if slot.item_loaded then
			skip_attachments = false
			slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
		else
			skip_attachments = true
			slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_load
		end

		if skip_attachments then
			return
		end

		local parent_unit_3p = slot.parent_unit_3p

		self:_fill_attach_settings_companion(parent_unit_3p, companion_unit_3p, attach_settings, slot)

		local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item)
		local equipment
		local attachments_by_unit_3p, unit_attachment_id_3p, unit_attachment_name_3p, _, item_name_by_unit_3p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, companion_unit_3p, true, false, true, optional_mission_template, equipment)

		CompanionVisualLoadout.assign_fur_material(companion_unit_3p, attachments_by_unit_3p)
		VisualLoadoutCustomization.apply_material_overrides(item, companion_unit_3p, companion_unit_3p, attach_settings)

		slot.owner_unit_3p = unit_3p
		slot.unit_3p = companion_unit_3p
		slot.attachments_by_unit_3p = attachments_by_unit_3p
		slot.attachment_id_lookup_3p = unit_attachment_id_3p
		slot.item_name_by_unit_3p = item_name_by_unit_3p
		slot.attachment_map_by_unit_3p = unit_attachment_name_3p

		Managers.event:trigger("on_spawn_companion_item", slot.name, slot.unit_3p)
	end
end

EquipmentComponent._spawn_player_item_units = function (self, slot, unit_3p, unit_1p, attach_settings, optional_mission_template, optional_equipment)
	local item = slot.item
	local skip_attachments

	if slot.item_loaded then
		skip_attachments = false
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
	else
		skip_attachments = true
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_load
	end

	if self:_should_spawn_3p(unit_3p, slot, item) then
		self:_fill_attach_settings_3p(unit_3p, attach_settings, slot)

		local item_unit_3p, attachment_units_3p, unit_attachment_id_3p, unit_attachment_name_3p, item_name_by_unit_3p, _

		if skip_attachments then
			item_unit_3p = VisualLoadoutCustomization.spawn_base_unit(item, attach_settings, unit_3p, optional_mission_template)
		else
			item_unit_3p, attachment_units_3p, _, unit_attachment_id_3p, unit_attachment_name_3p, _, item_name_by_unit_3p = VisualLoadoutCustomization.spawn_item(item, attach_settings, unit_3p, true, false, true, optional_mission_template, optional_equipment)
		end

		slot.unit_3p = item_unit_3p
		slot.attachments_by_unit_3p = attachment_units_3p
		slot.attachment_id_lookup_3p = unit_attachment_id_3p
		slot.attachment_map_by_unit_3p = unit_attachment_name_3p
		slot.item_name_by_unit_3p = item_name_by_unit_3p

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

	if self:_should_spawn_1p(unit_1p, item, slot) then
		self:_fill_attach_settings_1p(unit_1p, attach_settings, slot)

		local item_unit_1p, attachments_by_unit_1p, unit_attachment_id_1p, unit_attachment_name_1p, item_name_by_unit_1p, _

		if skip_attachments then
			item_unit_1p = VisualLoadoutCustomization.spawn_base_unit(item, attach_settings, unit_1p, optional_mission_template)
		else
			local equipment

			item_unit_1p, attachments_by_unit_1p, _, unit_attachment_id_1p, unit_attachment_name_1p, _, item_name_by_unit_1p = VisualLoadoutCustomization.spawn_item(item, attach_settings, unit_1p, true, false, true, optional_mission_template, equipment)
		end

		slot.unit_1p = item_unit_1p
		slot.attachments_by_unit_1p = attachments_by_unit_1p
		slot.attachment_id_lookup_1p = unit_attachment_id_1p
		slot.attachment_map_by_unit_1p = unit_attachment_name_1p
		slot.item_name_by_unit_1p = item_name_by_unit_1p

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

EquipmentComponent._spawn_item_attachments = function (self, slot, optional_mission_template)
	local item = slot.item

	if self:_is_companion_item(item) then
		self:_spawn_companion_item_attachments(item, slot, optional_mission_template)
	else
		self:_spawn_player_item_attachments(item, slot, optional_mission_template)
	end

	slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
end

EquipmentComponent._spawn_companion_item_attachments = function (self, item, slot, optional_mission_template)
	local parent_unit_3p = slot.parent_unit_3p
	local companion_spawner_extension = ScriptUnit.has_extension(parent_unit_3p, "companion_spawner_system")
	local companion_unit_3p = companion_spawner_extension and companion_spawner_extension:companion_unit()

	if not Unit.alive(companion_unit_3p) then
		return
	end

	local attach_settings = self:_attach_settings()

	self:_fill_attach_settings_companion(parent_unit_3p, companion_unit_3p, attach_settings, slot)

	local unit_3p = slot.unit_3p
	local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item)
	local equipment
	local attachments_by_unit_3p, unit_attachment_id_3p, unit_attachment_name_3p, _, item_name_by_unit_3p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, companion_unit_3p, true, false, true, optional_mission_template, equipment)

	CompanionVisualLoadout.assign_fur_material(companion_unit_3p, attachments_by_unit_3p)
	VisualLoadoutCustomization.apply_material_overrides(item, companion_unit_3p, companion_unit_3p, attach_settings)

	slot.owner_unit_3p = unit_3p
	slot.unit_3p = companion_unit_3p
	slot.attachments_by_unit_3p = attachments_by_unit_3p
	slot.attachment_id_lookup_3p = unit_attachment_id_3p
	slot.item_name_by_unit_3p = item_name_by_unit_3p
	slot.attachment_map_by_unit_3p = unit_attachment_name_3p

	Managers.event:trigger("on_spawn_companion_item", slot.name, slot.unit_3p)
end

EquipmentComponent._spawn_player_item_attachments = function (self, item, slot, optional_mission_template)
	local parent_unit_3p = slot.parent_unit_3p

	if self:_should_spawn_3p(parent_unit_3p, slot, item) then
		local attach_settings = self:_attach_settings()

		self:_fill_attach_settings_3p(parent_unit_3p, attach_settings, slot)

		local unit_3p = slot.unit_3p
		local weapon_skin_item = item.slot_weapon_skin
		local skin_data = weapon_skin_item and weapon_skin_item ~= "" and rawget(attach_settings.item_definitions, weapon_skin_item)
		local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item, skin_data)
		local equipment
		local attachments_by_unit_3p, unit_attachment_id_3p, unit_attachment_name_3p, _, item_name_by_unit_3p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, unit_3p, true, false, true, optional_mission_template, equipment)

		VisualLoadoutCustomization.apply_material_overrides(item, unit_3p, parent_unit_3p, attach_settings)

		if skin_data then
			VisualLoadoutCustomization.apply_material_overrides(skin_data, unit_3p, parent_unit_3p, attach_settings)
		end

		VisualLoadoutCustomization.add_extensions(nil, attachments_by_unit_3p and attachments_by_unit_3p[unit_3p], attach_settings)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_3p, parent_unit_3p, false, deform_override, false)
			end
		end

		slot.attachments_by_unit_3p = attachments_by_unit_3p
		slot.attachment_id_lookup_3p = unit_attachment_id_3p
		slot.item_name_by_unit_3p = item_name_by_unit_3p
		slot.attachment_map_by_unit_3p = unit_attachment_name_3p
	end

	local parent_unit_1p = slot.parent_unit_1p

	if self:_should_spawn_1p(parent_unit_1p, item, slot) then
		local attach_settings = self:_attach_settings()

		self:_fill_attach_settings_1p(parent_unit_1p, attach_settings, slot)

		local unit_1p = slot.unit_1p
		local weapon_skin_item = item.slot_weapon_skin
		local skin_data = weapon_skin_item and weapon_skin_item ~= "" and rawget(attach_settings.item_definitions, weapon_skin_item)
		local skin_overrides = VisualLoadoutCustomization.generate_attachment_overrides_lookup(item, skin_data)
		local equipment
		local attachments_by_unit_1p, unit_attachment_id_1p, unit_attachment_name_1p, _, item_name_by_unit_1p = VisualLoadoutCustomization.spawn_item_attachments(item, skin_overrides, attach_settings, unit_1p, true, false, true, optional_mission_template, equipment)

		VisualLoadoutCustomization.apply_material_overrides(item, unit_1p, parent_unit_1p, attach_settings)

		if skin_data then
			VisualLoadoutCustomization.apply_material_overrides(skin_data, unit_1p, parent_unit_1p, attach_settings)
		end

		VisualLoadoutCustomization.add_extensions(nil, attachments_by_unit_1p and attachments_by_unit_1p[unit_1p], attach_settings)
		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(unit_1p, "custom_fov", true)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_1p, parent_unit_1p, false, deform_override, false)
			end
		end

		slot.attachments_by_unit_1p = attachments_by_unit_1p
		slot.attachment_id_lookup_1p = unit_attachment_id_1p
		slot.attachment_map_by_unit_1p = unit_attachment_name_1p
		slot.item_name_by_unit_1p = item_name_by_unit_1p
	end
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
	local item = slot.item

	slot.equipped = false
	slot.item = nil
	slot.deform_overrides = nil
	slot.breed_name = nil

	local unit_3p, attachments_by_unit_3p, unit_spawner = slot.unit_3p, slot.attachments_by_unit_3p, self._unit_spawner

	if slot.use_existing_unit_3p then
		if unit_alive(unit_3p) then
			unit_set_unit_visibility(unit_3p, true, true)

			local smart_tagging_id = Unit.find_actor(unit_3p, "smart_tagging")

			if smart_tagging_id then
				Actor.set_scene_query_enabled(Unit.actor(unit_3p, smart_tagging_id), true)
			end
		end
	elseif self:_is_companion_item(item) then
		_despawn_item_units(unit_spawner, nil, attachments_by_unit_3p and attachments_by_unit_3p[unit_3p])
	else
		_despawn_item_units(unit_spawner, unit_3p, attachments_by_unit_3p and attachments_by_unit_3p[unit_3p])
	end

	slot.unit_3p = nil
	slot.attachments_by_unit_3p = nil

	local unit_1p = slot.unit_1p

	if unit_1p then
		_despawn_item_units(unit_spawner, unit_1p, slot.attachments_by_unit_1p and slot.attachments_by_unit_1p[unit_1p])

		slot.unit_1p = nil
		slot.attachments_by_unit_1p = nil
	end

	slot.hidden_3p = nil
	slot.hidden_1p = nil
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

EquipmentComponent.equip_slot_dependencies = function (self, equipment, slot_equip_order, items, body_deform_overrides, breed_name, character_unit_3p, character_unit_1p, companion_unit_3p)
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

			self:equip_item(parent_unit_3p, parent_unit_1p, slot, item, nil, body_deform_overrides, breed_name, nil, nil, companion_unit_3p)
		end
	end
end

local hidden_slot_names = {}

local function _hidden_slot_names(equipment, base_unit_name, wielded_slot_name, first_person_mode)
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

	local attachment_units = slot.attachments_by_unit_1p and slot.attachments_by_unit_1p[base_unit]

	if attachment_units then
		for i = 1, #attachment_units do
			local attachment_unit = attachment_units[i]

			unit_flow_event(attachment_unit, event_name)
		end
	end
end

local function _slot_flow_event_3p(slot, event_name)
	local base_unit = slot.unit_3p

	if not Unit.alive(base_unit) then
		return
	end

	unit_flow_event(base_unit, event_name)

	if slot.attachments_by_unit_3p then
		local attachment_units = slot.attachments_by_unit_3p[base_unit]

		for i = 1, #attachment_units do
			local attachment_unit = attachment_units[i]

			unit_flow_event(attachment_unit, event_name)
		end
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

local _temp_unspawned_attachment_slots = {}

EquipmentComponent.try_spawn_attachments = function (self, equipment, slot_equip_order, optional_mission_template)
	if not self._has_slot_package_streaming then
		return false
	end

	table.clear(_temp_unspawned_attachment_slots)

	local has_unspawned_attachments = false
	local attachments_was_spawned = false

	for slot_name, slot in pairs(equipment) do
		local equipped = slot.equipped

		if equipped then
			local needs_spawning = slot.attachment_spawn_status == ATTACHMENT_SPAWN_STATUS.waiting_for_load
			local is_companion_item = self:_is_companion_item(slot.item)

			if needs_spawning then
				has_unspawned_attachments = true
				_temp_unspawned_attachment_slots[slot_name] = slot
			elseif is_companion_item then
				local slot_waiting_for_companion_unit = slot.attachment_spawn_status == ATTACHMENT_SPAWN_STATUS.waiting_for_companion_unit_spawn

				if slot_waiting_for_companion_unit then
					local unit_3p = slot.parent_unit_3p
					local companion_spawner_extension = ScriptUnit.has_extension(unit_3p, "companion_spawner_system")
					local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

					if companion_unit then
						slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_load
					end
				end
			end
		end
	end

	local all_unspawned_slots_are_loaded = true

	for _, slot in pairs(_temp_unspawned_attachment_slots) do
		if not self:_slot_is_loaded(slot) then
			all_unspawned_slots_are_loaded = false

			break
		end
	end

	if has_unspawned_attachments and all_unspawned_slots_are_loaded then
		attachments_was_spawned = true

		local slot_equip_order_n = #slot_equip_order

		for ii = 1, slot_equip_order_n do
			local slot_name = slot_equip_order[ii]
			local slot = _temp_unspawned_attachment_slots[slot_name]
			local slot_is_unspawned = slot ~= nil

			if slot_is_unspawned then
				self:_spawn_item_attachments(slot, optional_mission_template)
			end
		end
	end

	return attachments_was_spawned, _temp_unspawned_attachment_slots
end

EquipmentComponent.resolve_profile_properties = function (equipment, wielded_slot, static_profile_properties)
	local properties = table.shallow_copy(static_profile_properties)

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
				if value ~= "" then
					properties[name] = value
				end
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
	local slot_names_to_hide = _hidden_slot_names(equipment, base_unit_name, wielded_slot, first_person_mode)
	local slot_data = _get_unit_3p_and_item_for_wanted_slot(equipment, "slot_body_face")
	local slot_body_face_unit = slot_data.unit_3p

	if slot_body_face_unit then
		VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, "mask_face_none", false)
		VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, "hair_no_mask", false)
		VisualLoadoutCustomization.apply_material_override(slot_body_face_unit, unit_3p, false, "facial_hair_no_mask", false)
	end

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
		elseif EquipmentComponent.is_companion_slot(slot) then
			is_hidden_3p = false
			is_hidden_1p = true
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
					local slot_data = _get_unit_3p_and_item_for_wanted_slot(equipment, "slot_body_hair")
					local current_hair_item = slot_data.item

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
		local slot_gear_upperbody = _get_unit_3p_and_item_for_wanted_slot(equipment, "slot_gear_upperbody")
		local gear_upperbody_item = slot_gear_upperbody and slot_gear_upperbody.item

		if gear_upperbody_item and slot_names_to_hide.slot_body_arms == nil then
			local arms_unit = equipment.slot_body_arms and equipment.slot_body_arms.unit_1p

			if arms_unit then
				local mask_arms = gear_upperbody_item.mask_arms

				if mask_arms == "" or mask_arms == nil then
					mask_arms = "mask_default"
				end

				VisualLoadoutCustomization.apply_material_override(arms_unit, unit_1p, false, mask_arms, false)
			end
		end
	else
		local slot_gear_upperbody = _get_unit_3p_and_item_for_wanted_slot(equipment, "slot_gear_upperbody")
		local gear_upperbody_item = slot_gear_upperbody and slot_gear_upperbody.item

		if gear_upperbody_item then
			if slot_names_to_hide.slot_body_torso == nil then
				local torso_unit = equipment.slot_body_torso and equipment.slot_body_torso.unit_3p

				if torso_unit then
					local mask_torso = gear_upperbody_item.mask_torso

					if mask_torso == "" or mask_torso == nil then
						mask_torso = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(torso_unit, unit_3p, false, mask_torso, false)
				end
			end

			if slot_names_to_hide.slot_body_arms == nil then
				local arms_unit = equipment.slot_body_arms and equipment.slot_body_arms.unit_3p

				if arms_unit then
					local mask_arms = gear_upperbody_item.mask_arms

					if mask_arms == "" or mask_arms == nil then
						mask_arms = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(arms_unit, unit_3p, false, mask_arms, false)
				end
			end
		else
			local torso_unit = equipment.slot_body_torso and equipment.slot_body_torso.unit_3p
			local arms_unit = equipment.slot_body_arms and equipment.slot_body_arms.unit_3p
			local default_mask = "mask_default"

			if torso_unit then
				VisualLoadoutCustomization.apply_material_override(torso_unit, unit_3p, false, default_mask, false)
			end

			if arms_unit then
				VisualLoadoutCustomization.apply_material_override(arms_unit, unit_3p, false, default_mask, false)
			end
		end

		local slot_gear_lowerbody = _get_unit_3p_and_item_for_wanted_slot(equipment, "slot_gear_lowerbody")
		local gear_lowerbody_item = slot_gear_lowerbody and slot_gear_lowerbody.item

		if gear_lowerbody_item then
			if slot_names_to_hide.slot_body_legs == nil then
				local legs_unit = equipment.slot_body_legs and equipment.slot_body_legs.unit_3p

				if legs_unit then
					local mask_legs = gear_lowerbody_item.mask_legs

					if mask_legs == "" or mask_legs == nil then
						mask_legs = "mask_default"
					end

					VisualLoadoutCustomization.apply_material_override(legs_unit, unit_3p, false, mask_legs, false)
				end
			end
		else
			local legs_unit = equipment.slot_body_legs and equipment.slot_body_legs.unit_3p
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

	local attachments_3p = slot.attachments_by_unit_3p[unit_3p]

	for i = 1, #attachments_3p do
		local attachment_unit = attachments_3p[i]

		Component_event(attachment_unit, event_name, ...)
	end

	local unit_1p = slot.unit_1p

	if unit_1p then
		Component_event(unit_1p, event_name, ...)

		local attachments_1p = slot.attachments_by_unit_1p[unit_1p]

		for i = 1, #attachments_1p do
			local attachment_unit = attachments_1p[i]

			Component_event(attachment_unit, event_name, ...)
		end
	end
end

local COMPANION_ITEM_TYPES = {
	COMPANION_BODY_COAT_PATTERN = true,
	COMPANION_BODY_FUR_COLOR = true,
	COMPANION_BODY_SKIN_COLOR = true,
	COMPANION_GEAR_FULL = true,
}
local COMPANION_SLOT_NAMES = {
	slot_companion_body_coat_pattern = true,
	slot_companion_body_fur_color = true,
	slot_companion_body_skin_color = true,
	slot_companion_gear_full = true,
}

EquipmentComponent._should_spawn_3p = function (self, unit_3p, slot, item)
	local item_type = item and item.item_type

	if COMPANION_ITEM_TYPES[item_type] then
		return false
	end

	return not slot.use_existing_unit_3p and (not DEDICATED_SERVER or slot.wieldable)
end

EquipmentComponent._should_spawn_1p = function (self, unit_1p, item, slot)
	local item_type = item and item.item_type

	if COMPANION_ITEM_TYPES[item_type] then
		return false
	end

	return unit_1p and item.base_unit and item.show_in_1p and (not DEDICATED_SERVER or slot.wieldable)
end

EquipmentComponent._is_companion_item = function (self, item)
	local item_type = item and item.item_type

	return COMPANION_ITEM_TYPES[item_type]
end

EquipmentComponent.is_companion_slot = function (slot)
	local slot_name = slot and slot.name

	return COMPANION_SLOT_NAMES[slot_name]
end

return EquipmentComponent
