-- chunkname: @scripts/extension_systems/volume_event/volume_event_system.lua

local VolumeEventSettings = require("scripts/settings/volume_event/volume_event_settings")
local volume_type_events = VolumeEventSettings.volume_type_events
local VolumeEventSystem = class("VolumeEventSystem", "ExtensionSystemBase")

VolumeEventSystem.init = function (self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)
	VolumeEventSystem.super.init(self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)

	self._init_done = false

	if not self._is_server then
		return
	end

	self._extension_list = extension_list
	self._engine_volume_event_system = VolumeEvent.init_system(nil, VolumeEventSettings.updates_per_frame)

	local level_name = extension_system_creation_context.level_name
	local level_volumes = self:_require_level_volumes(level_name, {})

	self._level_volumes_by_name = self:_create_event_volume_data(level_volumes)

	local units_by_extension = {}
	local traversal_costs = {}

	for i = 1, #extension_list do
		local extension_name = extension_list[i]

		units_by_extension[extension_name] = {}
		traversal_costs[extension_name] = {}
	end

	self._units_by_extension = units_by_extension
	self._traversal_costs = traversal_costs
end

VolumeEventSystem._require_level_volumes = function (self, level_name, volume_data)
	local num_nested_levels = LevelResource.nested_level_count(level_name)

	for i = 1, num_nested_levels do
		local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)

		self:_require_level_volumes(nested_level_name, volume_data)
	end

	local file_path = level_name .. "_volume_data"

	if Application.can_get_resource("lua", file_path) then
		local file_data = require(file_path)
		local volumes_data = file_data.volume_data

		for _, data in ipairs(volumes_data) do
			data.level_name = level_name
		end

		table.append(volume_data, volumes_data)
	else
		Log.warning("VolumeEventSystem", "Couldn't find any level volume data for level %q, no volume events will run on this level\nThe volume_data file should have been auto generated when saving the level in the editor, just add a reference to it in the level package.", level_name)
	end

	return volume_data
end

VolumeEventSystem._create_event_volume_data = function (self, level_volumes)
	local volumes_by_name = {}

	for i = 1, #level_volumes do
		local level_volume = level_volumes[i]
		local volume_type = level_volume.type
		local volume_events = volume_type_events[volume_type]

		if volume_events then
			local volume_name = level_volume.name
			local volume = volumes_by_name[volume_name]
			local level_name = level_volume.level_name .. ".level"

			if not volume then
				volume = {
					registered = false,
					type = volume_type,
					events = volume_events,
					connected_units = {},
					levels = {},
					level_names = {
						[level_name] = true
					},
					volume_ids = {}
				}
				volumes_by_name[volume_name] = volume
			else
				volume.level_names[level_name] = true
			end
		end
	end

	return volumes_by_name
end

