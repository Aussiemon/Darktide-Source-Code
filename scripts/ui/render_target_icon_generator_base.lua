local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local RenderTargetAtlasGenerator = require("scripts/ui/render_target_atlas_generator")
local DEBUG = false
local REQUEST_PREVIEWER_FRAME_DELAY = 5
local RenderTargetIconGeneratorBase = class("RenderTargetIconGeneratorBase")

RenderTargetIconGeneratorBase.init = function (self, render_settings)
	self._unique_id = "RenderTargetIconGeneratorBase" .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._render_settings = render_settings
	self._capture_render_target = nil
	self._capture_render_target_size = nil
	self._requests_queue_order = {}
	self._requests_by_size = {}
	local width = render_settings and render_settings.width
	local height = render_settings and render_settings.height
	self._default_size = {
		width,
		height
	}
	self._default_render_target_capture_multiple = render_settings and render_settings.render_target_capture_multiple or 4
	self._id_counter = 0
	self._id_counter_prefix = tostring(math.uuid())
	self._render_target_atlas_generator = render_settings and render_settings.render_target_atlas_generator or RenderTargetAtlasGenerator:new()
	self._initialized_render_target_atlas = not render_settings or not render_settings.render_target_atlas_generator
	self._always_render = render_settings and render_settings.always_render
	self._render_enabled = true
end

RenderTargetIconGeneratorBase.update_all = function (self)
	local updated_request_ids = {}
	local requests_by_size = self._requests_by_size

	for size_key, requests in pairs(requests_by_size) do
		for request_id, request in pairs(requests) do
			local data = request.data

			if not updated_request_ids[request_id] then
				updated_request_ids[request_id] = true

				self:_update_request(request, data)
			end
		end
	end
end

RenderTargetIconGeneratorBase._reset_active_spawning = function (self)
	self._request_preview_lifetime_frame_count = nil
	local active_request = self._active_request

	if active_request then
		active_request.spawning = false
	end

	self._request_preview_lifetime_frame_count = nil
end

RenderTargetIconGeneratorBase.prioritize_request = function (self, reference_id)
	local request = self:_request_by_reference_id(reference_id)

	if request then
		local request_id = request.id

		if not request.spawned and not request.spawning then
			for i = 1, #self._requests_queue_order do
				if self._requests_queue_order[i] == request_id then
					table.remove(self._requests_queue_order, i)
				end
			end

			table.insert(self._requests_queue_order, 1, request_id)
		end
	end
end

