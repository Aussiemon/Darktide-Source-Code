local Component = require("scripts/utilities/component")
local VisualLoadoutLodGroup = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_lod_group")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local unit_alive = Unit.alive
local unit_set_unit_visibility = Unit.set_unit_visibility
local unit_has_visibility_group = Unit.has_visibility_group
local unit_set_visibility = Unit.set_visibility
local unit_flow_event = Unit.flow_event
local ATTACHMENT_SPAWN_STATUS = table.enum("waiting_for_load", "fully_spawned")
local FACIAL_HAIR_VISIBILITY_GROUPS = table.enum("eyebrows", "beard")
local _should_spawn_3p, _should_spawn_1p = nil
local EquipmentComponent = class("EquipmentComponent")

EquipmentComponent.init = function (self, world, item_definitions, unit_spawner, unit_3p, optional_extension_manager, optional_item_streaming_settings, optional_is_in_menu)
	self._world = world
	self._item_definitions = item_definitions
	self._unit_spawner = unit_spawner
	self.lod_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod")
	self.lod_shadow_group_3p = VisualLoadoutLodGroup.try_init_and_fetch_lod_group(unit_3p, "lod_shadow")
	self._extension_manager = optional_extension_manager
	self._is_in_menu = optional_is_in_menu
	local has_slot_package_streaming = optional_item_streaming_settings ~= nil
	self._has_slot_package_streaming = has_slot_package_streaming

	if has_slot_package_streaming then
		self._package_synchronizer_client = optional_item_streaming_settings.package_synchronizer_client
		self._player = optional_item_streaming_settings.player
	end
end

local function _create_slot_from_configuration(configuration, slot_options)
	local slot_name = configuration.name

	fassert(configuration.wieldable ~= nil, "wieldable is not defined in slot (%s)", slot_name)

	local slot = {
		name = slot_name,
		equipped = false,
		item = nil,
		unit_3p = nil,
		unit_1p = nil,
		parent_unit_3p = nil,
		parent_unit_1p = nil,
		attachments_3p = nil,
		attachments_1p = nil,
		hidden_3p = nil,
		hidden_1p = nil,
		wants_hidden_by_gameplay_1p = false,
		wants_hidden_by_gameplay_3p = false,
		buffable = configuration.buffable,
		wieldable = configuration.wieldable,
		wield_input = configuration.wield_input,
		use_existing_unit_3p = configuration.use_existing_unit_3p,
		item_loaded = nil,
		attachment_spawn_status = nil,
		deform_overrides = nil,
		breed_name = nil,
		hide_unit_in_slot = configuration.hide_unit_in_slot,
		skip_link_children = slot_options.skip_link_children or false
	}

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
	temp.is_in_menu = self._is_in_menu

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

EquipmentComponent.equip_item = function (self, unit_3p, unit_1p, slot, item, optional_existing_unit_3p, deform_overrides, optional_breed_name, optional_mission_template)
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

	self:_spawn_item_units(slot, unit_3p, unit_1p, attach_settings, optional_mission_template)

	if slot.use_existing_unit_3p then
		fassert(ALIVE[optional_existing_unit_3p], "[EquipmentComponent] Missing existing unit 3p when equipping item.")

		slot.attachments_3p = nil
		slot.unit_3p = optional_existing_unit_3p
		local smart_tagging_id = Unit.find_actor(optional_existing_unit_3p, "smart_tagging")

		if smart_tagging_id then
			Actor.set_collision_enabled(Unit.actor(optional_existing_unit_3p, smart_tagging_id), false)
		end
	end
end

EquipmentComponent._slot_is_loaded = function (self, slot)
	local player = self._player
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()
	local slot_is_loaded = self._package_synchronizer_client:alias_loaded(peer_id, local_player_id, slot.name)

	return slot_is_loaded
end

