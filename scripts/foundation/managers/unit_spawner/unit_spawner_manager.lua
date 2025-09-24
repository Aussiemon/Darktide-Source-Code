-- chunkname: @scripts/foundation/managers/unit_spawner/unit_spawner_manager.lua

local GrowQueue = require("scripts/foundation/utilities/grow_queue")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Unit_alive = Unit.alive
local UNIT_TEMPLATE_GAME_OBJECT_TYPE = 1

Level._unit_by_index = Level._unit_by_index or Level.unit_by_index
Level._unit_index = Level._unit_index or Level.unit_index
Level.unit_index = nil
Level._name_hash_32 = Level._name_hash_32 or Level.name_hash_32
Level.name_hash_32 = nil

local UnitSpawnerManager = class("UnitSpawnerManager")
local DELETION_STATES = table.enum("default", "during_extension_update", "removing_units")

UnitSpawnerManager.DELETION_STATES = DELETION_STATES

local NUM_ESTIMATED_TEMPLATE_UNITS = 256
local CLIENT_RPCS = {
	"rpc_is_fully_hot_join_synced",
	"rpc_hot_join_sync_dynamic_spawned_level",
	"rpc_hot_join_sync_next_level_unit_index",
}

if Managers.state and Managers.state.unit_spawner and Managers.state.unit_spawner._deletion_state ~= DELETION_STATES.default then
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.default)
end

local function _log_info(...)
	Log.info("UnitSpawnerManager", ...)
end

UnitSpawnerManager.init = function (self, world, extension_manager, is_server, unit_templates, game_session, level_name, network_event_delegate)
	self._world = world
	self._extension_manager = extension_manager
	self._is_server = is_server
	self._main_level = ScriptWorld.level(world, level_name)
	self._runtime_loaded_levels = {}
	self._deletion_queue = GrowQueue:new()
	self._addition_queue = GrowQueue:new()
	self._num_deleted_units = 0
	self._deletion_state = DELETION_STATES.default
	self._temp_units_list = {}
	self._game_session = game_session
	self._unit_templates = unit_templates
	self._unit_template_by_unit = Script.new_map(NUM_ESTIMATED_TEMPLATE_UNITS)
	self._unit_template_context = {
		is_server = is_server,
		world = world,
	}
	self._unit_template_network_lookup = self:_build_network_lookup(self._unit_templates)

	if game_session then
		self.is_fully_hot_join_synced = is_server and true or false

		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end

	self._network_units = {}
	self._husk_units = {}
	self._game_object_ids = {}
	self._level_unit_array = Script.new_array(NetworkConstants.level_unit_id.max)
	self._level_unit_index_lookup = {
		Script.new_map(NetworkConstants.level_unit_id.max),
	}
	self._registered_levels = {}
	self._next_level_unit_index = 1
	self._has_spawned_dynamic_level = false
	self._last_level_id = 0
end

UnitSpawnerManager.next_level_id = function (self)
	return self._last_level_id + 1
end

UnitSpawnerManager.current_level_id = function (self)
	return self._last_level_id
end

UnitSpawnerManager.hot_join_sync = function (self, sender, channel_id)
	for id = 1, #self._registered_levels do
		local level_data = self._registered_levels[id]
		local start_index = level_data.start_index
		local end_index = level_data.end_index

		if level_data.is_spawned and level_data.is_dynamic then
			RPC.rpc_hot_join_sync_dynamic_spawned_level(channel_id, id, start_index, end_index)
			_log_info("%s : hotjoin sync dynamic level, id(%i) start index(%i)", sender, id, start_index)
		else
			_log_info("%s : NOT syncing dynamic level, id(%i) start index(%i)", sender, id, start_index)
		end
	end

	local next_level_unit_index = self._next_level_unit_index

	RPC.rpc_hot_join_sync_next_level_unit_index(channel_id, next_level_unit_index)
end

UnitSpawnerManager.rpc_hot_join_sync_next_level_unit_index = function (self, channel_id, index)
	self._next_level_unit_index = index

	_log_info("hotjoin sync level_unit_index (%i)", index)
end

UnitSpawnerManager.rpc_hot_join_sync_dynamic_spawned_level = function (self, channel_id, level_id, start_index, end_index)
	self._registered_levels[level_id] = {
		is_dynamic = true,
		is_spawned = false,
		start_index = start_index,
		end_index = end_index,
	}

	_log_info("hotjoin sync dynamic level, id(%i) unit start index(%i) unit end index(%i)", level_id, start_index, end_index)
end

