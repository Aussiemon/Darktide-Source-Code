local Promise = require("scripts/foundation/utilities/promise")
local GRPCManager = class("GRPCManager")

local function _info(...)
	Log.info("GRPCManager", ...)
end

local function _error(...)
	Log.error("GRPCManager", ...)
end

GRPCManager.init = function (self)
	self._retry_count = {}
	self._enabled = false
	self._async_promises = {}
	self._channel_state = gRPC.channel_state()
end

GRPCManager.connect_to_immaterium = function (self, immaterium_details)
	self._enabled = true

	_info("Connecting to grpc address %s", immaterium_details.address)
	gRPC.init(immaterium_details.address, immaterium_details.pemCerts)

	return self:ping_with_auth()
end

GRPCManager.should_retry = function (self, error)
	if error.error_code == 14 then
		return true
	end

	if error.error_code == 2 and error.error_message == "Stream removed" then
		return true
	end

	if error.error_code == 13 and error.error_message == "Received RST_STREAM with error code 2" then
		return true
	end

	return false
end

GRPCManager.reset_retry_count = function (self, id)
	self._retry_count[id] = nil
end

GRPCManager.delay_with_jitter_and_backoff = function (self, id)
	local count = self._retry_count[id]
	count = count or 0
	count = count + 1
	self._retry_count[id] = count
	local retry_in_sec = math.min(2^count * 0.1, 30)
	local jitter_margin = retry_in_sec * 0.3
	local jitter = math.random() * jitter_margin
	retry_in_sec = retry_in_sec + jitter

	_info("Will retry gRPC request id=%s in %s secs, count=%s jitter=%s", id, tostring(retry_in_sec), tostring(count), tostring(jitter))

	return Promise.delay(retry_in_sec)
end

GRPCManager.update = function (self, dt, t)
	if self._enabled then
		local channel_state = gRPC.channel_state()

		if self._channel_state ~= channel_state then
			_info("gRPC channel state changed to %s from %s", channel_state, self._channel_state)

			if channel_state == "TRANSIENT_FAILURE" then
				_info("Disconnected from Immaterium")
			end

			self._channel_state = channel_state
		end

		local operations = gRPC.update(dt)

		if operations then
			for id, response in pairs(operations) do
				local promise = self._async_promises[id]

				if promise then
					if response.ok then
						promise:resolve(response.response)
					else
						promise:reject(response.error)
					end

					self._async_promises[id] = nil
				else
					_info("warning, id=%s does not have a promise, response=%s", id, table.tostring(response, 3))
				end
			end
		end
	end
end

GRPCManager.is_connected = function (self)
	local state = gRPC.channel_state()

	return state == "READY"
end

