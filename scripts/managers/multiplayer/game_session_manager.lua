-- chunkname: @scripts/managers/multiplayer/game_session_manager.lua

local GameSessionManager = class("GameSessionManager")
local NETWORK_EVENTS = {
	"game_object_migrated_to_me",
	"game_object_created",
	"game_object_destroyed",
	"game_session_disconnect"
}

local function _info(...)
	Log.info("GameSessionManager", ...)
end

GameSessionManager.DELAYED_DISCONNECT_TIME = 1

GameSessionManager.init = function (self, fixed_time_step)
	self.fixed_time_step = fixed_time_step
	self._peer_id = Network.peer_id()
	self._session_disconnected = false
	self._is_server = nil
	self._engine_game_session = Network.create_game_session()

	local event_delegate = Managers.connection:network_event_delegate()

	event_delegate:register_session_events(self, unpack(NETWORK_EVENTS))

	self._event_delegate = event_delegate
	self._peer_to_channel = {}
	self._channel_to_peer = {}
	self._session_client = nil
	self._session_host = nil
	self._joined_peers_cache = {}
	self._delayed_peer_disconnects = {}
	self._connected_to_host = false
end

GameSessionManager.destroy = function (self)
	local event_delegate = self._event_delegate

	event_delegate:unregister_events(unpack(NETWORK_EVENTS))

	self._event_delegate = nil

	self:disconnect()

	if self._engine_game_session then
		Network.shutdown_game_session()

		self._engine_game_session = nil
	end
end

GameSessionManager.peer_to_channel = function (self, peer_id)
	return self._peer_to_channel[peer_id]
end

GameSessionManager.channel_to_peer = function (self, channel_id)
	return self._channel_to_peer[channel_id]
end

GameSessionManager.connected_to_host = function (self)
	return self._connected_to_host
end

GameSessionManager.connected_to_client = function (self, peer_id)
	return self._joined_peers_cache[peer_id] == true
end

GameSessionManager.joined_peers = function (self)
	return self._joined_peers_cache
end

GameSessionManager.is_host = function (self)
	return self._session_host and true or false
end

GameSessionManager.is_client = function (self)
	return self._session_client and true or false
end

GameSessionManager.host = function (self)
	if self._session_host then
		return Network.peer_id()
	end

	if self._session_client then
		return self._session_client:host()
	end
end

GameSessionManager.num_clients = function (self)
	local session_host = self._session_host

	return session_host and session_host:num_clients() or 0
end

GameSessionManager.disconnect = function (self)
	if self._session_host then
		for peer_id, _ in pairs(self._joined_peers_cache) do
			local engine_reason

			self:_client_left(self:peer_to_channel(peer_id), peer_id, "game_session_manager_disconnect", engine_reason)
		end

		self._session_host:delete()

		self._session_host = nil
	end

	if self._session_client then
		for peer_id, _ in pairs(self._joined_peers_cache) do
			local engine_reason

			self:_member_left(self:peer_to_channel(peer_id), peer_id, "game_session_manager_disconnect", engine_reason)
		end

		self._session_client:delete()

		self._session_client = nil
	end

	table.clear(self._peer_to_channel)
	table.clear(self._channel_to_peer)
	table.clear(self._joined_peers_cache)
	table.clear(self._delayed_peer_disconnects)
end

