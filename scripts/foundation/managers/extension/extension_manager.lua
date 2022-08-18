require("scripts/foundation/utilities/script_unit")

local ExtensionConfig = require("scripts/foundation/managers/extension/extension_config")
local ExtensionSystemHolder = require("scripts/foundation/managers/extension/extension_system_holder")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local EMPTY_TABLE = {}
local ExtensionManager = class("ExtensionManager")

ExtensionManager.init = function (self, world, physics_world, wwise_world, nav_world, has_navmesh, level_name, circumstance_name, is_server, unit_templates, system_configuration, system_init_data, unit_category_list, network_event_delegate, fixed_frame_time, game_session, optional_soft_cap_out_of_bounds_units, use_time_slice)
	self._ignore_extensions_list = {
		[""] = true
	}
	self._units = {}
	self._unit_extensions_list = {}
	self._extensions = {}
	self._systems = {}
	self._extension_to_system_map = {}
	self._extension_config = ExtensionConfig:new()
	local extension_system_creation_context = {
		world = world,
		physics_world = physics_world,
		wwise_world = wwise_world,
		nav_world = nav_world,
		has_navmesh = has_navmesh,
		level_name = level_name,
		circumstance_name = circumstance_name,
		is_server = is_server,
		network_event_delegate = network_event_delegate,
		extension_manager = self,
		game_session = game_session,
		soft_cap_out_of_bounds_units = optional_soft_cap_out_of_bounds_units
	}
	self._extension_system_holder = ExtensionSystemHolder:new(extension_system_creation_context, system_configuration, system_init_data, fixed_frame_time, use_time_slice)
	self._unit_templates = unit_templates
	local categories = {}

	for i = 1, #unit_category_list do
		categories[unit_category_list[i]] = {}
	end

	self._unit_categories = categories
	self._in_fixed_update = false
	self._fixed_update_added_unit_list = {}

	if use_time_slice then
		local time_slice_unit_registration_data = {
			last_index = 0,
			ready = false,
			parameters = {}
		}
		time_slice_unit_registration_data.parameters.world = nil
		time_slice_unit_registration_data.parameters.unit_list_to_register = nil
		time_slice_unit_registration_data.parameters.num_units = 0
		self._time_slice_unit_registration_data = time_slice_unit_registration_data
	end
end

ExtensionManager._units_added_and_registered = function (self)
	local time_slice_unit_registration_data = self._time_slice_unit_registration_data

	if time_slice_unit_registration_data then
		return time_slice_unit_registration_data.ready
	end

	return true
end

ExtensionManager.update_time_slice_init = function (self)
	fassert(not self._extension_system_holder:is_init_ready(), "Extension Holder ready.")

	return self._extension_system_holder:update_time_slice_init_systems()
end

ExtensionManager.update_time_slice_post_init = function (self)
	fassert(not self._extension_system_holder:is_post_init_ready(), "Extension Holder post-init ready.")

	return self._extension_system_holder:update_time_slice_post_init_systems()
end

ExtensionManager.pre_update = function (self, dt, t)
	self._extension_system_holder:pre_update(dt, t)
end

ExtensionManager.fixed_update = function (self, dt, t, frame)
	self._in_fixed_update = true
	local temp_byte_count = Script.temp_byte_count()

	self._extension_system_holder:fixed_update(dt, t, frame)
	Script.set_temp_byte_count(temp_byte_count)

	local position_lookup_manager = Managers.state.position_lookup

	if position_lookup_manager then
		local world_pos = Unit.world_position
		local added_units = self._fixed_update_added_unit_list

		for unit in pairs(added_units) do
			position_lookup_manager:register(unit, world_pos(unit, 1))
		end

		table.clear(added_units)
	end

	self._in_fixed_update = false
end

ExtensionManager.update = function (self)
	self._extension_system_holder:update()
end

ExtensionManager.post_update = function (self)
	self._extension_system_holder:post_update()
end

ExtensionManager.physics_async_update = function (self)
	self._extension_system_holder:physics_async_update()
end

ExtensionManager.register_system = function (self, system, system_name, extension_list)
	assert(self._systems[system_name] == nil, string.format("Tried to register system whose name '%s' was already registered.", system_name))

	self._systems[system_name] = system
	system.NAME = system_name

	for i, extension in ipairs(extension_list) do
		self._extension_to_system_map[extension] = system_name
	end
end

ExtensionManager.system = function (self, system_name)
	return self._systems[system_name]
end

ExtensionManager.has_system = function (self, system_name)
	return self._systems[system_name] ~= nil