EquipmentComponent._spawn_item_units = function (self, slot, unit_3p, unit_1p, attach_settings, optional_mission_template)
	local item = slot.item
	local skip_attachments = nil

	if slot.item_loaded then
		skip_attachments = false
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
	else
		skip_attachments = true
		slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.waiting_for_load
	end

	if _should_spawn_3p(slot) then
		self:_fill_attach_settings_3p(attach_settings, slot)

		local item_unit_3p, attachment_units_3p = nil
		local item_data = slot.item

		if skip_attachments then
			item_unit_3p = VisualLoadoutCustomization.spawn_base_unit(item_data, attach_settings, unit_3p, optional_mission_template)
		else
			item_unit_3p, attachment_units_3p = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit_3p, nil, optional_mission_template)
		end

		slot.unit_3p = item_unit_3p
		slot.attachments_3p = attachment_units_3p
		local dynamic_id = Unit.find_actor(item_unit_3p, "dynamic")

		if dynamic_id then
			Unit.destroy_actor(item_unit_3p, dynamic_id)
		end

		local start_target_id = Unit.find_actor(item_unit_3p, "smart_tagging")

		if start_target_id then
			Unit.destroy_actor(item_unit_3p, start_target_id)
		end

		unit_set_unit_visibility(item_unit_3p, false, true)

		local player_visibility = ScriptUnit.has_extension(unit_3p, "player_visibility_system")

		if player_visibility then
			player_visibility:visibility_updated()
		end

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(slot.unit_3p, unit_3p, false, deform_override, false)
			end
		end

		local hide_unit_in_slot = slot.hide_unit_in_slot

		if hide_unit_in_slot then
			unit_set_unit_visibility(item_unit_3p, false, true)
		end
	end

	if _should_spawn_1p(unit_1p, item) then
		self:_fill_attach_settings_1p(attach_settings, slot.breed_name)

		local item_unit_1p, attachment_units_1p = nil
		local item_data = slot.item

		if skip_attachments then
			item_unit_1p = VisualLoadoutCustomization.spawn_base_unit(item_data, attach_settings, unit_1p, optional_mission_template)
		else
			item_unit_1p, attachment_units_1p = VisualLoadoutCustomization.spawn_item(item_data, attach_settings, unit_1p, nil, optional_mission_template)
		end

		slot.unit_1p = item_unit_1p
		slot.attachments_1p = attachment_units_1p
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
		local attachment_units_3p = VisualLoadoutCustomization.spawn_item_attachments(item, attach_settings, unit_3p, nil, optional_mission_template)
		local parent_unit = slot.parent_unit_3p

		VisualLoadoutCustomization.apply_material_overrides(item, unit_3p, parent_unit, attach_settings)
		VisualLoadoutCustomization.add_extensions(nil, attachment_units_3p, attach_settings)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_3p, parent_unit, false, deform_override, false)
			end
		end

		slot.attachments_3p = attachment_units_3p
	end

	local parent_unit_1p = slot.parent_unit_1p

	if _should_spawn_1p(parent_unit_1p, item) then
		local attach_settings = self:_attach_settings()

		self:_fill_attach_settings_1p(attach_settings, slot.breed_name)

		local unit_1p = slot.unit_1p
		local attachment_units_1p = VisualLoadoutCustomization.spawn_item_attachments(item, attach_settings, unit_1p, nil, optional_mission_template)

		VisualLoadoutCustomization.apply_material_overrides(item, unit_1p, parent_unit_1p, attach_settings)
		VisualLoadoutCustomization.add_extensions(nil, attachment_units_1p, attach_settings)
		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(unit_1p, "custom_fov", true)

		local deform_overrides = slot.deform_overrides

		if deform_overrides then
			for _, deform_override in pairs(deform_overrides) do
				VisualLoadoutCustomization.apply_material_override(unit_1p, parent_unit_1p, false, deform_override, false)
			end
		end

		slot.attachments_1p = attachment_units_1p
	end

	slot.attachment_spawn_status = ATTACHMENT_SPAWN_STATUS.fully_spawned
end

local function _despawn_item_units(unit_spawner, base_unit, attachments)
	if attachments then
		for i = #attachments, 1, -1 do
			local unit = attachments[i]

			unit_spawner:mark_for_deletion(unit)
		end
	end

	unit_spawner:mark_for_deletion(base_unit)
end

EquipmentComponent.unequip_item = function (self, slot)
	slot.equipped = false
	slot.item = nil
	slot.deform_overrides = nil
	slot.breed_name = nil
	local unit_3p = slot.unit_3p
	local unit_spawner = self._unit_spawner

	if slot.use_existing_unit_3p then
		if unit_alive(unit_3p) then
			unit_set_unit_visibility(unit_3p, true, true)

			local smart_tagging_id = Unit.find_actor(unit_3p, "smart_tagging")

			if smart_tagging_id then
				Actor.set_scene_query_enabled(Unit.actor(unit_3p, smart_tagging_id), true)
			end
		end
	else
		_despawn_item_units(unit_spawner, unit_3p, slot.attachments_3p)
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

	fassert(not slot_config.wieldable, "A wieldable slot being used as another slots dependency is going to be all kinds of trouble")
	fassert(not slot_config.use_existing_unit_3p, "A slot used as another slots dependency that used an existing unit is going to be all kinds of trouble")
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

