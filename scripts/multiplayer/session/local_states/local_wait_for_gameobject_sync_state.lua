local RPCS = {
	"rpc_gameobject_sync_reply"
}
local LocalWaitForGameObjectSyncState = class("LocalWaitForGameObjectSyncState")

LocalWaitForGameObjectSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.network_delegate) == "table", "Network delegate required")
	assert(shared_state.engine_gamesession, "Game session required")
	assert(type(shared_state.channel_id) == "number", "Channel ID required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._got_rpc_reply = false

	shared_state.network_delegate:register_session_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalWaitForGameObjectSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalWaitForGameObjectSyncState.enter = function (self)
	local shared_state = self._shared_state

	RPC.rpc_gameobject_sync(shared_state.channel_id)
end

LocalWaitForGameObjectSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if Network.channel_state(shared_state.channel_id) ~= "connected" then
		Log.info("LocalWaitForGameObjectSyncState", "Lost game session")

		return "lost_session", {
			game_reason = "lost_session"
		}
	end

	if not GameSession.in_session(shared_state.engine_gamesession) then
		Log.info("LocalWaitForGameObjectSyncState", "Lost game session")

		return "lost_session", {
			game_reason = "lost_session"
		}
	end

	if self._got_rpc_reply then
		return "synchronized"
	end

	if shared_state.timeout < self._time then
		Log.info("LocalWaitForGameObjectSyncState", "Timeout waiting for game object sync")

		return "timeout", {
			game_reason = "timeout"
		}
	end
end

LocalWaitForGameObjectSyncState.rpc_gameobject_sync_reply = function (self, channel_id)
	self._got_rpc_reply = true
end

return LocalWaitForGameObjectSyncState
