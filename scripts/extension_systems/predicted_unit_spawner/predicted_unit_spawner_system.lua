-- chunkname: @scripts/extension_systems/predicted_unit_spawner/predicted_unit_spawner_system.lua

local _hash_by_action, _create_data_by_action, _data_by_action, _clear_data_by_action, _is_context_by_action
local SERVER_RPCS = {}
local CLIENT_RPCS = {
	"rpc_predicted_unit_consumed",
}
local PredictedUnitSpawnerSystem = class("PredictedUnitSpawnerSystem", "ExtensionSystemBase")

PredictedUnitSpawnerSystem.init = function (self, context, system_init_data, ...)
	PredictedUnitSpawnerSystem.super.init(self, context, system_init_data, ...)

	self._prepared_units = {}

	if self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

PredictedUnitSpawnerSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = PredictedUnitSpawnerSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local peer_id = extension:owner_peer_id()
	local local_player_id = extension:owner_local_player_id()
	local action_component_name = extension:action_component_name()
	local action_component_context_id = extension:action_component_context_id()
	local prepare_data = _create_data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_component_context_id)

	prepare_data.unit = unit

	return extension
end

PredictedUnitSpawnerSystem.on_remove_extension = function (self, unit, extension_name)
	local extension = self._unit_to_extension_map[unit]
	local peer_id = extension:owner_peer_id()
	local local_player_id = extension:owner_local_player_id()
	local action_component_name = extension:action_component_name()
	local action_component_context_id = extension:action_component_context_id()

	_clear_data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_component_context_id)
	PredictedUnitSpawnerSystem.super.on_remove_extension(self, unit, extension_name)
end

PredictedUnitSpawnerSystem.hot_join_sync = function (self, sender, channel)
	for _, prepared_data in pairs(self._prepared_units) do
		local extension = self._unit_to_extension_map[prepared_data.unit]

		if extension and extension:consumed() then
			RPC.rpc_predicted_unit_consumed(channel, prepared_data.peer_id, prepared_data.local_player_id, prepared_data.action_component_id, prepared_data.action_component_context_id, prepared_data.position:unbox(), prepared_data.rotation:unbox())
		end
	end
end

PredictedUnitSpawnerSystem.prepare_unit_by_action = function (self, peer_id, local_player_id, action_component_name, unit_name, unit_template_name, position, rotation, material, ...)
	local player = Managers.player:player(peer_id, local_player_id)
	local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
	local action_component = unit_data_extension:read_component(action_component_name)
	local action_context_id = action_component.action_context_id

	return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name or "predicted_unit", position, rotation, material, unit_name, peer_id, local_player_id, action_component_name, action_context_id, ...)
end

PredictedUnitSpawnerSystem.unprepare_unit_by_action = function (self, peer_id, local_player_id, action_component_name)
	local player = Managers.player:player(peer_id, local_player_id)
	local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
	local action_component = unit_data_extension:read_component(action_component_name)
	local action_context_id = action_component.action_context_id
	local prepared_unit_data = _data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_context_id)

	Managers.state.unit_spawner:mark_for_deletion(prepared_unit_data.unit)

	prepared_unit_data.unit = nil
end

PredictedUnitSpawnerSystem.try_consume_unit_by_action = function (self, peer_id, local_player_id, action_component_name, position, rotation)
	local player = Managers.player:player(peer_id, local_player_id)
	local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
	local action_component = unit_data_extension:read_component(action_component_name)
	local action_context_id = action_component.action_context_id
	local prepared_unit_data = _data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_context_id)

	if not prepared_unit_data then
		return
	end

	local unit = prepared_unit_data.unit
	local extension = self._unit_to_extension_map[unit]

	if not extension:consumed() then
		if self._is_server then
			extension:server_consumed(position, rotation)

			prepared_unit_data.position = Vector3Box(position)
			prepared_unit_data.rotation = QuaternionBox(rotation)

			local action_component_id = NetworkLookup.action_handler_component_names[action_component_name]

			Managers.state.game_session:send_rpc_clients("rpc_predicted_unit_consumed", peer_id, local_player_id, action_component_id, action_context_id, position, rotation)
		else
			extension:client_consumed(position, rotation)
		end
	end

	return unit
