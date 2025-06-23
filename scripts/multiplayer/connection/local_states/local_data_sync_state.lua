-- chunkname: @scripts/multiplayer/connection/local_states/local_data_sync_state.lua

local ProfileUtils = require("scripts/utilities/profile_utils")
local RPCS = {
	"rpc_session_seed_sync",
	"rpc_data_sync_done"
}
local LocalDataSyncState = class("LocalDataSyncState")

LocalDataSyncState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._data_sync_done = false

	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id

	network_event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
	RPC.rpc_ready_to_receive_data(channel_id)
end

LocalDataSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalDataSyncState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalDataSyncState", "Timeout waiting for rpc_data_sync_done")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalDataSyncState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._data_sync_done then
		return "data synced"
	end
end

LocalDataSyncState.rpc_data_sync_done = function (self, channel_id)
	self._data_sync_done = true
end

LocalDataSyncState.rpc_session_seed_sync = function (self, channel_id, session_seed)
	local shared_state = self._shared_state

	shared_state.session_seed = session_seed

	Log.info("LocalDataSyncState", "session_seed recieved %s", session_seed)
end

return LocalDataSyncState