local function _hide_base_unit(base_unit)
	unit_flow_event(base_unit, "lua_hidden")
end

local function _show_base_unit(base_unit)
	unit_flow_event(base_unit, "lua_visible")
end

local function _set_slot_hidden(slot, hidden_3p, hidden_1p)
	local unit_3p = slot.unit_3p

	if unit_3p and slot.hidden_3p ~= hidden_3p then
		slot.hidden_3p = hidden_3p

		if hidden_3p then
			_hide_base_unit(unit_3p)
		else
			_show_base_unit(unit_3p)
		end
	end

	local unit_1p = slot.unit_1p

	if unit_1p and slot.hidden_1p ~= hidden_1p then
		slot.hidden_1p = hidden_1p

		if hidden_1p then
			_hide_base_unit(unit_1p)
		else
			_show_base_unit(unit_1p)
		end
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
		selected_voice = selected_voice_property
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

	if unit_showing then
		unit_set_unit_visibility(unit_showing, true, true)
	end

	if unit_hidden then
		unit_set_unit_visibility(unit_hidden, false, true)
	end

	local base_unit_name = first_person_mode and "unit_1p" or "unit_3p"
	local slot_names_to_hide = _get_hidden_slot_names(equipment, base_unit_name, wielded_slot, first_person_mode)

	for slot_name, slot in pairs(equipment) do
		local is_hidden_3p, is_hidden_1p = nil
		local hide_unit_in_slot = slot.hide_unit_in_slot

		if hide_unit_in_slot and slot[base_unit_name] then
			unit_set_unit_visibility(slot[base_unit_name], false, true)
		end

		if slot_names_to_hide[slot_name] then
			is_hidden_1p = true
			is_hidden_3p = true

			if slot[base_unit_name] then
				unit_set_unit_visibility(slot[base_unit_name], false, true)
			end
		else
			is_hidden_3p = first_person_mode
			is_hidden_1p = not first_person_mode
		end

		_set_slot_hidden(slot, is_hidden_3p, is_hidden_1p)
	end

	if not first_person_mode then
		local slot_gear_head = equipment.slot_gear_head
		local head_gear_item = slot_gear_head.item

		if head_gear_item then
			local slot_body_face_hair = equipment.slot_body_face_hair
			local facial_hair_unit = slot_body_face_hair.unit_3p

			if facial_hair_unit then
				if unit_has_visibility_group(facial_hair_unit, "eyebrows") then
					local hide_eyebrows = head_gear_item.hide_eyebrows or false

					unit_set_visibility(facial_hair_unit, "eyebrows", not hide_eyebrows)
				end

				if unit_has_visibility_group(facial_hair_unit, "beard") then
					local hide_beard = head_gear_item.hide_beard or false

					unit_set_visibility(facial_hair_unit, "beard", not hide_beard)
				end
			end
		end
	end

	if player_visibility then
		player_visibility:visibility_updated()
	end
end

EquipmentComponent.slot_flow_event_1p = function (slot, event_name)
	local base_unit = slot.unit_1p

	unit_flow_event(base_unit, event_name)

	local attachment_units = slot.attachments_1p

	for i = 1, #attachment_units do
		local attachment_unit = attachment_units[i]

		unit_flow_event(attachment_unit, event_name)
	end
end

EquipmentComponent.slot_flow_event_3p = function (slot, event_name)
	local base_unit = slot.unit_3p

	unit_flow_event(base_unit, event_name)

	local attachment_units = slot.attachments_3p

	for i = 1, #attachment_units do
		local attachment_unit = attachment_units[i]

		unit_flow_event(attachment_unit, event_name)
	end
end

EquipmentComponent.wield_slot = function (slot, first_person_mode)
	local base_unit_1p = first_person_mode and slot.unit_1p
	local base_unit_3p = slot.unit_3p ~= nil and unit_alive(slot.unit_3p) and slot.unit_3p
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
	return not slot.use_existing_unit_3p
end

function _should_spawn_1p(unit_1p, item)
	return unit_1p and item.base_unit and item.show_in_1p
end

return EquipmentComponent
