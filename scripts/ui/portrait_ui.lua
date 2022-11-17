local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local DEBUG = false
local PREVIEWER_FRAME_DELAY = 5
local PortraitUI = class("PortraitUI")

PortraitUI.init = function (self, render_settings)
	self._unique_id = "PortraitUI" .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._render_settings = render_settings
	self._profile_requests_queue_order = {}
	self._profile_requests = {}
	self._portrait_width = render_settings and render_settings.portrait_width
	self._portrait_height = render_settings and render_settings.portrait_height
	self._target_resolution_width = render_settings and render_settings.target_resolution_width
	self._target_resolution_height = render_settings and render_settings.target_resolution_height
	self._default_camera_settings_key = "human"
	self._breed_camera_settings = {}
	self._id_counter = 0
	self._id_counter_prefix = tostring(self)

	self:_create_uv_grid()
end

PortraitUI.update_all = function (self)
	local profile_requests = self._profile_requests

	for character_id, data in pairs(profile_requests) do
		local profile = data.profile

		self:profile_updated(profile)
	end
end

PortraitUI.profile_updated = function (self, profile, prioritized)
	local character_id = profile.character_id
	local data = self._profile_requests[character_id]

	if data then
		if data.spawned then
			data.spawned = false

			if prioritized then
				table.insert(self._profile_requests_queue_order, 1, character_id)
			else
				table.insert(self._profile_requests_queue_order, #self._profile_requests_queue_order + 1, character_id)
			end
		elseif data.spawning then
			data.spawning = false
			self._profile_spawner_lifetime_frame_count = nil

			if self._profile_spawner then
				self._profile_spawner:destroy()

				self._profile_spawner = nil
			end

			table.insert(self._profile_requests_queue_order, 1, character_id)
		else
			for i = 1, #self._profile_requests_queue_order do
				if self._profile_requests_queue_order[i] == character_id then
					table.remove(self._profile_requests_queue_order, i)
				end
			end

			if prioritized then
				table.insert(self._profile_requests_queue_order, 1, character_id)
			else
				table.insert(self._profile_requests_queue_order, #self._profile_requests_queue_order + 1, character_id)
			end
		end

		data.profile = profile
	end
end

PortraitUI.get_profile_grid_index = function (self, id)
	local data = self:_profile_request_by_id(id)
	local grid_index = data.grid_index

	return grid_index, self._num_rows, self._num_columns
end

PortraitUI._profile_request_by_id = function (self, id, ignore_assert)
	local profile_requests = self._profile_requests

	for character_id, data in pairs(profile_requests) do
		local references_lookup = data.references_lookup

		if references_lookup[id] then
			return data
		end
	end

	if ignore_assert then
		-- Nothing
	end
end

PortraitUI.has_request = function (self, id)
	local data = self:_profile_request_by_id(id, true)

	return data ~= nil
end

PortraitUI.load_profile_portrait = function (self, profile, on_load_callback, optional_render_context, prioritized)
	local character_id = profile.character_id
	local id = self._id_counter_prefix .. "_" .. self._id_counter
	self._id_counter = self._id_counter + 1

	if not self._profile_requests[character_id] then
		self._profile_requests[character_id] = {
			spawned = false,
			spawning = false,
			render_context = optional_render_context,
			references_lookup = {},
			references_array = {},
			callbacks = {},
			character_id = character_id,
			profile = profile
		}

		if prioritized then
			table.insert(self._profile_requests_queue_order, 1, character_id)
		else
			table.insert(self._profile_requests_queue_order, #self._profile_requests_queue_order + 1, character_id)
		end
	end

	local data = self._profile_requests[character_id]
	data.references_lookup[id] = true
	data.references_array[#data.references_array + 1] = id

	if data.spawned then
		local grid_index = self:_grid_index_by_character_id(character_id)

		if on_load_callback then
			on_load_callback(grid_index, self._num_rows, self._num_columns, self._icon_render_target)
		end
	else
		data.callbacks[id] = on_load_callback
	end

	return id
end

PortraitUI.unload_profile_portrait = function (self, id)
	local data = self:_profile_request_by_id(id)
	local character_id = data.character_id
	local references_array = data.references_array
	local references_lookup = data.references_lookup

	if #references_array == 1 then
		local grid_index = data.grid_index

		if grid_index then
			self:_free_grid_index(grid_index)
		end

		self._profile_requests[character_id] = nil

		for i = 1, #self._profile_requests_queue_order do
			if self._profile_requests_queue_order[i] == character_id then
				table.remove(self._profile_requests_queue_order, i)

				break
			end
		end
	else
		references_lookup[id] = nil

		for i = 1, #references_array do
			if references_array[i] == id then
				table.remove(references_array, i)

				break
			end
		end
	end
end

PortraitUI._handle_request_queue = function (self)
	local profile_spawner = self._profile_spawner

	if profile_spawner then
		if profile_spawner:spawned() then
			if self._profile_spawner_lifetime_frame_count then
				self._profile_spawner_lifetime_frame_count = self._profile_spawner_lifetime_frame_count - 1

				if self._profile_spawner_lifetime_frame_count <= 0 then
					self._profile_spawner_lifetime_frame_count = nil

					if self._profile_spawner then
						self._profile_spawner:destroy()

						self._profile_spawner = nil
					end

					local active_request = self._active_request
					local callbacks = active_request.callbacks
					local grid_index = active_request.grid_index
					local uvs = self:_grid_index_uvs(grid_index)
					local size_scale_x = uvs[2][1] - uvs[1][1]
					local size_scale_y = uvs[2][2] - uvs[1][2]
					local position_scale_x = uvs[1][1]
					local position_scale_y = uvs[1][2]

					Renderer.copy_render_target_rect(self._capture_render_target, 0, 0, 1, 1, self._icon_render_target, position_scale_x, position_scale_y, size_scale_x, size_scale_y)

					for id, on_load_callback in pairs(callbacks) do
						on_load_callback(grid_index, self._num_rows, self._num_columns, self._icon_render_target)
					end

					table.clear(callbacks)

					active_request.spawned = true
					active_request.spawning = false
				end
			else
				self._profile_spawner_lifetime_frame_count = PREVIEWER_FRAME_DELAY
			end
		end
	elseif #self._profile_requests_queue_order > 0 then
		self:_handle_next_request_in_queue()
	else
		self._active_request = nil
	end
end

PortraitUI._handle_next_request_in_queue = function (self)
	if not self._world_spawner then
		self:_initialize_world()

		self._icon_render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, self._target_resolution_width, self._target_resolution_height, self._unique_id)
		self._capture_render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, self._portrait_width * 4, self._portrait_height * 4, self._unique_id .. "_2")
		local render_targets = {
			back_buffer = self._capture_render_target
		}
		local default_camera_settings_key = self._default_camera_settings_key
		local camera_settings = self._breed_camera_settings[default_camera_settings_key]
		local camera_unit = camera_settings.camera_unit

		self:_setup_viewport(camera_unit, render_targets)
	end

	self._active_request = nil
	local num_in_queue = #self._profile_requests_queue_order

	if num_in_queue > 0 then
		local character_id = self._profile_requests_queue_order[1]
		local request = self._profile_requests[character_id]
		local grid_index = request.grid_index or self:_get_free_grid_index()

		if not grid_index then
			return
		end

		table.remove(self._profile_requests_queue_order, 1)

		self._active_request = request

		if not request.grid_index then
			request.grid_index = grid_index

			self:_occupy_grid_index(grid_index, character_id)
		end

		request.spawning = true
		local uvs = self:_grid_index_uvs(grid_index)
		local size_scale_x = uvs[2][1] - uvs[1][1]
		local size_scale_y = uvs[2][2] - uvs[1][2]
		local position_scale_x = uvs[1][1]
		local position_scale_y = uvs[1][2]
		local profile = request.profile
		local render_context = request.render_context

		self:_spawn_profile(profile, render_context)
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
	local force_highest_mip = true

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, optional_state_machine, optional_animation_event, optional_face_animation_event, force_highest_mip)

	local archetype = profile.archetype
	local breed = archetype.breed
	local camera_settings = self._breed_camera_settings[breed]
	local camera_unit = camera_settings.camera_unit

	if render_context then
		local camera_focus_slot_name = render_context.camera_focus_slot_name

		if camera_focus_slot_name then
			local key = breed .. "_" .. camera_focus_slot_name
			local new_camera_unit = self:_get_camera_unit_by_key(key)
			camera_unit = new_camera_unit or camera_unit
		end
	end

	self._world_spawner:change_camera_unit(camera_unit)

	if render_context then
		local wield_slot = render_context.wield_slot

		if wield_slot then
			self._profile_spawner:wield_slot(wield_slot)
		end
	end
end

PortraitUI._initialize_world = function (self)
	local world_name = self._render_settings.world_name
	local world_layer = self._render_settings.world_layer
	local world_timer_name = self._render_settings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name)

	Managers.event:register(self, "event_register_portrait_camera_human", "event_register_portrait_camera_human")
	Managers.event:register(self, "event_register_portrait_camera_ogryn", "event_register_portrait_camera_ogryn")
	Managers.event:register(self, "event_register_spawn_point_character_portrait", "event_register_spawn_point_character_portrait")

	local level_name = self._render_settings.level_name
	local ignore_level_background = true

	self._world_spawner:spawn_level(level_name, nil, nil, nil, ignore_level_background)
