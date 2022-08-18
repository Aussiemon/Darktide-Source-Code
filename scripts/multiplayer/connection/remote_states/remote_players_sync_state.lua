local RPCS = {
	"rpc_sync_local_players"
}
local RemotePlayersSyncState = class("RemotePlayersSyncState")

RemotePlayersSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")
	assert(type(shared_state.is_dedicated_server) == "boolean", "Dedicated server state required")
	assert(type(shared_state.host_type) == "string", "host_type required.")

	self._shared_state = shared_state
	self._is_dedicated_server = shared_state.is_dedicated_server
	self._host_type = shared_state.host_type
	self._got_request = false
	self._finished_request = false
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemotePlayersSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemotePlayersSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemotePlayersSyncState", "Timeout waiting for rpc_sync_local_players %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemotePlayersSyncState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._send_reply then
		local player_sync_data = shared_state.player_sync_data

		RPC.rpc_sync_local_players_reply(shared_state.channel_id, player_sync_data.local_player_id_array, player_sync_data.slot_array)

		return "players synced"
	end
end

RemotePlayersSyncState.rpc_sync_local_players = function (self, channel_id, local_player_id_array, is_human_controlled_array, account_id_array, character_id_array, player_session_id_array)
	local peer_id = Network.peer_id(channel_id)
	local num_players = #local_player_id_array

	Log.info("RemotePlayersSyncState", "Received %s players from client %s", num_players, peer_id)

	local player_sync_data = self._shared_state.player_sync_data
	player_sync_data.local_player_id_array = local_player_id_array
	player_sync_data.is_human_controlled_array = is_human_controlled_array
	player_sync_data.account_id_array = account_id_array
	player_sync_data.character_id_array = character_id_array
	player_sync_data.player_session_id_array = player_session_id_array
	local slot_array = {}

	for i = 1, num_players, 1 do
		local slot = Managers.player:claim_slot()
		slot_array[i] = slot
	end

	player_sync_data.slot_array = slot_array
	self._shared_state.reserved_player_slots = slot_array
	self._send_reply = true
end

return RemotePlayersSyncState
