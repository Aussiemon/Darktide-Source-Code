local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local PlayerManagerTestify = GameParameters.testify and require("scripts/foundation/managers/player/player_manager_testify")
local PlayerManagerFixedTestify = GameParameters.testify and require("scripts/foundation/managers/player/player_manager_fixed_testify")
local ProfileUtils = require("scripts/utilities/profile_utils")
local PlayerManager = class("PlayerManager")
PlayerManager.NO_ACCOUNT_ID = "no_account_id"
local CLIENT_RPCS = {}
PlayerManager.PLAYER_INTERFACE = {
	"type",
	"name",
	"destroy",
	"session_id",
	"peer_id",
	"local_player_id",
	"account_id",
	"character_id",
	"unique_id"
}

PlayerManager.init = function (self)
	self._unique_id_counter = 0
	self._is_server = false
	self._players = {}
	self._players_by_peer = {}
	self._num_players = 0
	self._num_human_players = 0
	self._human_players = {}
	self._bot_players = {}
	self._remove_functions = {}
	self._game_state = nil
	self._game_state_mapping = nil
	self._game_state_context = nil
	self._game_state_objects = {}
	self._init_on_game_state_enter_data = nil
	self._claimed_slots = {}
	self._session_id_counter = 0
	self._players_by_session_id = {}
	self._session_id_cache = {}
end

PlayerManager.set_network = function (self, is_server, network_event_delegate)
	self._is_server = is_server

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

PlayerManager.unset_network = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

PlayerManager.claim_slot = function (self)
	local claimed_slots = self._claimed_slots
	local i = 1

	while claimed_slots[i] do
		i = i + 1
	end

	claimed_slots[i] = true

	return i
end

PlayerManager.release_slot = function (self, slot)
	self._claimed_slots[slot] = nil
end

PlayerManager.debug_remote_human_player_index = function (self, player)
	local index = 0

	for unique_id, _player in pairs(self._human_players) do
		if _player.remote then
			index = index + 1

			if _player == player then
				return index
			end
		end
	end
end

PlayerManager._generate_session_id = function (self, account_id, character_id)
	if not account_id or not character_id then
		self._session_id_counter = self._session_id_counter + 1

		return self._session_id_counter
	end

	local cache_id = string.format("%s:%s", account_id, character_id)

	if not self._session_id_cache[cache_id] then
		self._session_id_counter = self._session_id_counter + 1
		self._session_id_cache[cache_id] = self._session_id_counter
	end

	return self._session_id_cache[cache_id]
end

PlayerManager.player_from_session_id = function (self, session_id)
	return self._players_by_session_id[session_id]
end

PlayerManager._generate_unique_id = function (self, peer_id, local_player_id)
	self._unique_id_counter = self._unique_id_counter + 1
	local id_counter = self._unique_id_counter

	return tostring(peer_id) .. ":" .. tostring(local_player_id) .. ":" .. tostring(id_counter)
end

PlayerManager.player_from_unique_id = function (self, unique_id)
	return self._players[unique_id]
end

PlayerManager.on_game_state_enter = function (self, game_state_class, mapping, context)
	assert(not self._game_state, "Trying to enter game state while already in game_state.")

	self._game_state = game_state_class
	self._game_state_mapping = mapping
	self._game_state_context = context

	for k, player in pairs(self._players) do
		self:_add_player_game_state(player, self._game_state_mapping, self._game_state_context)
	end
end

