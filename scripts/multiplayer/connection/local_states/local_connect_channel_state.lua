-- chunkname: @scripts/multiplayer/connection/local_states/local_connect_channel_state.lua

local LocalConnectChannelState = class("LocalConnectChannelState")

LocalConnectChannelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

LocalConnectChannelState.enter = function (self)
	local shared_state = self._shared_state
	local host_peer_id = shared_state.host_peer_id
	local approve_message = "connection"
	local channel_id = shared_state.engine_lobby:open_channel(host_peer_id, approve_message)

	shared_state.channel_id = channel_id
	shared_state.event_list[#shared_state.event_list + 1] = {
		name = "connecting",
		parameters = {
			peer_id = host_peer_id,
			channel_id = channel_id,
		},
	}
end

LocalConnectChannelState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnecting" or state == "disconnected" then
		Log.info("LocalConnectChannelState", "Denied connection channel")

		return "disconnected", {
			engine_reason = reason,
		}
	elseif state == "connected" then
		return "channel connected"
	end
end

return LocalConnectChannelState