end

PortraitUI.event_register_spawn_point_character_portrait = function (self, spawn_point_unit)
	Managers.event:unregister(self, "event_register_spawn_point_character_portrait")

	self._spawn_point_unit = spawn_point_unit
end

PortraitUI.event_register_portrait_camera_human = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_human")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)
	self._breed_camera_settings.human = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

PortraitUI.event_register_portrait_camera_ogryn = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_ogryn")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)
	self._breed_camera_settings.ogryn = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

PortraitUI._setup_viewport = function (self, camera_unit, render_targets)
	local viewport_name = self._render_settings.viewport_name
	local viewport_type = DEBUG and "default" or self._render_settings.viewport_type
	local viewport_layer = self._render_settings.viewport_layer
	local shading_environment = self._render_settings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment, nil, render_targets)
end

PortraitUI._resume_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(false)
end

PortraitUI._pause_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(true)
end

PortraitUI.destroy = function (self)
	if self._icon_render_target then
		Renderer.destroy_resource(self._icon_render_target)

		self._icon_render_target = nil
	end

	if self._capture_render_target then
		Renderer.destroy_resource(self._capture_render_target)

		self._capture_render_target = nil
	end

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

PortraitUI.active = function (self)
	return self._active
end

PortraitUI.update = function (self, dt, t)
	self:_handle_request_queue()

	local world_spawner = self._world_spawner

	if not world_spawner then
		return
	end

	local profile_spawner = self._profile_spawner
	local should_render = profile_spawner and profile_spawner:spawned()
	local update_world = not world_spawner:world_disabled()

	if not self._render_world and should_render then
		update_world = true
		self._render_world = true

		self:_resume_rendering()
	elseif self._render_world and not should_render then
		self._render_world = false

		self:_pause_rendering()
	end

	if update_world then
		world_spawner:update(dt, t)
	end

	if profile_spawner then
		profile_spawner:update(dt, t)
	end
