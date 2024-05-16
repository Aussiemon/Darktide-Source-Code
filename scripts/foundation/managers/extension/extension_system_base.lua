-- chunkname: @scripts/foundation/managers/extension/extension_system_base.lua

local ExtensionSystemBase = class("ExtensionSystemBase")

ExtensionSystemBase.init = function (self, extension_system_creation_context, system_init_data, system_name, extension_list, has_pre_update, has_fixed_update, has_post_update)
	self._is_server = extension_system_creation_context.is_server
	self._world = extension_system_creation_context.world
	self._wwise_world = extension_system_creation_context.wwise_world
	self._nav_world = extension_system_creation_context.nav_world
	self._physics_world = extension_system_creation_context.physics_world
	self._name = system_name

	local extension_manager = extension_system_creation_context.extension_manager

	extension_manager:register_system(self, system_name, extension_list)

	self._extension_manager = extension_manager
	self._network_event_delegate = extension_system_creation_context.network_event_delegate
	self._run_in_runtime_loaded_level = false
	self._extension_init_context = {
		fixed_frame = 0,
		fixed_frame_t = 0,
		physics_world = self._physics_world,
		wwise_world = extension_system_creation_context.wwise_world,
		nav_world = self._nav_world,
		world = self._world,
		extension_manager = self._extension_manager,
		network_event_delegate = self._network_event_delegate,
		is_server = self._is_server,
		has_navmesh = extension_system_creation_context.has_navmesh,
		soft_cap_out_of_bounds_units = extension_system_creation_context.soft_cap_out_of_bounds_units,
		owner_system = self,
	}
	self._update_list = {}
	self._extensions = {}
	self._profiler_names = {}

	if has_fixed_update then
		self._fixed_update_extensions = {}
	end

	self._unit_to_extension_map = {}
	self._hot_join_sync_list = {}

	for i = 1, #extension_list do
		local extension_name = extension_list[i]
		local update_list = {
			update = {},
			hot_join_sync = {},
		}

		if has_pre_update then
			update_list.pre_update = {}
		end

		if has_fixed_update then
			update_list.fixed_update = {}
		end

		if has_post_update then
			update_list.post_update = {}
		end

		self._update_list[extension_name] = update_list
		self._extensions[extension_name] = 0
		self._profiler_names[extension_name] = extension_name .. " [ALL]"
	end
end

ExtensionSystemBase.initialize_client_fixed_frame = function (self, fixed_frame)
	if self._extension_init_context then
		self._extension_init_context.fixed_frame = fixed_frame
		self._extension_init_context.fixed_frame_t = fixed_frame * Managers.state.game_session.fixed_time_step
	end
end

ExtensionSystemBase.unit_to_extension_map = function (self)
	return self._unit_to_extension_map
end

ExtensionSystemBase.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension_alias = self._name
	local extension = ScriptUnit.add_extension(self._extension_init_context, unit, extension_name, extension_alias, extension_init_data, ...)

	self._extensions[extension_name] = (self._extensions[extension_name] or 0) + 1

	if extension.hot_join_sync then
		self._hot_join_sync_list[unit] = extension
	end

	if extension.fixed_update then
		self._fixed_update_extensions[unit] = extension
	end

	self._unit_to_extension_map[unit] = extension

	return extension
end

ExtensionSystemBase.register_extension_update = function (self, unit, extension_name, extension)
	local extension_update_list = self._update_list[extension_name]

	if not extension.UPDATE_DISABLED_BY_DEFAULT then
		if extension.pre_update then
			extension_update_list.pre_update[unit] = extension
		end

		if extension.fixed_update then
			extension_update_list.fixed_update[unit] = extension
		end

		if extension.update then
			extension_update_list.update[unit] = extension
		end

		if extension.post_update then
			extension_update_list.post_update[unit] = extension
		end
	end
end

ExtensionSystemBase.on_remove_extension = function (self, unit, extension_name)
	local extension = ScriptUnit.has_extension(unit, self._name)

	self._extensions[extension_name] = self._extensions[extension_name] - 1

	local extension_update_list = self._update_list[extension_name]

	if extension.pre_update then
		extension_update_list.pre_update[unit] = nil
	end

	if extension.fixed_update then
		extension_update_list.fixed_update[unit] = nil
	end

	if extension.update then
		extension_update_list.update[unit] = nil
	end

	if extension.post_update then
		extension_update_list.post_update[unit] = nil
	end

	if extension.hot_join_sync then
		self._hot_join_sync_list[unit] = nil
	end

	if extension.fixed_update then
		self._fixed_update_extensions[unit] = nil
	end

	ScriptUnit.remove_extension(unit, self._name)

	self._unit_to_extension_map[unit] = nil
end

ExtensionSystemBase.enable_update_function = function (self, extension_name, update_function_name, unit, extension)
	self._update_list[extension_name][update_function_name][unit] = extension
end

