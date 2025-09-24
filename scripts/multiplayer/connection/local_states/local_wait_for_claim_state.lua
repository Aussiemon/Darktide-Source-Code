-- chunkname: @scripts/multiplayer/connection/local_states/local_wait_for_claim_state.lua

local LocalWaitForClaimState = class("LocalWaitForClaimState")

LocalWaitForClaimState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
end

LocalWaitForClaimState.update = function (self, dt)
	local shared_state = self._shared_state

	if shared_state.ready_to_claim_slots then
		return "ready to claim"
	end

	self._time = self._time + dt

	if self._time > shared_state.reserve_timeout then
		Log.info("LocalWaitForClaimState", "Timeout waiting for the game to get ready for claiming slots")

		return "timeout", {
			game_reason = "timeout",
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnecting" or state == "disconnected" then
		Log.info("LocalWaitForClaimState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason,
		}
	end
end

return LocalWaitForClaimState
