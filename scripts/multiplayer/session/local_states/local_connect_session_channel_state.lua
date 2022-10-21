local LocalConnectSessionChannelState = class("LocalConnectSessionChannelState")

LocalConnectSessionChannelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time_to_next_connect_attempt = 0
	self._attempts_left = 3
end

LocalConnectSessionChannelState.update = function (self, dt)
	local shared_state = self._shared_state

	if shared_state.channel_id then
		local state, reason = Network.channel_state(shared_state.channel_id)

		if state == "disconnected" then
			if self._attempts_left <= 0 then
				Log.info("LocalConnectSessionChannelState", "Denied a channel to %s after several attempts", shared_state.peer_id)

				return "denied", {
					engine_reason = reason
				}
			end

			shared_state.engine_lobby:close_channel(shared_state.channel_id)

			shared_state.channel_id = nil
			self._time_to_next_connect_attempt = 2
		elseif state == "connected" then
			return "approved"
		end
	else
		self._time_to_next_connect_attempt = self._time_to_next_connect_attempt - dt

		if self._time_to_next_connect_attempt < 0 then
			shared_state.channel_id = shared_state.engine_lobby:open_channel(shared_state.peer_id, "session")
			self._attempts_left = self._attempts_left - 1
		end
	end
end

return LocalConnectSessionChannelState
