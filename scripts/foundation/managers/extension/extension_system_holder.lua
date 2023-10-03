require("scripts/foundation/managers/extension/extension_system_base")

local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local ExtensionSystemHolder = class("ExtensionSystemHolder")

ExtensionSystemHolder.init = function (self, extension_system_creation_context, system_configuration, system_init_data, fixed_time_step, use_time_slice)
	self._extension_manager = extension_system_creation_context.extension_manager
	self._world = extension_system_creation_context.world
	self._is_server = extension_system_creation_context.is_server
	self._fixed_time_step = fixed_time_step
	self._dt = nil
	self._t = nil
	self._systems = {}
	self._num_systems = 0
	local update_lists = {
		pre_update = {},
		fixed_update = {},
		update = {},
		post_update = {},
		physics_async_update = {}
	}
	self._update_lists = update_lists
	local system_update_context = {
		world = self._world,
		extension_manager = self._extension_manager,
		fixed_frame = 0
	}
	self._system_update_context = system_update_context

	if use_time_slice then
		local init_data = {
			last_index = 0,
			ready = false,
			parameters = {}
		}
		init_data.parameters.extension_system_creation_context = extension_system_creation_context
		init_data.parameters.system_configuration = system_configuration
		init_data.parameters.system_init_data = system_init_data
		self._init_data = init_data
		local post_init_data = {
			last_index = 0,
			ready = false,
			parameters = {}
		}
		post_init_data.parameters.level = nil
		post_init_data.parameters.themes = nil
		self._post_init_data = post_init_data
	else
		self:_init_systems(extension_system_creation_context, system_configuration, system_init_data)
	end
end

ExtensionSystemHolder._init_systems = function (self, extension_system_creation_context, system_configuration, system_init_data)
	for i, system_params in ipairs(system_configuration) do
		self:_add_system(extension_system_creation_context, system_init_data, unpack(system_params))
	end
end