UnitSpawnerManager.unregister_spawned_level = function (self, level)
	local level_id = Level.get_data(level, "UnitSpawnerManager", "level_id")

	_log_info("Unregister level %q, id: %i", level, tonumber(level_id))

	local level_data = self._registered_levels[level_id]

	level_data.is_spawned = false
	level_data.level = nil

	local start_index = level_data.start_index
	local end_index = level_data.end_index

	for i = start_index, end_index - 1 do
		local unit = self._level_unit_array[i]

		self._level_unit_array[i] = nil
		self._level_unit_index_lookup[unit] = nil
	end
end

UnitSpawnerManager.register_dynamic_level_spawned_units_client = function (self, level, units, server_level_id)
	local level_data

	if self.is_fully_hot_join_synced then
		level_data = {
			is_spawned = false,
			start_index = self._next_level_unit_index,
			end_index = self._next_level_unit_index + #units,
		}
		self._registered_levels[server_level_id] = level_data
	else
		level_data = self._registered_levels[server_level_id]

		if not level_data then
			table.dump(self._registered_levels, "registered levels", 2)
			ferror("Trying to spawn dynamic level with id %i that server hasn't synced yet.", server_level_id)
		end
	end

	self._has_spawned_dynamic_level = true
	level_data.level = level
	level_data.is_spawned = true
	level_data.is_dynamic = true
	self._last_level_id = server_level_id

	if self.is_fully_hot_join_synced then
		self:_register_spawned_units(level, units, server_level_id)
	else
		self:_register_spawned_units(level, units, server_level_id, level_data.start_index)
	end
end

UnitSpawnerManager.index_by_level = function (self, level)
	local level_id
	local sub_level_id = Level.get_data(level, "UnitSpawnerManager", "sub_level_id")

	if sub_level_id then
		level_id = Level.get_data(level, "UnitSpawnerManager", "parent_level_id")
	else
		level_id = Level.get_data(level, "UnitSpawnerManager", "level_id")
	end

	return level_id, sub_level_id
end

UnitSpawnerManager.level_by_index = function (self, level_index, sub_level_index)
	local registered_levels = self._registered_levels
	local level_data = registered_levels[level_index]

	if level_data then
		if sub_level_index and sub_level_index ~= -1 then
			local sub_levels = level_data.sub_levels
			local sub_level = sub_levels[sub_level_index]

			return sub_level
		end

		return level_data.level
	end
end

UnitSpawnerManager.register_dynamic_level_spawned_units_server = function (self, level, units)
	self._has_spawned_dynamic_level = true

	local id = self._last_level_id + 1

	self._last_level_id = id

	local assign_sub_level_ids

	function assign_sub_level_ids(current_level, current_index, all_sub_levels)
		local sub_levels = Level.nested_levels(current_level)

		for i = 1, #sub_levels do
			local sub_level = sub_levels[i]

			Level.set_data(sub_level, "UnitSpawnerManager", "sub_level_id", current_index)
			Level.set_data(sub_level, "UnitSpawnerManager", "parent_level_id", id)

			all_sub_levels[current_index] = sub_level
			current_index = current_index + 1

			assign_sub_level_ids(sub_level, current_index, all_sub_levels)
		end
	end

	local all_sub_levels = {}

	assign_sub_level_ids(level, 1, all_sub_levels)

	self._registered_levels[id] = {
		is_dynamic = true,
		is_spawned = true,
		level = level,
		start_index = self._next_level_unit_index,
		end_index = self._next_level_unit_index + #units,
		sub_levels = all_sub_levels,
	}

	self:_register_spawned_units(level, units, id)

	return id
end

UnitSpawnerManager.register_static_level_spawned_units = function (self, level, units)
	local id = self._last_level_id + 1

	self._last_level_id = id

	local assign_sub_level_ids

	function assign_sub_level_ids(current_level, current_index, all_sub_levels)
		local sub_levels = Level.nested_levels(current_level)

		for i = 1, #sub_levels do
			local sub_level = sub_levels[i]

			Level.set_data(sub_level, "UnitSpawnerManager", "sub_level_id", current_index)
			Level.set_data(sub_level, "UnitSpawnerManager", "parent_level_id", id)

			all_sub_levels[current_index] = sub_level
			current_index = current_index + 1

			assign_sub_level_ids(sub_level, current_index, all_sub_levels)
		end
	end

	local all_sub_levels = {}

	assign_sub_level_ids(level, 1, all_sub_levels)

	self._registered_levels[id] = {
		is_spawned = true,
		level = level,
		start_index = self._next_level_unit_index,
		end_index = self._next_level_unit_index + #units,
		sub_levels = all_sub_levels,
	}

	self:_register_spawned_units(level, units, id)
