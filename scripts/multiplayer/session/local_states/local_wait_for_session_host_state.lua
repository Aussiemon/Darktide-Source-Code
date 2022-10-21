local LocalWaitForSessionHostState = class("LocalWaitForSessionHostState")

LocalWaitForSessionHostState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
end

LocalWaitForSessionHostState.update = function (self, dt)
	local shared_state = self._shared_state
	local host = shared_state.engine_lobby:game_session_host()

	if host then
		shared_state.peer_id = host

		return "game_session_host_set"
	end

	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("LocalWaitForSessionHostState", "Timeout waiting for game session host")

		return "timeout", {
			game_reason = "timeout"
		}
	end
end

return LocalWaitForSessionHostState
