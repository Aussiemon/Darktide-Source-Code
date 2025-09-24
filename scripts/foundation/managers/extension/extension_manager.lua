-- chunkname: @scripts/foundation/managers/extension/extension_manager.lua

require("scripts/foundation/utilities/script_unit")

local ExtensionConfig = require("scripts/foundation/managers/extension/extension_config")
local ExtensionSystemHolder = require("scripts/foundation/managers/extension/extension_system_holder")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local EMPTY_TABLE = {}
local ExtensionManager = class("ExtensionManager")

ExtensionManager.init = function (self, world, physics_world, wwise_world, nav_world, has_navmesh, level_name, circumstance_name, havoc_data, is_server, unit_templates, system_configuration, system_init_data, unit_category_list, network_event_delegate, fixed_time_step, game_session, optional_soft_cap_out_of_bounds_units, use_time_slice)
	self._ignore_extensions_list = {
		[""] = true,
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
		havoc_data = havoc_data,
		is_server = is_server,
		network_event_delegate = network_event_delegate,
		extension_manager = self,
		game_session = game_session,
		soft_cap_out_of_bounds_units = optional_soft_cap_out_of_bounds_units,
	}

	self._extension_system_holder = ExtensionSystemHolder:new(extension_system_creation_context, system_configuration, system_init_data, fixed_time_step, use_time_slice)
	self._unit_templates = unit_templates

	local categories = {}

	for i = 1, #unit_category_list do
		categories[unit_category_list[i]] = {}
	end

	self._unit_categories = categories
	self._in_fixed_update = false
	self._fixed_update_added_unit_list = {}
	self._registered_level_units = {}

	if use_time_slice then
		local time_slice_unit_registration_data = {}

		time_slice_unit_registration_data.last_index = 0
		time_slice_unit_registration_data.ready = false
		time_slice_unit_registration_data.parameters = {}
		time_slice_unit_registration_data.parameters.world = nil
		time_slice_unit_registration_data.parameters.unit_list_to_register = nil
		time_slice_unit_registration_data.parameters.num_units = 0
		self._time_slice_unit_registration_data = time_slice_unit_registration_data
	end
end

ExtensionManager._units_added_and_registered = function (self)
	local time_slice_unit_registration_data = self._time_slice_unit_registration_data

	return not time_slice_unit_registration_data or time_slice_unit_registration_data.ready
end

ExtensionManager.update_time_slice_init = function (self)
	return self._extension_system_holder:update_time_slice_init_systems()
end

ExtensionManager.update_time_slice_post_init = function (self)
	return self._extension_system_holder:update_time_slice_post_init_systems()
end

ExtensionManager.is_in_fixed_update = function (self)
	return self._in_fixed_update
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

	return unit_map
end

ExtensionManager.get_entities = function (self, extension_name)
	return self._extensions[extension_name] or EMPTY_TABLE
end

ExtensionManager.units = function (self)
	return self._units
end

ExtensionManager.destroy = function (self)
	self._extension_system_holder:destroy()

	self._units = nil
	self._unit_extensions_list = nil
	self._extensions = nil
	self._systems = nil
	self._extension_to_system_map = nil
end