end

UnitSpawnerManager._register_spawned_units = function (self, level, units, id, override_start_index)
	local start_index = override_start_index or self._next_level_unit_index
	local next_index = start_index
	local unit_array = self._level_unit_array
	local index_lookup = self._level_unit_index_lookup
	local unit

	for i = 1, #units do
		unit = units[i]
		unit_array[next_index] = unit
		index_lookup[unit] = next_index
		next_index = next_index + 1
	end

	if not override_start_index then
		self._next_level_unit_index = next_index
	end

	_log_info("Registered level %q, id: %i", level, id)
	Level.set_data(level, "UnitSpawnerManager", "level_id", id)
end

UnitSpawnerManager.is_unit_template = function (self, game_object_type)
	return game_object_type == "unit_template"
end

UnitSpawnerManager._build_network_lookup = function (self, templates)
	local template_keys = table.keys(templates)

	table.sort(template_keys)

	local lookup = {}

	for i = 1, #template_keys do
		lookup[i] = template_keys[i]
	end

	table.mirror_array_inplace(lookup)

	return lookup
end

UnitSpawnerManager.destroy = function (self)
	if self._network_event_delegate then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		self._network_event_delegate = nil
	end

	self._unit_destroy_listeners = nil
	self._extension_manager = nil
end

UnitSpawnerManager.set_gameobject_to_unit_creator_function = function (self, func)
	self._create_unit_from_gameobject_function = func
end

UnitSpawnerManager.commit_and_remove_pending_units = function (self)
	local num_removed, num_added

	repeat
		num_added = self:_add_pending_extensions()
		num_removed = self:_remove_units_marked_for_deletion()
	until num_removed == 0 and num_added == 0
end

UnitSpawnerManager._add_pending_extensions = function (self)
	if not self.is_fully_hot_join_synced then
		return 0
	end

	local addition_queue = self._addition_queue

	if addition_queue:size() == 0 then
		return 0
	end

	local temp_list = self._temp_units_list
	local unit = addition_queue:pop_first()
	local num_units = 0

	while unit do
		num_units = num_units + 1
		temp_list[num_units] = unit
		unit = addition_queue:pop_first()
	end

	local extension_manager = self._extension_manager

	extension_manager:register_units_extensions(temp_list, num_units)

	return num_units
end

UnitSpawnerManager.mark_for_deletion = function (self, unit)
	if self._deletion_queue:contains(unit) then
		Log.exception("UnitSpawnerManager", "Tried to mark %s for deletion twice!", tostring(unit))
	end

	local deletion_state = self._deletion_state

	if deletion_state == DELETION_STATES.during_extension_update then
		self._deletion_queue:push_back(unit)
	elseif deletion_state == DELETION_STATES.removing_units then
		Unit.flow_event(unit, "cleanup_before_destroy")
		Managers.state.extension:unregister_unit(unit)

		self._num_deleted_units = self._num_deleted_units + 1
		self._temp_units_list[self._num_deleted_units] = unit
	else
		Unit.flow_event(unit, "cleanup_before_destroy")
		Managers.state.extension:unregister_unit(unit)
		self:_world_delete_unit(unit)
	end
end

UnitSpawnerManager.is_marked_for_deletion = function (self, unit)
	return self._deletion_queue:contains(unit)
end

UnitSpawnerManager._remove_units_marked_for_deletion = function (self)
	if self._deletion_queue:size() == 0 then
		return 0
	end

	local extension_manager = self._extension_manager
	local temp_deleted_units_list = self._temp_units_list

	self._num_deleted_units = 0

	self:set_deletion_state(DELETION_STATES.removing_units)

	local unit = self._deletion_queue:pop_first()

	while unit do
		Unit.flow_event(unit, "cleanup_before_destroy")
		extension_manager:unregister_unit(unit)

		self._num_deleted_units = self._num_deleted_units + 1
		temp_deleted_units_list[self._num_deleted_units] = unit
		unit = self._deletion_queue:pop_first()
	end

	self:set_deletion_state(DELETION_STATES.default)

	local num_deleted_units = self._num_deleted_units

	self:_world_delete_units(temp_deleted_units_list, num_deleted_units)

	return num_deleted_units
end

UnitSpawnerManager.set_deletion_state = function (self, state)
	self._deletion_state = state
end

UnitSpawnerManager.deletion_state = function (self)
	return self._deletion_state
end

UnitSpawnerManager.spawn_unit = function (self, unit_name, ...)
	local unit = World.spawn_unit_ex(self._world, unit_name, nil, ...)

	Unit.set_data(unit, "unit_name", unit_name)

	return unit
end

