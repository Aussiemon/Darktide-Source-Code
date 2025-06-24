-- chunkname: @scripts/ui/portrait_ui.lua

require("scripts/ui/render_target_icon_generator_base")

local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local PortraitUI = class("PortraitUI", "RenderTargetIconGeneratorBase")

PortraitUI.init = function (self, render_settings)
	PortraitUI.super.init(self, render_settings)

	self._default_camera_settings_key = "human"
	self._breed_camera_settings = {}
end

PortraitUI.profile_updated = function (self, profile, prioritized)
	local character_id = profile.character_id
	local requests_by_size = self._requests_by_size

	for size_key, requests in pairs(requests_by_size) do
		for _, request in pairs(requests) do
			if string.find(request.id, character_id, nil, true) then
				self:_update_request(request, profile, prioritized)
			end
		end
	end
end

PortraitUI.unload_profile_portrait = function (self, reference_id)
	self:unload_request_reference(reference_id)
end

PortraitUI.change_render_portrait_status = function (self, value, force_change)
	if not self._always_render and Application.rendering_enabled() and (self._render_enabled ~= value or force_change) then
		self._render_enabled = value

		if value then
			local requests_by_size = self._requests_by_size

			for size_key, requests in pairs(requests_by_size) do
				for request_id, request in pairs(requests) do
					for reference_id, _ in pairs(request.references_lookup) do
						local on_load_callback = request.callbacks[reference_id]
						local on_unload_callback = request.destroy_callbacks[reference_id]

						self:_generate_icon_request(request_id, request.data, on_load_callback, request.render_context, request.prioritized, on_unload_callback, reference_id)
					end
				end
			end
		else
			local requests_by_size = self._requests_by_size

			for size_key, requests in pairs(requests_by_size) do
				for request_id, request in pairs(requests) do
					for reference_id, _ in pairs(request.references_lookup) do
						self:unload_request_reference(reference_id, true)
					end
				end
			end
		end
	end
end

PortraitUI.load_profile_portrait = function (self, profile, on_load_callback, optional_render_context, prioritized, on_unload_callback)
	local character_id = profile.character_id
	local request_id_prefix = character_id or math.uuid()
	local request_data = profile

	if not self._always_render then
		local changed_player = false

		if self._current_player ~= Managers.player:local_player(1) then
			self._current_player = Managers.player:local_player(1)
			changed_player = true
		end

		if self._current_player then
			local portrait_enabled_status = self:_check_portrait_enabled_status()

			if portrait_enabled_status ~= self._render_enabled then
				if changed_player then
					Crashify.print_property("ui_portrait_enabled", portrait_enabled_status)
				end

				self:change_render_portrait_status(portrait_enabled_status)
			end
		end
	end

	local reference_id = self:_generate_icon_request(request_id_prefix, request_data, on_load_callback, optional_render_context, prioritized, on_unload_callback)

	return reference_id
end

PortraitUI._check_portrait_enabled_status = function (self)
	local force_disable = false

	if force_disable then
		return false
	end

	local save_manager = Managers.save

	if self._current_player and save_manager then
		local account_data = save_manager:account_data()

		return account_data.interface_settings.portrait_rendering_enabled
	end
end

PortraitUI._spawn_profile = function (self, profile, render_context)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local profile_spawner = UIProfileSpawner:new("PortraitUI", world, camera, unit_spawner)

	self._profile_spawner = profile_spawner

	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)
	local optional_state_machine = render_context and render_context.state_machine
	local optional_animation_event = render_context and render_context.animation_event
	local optional_face_animation_event = render_context and render_context.face_animation_event
	local optional_companion_state_machine = render_context and render_context.companion_state_machine
	local optional_companion_animation_event = render_context and render_context.companion_animation_event
	local ignore_companion = true

	if render_context and render_context.ignore_companion ~= nil then
		ignore_companion = render_context.ignore_companion
	end

	local force_highest_mip = true
	local disable_hair_state_machine = true
	local companion_data = {
		state_machine = optional_companion_state_machine,
		animation_event = optional_companion_animation_event,
		ignore = ignore_companion,
	}

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, optional_state_machine, optional_animation_event, nil, optional_face_animation_event, force_highest_mip, disable_hair_state_machine, nil, nil, companion_data)

	local archetype = profile.archetype
	local breed = archetype.breed
	local camera_settings = self._breed_camera_settings[breed]
	local camera_unit = camera_settings.camera_unit

	if render_context then
		local camera_focus_slot_name = render_context.camera_focus_slot_name

		if camera_focus_slot_name then
			local camera_settings_by_item_slot = camera_settings.camera_settings_by_item_slot
			local slot_camera_settings = camera_settings_by_item_slot[camera_focus_slot_name]

			if slot_camera_settings then
				camera_settings = slot_camera_settings
				camera_unit = slot_camera_settings.camera_unit
			end
		end
	end

	world_spawner:change_camera_unit(camera_unit)

	local camera_position = Vector3.from_array(camera_settings.boxed_camera_start_position)
	local camera_rotation = camera_settings.boxed_camera_start_rotation:unbox()

	if render_context then
		local wield_slot = render_context.wield_slot

		if wield_slot then
			self._profile_spawner:wield_slot(wield_slot)
		end
	end

	local icon_camera_adjustment = profile.loadout.slot_animation_end_of_round

	if render_context and icon_camera_adjustment then
		local position_offset = icon_camera_adjustment.icon_render_camera_position_offset

		if position_offset then
			camera_position = Vector3(camera_position.x + (position_offset[1] or 0), camera_position.y + (position_offset[2] or 0), camera_position.z + (position_offset[3] or 0))
		end

		local rotation_offset = icon_camera_adjustment.icon_render_camera_rotation_offset

		if rotation_offset then
			camera_rotation = Quaternion.multiply(camera_rotation, Quaternion.from_euler_angles_xyz(rotation_offset[1] or 0, rotation_offset[2] or 0, rotation_offset[3] or 0))
		end
	end

	world_spawner:set_camera_position(camera_position)
	world_spawner:set_camera_rotation(camera_rotation)
