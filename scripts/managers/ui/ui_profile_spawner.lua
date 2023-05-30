local Breeds = require("scripts/settings/breed/breeds")
local EquipmentComponent = require("scripts/extension_systems/visual_loadout/equipment_component")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UICharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local UIProfileSpawner = class("UIProfileSpawner")

UIProfileSpawner.init = function (self, reference_name, world, camera, unit_spawner, force_highest_lod_step, optional_mission_template)
	self._reference_name = reference_name
	self._world = world
	self._camera = camera
	self._unit_spawner = unit_spawner
	self._item_definitions = MasterItems.get_cached()
	self._mission_template = optional_mission_template
	self._visible = true

	if force_highest_lod_step == nil then
		self._force_highest_lod_step = true
	else
		self._force_highest_lod_step = force_highest_lod_step
	end

	self:reset()
end

UIProfileSpawner.reset = function (self)
	if self._single_item_profile_loader then
		self._single_item_profile_loader:destroy()
	end

	self:_despawn_current_character_profile()

	if self._loading_profile_data then
		self._loading_profile_data.profile_loader:destroy()

		self._loading_profile_data = nil
	end

	local single_item_loader_reference_name = self._reference_name .. "_single_item"
	self._single_item_profile_loader = UICharacterProfilePackageLoader:new(single_item_loader_reference_name, self._item_definitions, self._mission_template)
	self._ignored_slots = {}
	self._default_rotation_angle = 0
	self._rotation_angle = self._default_rotation_angle
	self._previous_rotation_angle = self._rotation_angle
end

UIProfileSpawner.node_world_position = function (self, node_name)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local node = self:_node(node_name) or 1
		local unit_3p = character_spawn_data.unit_3p
		local position = Unit.world_position(unit_3p, node)

		return position
	end
end

UIProfileSpawner._node = function (self, node_name)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit_3p = character_spawn_data.unit_3p
		local node = node_name and Unit.has_node(unit_3p, node_name) and Unit.node(unit_3p, node_name)

		return node
	end
end

UIProfileSpawner.spawn_profile = function (self, profile, position, rotation, scale, state_machine, animation_event, face_state_machine_key, face_animation_event, force_highest_mip, disable_hair_state_machine, optional_unit_3p, optional_ignore_state_machine)
	if self._loading_profile_data then
		self._loading_profile_data.profile_loader:destroy()

		self._loading_profile_data = nil
	end

	self._profile_loader_index = (self._profile_loader_index or 0) + 1
	local reference_name = self._reference_name .. "_profile_loader_" .. tostring(self._profile_loader_index)
	local character_profile_loader = UICharacterProfilePackageLoader:new(reference_name, self._item_definitions, self._mission_template)
	local loading_items = character_profile_loader:load_profile(profile)

	if not state_machine then
		local archetype = profile.archetype
		local breed_name = archetype and archetype.breed or profile.breed
		local breed_settings = Breeds[breed_name]
		state_machine = breed_settings.character_creation_state_machine
	end

	self._loading_profile_data = {
		profile = profile,
		profile_loader = character_profile_loader,
		reference_name = reference_name,
		position = position and Vector3.to_array(position),
		rotation = rotation and QuaternionBox(rotation),
		scale = scale and Vector3.to_array(scale),
		loading_items = loading_items,
		state_machine = state_machine,
		animation_event = animation_event,
		face_state_machine_key = face_state_machine_key,
		face_animation_event = face_animation_event,
		force_highest_mip = force_highest_mip,
		disable_hair_state_machine = disable_hair_state_machine or false,
		optional_unit_3p = optional_unit_3p,
		optional_ignore_state_machine = optional_ignore_state_machine
	}
end

UIProfileSpawner._apply_pending_animation_data = function (self)
	if self._pending_state_machine then
		local state_machine = self._pending_state_machine

		self:assign_state_machine(state_machine)
	end

	if self._pending_animation_event then
		local animation_event = self._pending_animation_event

		self:assign_animation_event(animation_event)
	end

	if self._pending_face_animation_event then
		local face_animation_event = self._pending_face_animation_event

		self:assign_face_animation_event(face_animation_event)
	end

	if self._pending_animation_variable_data then
		local index = self._pending_animation_variable_data.index
		local value = self._pending_animation_variable_data.value

		self:assign_animation_variable(index, value)
	end
end