PlayerManager.init_time_slice_on_game_state_enter = function (self, game_state_class, mapping, context)
	local init_on_game_state_enter_data = {
		last_index = 0,
		ready = false,
		parameters = {}
	}
	init_on_game_state_enter_data.parameters.mapping = mapping
	init_on_game_state_enter_data.parameters.context = context
	local players = {}

	for _, player in pairs(self._players) do
		players[#players + 1] = player
	end

	init_on_game_state_enter_data.parameters.players = players
	self._game_state = game_state_class
	self._game_state_mapping = mapping
	self._game_state_context = context
	self._init_on_game_state_enter_data = init_on_game_state_enter_data
end

PlayerManager.update_time_slice_on_game_state_enter = function (self)
	local init_data = self._init_on_game_state_enter_data

	fassert(init_data, "[PlayerManager] Missing call to 'PlayerManager:init_time_slice_on_game_state_enter()'")

	local last_index = init_data.last_index
	local game_state_mapping = init_data.parameters.mapping
	local game_state_context = init_data.parameters.context
	local players = init_data.parameters.players
	local num_players = #players
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()

	Profiler.start("PlayerManager:update_time_slice_on_game_state_enter")

	for index = last_index + 1, num_players do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local player = players[index]

		self:_add_player_game_state(player, game_state_mapping, game_state_context)

		init_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if init_data.last_index == num_players then
		GameplayInitTimeSlice.set_finished(init_data)
	end

	Profiler.stop("PlayerManager:update_time_slice_on_game_state_enter")

	return init_data.ready
end

PlayerManager.on_game_state_exit = function (self, game_state_class)
	assert(self._game_state == game_state_class, "Trying to exit game state not already in. Was in %q, is in %q", self._game_state.__class_name, game_state_class.__class_name)

	self._game_state = nil
	self._game_state_mapping = nil
	self._game_state_context = nil

	for k, player in pairs(self._players) do
		self:_remove_player_game_state(player)
	end
end

PlayerManager.on_reload = function (self, refreshed_resources)
	for player, game_state_object in pairs(self._game_state_objects) do
		game_state_object:on_reload(refreshed_resources)
	end
end

PlayerManager._add_player_game_state = function (self, player, mapping, context)
	local class = mapping[player.__class_name]

	if class then
		self._game_state_objects[player] = class:new(player, context)
	end
end

PlayerManager.game_state_context = function (self)
	local game_state_context = self._game_state_context

	return game_state_context
end

PlayerManager._remove_player_game_state = function (self, player)
	local game_state_object = self._game_state_objects[player]

	if game_state_object then
		game_state_object:delete()

		self._game_state_objects[player] = nil
	end
end

PlayerManager.add_bot_player = function (self, player_class, channel_id, peer_id, local_player_id, profile, slot, ...)
	local player, unique_id = self:add_player(player_class, channel_id, peer_id, local_player_id, profile, slot, nil, ...)
	self._bot_players[unique_id] = player
	self._remove_functions[unique_id] = "_remove_bot_player"

	return player, unique_id
end

PlayerManager.add_human_player = function (self, player_class, channel_id, peer_id, local_player_id, profile, slot, account_id, ...)
	local player, unique_id = self:add_player(player_class, channel_id, peer_id, local_player_id, profile, slot, account_id, ...)
	self._num_human_players = self._num_human_players + 1
	self._human_players[unique_id] = player
	self._remove_functions[unique_id] = "_remove_human_player"

	return player, unique_id
end

PlayerManager.add_player = function (self, player_class, channel_id, peer_id, local_player_id, profile, slot, account_id, ...)
	local unique_id = self:_generate_unique_id(peer_id, local_player_id)

	fassert(not self._players[unique_id], "Trying to create player with unique id that already exists.")

	local character_id = profile and profile.character_id
	local session_id = self:_generate_session_id(account_id, character_id)
	local player = player_class:new(unique_id, session_id, channel_id, peer_id, local_player_id, profile, slot, account_id, ...)

	assert_interface(player, PlayerManager.PLAYER_INTERFACE)

	self._players[unique_id] = player
	self._num_players = self._num_players + 1
	local player_table = self._players_by_peer
	player_table[peer_id] = player_table[peer_id] or {}
	player_table[peer_id][local_player_id] = player
	self._players_by_session_id[session_id] = player

	if self._game_state then
		self:_add_player_game_state(player, self._game_state_mapping, self._game_state_context)
	end

	return player, unique_id
end

PlayerManager.player_exists = function (self, peer_id, local_player_id)
	local peer_table = self._players_by_peer[peer_id]

	return peer_table and peer_table[local_player_id or 1] or false
end

PlayerManager.remove_player_safe = function (self, peer_id, local_player_id)
	local player = self:player(peer_id, local_player_id)
end

PlayerManager.remove_player = function (self, peer_id, local_player_id)
	local player = self:player(peer_id, local_player_id)
	local unique_id = player:unique_id()
	local session_id = player:session_id()

	if self._game_state then
		for _, object in pairs(self._game_state_objects) do
			if object.on_player_removed then
				object:on_player_removed(player)
			end
		end

		self:_remove_player_game_state(player, self._game_state)
	end

	local remove_function = self._remove_functions[unique_id]

	if remove_function then
		self[remove_function](self, unique_id, peer_id, local_player_id)

		self._remove_functions[unique_id] = nil
	end

	self._players[unique_id] = nil
	self._players_by_session_id[session_id] = nil
	local peer_table = self._players_by_peer[peer_id]
	peer_table[local_player_id] = nil

	if table.is_empty(peer_table) then
		self._players_by_peer[peer_id] = nil
	end

	local slot = player:slot()

	self:release_slot(slot)

	self._num_players = self._num_players - 1
	local owned_units = player.owned_units

	player:delete()

	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if player_unit_spawn_manager then
		player_unit_spawn_manager:remove_owner(owned_units)
		player_unit_spawn_manager:clear_player_unit(unique_id)
	end
end

PlayerManager._remove_human_player = function (self, unique_id, peer_id, local_player_id)
	self._human_players[unique_id] = nil
	self._num_human_players = self._num_human_players - 1
end

PlayerManager._remove_bot_player = function (self, unique_id)
	self._bot_players[unique_id] = nil
end

PlayerManager.player = function (self, peer_id, local_player_id)
	fassert(peer_id and local_player_id, "Required peer id and local player id.")

	local player_table = self._players_by_peer[peer_id]

	if not player_table then
		return nil
	end

	return player_table[local_player_id]
end

PlayerManager.players_at_peer = function (self, peer_id)
	return self._players_by_peer[peer_id]
end

PlayerManager.players = function (self)
	return self._players
end

PlayerManager.bot_players = function (self)
	return self._bot_players
end

PlayerManager.human_players = function (self)
	return self._human_players
end

PlayerManager.human_player = function (self, unique_id)
	return self._human_players[unique_id]
end

PlayerManager.player_by_unit = function (self, player_unit)
	local human_players = self._human_players

	for _, player in pairs(human_players) do
		if player.player_unit == player_unit then
			return player
		end
	end

	local bot_players = self._bot_players

	for _, player in pairs(bot_players) do
		if player.player_unit == player_unit then
			return player
		end
	end

	return nil
end

PlayerManager.next_available_local_player_id = function (self, peer_id, start_index)
	local i = start_index or 2
	local player_table = self._players_by_peer[peer_id]

	if player_table then
		while player_table[i] do
			i = i + 1
		end
	end

	return i
end

PlayerManager.num_players = function (self)
	return self._num_players
end

PlayerManager.num_human_players = function (self)
	return self._num_human_players
end

PlayerManager.local_player = function (self, local_player_id)
	return self:player(Network.peer_id(), local_player_id)
end

PlayerManager.print_players = function (self)
	local players = self._players

	Log.info("PlayerManager", "players -----------------------------------------------------------")

	for unique_id, player in pairs(players) do
		Log.info("PlayerManager", "PLAYER id: %s, unit: %s", unique_id, tostring(player.player_unit))
	end

	Log.info("PlayerManager", " ")
end

PlayerManager.destroy = function (self)
	if self._game_state then
		ferror("Should've exited game state %q before destroying PlayerManager", self._game_state.__class_name)
	end

	for peer, local_players in pairs(self._players_by_peer) do
		for local_player_id, player in pairs(local_players) do
			self:remove_player(peer, local_player_id)
		end
	end
end

PlayerManager.state_pre_update = function (self, dt, t)
	for player, object in pairs(self._game_state_objects) do
		if object.pre_update then
			object:pre_update(dt, t)
		end
	end
end

PlayerManager.state_fixed_update = function (self, dt, t, frame)
	for player, object in pairs(self._game_state_objects) do
		if object.fixed_update then
			object:fixed_update(dt, t, frame)
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(PlayerManagerFixedTestify, self, t)
	end
end

PlayerManager.state_update = function (self, dt, t)
	for player, object in pairs(self._game_state_objects) do
		if object.update then
			object:update(dt, t)
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(PlayerManagerTestify, self)
	end
end

PlayerManager.state_post_update = function (self, dt, t)
	for player, object in pairs(self._game_state_objects) do
		if object.post_update then
			object:post_update(dt, t)
		end
	end
end

PlayerManager.state_render = function (self, dt, t)
	for player, object in pairs(self._game_state_objects) do
		if object.render then
			object:render(dt, t)
		end
	end
end

PlayerManager.state_initialize_client_fixed_frame = function (self, frame)
	for player, object in pairs(self._game_state_objects) do
		if object.initialize_client_fixed_frame then
			object:initialize_client_fixed_frame(frame)
		end
	end
end

PlayerManager.local_player_backend_profile = function (self)
	local local_players = nil

	if Managers.connection:is_initialized() then
		local_players = self:players_at_peer(Network.peer_id())
	end

	if not local_players then
		return nil
	end

	for id, player in pairs(local_players) do
		local account_id = player:account_id()
		local profile = player:profile()

		if account_id ~= PlayerManager.NO_ACCOUNT_ID and profile then
			return profile
		end
	end
end

PlayerManager.create_sync_data = function (self, peer_id, include_profile_chunks)
	local players = self._players_by_peer[peer_id]

	if not players then
		return {}
	end

	local profile_chunks_array = include_profile_chunks and {}
	local sync_data = {
		local_player_id_array = {},
		is_human_controlled_array = {},
		account_id_array = {},
		player_session_id_array = {},
		character_id_array = {},
		profile_chunks_array = profile_chunks_array,
		slot_array = {}
	}
	local i = 1

	for local_player_id, player in pairs(players) do
		local is_human_controlled = player:is_human_controlled()
		sync_data.local_player_id_array[i] = local_player_id
		sync_data.is_human_controlled_array[i] = is_human_controlled
		sync_data.account_id_array[i] = player:account_id()
		local profile = player:profile()
		sync_data.character_id_array[i] = player:character_id()

		if include_profile_chunks then
			local profile_json = ProfileUtils.pack_profile(profile)
			local profile_chunks = {}

			ProfileUtils.split_for_network(profile_json, profile_chunks)

			sync_data.profile_chunks_array[i] = profile_chunks
		end

		sync_data.player_session_id_array[i] = player:telemetry_game_session()
		sync_data.slot_array[i] = player:slot()
		i = i + 1
	end

	return sync_data
end

PlayerManager.create_players_from_sync_data = function (self, player_class, channel_id, peer_id, is_server, local_player_id_array, is_human_controlled_array, account_id_array, profile_chunks_array, player_session_id_array, slot_array)
	for i = 1, #local_player_id_array do
		local local_player_id = local_player_id_array[i]
		local is_human_controlled = is_human_controlled_array[i]
		local account_id = account_id_array[i]
		local profile_chunks = profile_chunks_array[i]
		local profile_json = ProfileUtils.combine_network_chunks(profile_chunks)
		local profile = ProfileUtils.unpack_profile(profile_json)
		local player_session_id = player_session_id_array[i]
		local slot = slot_array[i]

		if is_human_controlled then
			self:add_human_player(player_class, channel_id, peer_id, local_player_id, profile, slot, account_id, is_human_controlled, is_server, player_session_id)
		else
			self:add_bot_player(player_class, channel_id, peer_id, local_player_id, profile, slot, is_human_controlled, is_server)
		end
	end
end

return PlayerManager
