-- chunkname: @scripts/foundation/managers/level_instance/level_instance_manager.lua

local LevelInstanceManagerSettings = require("scripts/foundation/managers/level_instance/level_instance_manager_settings")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local LevelInstanceManager = class("LevelInstanceManager")

LevelInstanceManager.init = function (self, world, extension_manager, is_server, unit_templates, game_session, level_name, network_event_delegate)
	self._world = world
	self._extension_manager = extension_manager
	self._is_server = is_server
	self._main_level = ScriptWorld.level(world, level_name)
	self._network_event_delegate = network_event_delegate
	self._spawned_level_instances = {}

	if not is_server then
		local client_rpcs = LevelInstanceManagerSettings.client_rpcs

		self._network_event_delegate:register_session_events(self, unpack(client_rpcs))
	end
end

LevelInstanceManager.cleanup = function (self)
	ScriptWorld.destroy_level_instances(self._world)

	self._spawned_level_instances = {}
end

LevelInstanceManager.destroy = function (self)
	ScriptWorld.destroy_level_instances(self._world)

	self._spawned_level_instances = {}

	if self._network_event_delegate then
		if not self._is_server then
			local client_rpcs = LevelInstanceManagerSettings.client_rpcs

			self._network_event_delegate:unregister_events(unpack(client_rpcs))
		end

		self._network_event_delegate = nil
	end
end

LevelInstanceManager.spawn_level_instance = function (self, level_name, position, rotation)
	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()

	local instance_data = self:_spawn_level_instance_local(level_name, position, rotation)

	self:_server_sync_instanced_level_with_clients(instance_data)

	return instance_data
end

LevelInstanceManager._spawn_level_instance_local = function (self, level_name, position, rotation, optional_instance_hash)
	local level, instance_id, instance_hash = ScriptWorld.spawn_level_instance(self._world, level_name, position, rotation, true, optional_instance_hash)
	local instance_data = {
		level = level,
		name = level_name,
		instance_id = instance_id,
		instance_hash = instance_hash,
		position_boxed = Vector3Box(),
		rotation_boxed = QuaternionBox(),
	}

	Vector3Box.store(instance_data.position_boxed, position)
	QuaternionBox.store(instance_data.rotation_boxed, rotation)

	self._spawned_level_instances[instance_hash] = instance_data

	return instance_data
end

LevelInstanceManager.destroy_level_instance = function (self, instance_hash)
	local level_instance_data = self._spawned_level_instances[instance_hash]

	if not level_instance_data then
		return
	end

	ScriptWorld.destroy_level_instance(self._world, level_instance_data.name, level_instance_data.instance_id)
end

LevelInstanceManager.hot_join_sync = function (self, sender, channel_id)
	for hash, instance_data in pairs(self._spawned_level_instances) do
		self:_server_sync_instanced_level_with_clients(instance_data, channel_id)
	end
end

LevelInstanceManager._server_sync_instanced_level_with_clients = function (self, instance_data, optional_channel)
	local game_session_manager = Managers.state.game_session

	if optional_channel then
		RPC.rpc_level_instance_spawn(optional_channel, instance_data.name, instance_data.instance_hash, instance_data.position_boxed:unbox(), instance_data.rotation_boxed:unbox())
	else
		game_session_manager:send_rpc_clients("rpc_level_instance_spawn", instance_data.name, instance_data.instance_hash, instance_data.position_boxed:unbox(), instance_data.rotation_boxed:unbox())
	end
end

LevelInstanceManager.rpc_level_instance_spawn = function (self, channel_id, level_name, server_level_hash, position, rotation)
	if self._spawned_level_instances[server_level_hash] then
		Log.warning("[LevelInstanceManager]", "client trying to spawn a level instance with the same hash again", server_level_hash, level_name)

		return
	end

	self:_spawn_level_instance_local(level_name, position, rotation, server_level_hash)
end

LevelInstanceManager.rpc_level_instance_destroy = function (self, instance_hash)
	return
end

return LevelInstanceManager