GameSessionManager.delayed_disconnects = function (self, result)
	table.clear(result)

	for peer_id, time in pairs(self._delayed_peer_disconnects) do
		if time >= GameSessionManager.DELAYED_DISCONNECT_TIME then
			result[#result + 1] = peer_id
		end
	end

	for _, peer_id in ipairs(result) do
		self._delayed_peer_disconnects[peer_id] = nil
	end
end

GameSessionManager.set_session_client = function (self, session_client)
	self:disconnect()

	self._is_server = false
	self._session_client = session_client
end

GameSessionManager.set_session_host = function (self, session_host)
	self:disconnect()

	self._is_server = true
	self._session_host = session_host
	self._joined_peers_cache[Network.peer_id()] = true
end

GameSessionManager.leave = function (self)
	self._session_client:leave()
end

GameSessionManager.update = function (self, dt)
	if self._session_host then
		self:_update_host(dt)
	end

	if self._session_client then
		self:_update_client(dt)
	end

	self:_update_delayed_disconnects(dt)

	return self._session_disconnected
end

GameSessionManager.game_session = function (self)
	return self._engine_game_session
end

GameSessionManager.can_send_session_bound_rpcs = function (self)
	if self._engine_game_session then
		return GameSession.in_session(self._engine_game_session)
	else
		return false
	end
end

GameSessionManager.is_server = function (self)
	return self._is_server
end

GameSessionManager.add_peer = function (self, peer_id)
	self._session_host:add(peer_id, self)
end

GameSessionManager.remove_peer = function (self, peer_id)
	local session_host = self._session_host

	if not session_host:has_client(peer_id) then
		return
	end

	session_host:remove(peer_id)

	while true do
		local event, parameters = session_host:next_event_by_peer(peer_id)

		if event == nil then
			break
		end

		self:_handle_host_event(event, parameters)

		if not session_host:has_client(peer_id) then
			break
		end
	end
end

GameSessionManager.game_object_migrated_to_me = function (id, old_owner_id)
	Log.info("GameSessionManager", "successfully migrated %i from %s", id, old_owner_id)
end

GameSessionManager.game_object_created = function (self, game_object_id, owner_peer_id)
	local game_object_type = NetworkLookup.game_object_types[GameSession.game_object_field(self._engine_game_session, game_object_id, "game_object_type")]
	local unit_spawner = Managers.state.unit_spawner

	if unit_spawner:is_unit_template(game_object_type) then
		unit_spawner:spawn_husk_unit(game_object_id, owner_peer_id)
	end

	if game_object_type == "music_parameters" then
		local unit_game_object_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_game_object_id")
		local unit = unit_spawner:unit(unit_game_object_id)
		local music_parameter_extension = ScriptUnit.extension(unit, "music_parameter_system")

		music_parameter_extension:on_game_object_created(self._engine_game_session, game_object_id)
	elseif game_object_type == "scanning_device" then
		local level_unit_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "level_unit_id")
		local unit = unit_spawner:unit(level_unit_id, true)
		local scanning_event_extension = ScriptUnit.extension(unit, "scanning_event_system")

		scanning_event_extension:on_game_object_created(game_object_id)
	elseif game_object_type == "prop_health" then
		local is_level_unit = GameSession.game_object_field(self._engine_game_session, game_object_id, "is_level_unit")
		local unit_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_id")
		local unit = unit_spawner:unit(unit_id, is_level_unit)
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:on_game_object_created(self._engine_game_session, game_object_id)
	elseif game_object_type == "materials_collected" then
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:on_game_object_created(game_object_id)
	elseif game_object_type == "server_unit_data_state" then
		local unit_game_object_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_game_object_id")
		local unit = unit_spawner:unit(unit_game_object_id)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)

		if player and not player.remote then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

			unit_data_extension:on_server_data_state_game_object_created(self._engine_game_session, game_object_id)
		end
	elseif game_object_type == "unit_template" then
		local unit = unit_spawner:unit(game_object_id)
		local minigame_extension = ScriptUnit.has_extension(unit, "minigame_system")

		if minigame_extension then
			minigame_extension:on_game_object_created(game_object_id)
		end
	elseif game_object_type == "server_husk_data_state" or game_object_type == "server_husk_hud_data_state" then
		local unit_game_object_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_game_object_id")
		local unit = unit_spawner:unit(unit_game_object_id)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		if game_object_type == "server_husk_data_state" then
			unit_data_extension:on_server_husk_data_state_game_object_created(game_object_id)
		elseif game_object_type == "server_husk_hud_data_state" then
			unit_data_extension:on_server_husk_hud_data_state_game_object_created(game_object_id)
		end
	end
end

GameSessionManager.game_object_destroyed = function (self, game_object_id, owner_peer_id)
	local game_object_type = NetworkLookup.game_object_types[GameSession.game_object_field(self._engine_game_session, game_object_id, "game_object_type")]
	local unit_spawner = Managers.state.unit_spawner

	if unit_spawner:is_unit_template(game_object_type) then
		unit_spawner:destroy_game_object_unit(game_object_id, owner_peer_id)
	end

	if game_object_type == "scanning_device" then
		local level_unit_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "level_unit_id")
		local scanning_device_unit

		if unit_spawner:valid_unit_id(level_unit_id, true) then
			scanning_device_unit = unit_spawner:unit(level_unit_id, true)
		end

		if scanning_device_unit then
			local scanning_device_extension = ScriptUnit.has_extension(scanning_device_unit, "scanning_event_system")

			if scanning_device_extension then
				scanning_device_extension:on_game_object_destroyed()
			end
		end
	elseif game_object_type == "prop_health" then
		local is_level_unit = GameSession.game_object_field(self._engine_game_session, game_object_id, "is_level_unit")
		local unit_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_id")
		local unit

		if unit_spawner:valid_unit_id(unit_id, is_level_unit) then
			unit = unit_spawner:unit(unit_id, is_level_unit)
		end

		if unit then
			local health_extension = ScriptUnit.has_extension(unit, "health_system")

			if health_extension then
				health_extension:on_game_object_destroyed(self._engine_game_session, game_object_id)
			end
		end
	elseif game_object_type == "music_parameters" then
		local unit_game_object_id = GameSession.game_object_field(self._engine_game_session, game_object_id, "unit_game_object_id")
		local unit = unit_spawner:unit(unit_game_object_id)
		local music_parameter_extension = ScriptUnit.extension(unit, "music_parameter_system")

		music_parameter_extension:on_game_object_destroyed(self._engine_game_session, game_object_id)
	end
