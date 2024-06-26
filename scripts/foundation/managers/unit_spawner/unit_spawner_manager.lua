-- chunkname: @scripts/foundation/managers/unit_spawner/unit_spawner_manager.lua

local GrowQueue = require("scripts/foundation/utilities/grow_queue")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Unit_alive = Unit.alive
local UNIT_TEMPLATE_GAME_OBJECT_TYPE = 1

Level._unit_by_index = Level._unit_by_index or Level.unit_by_index
Level.unit_by_index = nil
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
}

if Managers.state and Managers.state.unit_spawner and Managers.state.unit_spawner._deletion_state ~= DELETION_STATES.default then
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.default)
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
end

UnitSpawnerManager.is_unit_template = function (self, game_object_type)
	return game_object_type == "unit_template"
end

UnitSpawnerManager._build_network_lookup = function (self, templates)
	local lookup = {}
	local i = 1

	for template_name, _ in pairs(templates) do
		lookup[i] = template_name
		lookup[template_name] = i
		i = i + 1
	end

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

UnitSpawnerManager._create_unit_extensions = function (self, world, unit, extension_init_function, extension_unit_spawned_function_or_nil, game_object_data_or_session, is_husk, ...)
	local any_extensions_added = self._extension_manager:add_unit_extensions_from_template(world, unit, extension_init_function, extension_unit_spawned_function_or_nil, self._unit_template_context, game_object_data_or_session, is_husk, ...)

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

UnitSpawnerManager.level_index = function (self, unit)
	local runtime_loaded_levels = self._runtime_loaded_levels

	for level_name_hash, units in pairs(runtime_loaded_levels) do
		for unit_index, runtime_unit in pairs(units) do
			if runtime_unit == unit then
				return unit_index, level_name_hash
			end
		end
	end

	local unit_index = Level._unit_index(self._main_level, unit)

	return unit_index, NetworkConstants.invalid_level_name_hash
end

UnitSpawnerManager.unit = function (self, game_object_id_or_level_index, is_level_unit_optional, level_name_hash_optional)
	if level_name_hash_optional and level_name_hash_optional ~= NetworkConstants.invalid_level_name_hash then
		local units_in_runtime_loaded_level = self._runtime_loaded_levels[level_name_hash_optional]

		return units_in_runtime_loaded_level[game_object_id_or_level_index]
	elseif is_level_unit_optional then
		return Level._unit_by_index(self._main_level, game_object_id_or_level_index)
	else
		return self._network_units[game_object_id_or_level_index]
	end
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

	if self._game_session then
		local game_object_type = unit_template.game_object_type(...)

		game_object_id = GameSession.create_game_object(self._game_session, game_object_type, game_object_data)

		self:_add_network_unit(unit, game_object_id, false)
		self._extension_manager:sync_unit_extensions(unit, self._game_session, game_object_id)
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

	self:_create_unit_extensions(self._world, unit, template.local_init, template.unit_spawned, game_object_data, false, ...)

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
	self:_create_unit_extensions(self._world, unit, unit_template.husk_init, unit_template.unit_spawned, session, true, game_object_id, owner_id)
end

UnitSpawnerManager.register_runtime_loaded_level = function (self, level)
	local level_name_hash = Level._name_hash_32(level)

	self._runtime_loaded_levels[level_name_hash] = self._runtime_loaded_levels[level_name_hash] or {}

	local units_in_runtime_loaded_level = self._runtime_loaded_levels[level_name_hash]
	local level_units = Level.units(level, true)

	for _, unit in ipairs(level_units) do
		local unit_index = Level._unit_index(level, unit)

		units_in_runtime_loaded_level[unit_index] = unit
	end
end

UnitSpawnerManager.unregister_runtime_loaded_level = function (self, level)
	local level_name_hash = Level._name_hash_32(level)

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

UnitSpawnerManager.rpc_is_fully_hot_join_synced = function (self, channel_id)
	self.is_fully_hot_join_synced = true
end

return UnitSpawnerManager
