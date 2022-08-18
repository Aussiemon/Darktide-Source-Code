local RPCS = {
	"rpc_check_connected"
}
local RemoteStateSyncState = class("RemoteStateSyncState")

RemoteStateSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.peer_id) == "string", "Peer id required")

	self._shared_state = shared_state
	self._request_has_arrived = false

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteStateSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteStateSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteConnectedState", "Connection channel disconnected %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._request_has_arrived then
		Managers.mechanism:add_client(shared_state.channel_id)

		shared_state.is_state_synced = true

		return "state sync done"
	end
end

RemoteStateSyncState.rpc_check_connected = function (self, channel_id)
	self._request_has_arrived = true
end

return RemoteStateSyncState