end

GameSessionManager.game_session_disconnect = function (self)
	self._session_disconnected = true
end

GameSessionManager.game_session_disconnected = function (self)
	return self._session_disconnected
end

GameSessionManager.currently_lowest_reliable_send_buffer_size = function (self)
	local size = 32768
	local own_peer_id = self._peer_id

	for peer, _ in pairs(self._joined_peers_cache) do
		if peer ~= own_peer_id then
			local buffer_size = Network.reliable_send_buffer_left(peer)

			size = math.min(size, buffer_size)
		end
	end

	return size
end

GameSessionManager.send_rpc_clients = function (self, rpc_name, ...)
	local rpc = RPC[rpc_name]

	for peer, _ in pairs(self._joined_peers_cache) do
		if peer ~= self._peer_id then
			local channel = self:peer_to_channel(peer)

			rpc(channel, ...)
		end
	end
end

GameSessionManager.send_rpc_clients_except = function (self, rpc_name, except_channel_id, ...)
	local rpc = RPC[rpc_name]
	local except_peer = self:channel_to_peer(except_channel_id)

	for peer, _ in pairs(self._joined_peers_cache) do
		if peer ~= self._peer_id and peer ~= except_peer then
			local channel = self:peer_to_channel(peer)

			rpc(channel, ...)
		end
	end
end

GameSessionManager.send_rpc_client = function (self, rpc_name, peer, ...)
	local joined_peers_cache = self._joined_peers_cache
	local rpc = RPC[rpc_name]
	local channel = self:peer_to_channel(peer)

	rpc(channel, ...)
end

GameSessionManager.send_rpc_clients_list = function (self, rpc_name, client_list, ...)
	local rpc = RPC[rpc_name]
	local joined_peers_cache = self._joined_peers_cache

	for peer, _ in pairs(client_list) do
		if peer ~= self._peer_id then
			local channel = self:peer_to_channel(peer)

			rpc(channel, ...)
		end
	end
end

GameSessionManager.send_rpc_server = function (self, rpc_name, ...)
	local host_channel = self._session_client:host_channel()

	RPC[rpc_name](host_channel, ...)
end

GameSessionManager._update_host = function (self, dt)
	local session_host = self._session_host

	session_host:update(dt)

	while true do
		local event, parameters = session_host:next_event()

		if event == nil then
			break
		end

		self:_handle_host_event(event, parameters)
	end
end

GameSessionManager._handle_host_event = function (self, event, parameters)
	if event == "session_joined" then
		local peer_id = parameters.peer_id
		local channel_id = parameters.channel_id

		self:_client_joined(channel_id, peer_id)
	elseif event == "session_left" then
		local peer_id = parameters.peer_id
		local channel_id = parameters.channel_id

		self:_client_left(channel_id, peer_id, parameters.game_reason, parameters.engine_reason)
	end
end

GameSessionManager._update_client = function (self, dt)
	local session_client = self._session_client

	session_client:update(dt)

	while true do
		local event, parameters = session_client:next_event()

		if event == nil then
			break
		end

		if event == "session_joined" then
			local peer_id = parameters.peer_id
			local channel_id = parameters.channel_id

			self:_member_joined(channel_id, peer_id)
		elseif event == "session_left" then
			local peer_id = parameters.peer_id
			local channel_id = parameters.channel_id

			self:_member_left(channel_id, peer_id, parameters.game_reason, parameters.engine_reason)
		end
	end
end

