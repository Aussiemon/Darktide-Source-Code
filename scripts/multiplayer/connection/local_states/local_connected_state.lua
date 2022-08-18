local LocalConnectedState = class("LocalConnectedState")

LocalConnectedState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.event_list) == "table", "Event list required")

	self._shared_state = shared_state

	shared_state.event_list[#shared_state.event_list + 1] = function ()
		local channel_id = shared_state.channel_id

		RPC.rpc_client_entered_connected_state(channel_id)

		return {
			name = "connected",
			parameters = {
				peer_id = Network.peer_id(channel_id),
				channel_id = channel_id
			}
		}
	end

	self._host_peer = Network.peer_id(shared_state.channel_id)
end

LocalConnectedState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalConnectedState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end
end

return LocalConnectedState
