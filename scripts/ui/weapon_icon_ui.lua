local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UISettings = require("scripts/settings/ui/ui_settings")
local PREVIEWER_FRAME_DELAY = 5
local WeaponIconUI = class("WeaponIconUI")

WeaponIconUI.init = function (self, render_settings)
	self._unique_id = "WeaponIconUI" .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._render_settings = {
		world_name = render_settings and render_settings.world_name or "weapon_icon_world_" .. self._unique_id,
		world_layer = render_settings and render_settings.world_layer or 800,
		timer_name = render_settings and render_settings.timer_name or "ui",
		viewport_layer = render_settings and render_settings.viewport_layer or 900,
		viewport_type = render_settings and render_settings.viewport_type or "default_with_alpha",
		viewport_name = render_settings and render_settings.viewport_name or "weapon_viewport",
		level_name = render_settings and render_settings.level_name or "content/levels/ui/weapon_icon/weapon_icon",
		shading_environment = render_settings and render_settings.shading_environment or "content/shading_environments/ui/weapon_icons"
	}
	local weapon_icon_size = UISettings.weapon_icon_size
	self._weapon_width = render_settings and render_settings.weapon_width or weapon_icon_size[1]
	self._weapon_height = render_settings and render_settings.weapon_height or weapon_icon_size[2]
	self._target_resolution_width = render_settings and render_settings.target_resolution_width or self._weapon_width * 10
	self._target_resolution_height = render_settings and render_settings.target_resolution_height or self._weapon_width * 10
	self._icon_requests_queue_order = {}
	self._icon_requests = {}
	self._default_camera_settings_key = "human"
	self._breed_camera_settings = {}
	self._id_counter = 0
	self._id_prefix = tostring(self)

	self:_create_uv_grid()
end

WeaponIconUI.update_all = function (self)
	local icon_requests = self._icon_requests

	for gear_id, data in pairs(icon_requests) do
		local item = data.item

		self:weapon_icon_updated(item)
	end
end