GameSessionManager._client_joined = function (self, channel_id, peer_id)
	_info("Member %s joined", peer_id)

	self._channel_to_peer[channel_id] = peer_id
	self._peer_to_channel[peer_id] = channel_id
	self._delayed_peer_disconnects[peer_id] = nil
	self._joined_peers_cache[peer_id] = true

	self:_set_session_channel_on_player(channel_id, peer_id)

	local local_player_id = 1
	local player = Managers.player:player(peer_id, local_player_id)

	player:create_input_handler(self.fixed_time_step)
	Managers.state.unit_spawner:hot_join_sync(peer_id, channel_id)
	Managers.state.game_mode:hot_join_sync(peer_id, channel_id)
	Managers.state.extension:hot_join_sync(peer_id, channel_id)
	Managers.state.nav_mesh:hot_join_sync(peer_id, channel_id)
	Managers.state.network_story:hot_join_sync(peer_id, channel_id)
	Managers.state.networked_flow_state:hot_join_sync(peer_id, channel_id)
	Managers.state.mutator:hot_join_sync(peer_id, channel_id)
	Managers.state.cinematic:hot_join_sync(peer_id, channel_id)
	Managers.stats:hot_join_sync(peer_id, channel_id)
	RPC.rpc_is_fully_hot_join_synced(channel_id)
	Managers.event:trigger("host_game_session_manager_player_joined", peer_id, player)

	local player_spawner_system = Managers.state.extension:system("player_spawner_system")
	local wanted_spawn_point = player:wanted_spawn_point()

	player:set_wanted_spawn_point(nil)

	local position, rotation, parent, side_name = player_spawner_system:next_free_spawn_point(wanted_spawn_point)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local force_spawn = true
	local is_respawn = false

	player_unit_spawn_manager:spawn_player(player, position, rotation, parent, force_spawn, side_name, nil, "walking", is_respawn)
end

GameSessionManager._client_left = function (self, channel_id, peer_id, game_reason, engine_reason)
	local source = game_reason and "game" or "engine"
	local reason = game_reason or engine_reason

	_info("Member %s left with %s reason %s", peer_id, source, reason)

	self._joined_peers_cache[peer_id] = nil

	if engine_reason ~= "remote_disconnected" then
		self._delayed_peer_disconnects[peer_id] = 0
	end

	if peer_id == self._peer_id then
		return
	end

	if channel_id then
		self._channel_to_peer[channel_id] = nil
		self._peer_to_channel[peer_id] = nil
	end

	local players_at_peer = Managers.player:players_at_peer(peer_id)

	if players_at_peer then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local unit_spawner_manager = Managers.state.unit_spawner

		for local_player_id, player in pairs(players_at_peer) do
			local owned_units = player.owned_units
			local player_unit = player.player_unit

			for unit in pairs(owned_units) do
				if unit ~= player_unit then
					unit_spawner_manager:mark_for_deletion(unit)
				end
			end

			player_unit_spawn_manager:despawn_player(player)

			if player.input_handler then
				player:destroy_input_handler()
			end
		end
	end

	self:_set_session_channel_on_player(nil, peer_id)
	Managers.event:trigger("host_game_session_manager_player_left", peer_id)
end

GameSessionManager._session_joined = function (self, channel_id, peer_id)
	self:_set_session_channel_on_player(channel_id, peer_id)

	self._connected_to_host = true
end

GameSessionManager._session_left = function (self, peer_id)
	if peer_id ~= nil then
		self:_set_session_channel_on_player(nil, peer_id)
	end

	self._connected_to_host = false
	self._session_disconnected = true
end

GameSessionManager._member_joined = function (self, channel_id, peer_id)
	_info("Member %s joined", peer_id)

	local session_client = self._session_client

	if channel_id then
		self._channel_to_peer[channel_id] = peer_id
		self._peer_to_channel[peer_id] = channel_id
	end

	if peer_id == session_client:host() then
		self._delayed_peer_disconnects[peer_id] = nil

		self:_session_joined(channel_id, peer_id)
	end

	self._joined_peers_cache[peer_id] = true
end

GameSessionManager._member_left = function (self, channel_id, peer_id, game_reason, engine_reason)
	if channel_id then
		local source = game_reason and "game" or "engine"
		local reason = game_reason or engine_reason

		_info("Member %s left with %s reason %s", peer_id, source, reason)
	else
		_info("Member %s left", peer_id)
	end

	local session_client = self._session_client

	if peer_id then
		self._joined_peers_cache[peer_id] = nil
	end

	if peer_id == nil or peer_id == session_client:host() then
		if peer_id then
			self._delayed_peer_disconnects[peer_id] = 0
		end

		self:_session_left(peer_id)
	end

	if channel_id then
		self._channel_to_peer[channel_id] = nil
		self._peer_to_channel[peer_id] = nil
	end
end

GameSessionManager._set_session_channel_on_player = function (self, channel_id, peer_id)
	local player_manager = Managers.player
	local players_at_peer = player_manager:players_at_peer(peer_id)

	if players_at_peer then
		for local_player_id, player in pairs(players_at_peer) do
			player:set_session_channel_id(channel_id)
		end
	end
end

GameSessionManager._update_delayed_disconnects = function (self, dt)
	for peer_id, time in pairs(self._delayed_peer_disconnects) do
		self._delayed_peer_disconnects[peer_id] = time + dt
	end
end

return GameSessionManager