VolumeEventSystem._add_nested_levels = function (self, level, levels)
	local nested_levels = Level.nested_levels(level)

	for i = 1, #nested_levels do
		local nested_level = nested_levels[i]

		levels[#levels + 1] = nested_level

		self:_add_nested_levels(nested_level, levels)
	end

	return levels
end

VolumeEventSystem.on_gameplay_post_init = function (self, main_level)
	if not self._is_server then
		return
	end

	local levels = {
		main_level
	}

	self:_add_nested_levels(main_level, levels)

	for volume_name, volume in pairs(self._level_volumes_by_name) do
		local volume_level_names = volume.level_names

		for i = 1, #levels do
			local level = levels[i]
			local level_name = Level.name(level)

			if volume_level_names[level_name] then
				volume.levels[#volume.levels + 1] = level
			end
		end

		self:_register_level_volume(volume_name)
	end

	self._init_done = true
end

VolumeEventSystem._register_level_volume = function (self, volume_name)
	local volume = self._level_volumes_by_name[volume_name]
	local engine_volume_event_system = self._engine_volume_event_system
	local connected_units = volume.connected_units
	local volume_events = volume.events
	local volume_levels = volume.levels

	for extension_name, event_settings in pairs(volume_events) do
		local func, on_enter, on_exit = event_settings.func

		if func then
			on_enter, on_exit = func.on_enter, func.on_exit
		end

		local filter = event_settings.filter
		local invert_volume = event_settings.invert_volume
		local params = event_settings.params
		local traversal_cost = event_settings.traversal_cost

		if traversal_cost then
			self:_update_traversal_cost(extension_name, volume_name, traversal_cost)
		end

		local volume_data = {
			params = params,
			connected_units = connected_units
		}

		if self._init_done then
			-- Nothing
		end

		for i = 1, #volume_levels do
			local level = volume_levels[i]
			local volume_id = VolumeEvent.register_volume(engine_volume_event_system, level, volume_name, extension_name, invert_volume, volume_data, on_enter, on_exit, filter)

			table.insert(volume.volume_ids, volume_id)
		end
	end

	volume.registered = true
end

VolumeEventSystem.register_unit_volume = function (self, unit, volume_name, extension_name, volume_type)
	local engine_volume_event_system = self._engine_volume_event_system
	local volume_events = volume_type_events[volume_type]
	local event_settings = volume_events[extension_name]
	local on_enter = event_settings.func.on_enter
	local on_exit = event_settings.func.on_exit
	local filter = event_settings.filter
	local invert_volume = event_settings.invert_volume
	local params = event_settings.params
	local volume_data = {
		params = params,
		connected_units = unit
	}
	local volume_id = VolumeEvent.register_volume(engine_volume_event_system, unit, volume_name, extension_name, invert_volume, volume_data, on_enter, on_exit, filter)

	return volume_id
end

VolumeEventSystem.unregister_unit_volume = function (self, volume_id, extension_name)
	local engine_volume_event_system = self._engine_volume_event_system

	VolumeEvent.unregister_volume(engine_volume_event_system, volume_id, extension_name)
end

VolumeEventSystem._unregister_level_volume = function (self, volume_name)
	local volume = self._level_volumes_by_name[volume_name]
	local engine_volume_event_system = self._engine_volume_event_system
	local traversal_costs = self._traversal_costs
	local volume_ids = volume.volume_ids

	if self._init_done then
		-- Nothing
	end

	for extension_name, _ in pairs(volume.events) do
		for i = 1, #volume_ids do
			local volume_id = volume_ids[i]

			VolumeEvent.unregister_volume(engine_volume_event_system, volume_id, extension_name)
		end

		local traversal_cost = traversal_costs[extension_name][volume_name]

		if traversal_cost then
			self:_update_traversal_cost(extension_name, volume_name, 1)
		end
	end

	volume.registered = false

	table.clear(volume.connected_units)
end

VolumeEventSystem._update_traversal_cost = function (self, extension_name, volume_name, cost)
	local extension_units = self._units_by_extension[extension_name]

	for i = 1, #extension_units do
		local unit = extension_units[i]

		self:_set_unit_nav_tag_layer_cost(unit, volume_name, cost)
	end

	self._traversal_costs[extension_name][volume_name] = cost ~= 1 and cost or nil
end

VolumeEventSystem._set_unit_nav_tag_layer_cost = function (self, unit, layer_name, layer_cost)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_nav_tag_layer_cost(layer_name, layer_cost)
end

VolumeEventSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	if self._is_server then
		VolumeEvent.on_add_extension(self._engine_volume_event_system, unit, extension_name)

		local extension_units = self._units_by_extension[extension_name]

		extension_units[#extension_units + 1] = unit
	end

	return extension
end

local function _check_extension_dependencies(unit, extension_name)
	local has_traversal_cost = false

	for _, volume_events in pairs(volume_type_events) do
		local event_settings = volume_events[extension_name]

		if event_settings and event_settings.traversal_cost then
			has_traversal_cost = true

			break
		end
	end

	if has_traversal_cost then
		local navigation_extension = ScriptUnit.has_extension(unit, "navigation_system")
	end
end

VolumeEventSystem.extensions_ready = function (self, world, unit, extension_name)
	if not self._is_server then
		return
	end

	_check_extension_dependencies(unit, extension_name)

	local traversal_costs = self._traversal_costs[extension_name]

	for layer_name, layer_cost in pairs(traversal_costs) do
		self:_set_unit_nav_tag_layer_cost(unit, layer_name, layer_cost)
	end
end

VolumeEventSystem.on_remove_extension = function (self, unit, extension_name)
	self:_cleanup_extension(unit, extension_name)
end

VolumeEventSystem._cleanup_extension = function (self, unit, extension_name)
	VolumeEvent.on_remove_extension(self._engine_volume_event_system, unit, extension_name)
	ScriptUnit.remove_extension(unit, self._name)

	local extension_units = self._units_by_extension[extension_name]
	local unit_index = table.find(extension_units, unit)

	table.remove(extension_units, unit_index)
end

VolumeEventSystem.update = function (self, context, dt, t)
	if not self._is_server then
		return
	end

	VolumeEvent.update(self._engine_volume_event_system, t, dt)
end

VolumeEventSystem.destroy = function (self)
	if not self._is_server then
		return
	end

	VolumeEvent.destroy_system(self._engine_volume_event_system)

	self._engine_volume_event_system = nil
	self._world = nil
	self._level_volumes_by_name = nil
	self._extension_list = nil
	self._units_by_extension = nil
end

VolumeEventSystem.unregister_volumes_by_name = function (self, volume_name)
	if not self._is_server then
		return
	end

	self:_unregister_level_volume(volume_name)
end

VolumeEventSystem.register_volumes_by_name = function (self, volume_name)
	if not self._is_server then
		return
	end

	self:_register_level_volume(volume_name)
end

VolumeEventSystem.connect_unit_to_volume = function (self, volume_name, unit)
	if not self._is_server then
		return
	end

	local volume = self._level_volumes_by_name[volume_name]
	local connected_units = volume.connected_units

	connected_units[#connected_units + 1] = unit
end

VolumeEventSystem.disconnect_unit_from_volume = function (self, volume_name, unit)
	if not self._is_server then
		return
	end

	local volume = self._level_volumes_by_name[volume_name]
	local connected_units = volume.connected_units
	local unit_index = table.find(connected_units, unit)

	table.remove(connected_units, unit_index)
end

VolumeEventSystem.engine_volume_event_system = function (self)
	return self._engine_volume_event_system
end

return VolumeEventSystem