end

PredictedUnitSpawnerSystem.peek_unit_by_action = function (self, peer_id, local_player_id, action_component_name)
	local player = Managers.player:player(peer_id, local_player_id)
	local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
	local action_component = unit_data_extension:read_component(action_component_name)
	local action_context_id = action_component.action_context_id
	local prepared_unit_data = _data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_context_id)

	if not prepared_unit_data then
		return
	end

	return prepared_unit_data.unit
end

PredictedUnitSpawnerSystem.unconsume_unit_by_action = function (self, peer_id, local_player_id, action_component_name)
	local player = Managers.player:player(peer_id, local_player_id)
	local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
	local action_component = unit_data_extension:read_component(action_component_name)
	local action_context_id = action_component.action_context_id
	local prepared_unit_data = _data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_context_id)

	if not prepared_unit_data then
		return
	end

	local unit = prepared_unit_data.unit
	local extension = self._unit_to_extension_map[unit]

	extension:client_unconsume()

	return unit
end

PredictedUnitSpawnerSystem.rpc_predicted_unit_consumed = function (self, channel_id, peer_id, local_player_id, action_component_id, action_context_id, position, rotation)
	local action_component_name = NetworkLookup.action_handler_component_names[action_component_id]
	local prepared_unit_data = _data_by_action(self._prepared_units, peer_id, local_player_id, action_component_name, action_context_id)
	local unit = prepared_unit_data.unit
	local extension = self._unit_to_extension_map[unit]

	extension:resolve_transform(position, rotation)

	if not extension:consumed() then
		extension:client_consumed(position, rotation)
	end
end

PredictedUnitSpawnerSystem.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	PredictedUnitSpawnerSystem.super.destroy(self)
end

_hash_by_action = Application.make_hash

function _create_data_by_action(tbl, peer_id, local_player_id, action_component_name, action_context_id)
	local hash = _hash_by_action(peer_id, local_player_id, action_component_name, action_context_id)
	local datas = tbl[hash]

	if not datas then
		datas = {}
		tbl[hash] = datas
	end

	local data = {
		peer_id = peer_id,
		local_player_id = local_player_id,
		action_component_name = action_component_name,
		action_context_id = action_context_id,
	}

	datas[#datas + 1] = data

	return data
end

function _data_by_action(tbl, peer_id, local_player_id, action_component_name, action_context_id)
	local hash = _hash_by_action(peer_id, local_player_id, action_component_name, action_context_id)
	local datas = tbl[hash]

	if not datas then
		return nil
	end

	for i = 1, #datas do
		local data = datas[i]

		if _is_context_by_action(data, peer_id, local_player_id, action_component_name, action_context_id) then
			return data
		end
	end

	return nil
end

function _clear_data_by_action(tbl, peer_id, local_player_id, action_component_name, action_context_id)
	local hash = _hash_by_action(peer_id, local_player_id, action_component_name, action_context_id)
	local datas = tbl[hash]

	for i = 1, #datas do
		local data = datas[i]

		if _is_context_by_action(data, peer_id, local_player_id, action_component_name, action_context_id) then
			table.swap_delete(datas, i)

			return
		end
	end

	if not next(datas) then
		tbl[hash] = nil
	end
end

function _is_context_by_action(context, peer_id, local_player_id, action_component_name, action_context_id)
	if not context then
		return false
	end

	if context.peer_id ~= peer_id or context.local_player_id ~= local_player_id then
		return false
	end

	if context.action_component_name ~= action_component_name then
		return false
	end

	if context.action_context_id ~= action_context_id then
		return false
	end

	return true
end

return PredictedUnitSpawnerSystem