ExtensionSystemHolder._add_system = function (self, context, system_init_data, name, class_name, has_pre_update, has_fixed_update, has_post_update, run_on_dedicated, run_in_runtime_loaded_level, extension_list, extension_list_ignore_on_dedicated)
	local class = CLASSES[class_name]

	if DEDICATED_SERVER and not run_on_dedicated then
		local ignore_extensions = class.system_extensions or {}

		if extension_list then
			table.append(ignore_extensions, extension_list)
		end

		self._extension_manager:add_ignore_extensions(ignore_extensions)
	else
		local extensions = {}

		if extension_list ~= nil then
			table.append(extensions, extension_list)
		end

		if not DEDICATED_SERVER and extension_list_ignore_on_dedicated ~= nil then
			table.append(extensions, extension_list_ignore_on_dedicated)
		end

		local init_data = system_init_data[name]
		local system = class:new(context, init_data, name, extensions, has_pre_update, has_fixed_update, has_post_update)

		if not has_pre_update then
			system.pre_update = false
		end

		if not has_post_update then
			system.post_update = false
		end

		if not has_fixed_update then
			system.fixed_update = false
		end

		for function_name, list in pairs(self._update_lists) do
			if system[function_name] then
				list[#list + 1] = system
			end
		end

		system:set_run_in_runtime_loaded_level(run_in_runtime_loaded_level)

		self._num_systems = self._num_systems + 1
		self._systems[self._num_systems] = system

		if DEDICATED_SERVER and extension_list_ignore_on_dedicated ~= nil then
			self._extension_manager:add_ignore_extensions(extension_list_ignore_on_dedicated)
		end
	end
end

ExtensionSystemHolder.on_reload = function (self, refreshed_resources)
	local systems = self._systems
	local num_systems = self._num_systems

	for i = 1, num_systems do
		local system = systems[i]

		if system.on_reload then
			system:on_reload(refreshed_resources)
		else
			Log.warning("ExtensionSystemHolder", "System %q is missing on_reload functionality!", system.NAME)
		end
	end
end

ExtensionSystemHolder.pre_update = function (self, dt, t)
	self._dt = dt
	self._t = t

	self:_system_update("pre_update", self._system_update_context, dt, t)
end

ExtensionSystemHolder.fixed_update = function (self, dt, t, frame)
	local context = self._system_update_context
	context.fixed_frame = frame

	self:_system_update("fixed_update", context, dt, t)
end

ExtensionSystemHolder.update = function (self)
	self:_system_update("update", self._system_update_context, self._dt, self._t)
end

ExtensionSystemHolder.post_update = function (self)
	self:_system_update("post_update", self._system_update_context, self._dt, self._t)
end

ExtensionSystemHolder.physics_async_update = function (self)
	self:_system_update("physics_async_update", self._system_update_context, self._dt, self._t)
end

ExtensionSystemHolder._system_update = function (self, update_func, system_update_context, dt, t)
	if dt == 0 then
		return
	end

	local update_list = self._update_lists[update_func]

	for i = 1, #update_list do
		local system = update_list[i]

		system[update_func](system, system_update_context, dt, t)
	end
end

ExtensionSystemHolder.initialize_client_fixed_frame = function (self, fixed_frame)
	self._system_update_context.fixed_frame = fixed_frame

	for i, system in ipairs(self._systems) do
		if system.initialize_client_fixed_frame then
			system:initialize_client_fixed_frame(fixed_frame)
		end
	end
end

ExtensionSystemHolder.latest_fixed_t = function (self)
	return self._system_update_context.fixed_frame * self._fixed_time_step
end

local TEMP_SYSTEM_LIST = {}

ExtensionSystemHolder.fixed_update_resimulate_unit = function (self, unit, from_frame, simulated_components, system_map, server_correction_system_map)
	local context = self._system_update_context
	local to_frame = context.fixed_frame
	local systems = self._systems
	local num_systems = self._num_systems

	for i = 1, num_systems do
		local system = systems[i]
		local extension_name = server_correction_system_map[system.NAME]

		if extension_name then
			system:unit_server_correction_occurred(unit, extension_name, from_frame, to_frame, simulated_components)
		end
	end

	local update_list = self._update_lists.fixed_update
	local system_list_size = 0

	for i = 1, #update_list do
		local system = update_list[i]

		if system_map[system.NAME] then
			system_list_size = system_list_size + 1
			TEMP_SYSTEM_LIST[system_list_size] = system
		end
	end

	local dt = self._fixed_time_step
	context.resimulate_from_frame = from_frame
	context.resimulate_to_frame = to_frame

	for frame = from_frame, to_frame do
		context.fixed_frame = frame
		local t = dt * frame
		local temp_byte_count = Script.temp_byte_count()

		for i = 1, system_list_size do
			local system = TEMP_SYSTEM_LIST[i]
			local extension_name = system_map[system.NAME]

			system:unit_fixed_update_extension(unit, extension_name, context, dt, t)
			Script.set_temp_byte_count(temp_byte_count)
		end
	end

	table.clear(TEMP_SYSTEM_LIST)
end

ExtensionSystemHolder.hot_join_sync = function (self, sender, channel)
	for i, system in ipairs(self._systems) do
		if system.hot_join_sync then
			system:hot_join_sync(sender, channel)
		end
	end
end

ExtensionSystemHolder.on_gameplay_post_init = function (self, level, themes)
	for i, system in ipairs(self._systems) do
		if system.on_gameplay_post_init then
			system:on_gameplay_post_init(level, themes)
		end
	end
end

ExtensionSystemHolder.is_init_ready = function (self)
	local init_data = self._init_data

	if init_data then
		return init_data.ready
	end

	return true
end

ExtensionSystemHolder.update_time_slice_init_systems = function (self)
	local init_data = self._init_data
	local last_index = init_data.last_index
	local extension_system_creation_context = init_data.parameters.extension_system_creation_context
	local system_configuration = init_data.parameters.system_configuration
	local system_init_data = init_data.parameters.system_init_data
	local num_systems = #system_configuration
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()

	for index = last_index + 1, num_systems do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local system_params = system_configuration[index]

		self:_add_system(extension_system_creation_context, system_init_data, unpack(system_params))

		init_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if init_data.last_index == num_systems then
		GameplayInitTimeSlice.set_finished(init_data)
	end

	return self:is_init_ready()
end

ExtensionSystemHolder.is_post_init_ready = function (self)
	local post_init_data = self._post_init_data

	if post_init_data then
		return post_init_data.ready
	end

	return true
end

ExtensionSystemHolder.init_time_slice_on_gameplay_post_init = function (self, level, themes)
	local post_init_data = self._post_init_data
	post_init_data.last_index = 0
	post_init_data.ready = false
	post_init_data.parameters.level = level
	post_init_data.parameters.themes = themes
end

ExtensionSystemHolder.update_time_slice_post_init_systems = function (self)
	local post_init_data = self._post_init_data
	local last_index = post_init_data.last_index
	local level = post_init_data.parameters.level
	local themes = post_init_data.parameters.themes
	local num_systems = #self._systems
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()

	for index = last_index + 1, num_systems do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local system = self._systems[index]

		if system.on_gameplay_post_init then
			system:on_gameplay_post_init(level, themes)
		end

		post_init_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if post_init_data.last_index == num_systems then
		GameplayInitTimeSlice.set_finished(post_init_data)
	end

	return self:is_post_init_ready()
end

ExtensionSystemHolder.destroy = function (self)
	for _, system in ipairs(self._systems) do
		system:destroy()
	end
end

return ExtensionSystemHolder