end

ExtensionManager.system_by_extension = function (self, extension_name)
	local system_name = self._extension_to_system_map[extension_name]

	return system_name and self._systems[system_name]
end

ExtensionManager.units_by_category = function (self, category)
	local unit_map = self._unit_categories[category]

	fassert(unit_map, "Invalid unit category %q", category)

	return unit_map
end

ExtensionManager.get_entities = function (self, extension_name)
	return self._extensions[extension_name] or EMPTY_TABLE
end

ExtensionManager.destroy = function (self)
	fassert(table.is_empty(self._units), "Trying to destroy extension manager without first unregistering all units.")
	self._extension_system_holder:destroy()

	self._units = nil
	self._unit_extensions_list = nil
	self._extensions = nil
	self._systems = nil
	self._extension_to_system_map = nil
end

ExtensionManager.add_unit_extensions_from_template = function (self, world, unit, init_function, unit_spawned_function_or_nil, template_context, game_object_data_or_session, is_husk, ...)
	local extension_config = ExtensionConfig:new()

	init_function(unit, extension_config, template_context, game_object_data_or_session, ...)

	local extensions = self:add_unit_extensions(world, unit, extension_config, game_object_data_or_session, ...)

	if unit_spawned_function_or_nil then
		unit_spawned_function_or_nil(unit, template_context, game_object_data_or_session, is_husk, ...)
	end

	return extensions
end

ExtensionManager.add_unit_extensions_from_script_data = function (self, world, unit)
	local extension_config = ExtensionConfig:new()

	extension_config:parse_unit(unit)

	return self:add_unit_extensions(world, unit, extension_config, nil)
end