UnitSpawnerManager._create_unit_extensions = function (self, world, unit, extension_init_function, extension_unit_spawned_function_or_nil, game_object_data_or_session, ...)
	local any_extensions_added = self._extension_manager:add_unit_extensions_from_template(world, unit, extension_init_function, extension_unit_spawned_function_or_nil, self._unit_template_context, game_object_data_or_session, ...)

	if any_extensions_added then
		self._addition_queue:push_back(unit)
	end
end

UnitSpawnerManager.is_husk = function (self, unit)
	local is_husk = self._husk_units[unit]

	return is_husk
end

UnitSpawnerManager.game_object_id_or_level_index = function (self, unit)
	local id = self._game_object_ids[unit]

	if id then
		return false, id, NetworkConstants.invalid_level_name_hash
	else
		local unit_index, level_name_hash = self:level_index(unit)

		return true, unit_index, level_name_hash
	end
end

UnitSpawnerManager.game_object_id = function (self, unit)
	return self._game_object_ids[unit]
end

UnitSpawnerManager.unit_index = function (self, unit)
	return self:level_index(unit)
end

UnitSpawnerManager.level_index = function (self, unit)
	local unit_index

	unit_index = self._level_unit_index_lookup[unit]

	if unit_index then
		return self._level_unit_index_lookup[unit], NetworkConstants.invalid_level_name_hash
	end

	if not Unit.level(unit) then
		return nil, NetworkConstants.invalid_level_name_hash
	end

	local runtime_loaded_levels = self._runtime_loaded_levels

	for level_name_hash, units in pairs(runtime_loaded_levels) do
		for level_unit_index, runtime_unit in pairs(units) do
			if runtime_unit == unit then
				return level_unit_index, level_name_hash
			end
		end
	end

	unit_index = Level._unit_index(self._main_level, unit)

	if unit_index then
		return unit_index, NetworkConstants.invalid_level_name_hash
	end

	if Unit.level(unit) then
		Log.exception("UnitSpawnerManager", "Could not find a registered level for unit %s.", tostring(unit))
	end

	return nil, NetworkConstants.invalid_level_name_hash
end

UnitSpawnerManager.unit = function (self, game_object_id_or_level_index, is_level_unit_optional, level_name_hash_optional)
	local hash_ok = level_name_hash_optional and tonumber(level_name_hash_optional) ~= NetworkConstants.invalid_level_name_hash

	if hash_ok then
		local units_in_runtime_loaded_level = self._runtime_loaded_levels[level_name_hash_optional]

		return units_in_runtime_loaded_level[game_object_id_or_level_index]
	elseif is_level_unit_optional then
		local unit = self._level_unit_array[game_object_id_or_level_index]

		if unit then
			return unit
		else
			table.dump(self._level_unit_array)
			Log.exception("UnitSpawnerManager", "[FEATURE_expanded_level_ids] Level index %i not found in level unit array", game_object_id_or_level_index)
		end

		return Level._unit_by_index(self._main_level, game_object_id_or_level_index)
	end

	return self._network_units[game_object_id_or_level_index]
end

UnitSpawnerManager.valid_unit_id = function (self, unit_id, is_level_unit)
	local valid_level_id = is_level_unit == true and unit_id ~= NetworkConstants.invalid_level_unit_id
	local valid_object_id = is_level_unit == false and unit_id ~= NetworkConstants.invalid_game_object_id

	return valid_level_id or valid_object_id
end

UnitSpawnerManager._add_network_unit = function (self, unit, game_object_id, is_husk)
	self._game_object_ids[unit] = game_object_id
	self._network_units[game_object_id] = unit
	self._husk_units[unit] = is_husk
end

UnitSpawnerManager._remove_network_unit = function (self, unit)
	local game_object_id = self._game_object_ids[unit]

	self._game_object_ids[unit] = nil
	self._network_units[game_object_id] = nil
	self._husk_units[unit] = nil
end

UnitSpawnerManager.make_network_unit_local_unit = function (self, unit)
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = self:game_object_id(unit)

	GameSession.destroy_game_object(game_session, game_object_id)
	self:_remove_network_unit(unit)
end

UnitSpawnerManager.spawn_network_unit = function (self, unit_name, unit_template_name, position, rotation, material, ...)
	local game_object_data = {
		game_object_type = UNIT_TEMPLATE_GAME_OBJECT_TYPE,
		unit_template = self._unit_template_network_lookup[unit_template_name],
	}
	local unit = self:_spawn_unit_with_extensions(unit_name, unit_template_name, position, rotation, material, game_object_data, ...)
	local unit_template = self._unit_templates[unit_template_name]
	local game_object_id
	local game_session = self._game_session

	if game_session then
		local game_object_type = unit_template.game_object_type(...)

		game_object_id = GameSession.create_game_object(game_session, game_object_type, game_object_data)

		self:_add_network_unit(unit, game_object_id, false)
		self._extension_manager:on_unit_id_resolved(unit, false, game_object_id)
		self._extension_manager:sync_unit_extensions(unit, game_session, game_object_id)
	end

	return unit, game_object_id
