local RPCS = {
	"rpc_claim_slot"
}
local RemoteSlotClaimState = class("RemoteSlotClaimState")

RemoteSlotClaimState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._claim_done = false
	self._claim_success = false
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteSlotClaimState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteSlotClaimState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.reserve_timeout < self._time then
		Log.info("RemoteSlotClaimState", "Timeout waiting for rpc_claim_slot %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteSlotClaimState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._claim_done then
		RPC.rpc_claim_slot_reply(channel_id, self._claim_success)

		if self._claim_success then
			return "claimed"
		else
			Log.info("RemoteSlotClaimState", "Slot claim rejected %s", shared_state.peer_id)

			return "rejected", {
				game_reason = "claim_rejected"
			}
		end
	end
end

RemoteSlotClaimState.rpc_claim_slot = function (self, channel_id)
	local shared_state = self._shared_state
	local peer_id = Network.peer_id(channel_id)
	local success = shared_state.slot_reserver:claim_slot(peer_id, channel_id)

	if success then
		shared_state.claimed_peer = peer_id
	end

	self._claim_done = true
	self._claim_success = success
end

return RemoteSlotClaimState
