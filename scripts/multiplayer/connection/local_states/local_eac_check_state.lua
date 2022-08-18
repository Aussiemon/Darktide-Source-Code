local RPCS = {
	"rpc_request_eac_approval_reply"
}
local LocalEacCheckState = class("LocalEacCheckState")

LocalEacCheckState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._host_responded = false
	self._host_response = false

	if GameParameters.enable_EAC_feature then
		Managers.eac_client:begin_session()
	end

	RPC.rpc_request_eac_approval(shared_state.channel_id)
	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalEacCheckState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalEacCheckState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		if self._host_responded then
			Log.info("LocalEacCheckState", "Timeout waiting for EAC state")
		else
			Log.info("LocalEacCheckState", "Timeout waiting for rpc_request_eac_approval_reply")
		end

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		return "disconnected", {
			engine_reason = reason
		}
	end

	if not self._host_responded then
		return
	end

	return "eac approved"
end

LocalEacCheckState.rpc_request_eac_approval_reply = function (self, channel_id, success)
	self._host_responded = true
	self._host_response = success
end

return LocalEacCheckState
