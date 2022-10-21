local RPCS = {
	"rpc_reserve_slots",
	"rpc_claim_slot"
}
local RemoteSlotReserveState = class("RemoteSlotReserveState")

RemoteSlotReserveState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._reserve_done = false
	self._reserve_success = false
	self._claim_done = false
	self._claim_success = false
	self._waiting_for_slot = false
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteSlotReserveState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteSlotReserveState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteSlotReserveState", "Timeout waiting for rpc_claim_slot or rpc_reserve_slots %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteSlotReserveState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._waiting_for_slot then
		local success, has_reservation = shared_state.slot_reserver:claim_slot(shared_state.peer_id, channel_id)

		if success or not has_reservation then
			shared_state.claimed_peer = shared_state.peer_id
			self._claim_done = true
			self._claim_success = success
			self._waiting_for_slot = false
		end
	end

	if self._reserve_done then
		RPC.rpc_reserve_slots_reply(channel_id, self._reserve_success)

		if self._reserve_success then
			return "reserved"
		else
			Log.info("RemoteSlotReserveState", "Reservation rejected %s", shared_state.peer_id)

			return "rejected", {
				game_reason = "reserve_rejected"
			}
		end
	end

	if self._claim_done then
		RPC.rpc_claim_slot_reply(channel_id, self._claim_success)

		if self._claim_success then
			return "claimed"
		else
			Log.info("RemoteSlotReserveState", "Slot claim rejected %s", shared_state.peer_id)

			return "rejected", {
				game_reason = "claim_rejected"
			}
		end
	end
end

RemoteSlotReserveState.rpc_reserve_slots = function (self, channel_id, peer_ids)
	local shared_state = self._shared_state
	local success = self._shared_state.slot_reserver:reserve_slots(shared_state.peer_id, peer_ids)

	if success then
		shared_state.reserved_peers = peer_ids
	end

	self._reserve_done = true
	self._reserve_success = success
end

RemoteSlotReserveState.rpc_claim_slot = function (self, channel_id)
	local shared_state = self._shared_state
	local peer_id = Network.peer_id(channel_id)
	local success, has_reservation = shared_state.slot_reserver:claim_slot(peer_id, channel_id)

	if not success and has_reservation then
		self._waiting_for_slot = true
	else
		if success then
			shared_state.claimed_peer = peer_id
		end

		self._claim_done = true
		self._claim_success = success
	end
end

return RemoteSlotReserveState