UIProfileSpawner.assign_animation_variable = function (self, index, value)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit_3p = character_spawn_data.unit_3p
		local variable_id = Unit.animation_find_variable(unit_3p, index)

		if variable_id then
			Unit.animation_set_variable(unit_3p, variable_id, value)
		end

		self._pending_animation_variable_data = nil
	else
		self._pending_animation_variable_data = {
			index = index,
			value = value
		}
	end
end

UIProfileSpawner.assign_animation_event = function (self, animation_event)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		if animation_event then
			local unit_3p = character_spawn_data.unit_3p

			Unit.animation_event(unit_3p, animation_event)

			self._pending_animation_event = nil
		end
	else
		self._pending_animation_event = animation_event
	end
end

UIProfileSpawner.assign_face_animation_event = function (self, face_animation_event)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		if face_animation_event then
			local slots = self._character_spawn_data.slots
			local face_unit = slots.slot_body_face.unit_3p

			if Unit.has_animation_event(face_unit, "no_anim") then
				Unit.animation_event(face_unit, "no_anim")
			end

			if Unit.has_animation_event(face_unit, face_animation_event) then
				Unit.animation_event(face_unit, face_animation_event)
			end

			self._pending_face_animation_event = nil
		end
	else
		self._pending_face_animation_event = face_animation_event
	end
end

UIProfileSpawner.assign_state_machine = function (self, state_machine, optional_animation_event, optional_face_animation_event)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		if state_machine then
			local unit_3p = character_spawn_data.unit_3p

			Unit.set_animation_state_machine(unit_3p, state_machine)

			self._pending_state_machine = nil
		end
	else
		self._pending_state_machine = state_machine
	end

	if optional_animation_event then
		self:assign_animation_event(optional_animation_event)
	end

	if optional_face_animation_event then
		self:assign_face_animation_event(optional_face_animation_event)
	end
end

UIProfileSpawner._assign_face_state_machine = function (self, loadout, slots, face_state_machine_key)
	local head_item_data = loadout.slot_body_face
	local state_machine_name = head_item_data[face_state_machine_key]
	local face_unit = slots.slot_body_face.unit_3p

	if head_item_data and face_unit and state_machine_name and state_machine_name ~= "" then
		Unit.set_animation_state_machine(face_unit, state_machine_name)
	end
end

UIProfileSpawner._change_slot_item = function (self, slot_id, item)
	local character_spawn_data = self._character_spawn_data
	local loading_profile_data = self._loading_profile_data
	local use_loader_version = loading_profile_data ~= nil
	local loading_items = use_loader_version and loading_profile_data.loading_items or character_spawn_data.loading_items
	loading_items[slot_id] = item
	local loader = use_loader_version and loading_profile_data.profile_loader or self._single_item_profile_loader
	local complete_callback = callback(self, "cb_on_single_slot_item_loaded", slot_id, item)

	if item then
		loader:load_slot_item(slot_id, item, complete_callback)
	else
		complete_callback()
	end
end

UIProfileSpawner.cb_on_single_slot_item_loaded = function (self, slot_id, item)
	local character_spawn_data = self._character_spawn_data
	local loading_profile_data = self._loading_profile_data
	local use_loader_version = loading_profile_data ~= nil
	local profile_loader = use_loader_version and loading_profile_data.profile_loader or character_spawn_data.profile_loader
	local profile = use_loader_version and loading_profile_data.profile or character_spawn_data.profile
	local loadout = profile.loadout
	loadout[slot_id] = item

	if not use_loader_version then
		self:_equip_item_for_spawn_character(slot_id, item)
	end

	if item then
		profile_loader:load_slot_item(slot_id, item)
	end

	if not use_loader_version and self._visible then
		self:_update_items_visibility()
	end
end

UIProfileSpawner.destroy = function (self)
	if self._single_item_profile_loader then
		self._single_item_profile_loader:destroy()

		self._single_item_profile_loader = nil
	end

	self:_despawn_current_character_profile()

	if self._loading_profile_data then
		self._loading_profile_data.profile_loader:destroy()

		self._loading_profile_data = nil
	end
end

