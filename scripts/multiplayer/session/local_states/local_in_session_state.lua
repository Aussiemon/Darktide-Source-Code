local LocalInSessionState = class("LocalInSessionState")

LocalInSessionState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_list) == "table", "Event list required")
	assert(shared_state.engine_gamesession, "Game session required")
	assert(type(shared_state.channel_id) == "number", "Channel ID required")
	assert(type(shared_state.peer_id) == "string", "Peer ID required")

	self._shared_state = shared_state
end

LocalInSessionState.enter = function (self)
	local shared_state = self._shared_state
	shared_state.event_list[#shared_state.event_list + 1] = {
		name = "session_joined",
		parameters = {
			peer_id = shared_state.peer_id,
			channel_id = shared_state.channel_id
		}
	}
end

LocalInSessionState.update = function (self, dt)
	local shared_state = self._shared_state

	if not GameSession.in_session(shared_state.engine_gamesession) or Network.channel_state(shared_state.channel_id) ~= "connected" then
		Log.info("LocalInSessionState", "Lost game session")

		return "lost_session", {
			game_reason = "lost_session"
		}
	end
end

return LocalInSessionState
