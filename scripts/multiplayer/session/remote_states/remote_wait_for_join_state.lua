local RemoteWaitForJoinState = class("RemoteWaitForJoinState")
local RPCS = {
	"rpc_request_join_game_session"
}

RemoteWaitForJoinState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	shared_state.network_delegate:register_session_channel_events(self, shared_state.channel_id, unpack(RPCS))

	self._got_request = false
	self._time = 0
end

RemoteWaitForJoinState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteWaitForJoinState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if self._got_request then
		GameSession.add_peer(shared_state.engine_gamesession, shared_state.channel_id)

		shared_state.peer_added_to_session = true

		return "join_requested"
	end

	if shared_state.timeout < self._time then
		Log.info("RemoteWaitForJoinState", "Timeout waiting for rpc_request_join_game_session %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteWaitForJoinState", "Session channel disconnected %s", shared_state.peer_id)

		return "disconnect", {
			engine_reason = reason
		}
	end
end

RemoteWaitForJoinState.rpc_request_join_game_session = function (self, channel_id)
	self._got_request = true
end

return RemoteWaitForJoinState