WeaponIconUI.weapon_icon_updated = function (self, item, prioritized)
	local gear_id = item.gear_id
	local data = self._icon_requests[gear_id]

	if data then
		if data.spawned then
			data.spawned = false

			if prioritized then
				table.insert(self._icon_requests_queue_order, 1, gear_id)
			else
				table.insert(self._icon_requests_queue_order, #self._icon_requests_queue_order + 1, gear_id)
			end
		elseif data.spawning then
			data.spawning = false
			self._ui_weapon_spawner_lifetime_frame_count = nil

			if self._ui_weapon_spawner then
				self._ui_weapon_spawner:destroy()

				self._ui_weapon_spawner = nil
			end
		else
			for i = 1, #self._icon_requests_queue_order do
				if self._icon_requests_queue_order[i] == gear_id then
					table.remove(self._icon_requests_queue_order, i)
				end
			end

			if prioritized then
				table.insert(self._icon_requests_queue_order, 1, gear_id)
			else
				table.insert(self._icon_requests_queue_order, #self._icon_requests_queue_order + 1, gear_id)
			end
		end

		data.item = item
	end
end

WeaponIconUI.get_icon_grid_index = function (self, id)
	local data = self:_icon_request_by_id(id)
	local grid_index = data.grid_index

	return grid_index, self._num_rows, self._num_columns
end

WeaponIconUI.load_weapon_icon = function (self, item, on_load_callback, render_context, prioritized)
	local id = self._id_prefix .. "_" .. self._id_counter
	self._id_counter = self._id_counter + 1
	local gear_id = item.gear_id or item.name

	if not self._icon_requests[gear_id] then
		self._icon_requests[gear_id] = {
			spawned = false,
			spawning = false,
			references_lookup = {},
			references_array = {},
			callbacks = {},
			gear_id = gear_id,
			item = item,
			id = id,
			render_context = render_context
		}

		if prioritized then
			table.insert(self._icon_requests_queue_order, 1, gear_id)
		else
			table.insert(self._icon_requests_queue_order, #self._icon_requests_queue_order + 1, gear_id)
		end
	end

	local data = self._icon_requests[gear_id]
	data.references_lookup[id] = true
	data.references_array[#data.references_array + 1] = id

	if data.spawned then
		local grid_index = self:_grid_index_by_gear_id(gear_id)

		if on_load_callback then
			on_load_callback(grid_index, self._num_rows, self._num_columns, self._icon_render_target)
		end
	else
		data.callbacks[id] = on_load_callback
	end

	return id
end

WeaponIconUI._icon_request_by_id = function (self, id, ignore_assert)
	local icon_requests = self._icon_requests

	for gear_id, data in pairs(icon_requests) do
		local references_lookup = data.references_lookup

		if references_lookup[id] then
			return data
		end
	end

	if not ignore_assert then
		-- Nothing
	end
end

WeaponIconUI.has_request = function (self, id)
	local data = self:_icon_request_by_id(id, true)

	return data ~= nil
end

WeaponIconUI.unload_weapon_icon = function (self, id)
	local data = self:_icon_request_by_id(id)
	local gear_id = data.gear_id
	local references_array = data.references_array
	local references_lookup = data.references_lookup
	local callbacks = data.callbacks

	if #references_array == 1 then
		local grid_index = data.grid_index

		if grid_index then
			self:_free_grid_index(grid_index)
		end

		self._icon_requests[gear_id] = nil

		for i = 1, #self._icon_requests_queue_order do
			if self._icon_requests_queue_order[i] == gear_id then
				table.remove(self._icon_requests_queue_order, i)

				break
			end
		end
	else
		if callbacks then
			callbacks[id] = nil
		end

		references_lookup[id] = nil

		for i = 1, #references_array do
			if references_array[i] == id then
				table.remove(references_array, i)

				break
			end
		end
	end
end

WeaponIconUI._handle_request_queue = function (self)
	local ui_weapon_spawner = self._ui_weapon_spawner

	if ui_weapon_spawner then
		if ui_weapon_spawner:spawned() then
			if self._ui_weapon_spawner_lifetime_frame_count then
				self._ui_weapon_spawner_lifetime_frame_count = self._ui_weapon_spawner_lifetime_frame_count - 1

				if self._ui_weapon_spawner_lifetime_frame_count <= 0 then
					self._ui_weapon_spawner_lifetime_frame_count = nil

					if self._ui_weapon_spawner then
						self._ui_weapon_spawner:destroy()

						self._ui_weapon_spawner = nil
					end

					local active_request = self._active_request
					local grid_index = active_request.grid_index
					local uvs = self:_grid_index_uvs(grid_index)
					local size_scale_x = uvs[2][1] - uvs[1][1]
					local size_scale_y = uvs[2][2] - uvs[1][2]
					local position_scale_x = uvs[1][1]
					local position_scale_y = uvs[1][2]
					local callbacks = active_request.callbacks

					if self._capture_render_target and self._icon_render_target and not self._shutting_down then
						Renderer.copy_render_target_rect(self._capture_render_target, 0, 0, 1, 1, self._icon_render_target, position_scale_x, position_scale_y, size_scale_x, size_scale_y)

						local grid_index = active_request.grid_index

						for id, on_load_callback in pairs(callbacks) do
							on_load_callback(grid_index, self._num_rows, self._num_columns, self._icon_render_target)
						end
					end

					table.clear(callbacks)

					active_request.spawned = true
					active_request.spawning = false
				end
			else
				self._ui_weapon_spawner_lifetime_frame_count = PREVIEWER_FRAME_DELAY
			end
		end
	elseif #self._icon_requests_queue_order > 0 then
		self:_handle_next_request_in_queue()
	elseif self._ui_weapon_spawner then
		self._active_request = nil

		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end
end

WeaponIconUI._handle_next_request_in_queue = function (self)
	if not self._world_spawner then
		self:_initialize_world()

		self._icon_render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, self._target_resolution_width, self._target_resolution_height, self._unique_id)
		self._capture_render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, self._weapon_width * 4, self._weapon_height * 4, self._unique_id .. "_2")
		local render_targets = {
			back_buffer = self._capture_render_target
		}
		local default_camera_settings_key = self._default_camera_settings_key
		local camera_settings = self._breed_camera_settings[default_camera_settings_key]
		local camera_unit = camera_settings and camera_settings.camera_unit

		self:_setup_viewport(camera_unit, render_targets)
	end

	self._active_request = nil
	local num_in_queue = #self._icon_requests_queue_order

	if num_in_queue > 0 then
		local gear_id = self._icon_requests_queue_order[1]
		local grid_index = self._icon_requests[gear_id].grid_index or self:_get_free_grid_index()

		if not grid_index then
			return
		end

		table.remove(self._icon_requests_queue_order, 1)

		local request = self._icon_requests[gear_id]

		self:_occupy_grid_index(grid_index, gear_id)

		request.spawning = true
		request.grid_index = grid_index
		self._active_request = request
		local uvs = self:_grid_index_uvs(grid_index)
		local size_scale_x = uvs[2][1] - uvs[1][1]
		local size_scale_y = uvs[2][2] - uvs[1][2]
		local position_scale_x = uvs[1][1]
		local position_scale_y = uvs[1][2]
		local item = request.item
		local render_context = request.render_context

		self:_spawn_weapon(item, render_context)
	end
end

WeaponIconUI._spawn_weapon = function (self, item, render_context)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local ui_weapon_spawner = UIWeaponSpawner:new("WeaponIconUI", world, camera, unit_spawner)
	self._ui_weapon_spawner = ui_weapon_spawner
	local alignment_key = "weapon_alignment_tag"

	if render_context and render_context.alignment_key then
		alignment_key = render_context.alignment_key
	end

	local item_base_unit_name = item.base_unit
	local item_level_link_unit = self:_get_unit_by_value_key(alignment_key, item_base_unit_name)
	local spawn_point_unit = item_level_link_unit or self._spawn_point_unit
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local spawn_scale = Unit.world_scale(spawn_point_unit, 1)
	local force_highest_mip = true

	ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation, spawn_scale, nil, force_highest_mip)

	local breed = "human"
	local camera_settings = self._breed_camera_settings[breed]

	if camera_settings then
		local camera_position = Vector3.from_array(camera_settings.boxed_camera_start_position)
		local camera_rotation = camera_settings.boxed_camera_start_rotation:unbox()

		world_spawner:set_camera_position(camera_position)
		world_spawner:set_camera_rotation(camera_rotation)
	end
end

WeaponIconUI._initialize_world = function (self)
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

WeaponIconUI.event_register_spawn_point_character_portrait = function (self, spawn_point_unit)
	Managers.event:unregister(self, "event_register_spawn_point_character_portrait")

	self._spawn_point_unit = spawn_point_unit
end

WeaponIconUI.event_register_portrait_camera_human = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_human")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)
	self._breed_camera_settings.human = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

WeaponIconUI.event_register_portrait_camera_ogryn = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_ogryn")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)
	self._breed_camera_settings.ogryn = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

WeaponIconUI._setup_viewport = function (self, camera_unit, render_targets)
	local viewport_name = self._render_settings.viewport_name
	local viewport_type = self._render_settings.viewport_type
	local viewport_layer = self._render_settings.viewport_layer
	local shading_environment = self._render_settings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment, nil, render_targets)
