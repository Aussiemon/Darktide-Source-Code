local RemoteAwaitConnectionBootedState = class("RemoteAwaitConnectionBootedState")
local RPCS = {
	"rpc_connection_booted"
}
local TIMEOUT = 60

RemoteAwaitConnectionBootedState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._client_ready = false

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
	Log.info("RemoteAwaitConnectionBootedState", "Waiting for client")
end

RemoteAwaitConnectionBootedState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteAwaitConnectionBootedState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteAwaitConnectionBootedState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._client_ready then
		Log.info("RemoteAwaitConnectionBootedState", "Client ready, proceeding to next state")
		RPC.rpc_connection_booted_reply(shared_state.channel_id)

		return "done"
	end

	self._time = self._time + dt

	if TIMEOUT < self._time then
		Log.info("RemoteAwaitConnectionBootedState", "Timeout waiting for rpc_connection_booted %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end
end

RemoteAwaitConnectionBootedState.rpc_connection_booted = function (self, channel_id)
	self._client_ready = true
end

return RemoteAwaitConnectionBootedState
