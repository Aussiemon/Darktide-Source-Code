local Promise = require("scripts/foundation/utilities/promise")
local PartyImmateriumConnection = class("PartyImmateriumConnection")

local function _info(...)
	Log.info("PartyImmateriumManager", ...)
end

local empty_object = {}

PartyImmateriumConnection.init = function (self, requested_party_id, compatibility_string, resolve_optional_ticket_promise_func)
	self._requested_party_id = requested_party_id
	self._compatibility_string = compatibility_string
	self._resolve_optional_ticket_promise_func = resolve_optional_ticket_promise_func
	self._started = false
	self._aborted = false
	self._party_operation = nil
	self._optional_matchmaking_ticket = nil
	self._join_promises = {}
	self._error = nil
	self._event_buffer = {}
	self._party = empty_object
	self._party_version = 0
	self._party_vote = empty_object
	self._party_vote_version = 0
	self._game_state = empty_object
	self._game_state_version = 0
end

PartyImmateriumConnection.destroy = function (self)
	return
end

PartyImmateriumConnection._internal_start = function (self, optional_matchmaking_ticket)
	assert(not self._party_operation, "operation already exists")

	if self._aborted then
		return
	end

	local promise, operation_id = Managers.grpc:join_party(self._party.party_id or self._requested_party_id, self._compatibility_string, optional_matchmaking_ticket)
	self._party_operation = operation_id

	promise:next(function ()
		self._party_operation = nil

		if self._aborted then
			return
		end

		return Managers.grpc:delay_with_jitter_and_backoff("party_stream"):next(function ()
			return self:_internal_start()
		end)
	end):catch(function (error)
		self._party_operation = nil

		if self._aborted then
			return
		end

		if Managers.grpc:should_retry(error) then
			return Managers.grpc:delay_with_jitter_and_backoff("party_stream"):next(function ()
				return self:_internal_start()
			end)
		else
			local session_id = self:_requires_mission_hot_join_ticket_error(error)

			if session_id then
				return self._resolve_optional_ticket_promise_func(session_id):next(function (ticket)
					return self:_internal_start(ticket)
				end):catch(function (error)
					self:_on_error(error)
				end)
			else
				self:_on_error(error)
			end
		end
	end)
end

PartyImmateriumConnection.abort = function (self)
	if not self._aborted then
		if self._party_operation then
			Managers.grpc:abort_operation(self._party_operation)
		end

		self:_on_error({
			aborted = true,
			error_details = "ABORTED"
		})
	end
end

PartyImmateriumConnection._on_error = function (self, error)
	self._aborted = true
	self._error = error

	if self._join_promises then
		for _, join_promise in ipairs(self._join_promises) do
			join_promise:reject(error)
		end

		self._join_promises = nil
	end
end

PartyImmateriumConnection.party = function (self)
	return self._party
end

PartyImmateriumConnection.party_vote = function (self)
	return self._party_vote
end

PartyImmateriumConnection.party_game_state = function (self)
	return self._game_state
end

PartyImmateriumConnection.event_buffer = function (self)
	return self._event_buffer
end

PartyImmateriumConnection.error = function (self)
	return self._error
end

PartyImmateriumConnection.reset_event_buffer = function (self)
	table.clear(self._event_buffer)
end

PartyImmateriumConnection.join_promise = function (self)
	if not self._join_promises then
		return Promise.resolved(self)
	end

	local promise = Promise:new()

	table.insert(self._join_promises, promise)

	return promise
end

PartyImmateriumConnection.start = function (self)
	assert(not self._started, "already started")

	if self._aborted then
		return Promise.rejected(self._error)
	end

	self._started = true

	self:_internal_start()
end

PartyImmateriumConnection.update = function (self, dt)
	if self._party_operation then
		local party_events = Managers.grpc:get_party_events(self._party_operation)

		if party_events then
			for i, event in ipairs(party_events) do
				self:_handle_party_event(event)
			end
		end
	end
end

PartyImmateriumConnection._requires_mission_hot_join_ticket_error = function (self, error)
	local prefix = "REQUIRES_MISSION_HOT_JOIN_TICKET:"

	if type(error) == "table" and error.error_details and string.starts_with(error.error_details, prefix) then
		return string.sub(error.error_details, string.len(prefix) + 1, string.len(error.error_details))
	end

	return nil
end

PartyImmateriumConnection._handle_party_event = function (self, event)
	Managers.grpc:reset_retry_count("party_stream")

	if event.event_type == "party_update" then
		self:_handle_party_update_event(event)
	elseif event.event_type == "party_vote_update" then
		self:_handle_party_vote_update_event(event)
	elseif event.event_type == "party_game_state_update" then
		self:_handle_party_game_state_update_event(event)
	else
		table.insert(self._event_buffer, event)
	end
end

PartyImmateriumConnection._handle_party_update_event = function (self, event)
	if event.version < self._party_version then
		return
	end

	self._party = event
	self._party_version = event.version

	if self._join_promises then
		for _, join_promise in ipairs(self._join_promises) do
			join_promise:resolve(self)
		end

		self._join_promises = nil
	end

	table.insert(self._event_buffer, event)
end

PartyImmateriumConnection._handle_party_vote_update_event = function (self, event)
	if event.version < self._party_vote_version then
		return
	end

	self._party_vote = event
	self._party_vote_version = event.version

	table.insert(self._event_buffer, event)
end

PartyImmateriumConnection._handle_party_game_state_update_event = function (self, event)
	if event.version < self._game_state_version then
		return
	end

	self._game_state = event
	self._game_state_version = event.version

	table.insert(self._event_buffer, event)
end

return PartyImmateriumConnection
