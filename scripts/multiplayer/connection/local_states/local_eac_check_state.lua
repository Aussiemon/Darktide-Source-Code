local RPCS = {
	"rpc_request_eac_approval_reply"
}
local LocalEacCheckState = class("LocalEacCheckState")
local STATES = table.enum("start_eac_session", "wait_for_server_reply")

LocalEacCheckState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._host_responded = false
	self._host_response = false
	local has_eac = false

	if has_eac then
		self._state = STATES.start_eac_session
	else
		RPC.rpc_request_eac_approval(shared_state.channel_id)

		self._state = STATES.wait_for_server_reply
	end

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

	local channel_state, reason = Network.channel_state(shared_state.channel_id)

	if channel_state == "disconnected" then
		return "disconnected", {
			engine_reason = reason
		}
	end

	local state = self._state

	if state == STATES.start_eac_session then
		local user_id = Managers.eac_client:user_id()

		if user_id then
			Managers.eac_client:begin_session()
			RPC.rpc_request_eac_approval(shared_state.channel_id)

			self._state = STATES.wait_for_server_reply

			Log.info("LocalEacCheckState", "begin_session")
		else
			Log.info("LocalEacCheckState", "Waiting for EAC user_id")
		end
	elseif state == STATES.wait_for_server_reply and self._host_responded then
		Log.info("LocalEacCheckState", "Eac approved")

		return "eac approved"
	end
end

LocalEacCheckState.rpc_request_eac_approval_reply = function (self, channel_id, success)
	self._host_responded = true
	self._host_response = success
end

return LocalEacCheckState
