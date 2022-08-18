local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local VolumeEventSettings = require("scripts/settings/volume_event/volume_event_settings")
local volume_type_events = VolumeEventSettings.volume_type_events
local VolumeEventSystem = class("VolumeEventSystem", "ExtensionSystemBase")

VolumeEventSystem.init = function (self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)
	VolumeEventSystem.super.init(self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)

	if not self._is_server then
		return
	end

	self._extension_list = extension_list

	Profiler.start("VolumeEventSystem:volume_init_system")

	self._engine_volume_event_system = VolumeEvent.init_system(nil, VolumeEventSettings.updates_per_frame)

	Profiler.stop("VolumeEventSystem:volume_init_system")

	local level_name = extension_system_creation_context.level_name

	Profiler.start("VolumeEventSystem:require_level_volumes")

	local level_volumes = self:_require_level_volumes(level_name, {})

	Profiler.stop("VolumeEventSystem:require_level_volumes")

	self._level_volumes_by_name = self:_create_event_volume_data(level_volumes)
	local units_by_extension = {}
	local traversal_costs = {}

	for i = 1, #extension_list, 1 do
		local extension_name = extension_list[i]
		units_by_extension[extension_name] = {}
		traversal_costs[extension_name] = {}
	end

	self._units_by_extension = units_by_extension
	self._traversal_costs = traversal_costs
end

VolumeEventSystem._require_level_volumes = function (self, level_name, volume_data)
	local num_nested_levels = LevelResource.nested_level_count(level_name)

	for i = 1, num_nested_levels, 1 do
		local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)

		self:_require_level_volumes(nested_level_name, volume_data)
	end

	local file_path = level_name .. "_volume_data"

	if Application.can_get_resource("lua", file_path) then
		local file_data = require(file_path)

		table.append(volume_data, file_data.volume_data)
	else
		Log.info("VolumeEventSystem", "Couldn't find any level volume data for level %q, no volume events will run on this level\nThe volume_data file should have been auto generated when saving the level in the editor, just add a reference to it in the level package.", level_name)
	end

	return volume_data
end

VolumeEventSystem._create_event_volume_data = function (self, level_volumes)
	local volumes_by_name = {}

	for i = 1, #level_volumes, 1 do
		local level_volume = level_volumes[i]
		local volume_type = level_volume.type
		local volume_events = volume_type_events[volume_type]

		if volume_events then
			local volume_name = level_volume.name
			local volume = volumes_by_name[volume_name]

			if not volume then
				volume = {
					registered = false,
					type = volume_type,
					events = volume_events,
					connected_units = {},
					levels = {},
					volume_ids = {}
				}
				volumes_by_name[volume_name] = volume
			else
				fassert(volume.type == volume_type, "[VolumeEventSystem] Volumes has same name %q but different types %q ~= %q", volume_name, volume.type, volume_type)
			end
		end
	end

	return volumes_by_name
end

