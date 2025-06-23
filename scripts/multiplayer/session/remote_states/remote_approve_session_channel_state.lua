-- chunkname: @scripts/multiplayer/session/remote_states/remote_approve_session_channel_state.lua

local RemoteApproveSessionChannelState = class("RemoteApproveSessionChannelState")

RemoteApproveSessionChannelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
end

RemoteApproveSessionChannelState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if shared_state.channel_id then
		return "approved"
	end

	if self._time > shared_state.timeout then
		Log.info("RemoteApproveSessionChannelState", "Timeout waiting for channel request %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end
end

return RemoteApproveSessionChannelState