RenderTargetIconGeneratorBase._update_request = function (self, request, data, prioritized)
	local request_id = request.id

	if request then
		for i = 1, #self._requests_queue_order do
			if self._requests_queue_order[i] == request_id then
				table.remove(self._requests_queue_order, i)
			end
		end

		if request.spawned then
			request.spawned = false

			if prioritized then
				table.insert(self._requests_queue_order, 1, request_id)
			else
				table.insert(self._requests_queue_order, #self._requests_queue_order + 1, request_id)
			end
		elseif request.spawning then
			self:_reset_active_spawning()
			table.insert(self._requests_queue_order, 1, request_id)

			self._active_request = nil
		elseif self._render_enabled then
			if prioritized then
				table.insert(self._requests_queue_order, 1, request_id)
			else
				table.insert(self._requests_queue_order, #self._requests_queue_order + 1, request_id)
			end
		end

		request.data = data
	end
end

RenderTargetIconGeneratorBase._request_by_id = function (self, request_id, ignore_assert)
	local requests_by_size = self._requests_by_size

	for size_key, requests in pairs(requests_by_size) do
		for _, request in pairs(requests) do
			if request.id == request_id then
				return request
			end
		end
	end

	if ignore_assert then
		-- Nothing
	end
end

RenderTargetIconGeneratorBase._request_by_reference_id = function (self, reference_id)
	local requests_by_size = self._requests_by_size

	for size_key, requests in pairs(requests_by_size) do
		for request_id, request in pairs(requests) do
			local references_lookup = request.references_lookup

			if references_lookup[reference_id] then
				return request
			end
		end
	end
end

RenderTargetIconGeneratorBase.has_request = function (self, reference_id)
	local request = self:_request_by_reference_id(reference_id)

	return request ~= nil
end

RenderTargetIconGeneratorBase._get_key_by_size = function (self, size)
	local key_string = tostring(size[1]) .. "x" .. tostring(size[2])

	return key_string
end

RenderTargetIconGeneratorBase.increment_icon_request_by_reference_id = function (self, existing_reference_id)
	local request = self:_request_by_reference_id(existing_reference_id)

	if request then
		local new_reference_id = self._id_counter_prefix .. "_" .. self._id_counter
		self._id_counter = self._id_counter + 1
		request.references_lookup[new_reference_id] = true
		request.references_array[#request.references_array + 1] = new_reference_id

		return new_reference_id
	end
end

RenderTargetIconGeneratorBase._generate_icon_request = function (self, request_id_prefix, data, on_load_callback, optional_render_context, prioritized, on_unload_callback, current_reference_id)
	local size = optional_render_context and optional_render_context.size or self._default_size
	local size_key = self:_get_key_by_size(size)
	local request_id = request_id_prefix .. "_" .. size_key
	local reference_id = current_reference_id or self._id_counter_prefix .. "_" .. self._id_counter
	self._id_counter = current_reference_id and self._id_counter or self._id_counter + 1
	local requests_by_size = self._requests_by_size
	local existing_requests = requests_by_size[size_key] and requests_by_size[size_key][request_id]

	if not existing_requests then
		if not requests_by_size[size_key] then
			requests_by_size[size_key] = {}
		end

		requests_by_size[size_key][request_id] = {
			spawned = false,
			spawning = false,
			render_context = optional_render_context,
			references_lookup = {},
			references_array = {},
			callbacks = {},
			destroy_callbacks = {},
			data = data,
			size = size,
			id = request_id,
			prioritized = prioritized
		}

		if self._render_enabled then
			if prioritized then
				table.insert(self._requests_queue_order, 1, request_id)
			else
				table.insert(self._requests_queue_order, #self._requests_queue_order + 1, request_id)
			end
		end
	elseif prioritized and not existing_requests.spawned and not existing_requests.spawning then
		for i = 1, #self._requests_queue_order do
			if self._requests_queue_order[i] == request_id then
				table.remove(self._requests_queue_order, i)
			end
		end

		table.insert(self._requests_queue_order, 1, request_id)
	elseif current_reference_id and self._render_enabled then
		if prioritized then
			table.insert(self._requests_queue_order, 1, request_id)
		else
			table.insert(self._requests_queue_order, #self._requests_queue_order + 1, request_id)
		end
	end

	local request = requests_by_size[size_key][request_id]
	request.references_lookup[reference_id] = true
	request.references_array[#request.references_array + 1] = reference_id

	if on_load_callback then
		request.callbacks[reference_id] = on_load_callback

		if request.spawned and self._render_enabled then
			local grid_index = request.grid_index
			local atlas_id = request.atlas_id
			local render_target, rows, columns = self._render_target_atlas_generator:get_atlas_render_target(atlas_id)

			on_load_callback(grid_index, rows, columns, render_target)
		end
	end

	if on_unload_callback then
		request.destroy_callbacks[reference_id] = on_unload_callback

		if not self._render_enabled then
			on_unload_callback()
		end
	end

	return reference_id
end

RenderTargetIconGeneratorBase.unload_request_reference = function (self, reference_id, keep_reference)
	local unload_request, unload_request_size_key = nil
	local requests_by_size = self._requests_by_size

	for size_key, requests in pairs(requests_by_size) do
		for request_id, request in pairs(requests) do
			local references_lookup = request.references_lookup

			if references_lookup[reference_id] then
				unload_request = request
				unload_request_size_key = size_key

				break
			end
		end
	end

	local request_id = unload_request.id
	local references_array = unload_request.references_array
	local references_lookup = unload_request.references_lookup
	local callbacks = unload_request.callbacks
	local destroy_callbacks = unload_request.destroy_callbacks

	if destroy_callbacks and destroy_callbacks[reference_id] then
		destroy_callbacks[reference_id]()
	end

	for i = 1, #references_array do
		if references_array[i] == reference_id then
			table.remove(references_array, i)

			break
		end
	end

	if #references_array == 0 then
		local grid_index = unload_request.grid_index
		local atlas_id = unload_request.atlas_id

		if grid_index and atlas_id then
			self._render_target_atlas_generator:free_atlas_grid_index(atlas_id, grid_index)
		end

		if keep_reference then
			requests_by_size[unload_request_size_key][request_id].spawned = false
			requests_by_size[unload_request_size_key][request_id].spawning = false
			requests_by_size[unload_request_size_key][request_id].grid_index = nil
			requests_by_size[unload_request_size_key][request_id].atlas_id = nil
		else
			requests_by_size[unload_request_size_key][request_id] = nil
		end

		if callbacks and not keep_reference then
			callbacks[reference_id] = nil
		end

		if destroy_callbacks and not keep_reference then
			destroy_callbacks[reference_id] = nil
		end

		if not keep_reference then
			references_lookup[reference_id] = nil
		end

		for i = 1, #self._requests_queue_order do
			if self._requests_queue_order[i] == request_id then
				table.remove(self._requests_queue_order, i)

				break
			end
		end

		if self._active_request and self._active_request == unload_request then
			self:_reset_active_spawning()

			self._active_request = nil
		end
	end
end

RenderTargetIconGeneratorBase._handle_request_queue = function (self)
	if self._shutting_down then
		return
	end

	local active_request = self._active_request

	if active_request then
		if self:_is_ready_to_capture_request() then
			if self._request_preview_lifetime_frame_count then
				self._request_preview_lifetime_frame_count = self._request_preview_lifetime_frame_count - 1

				if self._request_preview_lifetime_frame_count <= 0 then
					self._request_preview_lifetime_frame_count = nil
					local grid_index = active_request.grid_index
					local atlas_id = active_request.atlas_id
					local render_target_atlas_generator = self._render_target_atlas_generator

					render_target_atlas_generator:store_render_target_to_atlas(self._capture_render_target, atlas_id, grid_index)

					local render_target, rows, columns = render_target_atlas_generator:get_atlas_render_target(atlas_id)
					local callbacks = active_request.callbacks

					for id, on_load_callback in pairs(callbacks) do
						if self._render_enabled then
							on_load_callback(grid_index, rows, columns, render_target)
						end
					end

					active_request.spawned = true
					active_request.spawning = false

					self:_on_capture_complete()

					self._active_request = nil
				end
			else
				self._request_preview_lifetime_frame_count = active_request.frame_delay or REQUEST_PREVIEWER_FRAME_DELAY
			end
		end
	elseif #self._requests_queue_order > 0 then
		self:_handle_next_request_in_queue()
	end
end

RenderTargetIconGeneratorBase._handle_next_request_in_queue = function (self)
	if not self._world_spawner then
		self:_initialize_world()
		self:_setup_viewport()
	end

	local request_id = self._requests_queue_order[1]
	local request = self:_request_by_id(request_id)

	self:_handle_request(request)
end

RenderTargetIconGeneratorBase._handle_request = function (self, request)
	local grid_index = request.grid_index
	local atlas_id = request.atlas_id
	local size = request.size

	if not grid_index then
		grid_index, atlas_id = self._render_target_atlas_generator:generate_atlas_grid_index(size[1], size[2])
	end

	local capture_render_target_size = self._capture_render_target_size
	local update_viewport_render_target = not capture_render_target_size or capture_render_target_size[1] ~= size[1] or capture_render_target_size[2] ~= size[2]

	if update_viewport_render_target then
		self:_setup_viewport(size)
	end

	table.remove(self._requests_queue_order, 1)

	self._active_request = request
	request.grid_index = grid_index
	request.atlas_id = atlas_id
	request.spawning = true

	self:_prepare_request_capture(request)
end

RenderTargetIconGeneratorBase._initialize_world = function (self)
	local render_settings = self._render_settings
	local world_name = render_settings.world_name
	local world_layer = render_settings.world_layer
	local world_timer_name = render_settings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name)
	local level_name = render_settings.level_name
	local ignore_level_background = true

	self._world_spawner:spawn_level(level_name, nil, nil, nil, ignore_level_background)
end

RenderTargetIconGeneratorBase._setup_viewport = function (self, custom_size)
	local camera_unit = self:_camera_unit()
	local render_settings = self._render_settings
	local viewport_name = render_settings.viewport_name
	local viewport_type = DEBUG and "default" or render_settings.viewport_type
	local viewport_layer = render_settings.viewport_layer
	local shading_environment = render_settings.shading_environment

	if self._capture_render_target then
		Renderer.destroy_resource(self._capture_render_target)

		self._capture_render_target = nil
	end

	local width = custom_size and custom_size[1] or self._default_size[1]
	local height = custom_size and custom_size[2] or self._default_size[2]
	local default_render_target_capture_multiple = self._default_render_target_capture_multiple
	self._capture_render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, width * default_render_target_capture_multiple, height * default_render_target_capture_multiple, self._unique_id)
	self._capture_render_target_size = {
		width,
		height
	}
	local render_targets = {
		back_buffer = self._capture_render_target
	}

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment, nil, render_targets)
end

RenderTargetIconGeneratorBase._resume_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(false)
end

RenderTargetIconGeneratorBase._pause_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(true)
end

RenderTargetIconGeneratorBase.prepare_for_destruction = function (self)
	self._shutting_down = true
end

RenderTargetIconGeneratorBase.destroy = function (self)
	if self._initialized_render_target_atlas then
		self._render_target_atlas_generator:destroy()

		self._render_target_atlas_generator = nil
	end

	if self._capture_render_target then
		Renderer.destroy_resource(self._capture_render_target)

		self._capture_render_target = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

RenderTargetIconGeneratorBase.update = function (self, dt, t)
	if self._initialized_render_target_atlas then
		self._render_target_atlas_generator:update(dt, t)
	end

	self:_handle_request_queue()

	local world_spawner = self._world_spawner

	if not world_spawner then
		return
	end

	local should_render = self:_should_render()
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
end

RenderTargetIconGeneratorBase._should_render = function (self)
	return
end

RenderTargetIconGeneratorBase._prepare_request_capture = function (self, request)
	return
end

RenderTargetIconGeneratorBase._is_ready_to_capture_request = function (self)
	return
end

RenderTargetIconGeneratorBase._on_capture_complete = function (self)
	return
end

RenderTargetIconGeneratorBase._camera_unit = function (self)
	return
end

return RenderTargetIconGeneratorBase
