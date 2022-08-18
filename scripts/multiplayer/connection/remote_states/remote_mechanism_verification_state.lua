local JwtTicketUtils = require("scripts/multiplayer/utilities/jwt_ticket_utils")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local RPCS = {
	"rpc_check_mechanism"
}
local RemoteMechanismVerificationState = class("RemoteMechanismVerificationState")

RemoteMechanismVerificationState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")
	assert(type(shared_state.is_dedicated_server) == "boolean", "Dedicated server state required")
	assert(type(shared_state.host_type) == "string", "host_type required.")

	self._shared_state = shared_state
	self._is_dedicated_server = shared_state.is_dedicated_server
	self._host_type = shared_state.host_type
	self._result = nil
	self._fail_reason = nil
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))

	self._jwt_ticket = ""
end

RemoteMechanismVerificationState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteMechanismVerificationState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteMechanismVerificationState", "Timeout waiting for rpc_check_mechanism %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteMechanismVerificationState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	local result = self._result

	if result ~= nil then
		if result == true then
			Log.info("RemoteMechanismVerificationState", "Verification success")
			RPC.rpc_check_mechanism_reply(channel_id, result)

			return "mechanism matched"
		else
			local fail_reason = self._fail_reason

			Log.info("RemoteMechanismVerificationState", "Verification failed, reason: %s", fail_reason)
			RPC.rpc_check_mechanism_reply(channel_id, result, fail_reason)

			return "mechanism mismatched", {
				game_reason = "mechanism_mismatched"
			}
		end
	end
end

RemoteMechanismVerificationState.rpc_check_mechanism = function (self, channel_id, jwt_ticket_part, is_last_part)
	if self._jwt_ticket_recieved then
		return self:_failed("JWT already received")
	end

	Log.info("RemoteMechanismVerificationState", "Recieved JWT Ticket part length: %s, is_last_part: %s, ", string.len(jwt_ticket_part), is_last_part)

	self._jwt_ticket = self._jwt_ticket .. jwt_ticket_part

	if is_last_part then
		Log.info("RemoteMechanismVerificationState", "Recieved JWT Ticket final part, total length: %s", string.len(self._jwt_ticket))

		self._jwt_ticket_recieved = true

		self:_check_mechanism(self._jwt_ticket)
	end
end

RemoteMechanismVerificationState._check_mechanism = function (self, jwt_ticket)
	local host_type = self._host_type

	assert(host_type == HOST_TYPES.mission_server or host_type == HOST_TYPES.hub_server, "invalid host type")

	local server_manager = Managers.hub_server or Managers.mission_server
	local is_valid, verified_jwt_header, verified_jwt_payload = JwtTicketUtils.verify_jwt_ticket(jwt_ticket, server_manager:jwt_sign_public_key())

	if not is_valid then
		return self:_failed("JWT ticket invalid")
	end

	Log.info("RemoteMechanismVerificationState", "Got valid JWT ticket from client with payload: %s", table.tostring(verified_jwt_payload, 3))

	local exp = verified_jwt_payload.exp
	local os_time = os.time()

	if not exp then
		return self:_failed("JWT ticket does not have exp claim")
	end

	if exp < os_time then
		return self:_failed("JWT ticket too old, current=%s > jwt.exp=%s", os_time, exp)
	end

	local server_instance_id = server_manager:instance_id()

	if server_instance_id ~= "NO_INSTANCE_ID" then
		local client_instance_id = verified_jwt_payload.instanceId

		if server_instance_id ~= client_instance_id then
			return self:_failed("instanceId mismatch (server: %s/client: %s)", server_instance_id, client_instance_id)
		end
	end

	if server_manager:session_completed() then
		return self:_failed("session_completed")
	end

	local server_session_id = server_manager:session_id()
	local client_session_id = verified_jwt_payload.sessionId
	local is_first_connecting_client = not server_session_id

	if is_first_connecting_client then
		if not client_session_id then
			return self:_failed("Server requires sesssion id from first connecting client")
		end

		if host_type == HOST_TYPES.mission_server then
			local client_mission_data = verified_jwt_payload.sessionSettings.missionJson

			if client_mission_data then
				server_manager:allocate_session(client_session_id, client_mission_data)
			else
				return self:_failed("Mission server requires mission data from first connecting client")
			end
		end
	elseif server_session_id == client_session_id or server_session_id == "NO_INSTANCE_ID" then
		if host_type == HOST_TYPES.mission_server then
			local client_mission_data = verified_jwt_payload.sessionSettings.missionJson

			if client_mission_data then
				local server_mission_id = server_manager:mission_id()
				local client_mission_id = client_mission_data.id

				if server_mission_id ~= client_mission_id then
					return self:_failed("wrong mission(server:%q/client%q)", server_mission_id, client_mission_id)
				end
			elseif Managers.multiplayer_session:aws_matchmaking() then
				return self:_failed("mission data required from connecting client")
			end
		end
	else
		return self:_failed("sessionId mismatch (server: %s/client: %s)", server_session_id, client_session_id)
	end

	self._result = true
end

RemoteMechanismVerificationState._failed = function (self, ...)
	self._result = false
	self._fail_reason = string.format(...)
end

return RemoteMechanismVerificationState