UIProfileSpawner._sync_profile_changes = function (self)
	local loading_profile_data = self._loading_profile_data
	local use_loader_version = loading_profile_data ~= nil
	local character_spawn_data = self._character_spawn_data
	local data = loading_profile_data or character_spawn_data

	if data then
		local profile = data.profile
		local loadout = profile.loadout
		local loading_items = data.loading_items
		local ignored_slots = self._ignored_slots

		for slot_id, config in pairs(ItemSlotSettings) do
			if not ignored_slots[slot_id] and not config.ignore_character_spawning then
				local item = loadout[slot_id]

				if use_loader_version then
					if loading_items[slot_id] ~= item then
						self:_change_slot_item(slot_id, item)
					end
				else
					local equipped_items = data.equipped_items
					local equipped_item = equipped_items[slot_id]

					if item ~= equipped_item and (loading_items[slot_id] ~= item or not item) then
						self:_change_slot_item(slot_id, item)
					end
				end
			end
		end
	end
end

UIProfileSpawner.update = function (self, dt, t, input_service)
	self:_sync_profile_changes()

	if self._character_spawn_data then
		self:_apply_pending_animation_data()

		if input_service then
			self:_handle_input(input_service, dt)
			self:_update_input_rotation(dt)
		end
	end

	local loading_profile_data = self._loading_profile_data

	if loading_profile_data then
		local profile_loader = loading_profile_data.profile_loader

		if profile_loader:is_all_loaded() then
			if self._character_spawn_data then
				self:_despawn_current_character_profile()
			end

			local position = loading_profile_data.position and Vector3.from_array(loading_profile_data.position)
			local rotation = loading_profile_data.rotation and QuaternionBox.unbox(loading_profile_data.rotation)
			local scale = loading_profile_data.scale and Vector3.from_array(loading_profile_data.scale)
			local state_machine = loading_profile_data.state_machine
			local animation_event = loading_profile_data.animation_event
			local face_state_machine_key = loading_profile_data.face_state_machine_key
			local face_animation_event = loading_profile_data.face_animation_event
			local force_highest_mip = loading_profile_data.force_highest_mip
			local disable_hair_state_machine = loading_profile_data.disable_hair_state_machine
			local optional_unit_3p = loading_profile_data.optional_unit_3p
			local profile = loading_profile_data.profile
			local optional_ignore_state_machine = loading_profile_data.optional_ignore_state_machine

			self:_spawn_character_profile(profile, profile_loader, position, rotation, scale, state_machine, animation_event, face_state_machine_key, face_animation_event, force_highest_mip, disable_hair_state_machine, optional_unit_3p, optional_ignore_state_machine)

			self._loading_profile_data = nil
		end
	end
end

UIProfileSpawner.spawned = function (self)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		return character_spawn_data.streaming_complete
	end

	return false
end

UIProfileSpawner.loading = function (self)
	return self._loading_profile_data ~= nil
end

UIProfileSpawner.spawned_character_unit = function (self)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit_3p = character_spawn_data.unit_3p

		return unit_3p
	end
end

UIProfileSpawner.set_position = function (self, position)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit_3p = character_spawn_data.unit_3p

		Unit.set_local_position(unit_3p, 1, position)
	else
		local loading_profile_data = self._loading_profile_data

		if loading_profile_data then
			loading_profile_data.position = Vector3.to_array(position)
		end
	end
end

UIProfileSpawner._handle_input = function (self, input_service, dt)
	if not self._rotation_input_disabled then
		local handled = not self._is_controller_rotating and self:_mouse_rotation_input(input_service, dt)

		if not handled then
			self:_controller_rotation_input(input_service, dt)
		end
	end
end

UIProfileSpawner._despawn_current_character_profile = function (self)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local profile_loader = character_spawn_data.profile_loader

		self:_despawn_players_gear()
		self._unit_spawner:remove_pending_units()
		self:_despawn_players_characters()
		profile_loader:destroy()

		self._character_spawn_data = nil
	end
end

UIProfileSpawner._despawn_players_characters = function (self)
	local world = self._world
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data and not character_spawn_data.has_external_unit_3p then
		local unit_3p = character_spawn_data.unit_3p

		World.destroy_unit(world, unit_3p)

		self._character_spawn_data = nil
	end
end

UIProfileSpawner._despawn_players_gear = function (self)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local equipment_component = character_spawn_data.equipment_component
		local equipped_items = character_spawn_data.equipped_items
		local slots = character_spawn_data.slots
		local slot_equip_order = PlayerCharacterConstants.slot_equip_order

		for i = #slot_equip_order, 1, -1 do
			local slot_id = slot_equip_order[i]
			local slot = slots[slot_id]

			if slot and slot.equipped then
				equipment_component:unequip_item(slot)
			end

			equipped_items[slot_id] = nil
		end
	end