ExtensionManager.add_unit_extensions_from_template = function (self, world, unit, init_function, unit_spawned_function_or_nil, template_context, game_object_data_or_session, ...)
	local extension_config = ExtensionConfig:new()

	init_function(unit, extension_config, template_context, game_object_data_or_session, ...)

	local extensions = self:add_unit_extensions(world, unit, extension_config, game_object_data_or_session, ...)

	if unit_spawned_function_or_nil then
		unit_spawned_function_or_nil(unit, template_context, game_object_data_or_session, ...)
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
	local self_units, self_extensions, self_systems = self._units, self._extensions, self._systems
	local unit_extensions_list = self._unit_extensions_list
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

	local unit_in_cinematic_level = ScriptUnit.unit_in_cinematic_level(unit)

	for i = 1, num_extensions do
		repeat
			local name, init_args, _ = extension_config:extension(i)

			extension_list[#extension_list + 1] = name

			if ignore_extensions_list[name] then
				break
			end

			local extension_system_name = extension_to_system_map[name]
			local system = self_systems[extension_system_name]

			if unit_in_cinematic_level and not system:run_in_cinematic_level() then
				extension_list[#extension_list] = nil

				break
			end

			local extension = system:on_add_extension(world, unit, name, init_args, game_object_data_or_session, ...)

			self_extensions[name] = self_extensions[name] or {}
			self_units[unit] = self_units[unit] or {}
			self_units[unit][name] = extension
		until true
	end

	local extensions = self_units[unit]

	for i = 1, #extension_list do
		repeat
			local name = extension_list[i]

			if ignore_extensions_list[name] then
				break
			end

			local extension = extensions[name]

			if extension.extensions_ready ~= nil then
				extension:extensions_ready(world, unit)
			end

			local extension_system_name = extension_to_system_map[name]
			local system = self_systems[extension_system_name]

			if system.extensions_ready ~= nil then
				system:extensions_ready(world, unit, name)
			end
		until true
	end

	Managers.event:trigger("unit_registered", unit)
	Unit.flow_event(unit, "unit_registered")

	return true
end

ExtensionManager.on_unit_id_resolved = function (self, unit, is_level_unit, unit_id)
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

				local extension = extensions[name]

				if extension.on_unit_id_resolved ~= nil then
					extension:on_unit_id_resolved(unit, is_level_unit, unit_id)
				end
			until true
		end
	end
end

ExtensionManager.sync_unit_extensions = function (self, unit, session, object_id)
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

				local extension = extensions[name]

				if extension.game_object_initialized ~= nil then
					extension:game_object_initialized(session, object_id)
				end
			until true
		end
	end
end

ExtensionManager.hot_join_sync = function (self, sender, channel)
	self._extension_system_holder:hot_join_sync(sender, channel)
end

ExtensionManager.on_gameplay_post_init = function (self, level, themes)
	self._extension_system_holder:on_gameplay_post_init(level, themes)
end

ExtensionManager.init_time_slice_on_gameplay_post_init = function (self, level, themes)
	self._extension_system_holder:init_time_slice_on_gameplay_post_init(level, themes)
end

local TEMP_TABLE = {}

ExtensionManager.register_unit = function (self, world, unit, optional_category)
	local unit_template_name = Unit.get_data(unit, "unit_template")

	if unit_template_name then
		local unit_template = self._unit_templates[unit_template_name]
		local init_function = unit_template.local_init
		local unit_spawned_function_or_nil = unit_template.local_unit_spawned

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

		category_table[unit] = unit

		Unit.set_data(unit, "__unit_category", optional_category)
	end
end

ExtensionManager.init_time_slice_add_and_register_level_units = function (self, world, unit_list, optional_category)
	local time_slice_unit_registration_data = self._time_slice_unit_registration_data

	time_slice_unit_registration_data.last_index = 0
	time_slice_unit_registration_data.ready = false
	time_slice_unit_registration_data.parameters.world = world
	time_slice_unit_registration_data.parameters.unit_list_to_register = unit_list
	time_slice_unit_registration_data.parameters.num_units = #unit_list
	time_slice_unit_registration_data.parameters.optional_category = optional_category
end

ExtensionManager.update_time_slice_add_and_register_level_units = function (self)
	local time_slice_unit_registration_data = self._time_slice_unit_registration_data
	local last_index = time_slice_unit_registration_data.last_index
	local world = time_slice_unit_registration_data.parameters.world
	local unit_list = time_slice_unit_registration_data.parameters.unit_list_to_register
	local num_units = time_slice_unit_registration_data.parameters.num_units
	local optional_category = time_slice_unit_registration_data.parameters.optional_category
	local added_list = TEMP_TABLE
	local num_added = 0
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()
	local step_size = 128

	for index = last_index + 1, num_units, step_size do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local end_at = math.min(index + step_size - 1, num_units)

		num_added = self:_add_and_register_units(world, unit_list, index, end_at, optional_category, added_list, num_added)
		time_slice_unit_registration_data.last_index = end_at
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	table.append(self._registered_level_units, added_list, num_added)

	local unit_spawner_manager = Managers.state.unit_spawner

	for i = 1, num_added do
		self:on_unit_id_resolved(added_list[i], true, unit_spawner_manager:unit_index(added_list[i]))
	end

	if num_added > 0 then
		self:register_units_extensions(added_list, num_added)
	end

	if time_slice_unit_registration_data.last_index == num_units then
		GameplayInitTimeSlice.set_finished(time_slice_unit_registration_data)
	end

	return self:_units_added_and_registered()
end

ExtensionManager.add_and_register_units = function (self, world, unit_list, num_units, optional_category)
	local added_list, num_added = TEMP_TABLE, 0

	num_added = self:_add_and_register_units(world, unit_list, 1, num_units or #unit_list, optional_category, added_list, num_added)

	if num_added > 0 then
		self:register_units_extensions(added_list, num_added)
	end
end

ExtensionManager._add_and_register_units = function (self, world, unit_list, from_index, to_index, optional_category, added_list, num_added)
	from_index = from_index or 1
	to_index = to_index or #unit_list

	local unit_templates = self._unit_templates

	for i = from_index, to_index do
		local unit = unit_list[i]
		local unit_template_name = Unit.get_data(unit, "unit_template")
		local added

		if unit_template_name then
			local unit_template = unit_templates[unit_template_name]
			local init_function = unit_template.local_init
			local unit_spawned_function_or_nil = unit_template.local_unit_spawned

			added = self:add_unit_extensions_from_template(world, unit, init_function, unit_spawned_function_or_nil, nil, nil)
		else
			added = self:add_unit_extensions_from_script_data(world, unit)
		end

		if added then
			num_added = num_added + 1
			added_list[num_added] = unit
		end
	end

	if optional_category then
		local category_table = self._unit_categories[optional_category]

		for i = from_index, to_index do
			local unit = unit_list[i]

			category_table[unit] = unit

			Unit.set_data(unit, "__unit_category", optional_category)
		end
	end

	return num_added
end

ExtensionManager.register_units_extensions = function (self, unit_list, num_units)
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
				self_extensions[extension_name][unit] = extension

				local system = systems[systems_map[extension_name]]

				system:register_extension_update(unit, extension_name, extension)
			end
		until true
	end
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

	for i = #extensions_list, 1, -1 do
		local extension_list_name = extensions_list[i]
		local should_remove = extensions_to_remove[extension_list_name]

		if should_remove then
			local system = self:system_by_extension(extension_list_name)

			system:on_remove_extension(unit, extension_list_name)

			self_extensions[extension_list_name][unit] = nil
			unit_extensions[extension_list_name] = nil

			table.remove(extensions_list, i)
		end
	end
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
			table.remove(extensions_list, i)

			self_extensions[extension_list_name][unit] = nil
			unit_extensions[extension_list_name] = nil
		end
	end
end

ExtensionManager.unregister_unit_category = function (self, category)
	local unit_map = self._unit_categories[category]
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

ExtensionManager.unregister_units = function (self, units, num_units, unregister_from_level_units)
	local self_units, self_extensions = self._units, self._extensions
	local unit_extensions_list = self._unit_extensions_list
	local ignore_extensions_list = self._ignore_extensions_list

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

			for j = #extensions_list, 1, -1 do
				local extension_name = extensions_list[j]

				if not ignore_extensions_list[extension_name] then
					local system_name = self._extension_to_system_map[extension_name]
					local system = self._systems[system_name]

					system:on_remove_extension(unit, extension_name)

					self_extensions[extension_name][unit] = nil
				end
			end

			if unregister_from_level_units then
				local registered_level_units = self._registered_level_units

				for j = 1, #registered_level_units do
					if registered_level_units[j] == unit then
						table.swap_delete(registered_level_units, j)

						break
					end
				end
			end

			ScriptUnit.remove_unit(unit)

			self_units[unit] = nil
			unit_extensions_list[unit] = nil

			local position_lookup_manager = Managers.state.position_lookup

			if position_lookup_manager then
				position_lookup_manager:unregister(unit)
			end
		until true
	end
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

	self:unregister_units(TEMP_UNIT_TABLE, 1, true)
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

ExtensionManager.registered_level_units = function (self)
	return self._registered_level_units
end

ExtensionManager.on_reload = function (self, refreshed_resources)
	self._extension_system_holder:on_reload(refreshed_resources)
end

return ExtensionManager
