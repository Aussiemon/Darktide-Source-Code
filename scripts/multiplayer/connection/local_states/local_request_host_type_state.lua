-- chunkname: @scripts/multiplayer/connection/local_states/local_request_host_type_state.lua

local RPCS = {
	"rpc_request_host_type_reply",
}
local LocalRequestHostTypeState = class("LocalRequestHostTypeState")

LocalRequestHostTypeState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0

	RPC.rpc_request_host_type(shared_state.channel_id)
	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalRequestHostTypeState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalRequestHostTypeState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalRequestHostTypeState", "Timeout waiting for rpc_request_host_type_reply")

		return "timeout", {
			game_reason = "timeout",
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalRequestHostTypeState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason,
		}
	end

	if self._shared_state.is_dedicated ~= nil then
		return "host type reply"
	end
end

LocalRequestHostTypeState.rpc_request_host_type_reply = function (self, channel_id, is_dedicated, max_members)
	self._shared_state.is_dedicated = is_dedicated
	self._shared_state.max_members = max_members
end

return LocalRequestHostTypeState
