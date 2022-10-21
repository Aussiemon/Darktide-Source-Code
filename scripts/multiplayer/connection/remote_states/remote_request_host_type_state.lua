local RPCS = {
	"rpc_request_host_type"
}
local RemoteRequestHostTypeState = class("RemoteRequestHostTypeState")

RemoteRequestHostTypeState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._got_request = false
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteRequestHostTypeState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteRequestHostTypeState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteRequestHostTypeState", "Timeout waiting for rpc_request_host_type %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteRequestHostTypeState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._got_request then
		RPC.rpc_request_host_type_reply(channel_id, shared_state.is_dedicated_server, shared_state.max_members)

		return "host type replied"
	end
end

RemoteRequestHostTypeState.rpc_request_host_type = function (self, channel_id)
	self._got_request = true
end

return RemoteRequestHostTypeState
