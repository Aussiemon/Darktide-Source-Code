-- chunkname: @scripts/multiplayer/connection/local_states/local_slot_claim_state.lua

local RPCS = {
	"rpc_claim_slot_reply"
}
local LocalSlotClaimState = class("LocalSlotClaimState")

LocalSlotClaimState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._claim_done = false
	self._claim_success = false

	RPC.rpc_claim_slot(shared_state.channel_id)
	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalSlotClaimState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalSlotClaimState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalSlotClaimState", "Timeout waiting for rpc_claim_slot_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalSlotClaimState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._claim_done then
		if self._claim_success then
			return "slot claimed"
		else
			Log.info("LocalSlotClaimState", "Slot claim rejected")

			return "slot rejected", {
				game_reason = "slot_rejected"
			}
		end
	end
end

LocalSlotClaimState.rpc_claim_slot_reply = function (self, channel_id, success)
	self._claim_done = true
	self._claim_success = success
end

return LocalSlotClaimState