GRPCManager.abort_operation = function (self, operation_id)
	local promise = Promise:new()
	local id = gRPC.abort_operation(operation_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.ping_with_auth = function (self)
	local promise = Promise:new()
	local id = gRPC.ping_with_auth()
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager._convert_presence_key_values = function (self, keyValues)
	local result = {}

	for key, value in pairs(keyValues) do
		table.insert(result, {
			key,
			value
		})
	end

	return result
end

GRPCManager.start_presence = function (self, keyValues)
	local promise = Promise:new()
	local id = gRPC.start_presence(unpack(self:_convert_presence_key_values(keyValues)))
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.update_presence = function (self, operation_id, keyValues)
	gRPC.update_presence(operation_id, unpack(self:_convert_presence_key_values(keyValues)))
end

GRPCManager.get_push_messages = function (self, presence_operation_id)
	if gRPC.get_push_messages then
		return gRPC.get_push_messages(presence_operation_id)
	end
end

GRPCManager.get_presence = function (self, ...)
	local promise = Promise:new()
	local id = gRPC.get_presence(...)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.get_presence_stream = function (self, platform, platform_user_id)
	local promise = Promise:new()
	local id = gRPC.get_presence_stream(platform, platform_user_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.get_latest_presence_from_stream = function (self, operation_id)
	local presence = gRPC.get_latest_presence_from_stream(operation_id)

	return presence
end

GRPCManager.get_batched_presence_stream = function (self)
	local promise = Promise:new()
	local id = gRPC.get_batched_presence_stream()
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.request_presence_from_batched_stream = function (self, operation_id, platform, platform_user_id)
	local request_id = gRPC.request_presence_from_batched_stream(operation_id, platform, platform_user_id)

	return request_id
end

GRPCManager.abort_presence_from_batched_stream = function (self, operation_id, request_id)
	gRPC.abort_presence_from_batched_stream(operation_id, request_id)
end

GRPCManager.get_latest_presence_from_batched_stream = function (self, operation_id, request_id)
	local presence = gRPC.get_latest_presence_from_batched_stream(operation_id, request_id)

	return presence
end

GRPCManager.get_party_events = function (self, party_operation_id)
	return gRPC.get_party_events(party_operation_id)
end

GRPCManager.debug_get_parties = function (self, compatibility)
	local promise = Promise:new()
	local id = gRPC.debug_get_parties(compatibility)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.join_party = function (self, party_id, context_account_id, invite_token, compatibility_string, optional_matchmaking_ticket)
	local promise = Promise:new()
	local id = gRPC.join_party(party_id, context_account_id, invite_token, compatibility_string, optional_matchmaking_ticket)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.create_empty_party = function (self, compatibility)
	local promise = Promise:new()
	local id = gRPC.create_empty_party(compatibility)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.invite_to_party = function (self, party_id, platform, platform_user_id)
	local promise = Promise:new()
	local id = gRPC.invite_to_party(party_id, platform, platform_user_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.get_party = function (self, party_id)
	local promise = Promise:new()
	local id = gRPC.get_party(party_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.cancel_invite_to_party = function (self, party_id, invite_token, answer_code)
	local promise = Promise:new()
	local id = gRPC.cancel_invite_to_party(party_id, invite_token, answer_code)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.answer_request_to_join = function (self, party_id, requester_account_id, answer_code)
	local promise = Promise:new()
	local id = gRPC.answer_request_to_join(party_id, requester_account_id, answer_code)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.hot_join_party_hub_server = function (self, matchmaking_ticket)
	local promise = Promise:new()
	local id = gRPC.hot_join_party_hub_server(matchmaking_ticket)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.latched_hub_server_matchmaking = function (self, matchmaking_ticket)
	local promise = Promise:new()
	local id = gRPC.latched_hub_server_matchmaking(matchmaking_ticket)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.leave_party = function (self, party_id)
	local promise = Promise:new()
	local id = gRPC.leave_party(party_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.party_broadcast = function (self, party_id, party_version, type_as_int, payload_as_string)
	local promise = Promise:new()
	local id = gRPC.party_broadcast(party_id, party_version, type_as_int, payload_as_string)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.start_party_vote = function (self, party_id, party_version, type, params, myParams)
	local promise = Promise:new()
	local id = gRPC.start_party_vote(party_id, party_version, type, params, myParams)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.answer_party_vote = function (self, vote_id, party_id, yes, myParams)
	local promise = Promise:new()
	local id = gRPC.answer_party_vote(vote_id, party_id, yes, myParams)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.create_single_player_game = function (self, party_id, ticket)
	local promise = Promise:new()
	local id = gRPC.create_single_player_game(party_id, ticket)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.cancel_matchmaking = function (self, party_id)
	local promise = Promise:new()
	local id = gRPC.cancel_matchmaking(party_id)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.request_vivox_token = function (self, party_id, type)
	local promise = Promise:new()
	local id = gRPC.request_vivox_token(party_id, type)
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.allocate_party_id = function (self)
	local promise = Promise:new()
	local id = gRPC.allocate_party_id()
	self._async_promises[id] = promise

	return promise, id
end

GRPCManager.start_stay_in_party_vote = function (self)
	return self:allocate_party_id():next(function (response)
		Log.info("Allocated new party_id %s", response.allocated_party_id)

		return Managers.voting:start_voting("stay_in_party", {
			allocated_party_id = response.allocated_party_id
		})
	end)
end

return GRPCManager
