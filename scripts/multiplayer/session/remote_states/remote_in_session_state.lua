-- chunkname: @scripts/multiplayer/session/remote_states/remote_in_session_state.lua

local RemoteInSessionState = class("RemoteInSessionState")

RemoteInSessionState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

RemoteInSessionState.enter = function (self)
	local shared_state = self._shared_state

	shared_state.event_list[#shared_state.event_list + 1] = {
		name = "session_joined",
		parameters = {
			peer_id = shared_state.peer_id,
			channel_id = shared_state.channel_id
		}
	}
	shared_state.has_been_in_session = true
end

RemoteInSessionState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteInSessionState", "Session channel disconnected %s", shared_state.peer_id)

		return "disconnect", {
			engine_reason = reason
		}
	end
end

return RemoteInSessionState
