-- chunkname: @scripts/multiplayer/session/local_states/local_request_join_session_state.lua

local LocalRequestJoinSessionState = class("LocalRequestJoinSessionState")

LocalRequestJoinSessionState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
end

LocalRequestJoinSessionState.enter = function (self)
	local shared_state = self._shared_state

	GameSession.join(shared_state.engine_gamesession, shared_state.channel_id)

	shared_state.has_joined_session = true

	RPC.rpc_request_join_game_session(shared_state.channel_id)
end

LocalRequestJoinSessionState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state ~= "connected" then
		Log.info("LocalRequestJoinSessionState", "Lost game session channel")

		return "lost_session", {
			engine_reason = reason,
		}
	end

	if GameSession.in_session(shared_state.engine_gamesession) then
		return "in_session"
	end

	if self._time > shared_state.timeout then
		Log.info("LocalRequestJoinSessionState", "Timeout while waiting for in_session")

		return "timeout", {
			game_reason = "timeout",
		}
	end
end

return LocalRequestJoinSessionState