end

PortraitUI._create_uv_grid = function (self)
	self._uv_grid_index_by_character_id = {}
	self._uv_grid_index_occupation_list = {}
	local num_columns = math.floor(self._target_resolution_width / self._portrait_width)
	local num_rows = math.floor(self._target_resolution_height / self._portrait_height)
	local uv_grid = {}

	for i = 1, num_rows do
		local y_start = (i - 1) / num_rows
		local y_end = i / num_rows

		for j = 1, num_columns do
			local x_start = (j - 1) / num_columns
			local x_end = j / num_columns
			local uvs = {
				{
					x_start,
					y_start
				},
				{
					x_end,
					y_end
				}
			}
			local grid_index = #uv_grid + 1
			uv_grid[grid_index] = uvs
			self._uv_grid_index_occupation_list[grid_index] = false
		end
	end

	self._num_rows = num_rows
	self._num_columns = num_columns
	self._uv_grid = uv_grid
end

PortraitUI._get_free_grid_index = function (self)
	local uv_grid_index_occupation_list = self._uv_grid_index_occupation_list

	for i = 1, #uv_grid_index_occupation_list do
		local occupied = uv_grid_index_occupation_list[i]

		if not occupied then
			return i
		end
	end

	Log.warning("PortraitUI", "Trying to go out of bound and request a grid index.")
end

PortraitUI._grid_index_by_character_id = function (self, character_id)
	local grid_index = self._uv_grid_index_by_character_id[character_id]

	return grid_index
end

PortraitUI._occupy_grid_index = function (self, index, character_id)
	self._uv_grid_index_occupation_list[index] = true
	self._uv_grid_index_by_character_id[character_id] = index
end

PortraitUI._free_grid_index = function (self, index)
	self._uv_grid_index_occupation_list[index] = false

	for character_id, grid_index in pairs(self._uv_grid_index_by_character_id) do
		if grid_index == index then
			self._uv_grid_index_by_character_id[character_id] = nil

			break
		end
	end
end

PortraitUI._grid_index_uvs = function (self, index)
	return self._uv_grid[index]
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

return PortraitUI