end

UnitSpawnerManager._spawn_unit_with_extensions = function (self, unit_name, unit_template_name, position, rotation, material, game_object_data, ...)
	local template = self._unit_templates[unit_template_name]

	if position == nil then
		position = Vector3(0, 0, 0)
	end

	if rotation == nil then
		rotation = Quaternion.identity()
	end

	local unit = self:spawn_unit(template.local_unit(unit_name, position, rotation, material, ...))

	self:_create_unit_extensions(self._world, unit, template.local_init, template.local_unit_spawned, game_object_data, ...)

	self._unit_template_by_unit[unit] = template

	return unit
end

UnitSpawnerManager._world_delete_units = function (self, units_list, num_units)
	local game_session, unit_template_by_unit = self._game_session, self._unit_template_by_unit

	for i = 1, num_units do
		local unit = units_list[i]
		local unit_is_alive = Unit_alive(unit)
		local game_object_id_to_remove = self:game_object_id(unit)

		if game_object_id_to_remove then
			if game_session then
				GameSession.destroy_game_object(game_session, game_object_id_to_remove)
			end

			self:_remove_network_unit(unit)
		end

		Unit.flow_event(unit, "unit_despawned")

		local unit_template = unit_template_by_unit[unit]
		local pre_unit_destroyed_func = unit_template and unit_template.pre_unit_destroyed

		if pre_unit_destroyed_func then
			pre_unit_destroyed_func(unit)
		end

		local unit_world = Unit.world(unit)

		World.destroy_unit(unit_world, unit)

		unit_template_by_unit[unit] = nil
	end
end

local TEMP_UNIT_TABLE = {}

UnitSpawnerManager._world_delete_unit = function (self, unit)
	TEMP_UNIT_TABLE[1] = unit

	self:_world_delete_units(TEMP_UNIT_TABLE, 1)
end

UnitSpawnerManager.spawn_husk_unit = function (self, game_object_id, owner_id)
	local session = self._game_session
	local unit_template_name = self._unit_template_network_lookup[GameSession.game_object_field(session, game_object_id, "unit_template")]
	local unit_template = self._unit_templates[unit_template_name]
	local unit = self:spawn_unit(unit_template.husk_unit(session, game_object_id))

	self._unit_template_by_unit[unit] = unit_template

	self:_add_network_unit(unit, game_object_id, true)
	self:_create_unit_extensions(self._world, unit, unit_template.husk_init, unit_template.husk_unit_spawned, session, game_object_id, owner_id)
end

UnitSpawnerManager.register_runtime_loaded_level = function (self, level, level_hash)
	local level_name_hash = level_hash or Level._name_hash_32(level)

	self._runtime_loaded_levels[level_name_hash] = self._runtime_loaded_levels[level_name_hash] or {}

	local units_in_runtime_loaded_level = self._runtime_loaded_levels[level_name_hash]
	local level_units = Level.units(level, true)

	for _, unit in ipairs(level_units) do
		local unit_index = Level._unit_index(level, unit)

		units_in_runtime_loaded_level[unit_index] = unit
	end
end

UnitSpawnerManager.unregister_runtime_loaded_level = function (self, level, level_hash)
	local level_name_hash = level_hash or Level._name_hash_32(level)

	self._runtime_loaded_levels[level_name_hash] = nil
end

UnitSpawnerManager.destroy_game_object_unit = function (self, game_object_id, owner_id)
	local unit = self._network_units[game_object_id]

	self:_remove_network_unit(unit)

	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
	local is_owned_by_death_manager = unit_data_extension and unit_data_extension:is_owned_by_death_manager()

	if is_owned_by_death_manager then
		Managers.state.minion_death:client_finalize_death(unit, game_object_id)

		return
	end

	self:mark_for_deletion(unit)
end

UnitSpawnerManager.rpc_is_fully_hot_join_synced = function (self, sender, channel_id)
	_log_info("%s : rpc_is_fully_hot_join_synced", sender)

	self.is_fully_hot_join_synced = true
end

UnitSpawnerManager.fully_hot_join_synced = function (self)
	return self.is_fully_hot_join_synced
end

return UnitSpawnerManager
