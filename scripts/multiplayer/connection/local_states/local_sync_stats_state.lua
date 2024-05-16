-- chunkname: @scripts/multiplayer/connection/local_states/local_sync_stats_state.lua

local LocalSyncStatsState = class("LocalSyncStatsState")
local RPCS = {
	"rpc_stat_version_mismatch",
	"rpc_stat_version_matched",
}

LocalSyncStatsState._is_ready = function (self, local_player_id)
	return Managers.stats:user_state(local_player_id) == Managers.stats.user_states.idle
end

LocalSyncStatsState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id

	network_event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))

	self._time = 0
	self._versions_match = false
	self._loading_accounts = {}

	local players_at_peer = Managers.player:players_at_peer(Network.peer_id())

	for _, player in pairs(players_at_peer) do
		local local_player_id = player:local_player_id()

		Managers.stats:clear_session_data(local_player_id)

		if self:_is_ready(local_player_id) then
			local version = Managers.stats:user_version(local_player_id)

			RPC.rpc_sync_stat_version(channel_id, local_player_id, version)
		else
			self._loading_accounts[local_player_id] = true
		end
	end
end

LocalSyncStatsState.destroy = function (self)
	local shared_state = self._shared_state
	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id

	network_event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
end

LocalSyncStatsState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalSyncStatsState", "Timeout waiting for stats to sync.")

		return "timeout", {
			game_reason = "timeout",
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalSyncStatsState", "Connection channel disconnected.")

		return "disconnected", {
			engine_reason = reason,
		}
	end

	local loading_accounts = self._loading_accounts

	for local_player_id, _ in pairs(loading_accounts) do
		if self:_is_ready(local_player_id) then
			local version = Managers.stats:user_version(local_player_id)

			RPC.rpc_sync_stat_version(shared_state.channel_id, local_player_id, version)

			loading_accounts[local_player_id] = nil
		end
	end

	if self._versions_match then
		return "stats synced"
	end
end

LocalSyncStatsState.rpc_stat_version_mismatch = function (self, _, local_player_id)
	Log.info("LocalSyncStatsState", "Stats version mismatched for %s.", local_player_id)
	Managers.stats:reload(local_player_id)

	self._loading_accounts[local_player_id] = true
end

LocalSyncStatsState.rpc_stat_version_matched = function (self, _)
	self._versions_match = true
end

return LocalSyncStatsState