end

UIProfileSpawner._equip_item_for_spawn_character = function (self, slot_id, item)
	local spawn_data = self._character_spawn_data
	local unit_3p = spawn_data.unit_3p
	local equipment_component = spawn_data.equipment_component
	local equipped_items = spawn_data.equipped_items
	local loading_items = spawn_data.loading_items
	local breed_name = spawn_data.breed_name
	local profile = spawn_data.profile
	local slots = spawn_data.slots
	local slot = slots[slot_id]
	local slot_config = PlayerCharacterConstants.slot_configuration[slot_id]
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order
	local slot_dependency_items = nil

	if slot.equipped then
		slot_dependency_items = equipment_component:unequip_slot_dependencies(slot_config, slots, slot_equip_order)

		equipment_component:unequip_item(slot)
	end

	local unit_spawner = self._unit_spawner

	if unit_spawner then
		unit_spawner:remove_pending_units()
	end

	equipped_items[slot_id] = item
	loading_items[slot_id] = nil
	local parent_item_unit = nil

	if slot and item then
		local gender = profile.gender
		local deform_overrides = {}

		if gender == "female" then
			deform_overrides[#deform_overrides + 1] = "wrap_deform_human_body_female"
		end

		local parent_unit_3p = unit_3p
		local parent_slot_names = item.parent_slot_names or {}

		for _, parent_slot_name in pairs(parent_slot_names) do
			local parent_slot_unit_3p = slots[parent_slot_name].unit_3p
			local parent_item = slots[parent_slot_name].item
			local parent_item_deform_overrides = parent_item and parent_item.deform_overrides or {}

			for _, deform_override in pairs(parent_item_deform_overrides) do
				deform_overrides[#deform_overrides + 1] = deform_override
			end

			if parent_slot_unit_3p then
				parent_unit_3p = parent_slot_unit_3p
				parent_item_unit = parent_unit_3p
				local apply_to_parent = item.material_override_apply_to_parent

				if apply_to_parent then
					local material_overrides = item.material_overrides

					for _, material_override in ipairs(material_overrides) do
						VisualLoadoutCustomization.apply_material_override(parent_unit_3p, nil, false, material_override, false)
					end
				end
			else
				Log.warning("UIProfileSpawner", "Item %s cannot attach to unit in slot %s as it is spawned in the wrong order. Fix the slot priority configuration", item.name, parent_slot_name)
			end
		end

		equipment_component:equip_item(parent_unit_3p, nil, slot, item, nil, deform_overrides, breed_name)

		if slot_dependency_items then
			equipment_component:equip_slot_dependencies(slots, slot_equip_order, slot_dependency_items, deform_overrides, breed_name, unit_3p, nil)
		end

		if parent_item_unit then
			Unit.set_unit_visibility(parent_item_unit, false, true)
		end

		local complete_callback = callback(self, "cb_on_unit_3p_streaming_complete_equip_item", parent_item_unit)

		Unit.force_stream_meshes(unit_3p, complete_callback, true)
	end
end

UIProfileSpawner.ignore_slot = function (self, slot_id)
	self._ignored_slots[slot_id] = true
end

UIProfileSpawner._spawn_character_profile = function (self, profile, profile_loader, position, rotation, scale, state_machine, animation_event, face_state_machine_key, face_animation_event, force_highest_mip, disable_hair_state_machine, optional_unit_3p, optional_ignore_state_machine)
	local loadout = profile.loadout
	local archetype = profile.archetype
	local archetype_name = archetype and archetype.name
	local breed_name = archetype and archetype.breed or profile.breed
	local optional_base_unit = profile.optional_base_unit
	local breed_settings = Breeds[breed_name]
	local base_unit = optional_base_unit or breed_settings.base_unit
	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()
	local spawn_rotation = rotation

	if self._rotation_angle and self._rotation_angle ~= 0 then
		local character_rotation_angle = Quaternion.axis_angle(Vector3(0, 0, 1), -self._rotation_angle)
		spawn_rotation = Quaternion.multiply(character_rotation_angle, spawn_rotation)
	end

	local unit_3p = optional_unit_3p

	if not unit_3p then
		if scale then
			local pose = Matrix4x4.from_quaternion_position(rotation, position)

			Matrix4x4.set_scale(pose, scale)

			unit_3p = World.spawn_unit_ex(self._world, base_unit, nil, pose)
		else
			unit_3p = World.spawn_unit_ex(self._world, base_unit, nil, position, spawn_rotation)
		end
	end

	local equipment_component = EquipmentComponent:new(self._world, self._item_definitions, self._unit_spawner, unit_3p, nil, nil, self._force_highest_lod_step)
	local slot_configuration = PlayerCharacterConstants.slot_configuration
	local gear_slots = {}
	local ignored_slots = self._ignored_slots

	for slot_id, config in pairs(slot_configuration) do
		if not ignored_slots[slot_id] and not config.ignore_character_spawning then
			gear_slots[slot_id] = config
		end
	end

	local slot_options = {
		slot_primary = {
			skip_link_children = false
		},
		slot_secondary = {
			skip_link_children = true
		}
	}
	local slots = equipment_component.initialize_equipment(gear_slots, slot_options)
	local slot_equip_order = PlayerCharacterConstants.slot_equip_order
	local equipped_items = {}

	for i = 1, #slot_equip_order do
		local slot_id = slot_equip_order[i]
		local slot = slots[slot_id]
		local item = loadout[slot_id]

		if slot and item then
			local gender = profile.gender
			local deform_overrides = {}

			if gender == "female" then
				deform_overrides[#deform_overrides + 1] = "wrap_deform_human_body_female"
			end

			local parent_unit_3p = unit_3p
			local parent_slot_names = item.parent_slot_names or {}

			for _, parent_slot_name in pairs(parent_slot_names) do
				local parent_slot_unit_3p = slots[parent_slot_name].unit_3p
				local parent_item = slots[parent_slot_name].item
				local parent_item_deform_overrides = parent_item and parent_item.deform_overrides or {}

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
					Log.warning("UIProfileSpawner", "Item %s cannot attach to unit in slot %s as it is spawned in the wrong order. Fix the slot priority configuration", item.name, parent_slot_name)
				end
			end

			equipment_component:equip_item(parent_unit_3p, nil, slot, item, nil, deform_overrides, breed_name)

			equipped_items[slot_id] = item
		end

		if unit_3p and not self._visible then
			Unit.set_unit_visibility(unit_3p, false, true)
		end
	end

	if state_machine and not optional_ignore_state_machine then
		Unit.set_animation_state_machine(unit_3p, state_machine)
	end

	if animation_event then
		Unit.animation_event(unit_3p, animation_event)
	end

	if face_state_machine_key then
		self:_assign_face_state_machine(loadout, slots, face_state_machine_key)
	end

	if face_animation_event then
		local face_unit = slots.slot_body_face.unit_3p

		if Unit.has_animation_event(face_unit, "no_anim") then
			Unit.animation_event(face_unit, "no_anim")
		end

		if Unit.has_animation_event(face_unit, face_animation_event) then
			Unit.animation_event(face_unit, face_animation_event)
		end
	end

	local spawn_data = {
		streaming_complete = false,
		slots = slots,
		archetype_name = archetype_name,
		breed_name = breed_name,
		equipment_component = equipment_component,
		equipped_items = equipped_items,
		profile_loader = profile_loader,
		rotation = rotation and QuaternionBox(rotation),
		loading_items = {},
		profile = profile,
		unit_3p = unit_3p,
		disable_hair_state_machine = disable_hair_state_machine,
		has_external_unit_3p = optional_unit_3p ~= nil
	}
	self._character_spawn_data = spawn_data
	local wield_slot_id = self._request_wield_slot_id

	if not wield_slot_id or self._ignored_slots[wield_slot_id] then
		wield_slot_id = "slot_unarmed"
	end

	self:wield_slot(wield_slot_id)

	local complete_callback = callback(self, "cb_on_unit_3p_streaming_complete", unit_3p)

	Unit.force_stream_meshes(unit_3p, complete_callback, true)
	self:cb_on_unit_3p_streaming_complete(unit_3p)
end

UIProfileSpawner.cb_on_unit_3p_streaming_complete_equip_item = function (self, unit_3p)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data and character_spawn_data.streaming_complete and self._visible then
		self:_update_items_visibility()
	end
end

UIProfileSpawner.cb_on_unit_3p_streaming_complete = function (self, unit_3p)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data and character_spawn_data.unit_3p == unit_3p then
		character_spawn_data.streaming_complete = true
		local disable_hair_state_machine = character_spawn_data.disable_hair_state_machine

		if disable_hair_state_machine then
			local slots = character_spawn_data.slots
			local hair_unit = slots.slot_body_hair.unit_3p

			if hair_unit then
				Unit.disable_animation_state_machine(hair_unit)
			end
		end
	end

	if self._visible then
		self:_update_items_visibility()
	end
end

UIProfileSpawner.wield_slot = function (self, slot_id)
	local spawn_data = self._character_spawn_data

	if not spawn_data then
		self._request_wield_slot_id = slot_id

		return
	end

	self._request_wield_slot_id = nil
	local equipment_component = spawn_data.equipment_component
	local first_person_mode = spawn_data.first_person_mode
	local slots = spawn_data.slots
	local wield_slot = slots[slot_id]

	equipment_component.wield_slot(wield_slot, first_person_mode)

	spawn_data.wielded_slot = wield_slot

	if self._visible then
		self:_update_items_visibility()
	end
end

UIProfileSpawner.set_visibility = function (self, visible)
	local update = visible ~= self._visible
	self._visible = visible

	if update then
		self:_update_items_visibility()
	end
end

UIProfileSpawner._update_items_visibility = function (self)
	local character_spawn_data = self._character_spawn_data

	if not character_spawn_data then
		return
	end

	local spawn_data = self._character_spawn_data
	local equipment_component = spawn_data.equipment_component
	local slots = spawn_data.slots
	local wielded_slot = spawn_data.wielded_slot
	local wielded_slot_name = wielded_slot.name
	local unit_3p = spawn_data.unit_3p
	local unit_1p = spawn_data.unit_1p
	local first_person_mode = spawn_data.first_person_mode

	if self._visible then
		equipment_component.update_item_visibility(slots, wielded_slot_name, unit_3p, unit_1p, first_person_mode)
	else
		Unit.set_unit_visibility(unit_3p, false, true)
	end
end

UIProfileSpawner._update_input_rotation = function (self, dt)
	local character_spawn_data = self._character_spawn_data

	if not character_spawn_data then
		return
	end

	local unit_3p = character_spawn_data.unit_3p
	local rotation_angle = nil

	if self._rotate_instantly then
		rotation_angle = self._rotation_angle
	else
		rotation_angle = math.lerp(self._previous_rotation_angle, self._rotation_angle, 0.2)
	end

	self._previous_rotation_angle = rotation_angle
	local character_rotation = Quaternion.axis_angle(Vector3(0, 0, 1), -rotation_angle)
	local boxed_start_rotation = character_spawn_data.rotation

	if boxed_start_rotation then
		local start_rotation = QuaternionBox.unbox(boxed_start_rotation)
		character_rotation = Quaternion.multiply(start_rotation, character_rotation)
	end

	Unit.set_local_rotation(unit_3p, 1, character_rotation)

	if self._auto_rotation_return and not self._is_rotating and self._rotation_angle ~= self._default_rotation_angle then
		local new_rotation_angle = math.lerp(self._default_rotation_angle, self._rotation_angle, 0.1)

		self:_set_character_rotation(new_rotation_angle)
	end
end

UIProfileSpawner._set_auto_rotation_return = function (self, enabled)
	self._auto_rotation_return = enabled
end

UIProfileSpawner._set_character_rotation = function (self, angle, instant)
	self._rotation_angle = angle
	self._rotate_instantly = instant
end

UIProfileSpawner.disable_rotation_input = function (self)
	self._rotation_input_disabled = true
end

local mouse_pos_temp = {}

UIProfileSpawner._mouse_rotation_input = function (self, input_service, dt)
	local mouse = input_service and input_service:get("cursor")

	if not mouse then
		return
	end

	local can_rotate = self._is_rotating or self:_is_character_pressed(input_service)
	local handled = false

	if can_rotate then
		if input_service:get("left_pressed") then
			self._is_rotating = true
			self._last_mouse_position = nil
			handled = true
		end

		if input_service:get("right_pressed") then
			self._previous_rotation_angle = self._previous_rotation_angle % (math.pi * 2)

			if math.pi < self._previous_rotation_angle then
				self._previous_rotation_angle = -(math.pi * 2 - self._previous_rotation_angle)
			end

			self:_set_character_rotation(self._default_rotation_angle)

			handled = true
		end
	end

	local is_moving_camera = self._is_rotating
	local mouse_hold = input_service:get("left_hold")

	if is_moving_camera and mouse_hold then
		if self._last_mouse_position then
			local angle = self._rotation_angle - (mouse.x - self._last_mouse_position[1]) * 0.005

			self:_set_character_rotation(angle)
		end

		mouse_pos_temp[1] = mouse.x
		mouse_pos_temp[2] = mouse.y
		self._last_mouse_position = mouse_pos_temp
		handled = true
	elseif is_moving_camera then
		self._is_rotating = false
		handled = true
	end

	return handled
end

UIProfileSpawner._controller_rotation_input = function (self, input_service, dt)
	local camera_move = input_service and input_service:get("navigate_controller_right")

	if not camera_move then
		return
	end

	if camera_move and Vector3.length(camera_move) > 0.01 then
		local angle = self._rotation_angle + -camera_move.x * dt * 5

		self:_set_character_rotation(angle)

		self._is_rotating = true
		self._is_controller_rotating = true
	elseif self._is_rotating then
		self._is_rotating = false
		self._is_controller_rotating = false
	end
end

UIProfileSpawner._is_character_pressed = function (self, input_service)
	local input_pressed = input_service:get("left_pressed") or input_service:get("right_pressed")

	if input_pressed then
		local physics_world = World.physics_world(self._world)

		if not physics_world then
			return
		end

		local cursor_name = "cursor"
		local cursor = input_service:get(cursor_name) or NilCursor
		local camera = self._camera

		if physics_world and camera then
			local screen_height = RESOLUTION_LOOKUP.height
			cursor[2] = screen_height - cursor[2]
			local from = Camera.screen_to_world(camera, Vector3(cursor[1], cursor[2], 0), 0)
			local direction = Camera.screen_to_world(camera, cursor, 1) - from
			local to = Vector3.normalize(direction)
			local collision_filter = "filter_player_detection"
			local hit_unit, hit_actor = self:_get_raycast_hit(from, to, physics_world, collision_filter)

			if hit_unit then
				return true
			end
		end
	end
end

UIProfileSpawner._get_raycast_hit = function (self, from, to, physics_world, collision_filter)
	local result, other = PhysicsWorld.raycast(physics_world, from, to, 10, "all", "collision_filter", collision_filter)

	if not result then
		return
	end

	local closest_distance = math.huge
	local closest_hit = nil
	local INDEX_DISTANCE = 2
	local INDEX_ACTOR = 4
	local num_hits = #result

	for i = 1, num_hits do
		local hit = result[i]
		local hit_distance = hit[INDEX_DISTANCE]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(hit_actor)

		if hit_distance < closest_distance then
			closest_distance = hit_distance
			closest_hit = hit
		end
	end

	if closest_hit then
		local hit_actor = closest_hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(hit_actor)

		return hit_unit, hit_actor
	end
end

UIProfileSpawner.character_scale = function (self)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit = character_spawn_data.unit_3p

		return Unit.local_scale(unit, 1)
	end

	return nil
end

UIProfileSpawner.rotation_angle = function (self)
	return self._rotation_angle
end

UIProfileSpawner.default_rotation_angle = function (self)
	return self._default_rotation_angle
end

UIProfileSpawner.set_character_scale = function (self, scale_value)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local unit = character_spawn_data.unit_3p
		local scale = Vector3(scale_value, scale_value, scale_value)

		Unit.set_local_scale(unit, 1, scale)
	end
end

UIProfileSpawner.set_character_rotation = function (self, angle, instant)
	self:_set_character_rotation(angle, instant)
end

UIProfileSpawner.set_character_default_rotation = function (self, angle, ignore_direct_application)
	self._default_rotation_angle = angle

	if not ignore_direct_application then
		self:_set_character_rotation(angle - 0.001)
	end
end

UIProfileSpawner.unit_3p_from_slot = function (self, slot_id)
	local character_spawn_data = self._character_spawn_data

	if character_spawn_data then
		local slot = character_spawn_data.slots[slot_id]

		if slot then
			local unit = slot.unit_3p

			return unit
		end
	end

	return nil
end

return UIProfileSpawner
