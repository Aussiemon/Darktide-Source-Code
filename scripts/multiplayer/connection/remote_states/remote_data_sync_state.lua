local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local RPCS = {
	"rpc_ready_to_receive_data"
}
local RemoteDataSyncState = class("RemoteDataSyncState")

RemoteDataSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")
	assert(type(shared_state.is_dedicated_server) == "boolean", "Dedicated server state required")
	assert(type(shared_state.host_type) == "string", "host_type required.")
	assert(type(shared_state.session_seed) == "number", "session_seed required.")

	self._shared_state = shared_state
	self._is_dedicated_server = shared_state.is_dedicated_server
	self._host_type = shared_state.host_type
	self._time = 0
	self._client_ready_to_sync_data = false
	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id

	network_event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
end

RemoteDataSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteDataSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteDataSyncState", "Timeout waiting for rpc_sync_local_profiles %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteDataSyncState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if not self._client_ready_to_sync_data then
		return
	end

	self:_send_data_to_client()

	if self._data_sync_done then
		RPC.rpc_data_sync_done(channel_id)

		return "data synced"
	end
end

RemoteDataSyncState._send_data_to_client = function (self)
	local shared_state = self._shared_state
	local session_seed = shared_state.session_seed
	local channel_id = shared_state.channel_id

	RPC.rpc_session_seed_sync(channel_id, session_seed)

	self._data_sync_done = true

	Log.info("RemoteDataSyncState", "session_seed sent %s", session_seed)
end

RemoteDataSyncState.rpc_ready_to_receive_data = function (self, channel_id)
	self._client_ready_to_sync_data = true
end

return RemoteDataSyncState