end

PortraitUI.destroy = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	PortraitUI.super.destroy(self)
end

PortraitUI.update = function (self, dt, t)
	PortraitUI.super.update(self, dt, t)

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t)
	end
end

PortraitUI._should_render = function (self)
	local profile_spawner = self._profile_spawner
	local should_render = profile_spawner and profile_spawner:spawned()

	return should_render
end

PortraitUI._prepare_request_capture = function (self, request)
	local data = request.data
	local render_context = request.render_context

	self:_spawn_profile(data, render_context)
end

PortraitUI._is_ready_to_capture_request = function (self)
	local profile_spawner = self._profile_spawner

	if profile_spawner then
		return profile_spawner:spawned()
	end

	return false
end

PortraitUI._on_capture_complete = function (self, active_request)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end
end

PortraitUI._initialize_world = function (self)
	Managers.event:register(self, "event_register_portrait_camera_human", "event_register_portrait_camera_human")
	Managers.event:register(self, "event_register_portrait_camera_ogryn", "event_register_portrait_camera_ogryn")
	Managers.event:register(self, "event_register_spawn_point_character_portrait", "event_register_spawn_point_character_portrait")
	PortraitUI.super._initialize_world(self)
end

PortraitUI.event_register_spawn_point_character_portrait = function (self, spawn_point_unit)
	Managers.event:unregister(self, "event_register_spawn_point_character_portrait")

	self._spawn_point_unit = spawn_point_unit
end

PortraitUI.event_register_portrait_camera_human = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_human")

	local breed = "human"

	self:_store_camera_settings_by_breed(breed, camera_unit)
end

PortraitUI.event_register_portrait_camera_ogryn = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_ogryn")

	local breed = "ogryn"

	self:_store_camera_settings_by_breed(breed, camera_unit)
end

PortraitUI._store_camera_settings_by_breed = function (self, breed, camera_unit)
	local camera_settings_by_item_slot = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		local key = breed .. "_" .. slot_name
		local slot_camera_unit = self:_get_camera_unit_by_key(key)

		if slot_camera_unit then
			local slot_camera_position = Unit.world_position(slot_camera_unit, 1)
			local slot_camera_rotation = Unit.world_rotation(slot_camera_unit, 1)

			camera_settings_by_item_slot[slot_name] = {
				breed = breed,
				slot_name = slot_name,
				camera_unit = slot_camera_unit,
				boxed_camera_start_position = Vector3.to_array(slot_camera_position),
				boxed_camera_start_rotation = QuaternionBox(slot_camera_rotation),
			}
		end
	end

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)

	self._breed_camera_settings[breed] = {
		breed = breed,
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation),
		camera_settings_by_item_slot = camera_settings_by_item_slot,
	}
end

PortraitUI._get_camera_unit_by_key = function (self, key)
	return self:_get_unit_by_value_key("camera_gear_slot_name", key)
end

PortraitUI._get_unit_by_value_key = function (self, key, value)
	local world_spawner = self._world_spawner
	local level = world_spawner:level()
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]
		local unit_array_size = Unit.data_table_size(unit, key) or 0

		for j = 1, unit_array_size do
			local unit_array_value = Unit.get_data(unit, key, j)

			if not unit_array_value then
				return
			elseif value == unit_array_value then
				return unit
			end
		end
	end
end

PortraitUI._reset_active_spawning = function (self)
	PortraitUI.super._reset_active_spawning(self)

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end
end

PortraitUI._camera_unit = function (self)
	local default_camera_settings_key = self._default_camera_settings_key
	local camera_settings = self._breed_camera_settings[default_camera_settings_key]
	local camera_unit = camera_settings.camera_unit

	return camera_unit
end

return PortraitUI
