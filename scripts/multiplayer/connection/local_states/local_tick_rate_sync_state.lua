-- chunkname: @scripts/multiplayer/connection/local_states/local_tick_rate_sync_state.lua

local RPCS = {
	"rpc_sync_tick_rate",
}
local LocalTickRateSyncState = class("LocalTickRateSyncState")

LocalTickRateSyncState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._received_tick_rate = false

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
	RPC.rpc_ready_to_receive_tick_rate(shared_state.channel_id)
end

LocalTickRateSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalTickRateSyncState.update = function (self, dt)
	local shared_state = self._shared_state

	if self._received_tick_rate then
		return "tick_rate synced"
	end

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalTickRateSyncState", "Timeout waiting for rpc_sync_tick_rate")

		return "timeout", {
			game_reason = "timeout",
		}
	end
end

LocalTickRateSyncState.rpc_sync_tick_rate = function (self, channel_id, tick_rate)
	self._shared_state.tick_rate = tick_rate
	self._received_tick_rate = true
end

return LocalTickRateSyncState