end

WeaponIconUI._resume_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(false)
end

WeaponIconUI._pause_rendering = function (self)
	local world_spawner = self._world_spawner

	world_spawner:set_world_disabled(true)
end

WeaponIconUI.prepare_for_destruction = function (self)
	self._shutting_down = true
end

WeaponIconUI.destroy = function (self)
	if self._icon_render_target then
		Renderer.destroy_resource(self._icon_render_target)

		self._icon_render_target = nil
	end

	if self._capture_render_target then
		Renderer.destroy_resource(self._capture_render_target)

		self._capture_render_target = nil
	end

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

WeaponIconUI.active = function (self)
	return self._active
end

WeaponIconUI.update = function (self, dt, t)
	self:_handle_request_queue()

	local world_spawner = self._world_spawner

	if not world_spawner then
		return
	end

	local ui_weapon_spawner = self._ui_weapon_spawner
	local should_render = ui_weapon_spawner and ui_weapon_spawner:spawned()
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

	if ui_weapon_spawner then
		ui_weapon_spawner:update(dt, t)
	end
end

WeaponIconUI._create_uv_grid = function (self)
	self._uv_grid_index_by_gear_id = {}
	self._uv_grid_index_occupation_list = {}
	local num_columns = math.floor(self._target_resolution_width / self._weapon_width)
	local num_rows = math.floor(self._target_resolution_height / self._weapon_height)
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

WeaponIconUI._get_free_grid_index = function (self)
	local uv_grid_index_occupation_list = self._uv_grid_index_occupation_list

	for i = 1, #uv_grid_index_occupation_list do
		local occupied = uv_grid_index_occupation_list[i]

		if not occupied then
			return i
		end
	end
end

WeaponIconUI._grid_index_by_gear_id = function (self, gear_id)
	local grid_index = self._uv_grid_index_by_gear_id[gear_id]

	return grid_index
end

WeaponIconUI._occupy_grid_index = function (self, index, gear_id)
	self._uv_grid_index_occupation_list[index] = true
	self._uv_grid_index_by_gear_id[gear_id] = index
end

WeaponIconUI._free_grid_index = function (self, index)
	self._uv_grid_index_occupation_list[index] = false

	for gear_id, grid_index in pairs(self._uv_grid_index_by_gear_id) do
		if grid_index == index then
			self._uv_grid_index_by_gear_id[gear_id] = nil

			break
		end
	end
end

WeaponIconUI._grid_index_uvs = function (self, index)
	return self._uv_grid[index]
end

WeaponIconUI._get_unit_by_value_key = function (self, key, value)
	local world_spawner = self._world_spawner
	local level = world_spawner:level()
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) == value then
			return unit
		end
	end
end

return WeaponIconUI