ExtensionManager.add_unit_extensions = function (self, world, unit, extension_config, game_object_data_or_session, ...)
	local ignore_extensions_list = self._ignore_extensions_list
	local extension_to_system_map = self._extension_to_system_map
	local self_units = self._units
	local self_extensions = self._extensions
	local self_systems = self._systems
	local unit_extensions_list = self._unit_extensions_list

	assert(not unit_extensions_list[unit], "Adding extensions to a unit that already has extensions added!")

	local extension_list = {}
	unit_extensions_list[unit] = extension_list
	local num_extensions = extension_config:num_extensions()

	if num_extensions == 0 then
		Unit.flow_event(unit, "unit_registered")

		return false
	end

	local position_lookup_manager = Managers.state.position_lookup

	if position_lookup_manager then
		position_lookup_manager:register(unit, Unit.world_position(unit, 1))
	end

	if self._in_fixed_update then
		self._fixed_update_added_unit_list[unit] = true
	end

	Profiler.start("creating extensions")

	local unit_in_runtime_loaded_level = ScriptUnit.unit_in_runtime_loaded_level(unit)

	for i = 1, num_extensions do
		repeat
			local name, init_args, _ = extension_config:extension(i)
			extension_list[#extension_list + 1] = name

			if ignore_extensions_list[name] then
				break
			end

			local extension_system_name = extension_to_system_map[name]

			fassert(extension_system_name, "No such registered extension %q", name)

			local system = self_systems[extension_system_name]

			fassert(system ~= nil, "Adding extension %q to system %q that doesn't exist.", name, extension_system_name)

			if unit_in_runtime_loaded_level and not system:run_in_runtime_loaded_level() then
				extension_list[#extension_list] = nil
			else
				Profiler.start(name)

				local extension = system:on_add_extension(world, unit, name, init_args, game_object_data_or_session, ...)

				fassert(extension, "System (%s) must return the created extension (%s)", extension_system_name, name)

				self_extensions[name] = self_extensions[name] or {}
				self_units[unit] = self_units[unit] or {}
				self_units[unit][name] = extension

				assert(extension ~= EMPTY_TABLE)
				Profiler.stop(name)
			end
		until true
	end

	Profiler.stop("creating extensions")
	Profiler.start("extensions_ready")

	local extensions = self_units[unit]

	for i = 1, #extension_list do
		repeat
			local name = extension_list[i]

			if ignore_extensions_list[name] then
				break
			end

			Profiler.start(name)

			local extension = extensions[name]

			if extension.extensions_ready ~= nil then
				extension:extensions_ready(world, unit)
			end

			local extension_system_name = extension_to_system_map[name]
			local system = self_systems[extension_system_name]

			if system.extensions_ready ~= nil then
				system:extensions_ready(world, unit, name)
			end

			Profiler.stop(name)
		until true
	end

	Profiler.stop("extensions_ready")
	Unit.flow_event(unit, "unit_registered")

	return true
end

ExtensionManager.sync_unit_extensions = function (self, unit, session, object_id)
	Profiler.start("sync_extensions")

	local extensions = self._units[unit]

	if extensions then
		local ignore_extensions_list = self._ignore_extensions_list
		local unit_extensions_list = self._unit_extensions_list
		local extension_list = unit_extensions_list[unit]
		local num_extensions = #extension_list

		for i = 1, num_extensions do
			repeat
				local name = extension_list[i]

				if ignore_extensions_list[name] then
					break
				end

				Profiler.start(name)

				local extension = extensions[name]

				if extension.game_object_initialized ~= nil then
					extension:game_object_initialized(session, object_id)
				end

				Profiler.stop(name)
			until true
		end
	end

	Profiler.stop("sync_extensions")
end

ExtensionManager.hot_join_sync = function (self, sender, channel)
	self._extension_system_holder:hot_join_sync(sender, channel)
end

ExtensionManager.on_gameplay_post_init = function (self, level, themes)
	self._extension_system_holder:on_gameplay_post_init(level, themes)
end

ExtensionManager.init_time_slice_on_gameplay_post_init = function (self, level, themes)
	fassert(self._extension_system_holder:is_init_ready(), "Extension Holder not ready.")
	fassert(not self._extension_system_holder:is_post_init_ready(), "Extension Holder post-init ready.")
	fassert(self:_units_added_and_registered(), "Units not registered.")
	self._extension_system_holder:init_time_slice_on_gameplay_post_init(level, themes)
end

local TEMP_TABLE = {}

ExtensionManager.register_unit = function (self, world, unit, optional_category)
	local unit_template_name = Unit.get_data(unit, "unit_template")

	if unit_template_name then
		local unit_template = self._unit_templates[unit_template_name]
		local init_function = unit_template.local_init
		local unit_spawned_function_or_nil = unit_template.unit_spawned

		if self:add_unit_extensions_from_template(world, unit, init_function, unit_spawned_function_or_nil, nil, nil) then
			TEMP_TABLE[1] = unit

			self:register_units_extensions(TEMP_TABLE, 1)
		end
	elseif self:add_unit_extensions_from_script_data(world, unit) then
		TEMP_TABLE[1] = unit

		self:register_units_extensions(TEMP_TABLE, 1)
	end

	if optional_category then
		local category_table = self._unit_categories[optional_category]

		fassert(category_table, "Unit registered with invalid category %q", optional_category)

		category_table[unit] = unit

		Unit.set_data(unit, "__unit_category", optional_category)
	end
end

ExtensionManager.add_and_register_units = function (self, world, unit_list, num_units, optional_category)
	Profiler.start("add_and_register_units")

	num_units = num_units or #unit_list
	local added_list = TEMP_TABLE
	local num_added = 0

	for i = 1, num_units do
		local unit = unit_list[i]
		local unit_template_name = Unit.get_data(unit, "unit_template")

		if unit_template_name then
			local unit_template = self._unit_templates[unit_template_name]
			local init_function = unit_template.local_init
			local unit_spawned_function_or_nil = unit_template.unit_spawned

			if self:add_unit_extensions_from_template(world, unit, init_function, unit_spawned_function_or_nil, nil, nil) then
				num_added = num_added + 1
				added_list[num_added] = unit
			end
		elseif self:add_unit_extensions_from_script_data(world, unit) then
			num_added = num_added + 1
			added_list[num_added] = unit
		end
	end

	if optional_category then
		local category_table = self._unit_categories[optional_category]

		fassert(category_table, "Unit registered with invalid category %q", optional_category)

		for i = 1, num_units do
			local unit = unit_list[i]
			category_table[unit] = unit

			Unit.set_data(unit, "__unit_category", optional_category)
		end
	end

	if num_added > 0 then
		self:register_units_extensions(added_list, num_added)
	end

	Profiler.stop("add_and_register_units")
end

ExtensionManager.init_time_slice_add_and_register_units = function (self, world, unit_list, optional_category)
	local time_slice_unit_registration_data = self._time_slice_unit_registration_data

	fassert(time_slice_unit_registration_data, "[ExtensionManager] Instantiate class with 'use_time_slice'")

	time_slice_unit_registration_data.last_index = 0
	time_slice_unit_registration_data.ready = false
	time_slice_unit_registration_data.parameters.world = world
	time_slice_unit_registration_data.parameters.unit_list_to_register = unit_list
	time_slice_unit_registration_data.parameters.num_units = #unit_list
	time_slice_unit_registration_data.parameters.optional_category = optional_category
end

ExtensionManager.update_time_slice_add_and_register_units = function (self)
	Profiler.start("update_time_slice_add_and_register_units")

	local time_slice_unit_registration_data = self._time_slice_unit_registration_data
	local last_index = time_slice_unit_registration_data.last_index
	local world = time_slice_unit_registration_data.parameters.world
	local unit_list = time_slice_unit_registration_data.parameters.unit_list_to_register
	local num_units = time_slice_unit_registration_data.parameters.num_units

	fassert(#unit_list == num_units, "[ExtensionManager][update_time_slice_add_and_register_units] Unit list mutated during time slice. [orig: %d, current: %d]", num_units, #unit_list)

	local optional_category = time_slice_unit_registration_data.parameters.optional_category
	local category_table = nil

	if optional_category then
		category_table = self._unit_categories[optional_category]

		fassert(category_table, "[ExtensionManager][update_time_slice_add_and_register_units] Unit registered with invalid category %q", optional_category)
	end

	local added_list = TEMP_TABLE
	local num_added = 0
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()

	for index = last_index + 1, num_units do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local unit = unit_list[index]
		local unit_template_name = Unit.get_data(unit, "unit_template")

		if unit_template_name then
			local unit_template = self._unit_templates[unit_template_name]
			local init_function = unit_template.local_init
			local unit_spawned_function_or_nil = unit_template.unit_spawned

			if self:add_unit_extensions_from_template(world, unit, init_function, unit_spawned_function_or_nil, nil, nil) then
				num_added = num_added + 1
				added_list[num_added] = unit
			end
		elseif self:add_unit_extensions_from_script_data(world, unit) then
			num_added = num_added + 1
			added_list[num_added] = unit
		end

		if category_table then
			category_table[unit] = unit

			Unit.set_data(unit, "__unit_category", optional_category)
		end

		time_slice_unit_registration_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if num_added > 0 then
		self:register_units_extensions(added_list, num_added)
	end

	if time_slice_unit_registration_data.last_index == num_units then
		GameplayInitTimeSlice.set_finished(time_slice_unit_registration_data)
	end

	Profiler.stop("update_time_slice_add_and_register_units")

	return self:_units_added_and_registered()
end

ExtensionManager.register_units_extensions = function (self, unit_list, num_units)
	Profiler.start("register_units_extensions")

	local self_units = self._units
	local self_extensions = self._extensions
	local systems_map = self._extension_to_system_map
	local systems = self._systems

	for i = 1, num_units do
		repeat
			local unit = unit_list[i]
			local unit_extensions = self_units[unit]

			if not unit_extensions then
				break
			end

			for extension_name, extension in pairs(unit_extensions) do
				fassert(not self_extensions[extension_name][unit], "Unit %q already has extension %s registered.", unit, extension_name)

				self_extensions[extension_name][unit] = extension
				local system = systems[systems_map[extension_name]]

				system:register_extension_update(unit, extension_name, extension)
			end
		until true
	end

	Profiler.stop("register_units_extensions")
end

ExtensionManager.remove_extensions_from_unit = function (self, unit, extensions_to_remove)
	local unit_extensions_list = self._unit_extensions_list
	local self_extensions = self._extensions
	local extensions_list = unit_extensions_list[unit]

	if not extensions_list then
		return
	end

	local self_units = self._units
	local unit_extensions = self_units[unit]

	Profiler.start("remove_extensions_from_unit")

	for i = #extensions_list, 1, -1 do
		local extension_list_name = extensions_list[i]
		local should_remove = extensions_to_remove[extension_list_name]

		if should_remove then
			local system = self:system_by_extension(extension_list_name)

			system:on_remove_extension(unit, extension_list_name)
			fassert(not ScriptUnit.has_extension(unit, system.NAME), "Extension was not properly destroyed for extension %s", extension_list_name)

			self_extensions[extension_list_name][unit] = nil
			unit_extensions[extension_list_name] = nil

			table.remove(extensions_list, i)
		end
	end

	Profiler.stop("remove_extensions_from_unit")
end

ExtensionManager.remove_all_extensions_from_unit_except = function (self, unit, extension_exceptions)
	local unit_extensions_list = self._unit_extensions_list
	local extensions_list = unit_extensions_list[unit]

	if not extensions_list then
		return
	end

	local self_extensions = self._extensions
	local self_units = self._units
	local unit_extensions = self_units[unit]
	local ignore_extensions_list = self._ignore_extensions_list

	for i = #extensions_list, 1, -1 do
		local extension_list_name = extensions_list[i]

		if not extension_exceptions[extension_list_name] and not ignore_extensions_list[extension_list_name] then
			local system = self:system_by_extension(extension_list_name)

			system:on_remove_extension(unit, extension_list_name)
			fassert(not ScriptUnit.has_extension(unit, system.NAME), "Extension was not properly destroyed for extension %s", extension_list_name)
			table.remove(extensions_list, i)

			self_extensions[extension_list_name][unit] = nil
			unit_extensions[extension_list_name] = nil
		end
	end
end

ExtensionManager.unregister_unit_category = function (self, category)
	local unit_map = self._unit_categories[category]

	fassert(unit_map, "Invalid unit category %q", category)

	local i = 0

	for unit, _ in pairs(unit_map) do
		i = i + 1
		TEMP_TABLE[i] = unit
	end

	if i > 0 then
		self:unregister_units(TEMP_TABLE, i)
	end

	table.clear(unit_map)

	return TEMP_TABLE, i
end

ExtensionManager.unregister_units = function (self, units, num_units)
	local self_units = self._units
	local self_extensions = self._extensions
	local unit_extensions_list = self._unit_extensions_list
	local ignore_extensions_list = self._ignore_extensions_list

	Profiler.start("destroy extensions")

	for i = 1, num_units do
		repeat
			local unit = units[i]
			local optional_category = Unit.get_data(unit, "__unit_category")

			if optional_category then
				self._unit_categories[optional_category][unit] = nil
			end

			local extensions_list = unit_extensions_list[unit]

			if not extensions_list then
				break
			end

			Profiler.start("unit")

			for j = #extensions_list, 1, -1 do
				local extension_name = extensions_list[j]

				if not ignore_extensions_list[extension_name] then
					local system_name = self._extension_to_system_map[extension_name]
					local system = self._systems[system_name]

					system:on_remove_extension(unit, extension_name)
					fassert(not ScriptUnit.has_extension(unit, system_name), "Extension was not properly destroyed for extension %s", extension_name)

					self_extensions[extension_name][unit] = nil
				end
			end

			ScriptUnit.remove_unit(unit)

			self_units[unit] = nil
			unit_extensions_list[unit] = nil
			local position_lookup_manager = Managers.state.position_lookup

			if position_lookup_manager then
				position_lookup_manager:unregister(unit)
			end

			Profiler.stop("unit")
		until true
	end

	Profiler.stop("destroy extensions")
end

ExtensionManager.add_ignore_extensions = function (self, ignore_extensions)
	local ignore_extensions_list = self._ignore_extensions_list
	local num_extensions = #ignore_extensions

	for i = 1, num_extensions do
		local extension_name = ignore_extensions[i]
		ignore_extensions_list[extension_name] = true
	end
end

local TEMP_UNIT_TABLE = {}

ExtensionManager.unregister_unit = function (self, unit)
	TEMP_UNIT_TABLE[1] = unit

	self:unregister_units(TEMP_UNIT_TABLE, 1)
end

ExtensionManager.initialize_client_fixed_frame = function (self, fixed_frame)
	self._extension_system_holder:initialize_client_fixed_frame(fixed_frame)
end

ExtensionManager.latest_fixed_t = function (self)
	return self._extension_system_holder:latest_fixed_t()
end

local TEMP_SYSTEM_MAP = {}
local SERVER_CORRECTION_SYSTEM_MAP = {}

ExtensionManager.fixed_update_resimulate_unit = function (self, unit, from_frame, simulated_components)
	local extension_to_system_map = self._extension_to_system_map
	local extensions = self._units[unit]

	for extension_name, extension in pairs(extensions) do
		if extension.fixed_update then
			local system_name = extension_to_system_map[extension_name]
			TEMP_SYSTEM_MAP[system_name] = extension_name
		end

		if extension.server_correction_occurred then
			local system_name = extension_to_system_map[extension_name]
			SERVER_CORRECTION_SYSTEM_MAP[system_name] = extension_name
		end
	end

	self._extension_system_holder:fixed_update_resimulate_unit(unit, from_frame, simulated_components, TEMP_SYSTEM_MAP, SERVER_CORRECTION_SYSTEM_MAP)
	table.clear(TEMP_SYSTEM_MAP)
	table.clear(SERVER_CORRECTION_SYSTEM_MAP)
end

ExtensionManager.on_reload = function (self, refreshed_resources)
	self._extension_system_holder:on_reload(refreshed_resources)
end

return ExtensionManager
