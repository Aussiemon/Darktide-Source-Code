local BotPlayer = require("scripts/managers/player/bot_player")
local BotSynchronizerHost = class("BotSynchronizerHost")
local RPCS = {}
local SPAWN_STATES = table.enum("spawn", "syncing_profile")

BotSynchronizerHost.init = function (self, network_delegate)
	self._peer_id = Network.peer_id()
	self._network_delegate = network_delegate
	self._bots = {}
	self._connected_peers = {}
	self._bots_queued_for_removal = {}
	self._spawn_group = nil
end

BotSynchronizerHost.destroy = function (self)
	local connected_peers = self._connected_peers

	for channel_id, _ in pairs(connected_peers) do
		self._network_delegate:unregister_channel_events(channel_id, unpack(RPCS))
	end
end

BotSynchronizerHost.update = function (self)
	local bots = self._bots

	if table.is_empty(bots) then
		return
	end

	local spawn_group = self._spawn_group

	if not spawn_group then
		return
	end

	for local_player_id, spawn_item in pairs(spawn_group) do
		if spawn_item.state == SPAWN_STATES.spawn then
			local profile = spawn_item.profile
			local profile_synchronization_manager = Managers.profile_synchronization
			local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

			profile_synchronizer_host:add_bot(local_player_id, profile)

			local player_manager = Managers.player
			local viewport_name = "player" .. local_player_id
			local slot = Managers.player:claim_slot()
			local player = player_manager:add_bot_player(BotPlayer, nil, self._peer_id, local_player_id, profile, slot, viewport_name)

			Managers.telemetry_events:client_connected(player)

			spawn_item.state = SPAWN_STATES.syncing_profile
			local package_synchronization_manager = Managers.package_synchronization
			local package_synchronizer_host = package_synchronization_manager:synchronizer_host()

			package_synchronizer_host:add_bot(local_player_id)
		end
	end

	local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()
	local profiles_synced = profile_synchronizer_host:peer_profiles_synced(self._peer_id)

	if profiles_synced then
		for local_player_id, spawn_item in pairs(spawn_group) do
			if spawn_item.state == SPAWN_STATES.syncing_profile then
				local connected_peers = self._connected_peers

				for channel_id, _ in pairs(connected_peers) do
					local player = Managers.player:player(self._peer_id, local_player_id)
					local slot = player:slot()

					RPC.rpc_add_bot_player(channel_id, local_player_id, slot)
				end
			end
		end

		self._spawn_group = nil
	end
end

BotSynchronizerHost.add_bot = function (self, local_player_id, player_profile)
	local spawn_group = self._spawn_group or {}
	spawn_group[local_player_id] = {
		state = SPAWN_STATES.spawn,
		profile = player_profile
	}
	self._bots[local_player_id] = true
	self._spawn_group = spawn_group
end

BotSynchronizerHost.active_bot_ids = function (self)
	return self._bots
end

BotSynchronizerHost.remove_bot_safe = function (self, local_player_id)
	local player_manager = Managers.player
	local bot_player = player_manager:player(self._peer_id, local_player_id)
	local bot_unit = bot_player.player_unit

	if ALIVE[bot_unit] then
		Managers.state.unit_spawner:mark_for_deletion(bot_unit)
	end

	if ALIVE[bot_unit] then
		self._bots_queued_for_removal[#self._bots_queued_for_removal + 1] = local_player_id
	else
		self:remove_bot(local_player_id)
	end
end

BotSynchronizerHost.remove_bot = function (self, local_player_id)
	local player_manager = Managers.player
	local player = player_manager:player(self._peer_id, local_player_id)
	local spawn_group = self._spawn_group
	local spawn_item = spawn_group and spawn_group[local_player_id]
	local spawn_state = spawn_item and spawn_item.state

	if spawn_state == SPAWN_STATES.spawn then
		self._bots[local_player_id] = nil
		self._spawn_group[local_player_id] = nil

		return
	end

	Managers.telemetry_events:client_disconnected(player)

	local package_synchronization_manager = Managers.package_synchronization
	local package_synchronizer_host = package_synchronization_manager:synchronizer_host()

	package_synchronizer_host:remove_bot(local_player_id)
	player_manager:remove_player(self._peer_id, local_player_id)

	local connected_peers = self._connected_peers

	if spawn_state == SPAWN_STATES.syncing_profile then
		spawn_group[local_player_id] = nil
	else
		for channel_id, _ in pairs(connected_peers) do
			RPC.rpc_remove_bot_player(channel_id, local_player_id)
		end
	end

	self._bots[local_player_id] = nil
end

BotSynchronizerHost.handle_queued_bot_removals = function (self)
	local queued_bots = self._bots_queued_for_removal

	for i = 1, #queued_bots do
		self:remove_bot(queued_bots[i])

		queued_bots[i] = nil
	end
end

BotSynchronizerHost.spawn_group_contains = function (self, local_player_id)
	if not self._spawn_group then
		return false
	end

	return self._spawn_group[local_player_id]
end

BotSynchronizerHost.num_bots = function (self)
	return table.size(self._bots)
end

BotSynchronizerHost.add_peer = function (self, channel_id)
	self._connected_peers[channel_id] = true

	self._network_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
end

BotSynchronizerHost.remove_peer = function (self, channel_id)
	if self._connected_peers[channel_id] then
		self._connected_peers[channel_id] = nil

		self._network_delegate:unregister_channel_events(channel_id, unpack(RPCS))
	end
end

return BotSynchronizerHost
