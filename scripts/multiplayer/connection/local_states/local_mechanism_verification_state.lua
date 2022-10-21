local RPCS = {
	"rpc_check_mechanism_reply"
}
local LocalMechanismVerificationState = class("LocalMechanismVerificationState")

LocalMechanismVerificationState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._mechanism_matched = nil
	self._mismatch_reason = nil

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))

	local jwt_ticket = shared_state.jwt_ticket
	local chunk_size = 500
	local ticket_array = string.split_by_chunk(jwt_ticket, chunk_size)
	local ticket_array_size = #ticket_array

	Log.info("LocalMechanismVerificationState", "Sending JWT Ticket, total length %s split into %s chunks", string.len(jwt_ticket), #ticket_array)

	for i = 1, #ticket_array do
		local ticket_part = ticket_array[i]
		local is_last_part = i == ticket_array_size

		Log.info("LocalMechanismVerificationState", "Sending JWT Ticket part %s/%s, string length %s, is_last_part: %s", i, ticket_array_size, string.len(ticket_part), is_last_part)
		RPC.rpc_check_mechanism(shared_state.channel_id, ticket_part, is_last_part)
	end
end

LocalMechanismVerificationState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalMechanismVerificationState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("LocalMechanismVerificationState", "Timeout waiting for rpc_check_mechanism_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalMechanismVerificationState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._mechanism_matched ~= nil then
		if self._mechanism_matched == true then
			return "mechanism matched"
		else
			Log.info("LocalMechanismVerificationState", "Mechanism mismatched, reason: %s", self._mismatch_reason)

			return "mechanism mismatched", {
				game_reason = "mechanism_mismatched"
			}
		end
	end
end

LocalMechanismVerificationState.rpc_check_mechanism_reply = function (self, channel_id, mechanism_matched, mismatch_reason)
	self._mechanism_matched = mechanism_matched
	self._mismatch_reason = mismatch_reason
end

return LocalMechanismVerificationState