ExtensionSystemBase.disable_update_function = function (self, extension_name, update_function_name, unit)
	self._update_list[extension_name][update_function_name][unit] = nil
end

ExtensionSystemBase.has_update_function = function (self, extension_name, update_function_name, unit)
	return self._update_list[extension_name][update_function_name][unit] ~= nil
end

ExtensionSystemBase.set_unit_local = function (self, unit)
	self._hot_join_sync_list[unit] = nil

	local extension = self._unit_to_extension_map[unit]

	if extension.set_unit_local then
		extension:set_unit_local()
	end
end

ExtensionSystemBase.on_reload = function (self, refreshed_resources)
	local unit_to_extension_map = self._unit_to_extension_map

	if unit_to_extension_map then
		for unit, extension in pairs(unit_to_extension_map) do
			if extension.on_reload then
				extension:on_reload(unit, refreshed_resources)
			end
		end
	else
		Log.warning("ExtensionSystemBase", "System %q does not have a self._unit_to_extension_map. Skipping running on_reload functionality.", self.NAME)
	end
end

ExtensionSystemBase.pre_update = function (self, context, dt, t, ...)
	local update_list = self._update_list

	for extension_name, _ in pairs(self._extensions) do
		local profiler_name = self._profiler_names[extension_name]

		for unit, extension in pairs(update_list[extension_name].pre_update) do
			extension:pre_update(unit, dt, t, context, ...)
		end
	end
end

ExtensionSystemBase.fixed_update = function (self, context, dt, t, ...)
	local update_list = self._update_list
	local fixed_frame = context.fixed_frame

	self._extension_init_context.fixed_frame = fixed_frame
	self._extension_init_context.fixed_frame_t = fixed_frame * Managers.state.game_session.fixed_time_step

	for extension_name, _ in pairs(self._extensions) do
		local profiler_name = self._profiler_names[extension_name]

		for unit, extension in pairs(update_list[extension_name].fixed_update) do
			extension:fixed_update(unit, dt, t, fixed_frame, context, ...)
		end
	end
end

ExtensionSystemBase.update = function (self, context, dt, t, ...)
	local update_list = self._update_list

	for extension_name, _ in pairs(self._extensions) do
		local profiler_name = self._profiler_names[extension_name]

		for unit, extension in pairs(update_list[extension_name].update) do
			extension:update(unit, dt, t, context, ...)
		end
	end
end

ExtensionSystemBase.post_update = function (self, context, dt, t, ...)
	local update_list = self._update_list

	for extension_name, _ in pairs(self._extensions) do
		local profiler_name = self._profiler_names[extension_name]

		for unit, extension in pairs(update_list[extension_name].post_update) do
			extension:post_update(unit, dt, t, context, ...)
		end
	end
end

ExtensionSystemBase.pre_update_extension = function (self, extension_name, dt, t, context, ...)
	for unit, extension in pairs(self._update_list[extension_name].pre_update) do
		extension:pre_update(unit, dt, t, context, ...)
	end
end

ExtensionSystemBase.fixed_update_extension = function (self, extension_name, dt, t, context, ...)
	local frame = context.fixed_frame

	for unit, extension in pairs(self._update_list[extension_name].fixed_update) do
		extension:fixed_update(unit, dt, t, frame, context, ...)
	end
end

ExtensionSystemBase.update_extension = function (self, extension_name, dt, t, context, ...)
	for unit, extension in pairs(self._update_list[extension_name].update) do
		extension:update(unit, dt, t, context, ...)
	end
end

ExtensionSystemBase.post_update_extension = function (self, extension_name, dt, t, context, ...)
	for unit, extension in pairs(self._update_list[extension_name].post_update) do
		extension:post_update(unit, dt, t, context, ...)
	end
end

ExtensionSystemBase.unit_server_correction_occurred = function (self, unit, extension_name, from_frame, to_frame, simulated_components)
	local extension = self._unit_to_extension_map[unit]

	extension:server_correction_occurred(unit, from_frame, to_frame, simulated_components)
end

ExtensionSystemBase.unit_fixed_update_extension = function (self, unit, extension_name, context, dt, t, ...)
	local fixed_update_list = self._fixed_update_extensions
	local extension = fixed_update_list[unit]
	local frame = context.fixed_frame

	extension:fixed_update(unit, dt, t, frame, context, ...)
end

ExtensionSystemBase.hot_join_sync = function (self, sender, channel)
	for unit, extension in pairs(self._hot_join_sync_list) do
		extension:hot_join_sync(unit, sender, channel)
	end
end

ExtensionSystemBase.destroy = function (self)
	return
end

ExtensionSystemBase.set_run_in_runtime_loaded_level = function (self, val)
	self._run_in_runtime_loaded_level = val
end

ExtensionSystemBase.run_in_runtime_loaded_level = function (self)
	return self._run_in_runtime_loaded_level
end

return ExtensionSystemBase