VolumeEventSystem._add_nested_levels = function (self, level, levels)
	local nested_levels = Level.nested_levels(level)

	for i = 1, #nested_levels, 1 do
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
		for i = 1, #levels, 1 do
			local level = levels[i]

			if Level.has_volume(level, volume_name) then
				volume.levels[#volume.levels + 1] = level
			end
		end

		self:_register_level_volume(volume_name)
	end
end

VolumeEventSystem._register_level_volume = function (self, volume_name)
	Profiler.start("VolumeEventSystem:_register_level_volume")

	local volume = self._level_volumes_by_name[volume_name]

	fassert(volume, "[VolumeEventSystem] Volume data not found %q", volume_name)
	fassert(not volume.registered, "[VolumeEventSystem] Volume already registered %q", volume_name)

	local engine_volume_event_system = self._engine_volume_event_system
	local connected_units = volume.connected_units
	local volume_events = volume.events
	local volume_levels = volume.levels

	for extension_name, event_settings in pairs(volume_events) do
		local func = event_settings.func
		local on_enter, on_exit = nil

		if func then
			on_exit = func.on_exit
			on_enter = func.on_enter
		end

		local filter = event_settings.filter
		local invert_volume = event_settings.invert_volume
		local params = event_settings.params
		local traversal_cost = event_settings.traversal_cost

		if traversal_cost then
			self:_update_traversal_cost(extension_name, volume_name, traversal_cost)
		end

		local data = {
			params = params,
			connected_units = connected_units
		}

		for i = 1, #volume_levels, 1 do
			local level = volume_levels[i]
			local volume_id = VolumeEvent.register_volume(engine_volume_event_system, level, volume_name, extension_name, invert_volume, data, on_enter, on_exit, filter)

			table.insert(volume.volume_ids, volume_id)
		end
	end

	volume.registered = true

	Profiler.stop("VolumeEventSystem:_register_level_volume")
end

VolumeEventSystem.register_unit_volume = function (self, unit, volume_name, extension_name, volume_type)
	Profiler.start("VolumeEventSystem:register_unit_volume")

	local engine_volume_event_system = self._engine_volume_event_system
	local volume_events = volume_type_events[volume_type]
	local event_settings = volume_events[extension_name]
	local on_enter = event_settings.func.on_enter
	local on_exit = event_settings.func.on_exit
	local filter = event_settings.filter
	local invert_volume = event_settings.invert_volume
	local params = event_settings.params
	local data = {
		params = params,
		connected_units = unit
	}
	local volume_id = VolumeEvent.register_volume(engine_volume_event_system, unit, volume_name, extension_name, invert_volume, data, on_enter, on_exit, filter)

	Profiler.stop("VolumeEventSystem:register_unit_volume")

	return volume_id
end

VolumeEventSystem.unregister_unit_volume = function (self, volume_id, extension_name)
	Profiler.start("VolumeEventSystem:unregister_unit_volume")

	local engine_volume_event_system = self._engine_volume_event_system

	VolumeEvent.unregister_volume(engine_volume_event_system, volume_id, extension_name)
	Profiler.stop("VolumeEventSystem:unregister_unit_volume")
end

VolumeEventSystem._unregister_level_volume = function (self, volume_name)
	Profiler.start("VolumeEventSystem:_unregister_level_volume")

	local volume = self._level_volumes_by_name[volume_name]

	fassert(volume, "[VolumeEventSystem] Volume does not exist %q", volume_name)
	fassert(volume.registered, "[VolumeEventSystem] Tried to unregister a non-registered volume %q", volume_name)

	local engine_volume_event_system = self._engine_volume_event_system
	local traversal_costs = self._traversal_costs
	local volume_ids = volume.volume_ids

	for extension_name, _ in pairs(volume.events) do
		for i = 1, #volume_ids, 1 do
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
	Profiler.stop("VolumeEventSystem:_unregister_level_volume")
end

VolumeEventSystem._update_traversal_cost = function (self, extension_name, volume_name, cost)
	local extension_units = self._units_by_extension[extension_name]

	for i = 1, #extension_units, 1 do
		local unit = extension_units[i]

		self:_set_unit_nav_tag_layer_cost(unit, volume_name, cost)
	end

	self._traversal_costs[extension_name][volume_name] = (cost ~= 1 and cost) or nil
end

VolumeEventSystem._set_unit_nav_tag_layer_cost = function (self, unit, layer_name, layer_cost)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_nav_tag_layer_cost(layer_name, layer_cost)
end

VolumeEventSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	Profiler.start("VolumeEventSystem:on_add_extension")

	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	if self._is_server then
		VolumeEvent.on_add_extension(self._engine_volume_event_system, unit, extension_name)

		local extension_units = self._units_by_extension[extension_name]
		extension_units[#extension_units + 1] = unit
	end

	Profiler.stop("VolumeEventSystem:on_add_extension")

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

		fassert(navigation_extension, "[VolumeEventSystem] Volume extension %s on unit %s has traveral cost specified for one or more volume types, but no navigation extension was found", extension_name, unit)
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

	Profiler.start("VolumeEventSystem:update")
	VolumeEvent.update(self._engine_volume_event_system, t, dt)
	Profiler.stop("VolumeEventSystem:update")
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

	fassert(volume, "[VolumeEventSystem] Volume data not found %q", volume_name)
	fassert(volume.registered, "[VolumeEventSystem] Volume not registered %q", volume_name)

	local connected_units = volume.connected_units

	fassert(not table.contains(connected_units, unit), "[VolumeEventSystem] Unit %q already connected to volume %q", unit, volume_name)

	connected_units[#connected_units + 1] = unit
end

VolumeEventSystem.disconnect_unit_from_volume = function (self, volume_name, unit)
	if not self._is_server then
		return
	end

	local volume = self._level_volumes_by_name[volume_name]

	fassert(volume, "[VolumeEventSystem] Volume data not found %q", volume_name)

	local connected_units = volume.connected_units
	local unit_index = table.find(connected_units, unit)

	fassert(unit_index, "[VolumeEventSystem] Tried to disconnect a non-connected unit %q from volume %q", unit, volume_name)
	table.remove(connected_units, unit_index)
end

local units_to_test = {}

VolumeEventSystem.end_zone_conditions_fulfilled = function (self, volume_id)
	table.clear(units_to_test)

	local num_units_to_test = 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local num_alive_players = #alive_players

	for i = 1, num_alive_players, 1 do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")
			local can_complete_mission = PlayerUnitStatus.end_zone_conditions_fulfilled(character_state_component)
			local is_human = player:is_human_controlled()

			if is_human and can_complete_mission then
				num_units_to_test = num_units_to_test + 1
				units_to_test[num_units_to_test] = player_unit
			end
		end
	end

	if num_units_to_test ~= 0 then
		return VolumeEvent.has_all_units_inside(self._engine_volume_event_system, volume_id, unpack(units_to_test))
	end

	return false
end

return VolumeEventSystem
