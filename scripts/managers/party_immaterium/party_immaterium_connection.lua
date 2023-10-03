local Promise = require("scripts/foundation/utilities/promise")
local PartyImmateriumConnection = class("PartyImmateriumConnection")

local function _info(...)
	Log.info("PartyImmateriumManager", ...)
end

local empty_object = {}

PartyImmateriumConnection.init = function (self, join_parameter, compatibility_string, resolve_optional_ticket_promise_func)
	self._requested_join_parameter = join_parameter
	self._compatibility_string = compatibility_string
	self._resolve_optional_ticket_promise_func = resolve_optional_ticket_promise_func
	self._started = false
	self._aborted = false
	self._optional_matchmaking_ticket = nil
	self._join_promises = {}
	self._error = nil
	self._event_buffer = {}
	self._party = empty_object
	self._party_version = 0
	self._party_vote = empty_object
	self._party_vote_version = 0
	self._game_state = empty_object
	self._game_state_version = -1
	self._invite_list = nil
	self._invite_list_version = 0
end

PartyImmateriumConnection.destroy = function (self)
	return
end

PartyImmateriumConnection._internal_start = function (self, optional_matchmaking_ticket)
	if self._aborted then
		return
	end

	local party_id = nil
	local context_account_id = ""
	local invite_token = ""
	local current_game_session_id = nil

	if self._party.party_id then
		party_id = self._party.party_id
		context_account_id = ""
		invite_token = ""
	else
		party_id = self._requested_join_parameter.party_id
		context_account_id = self._requested_join_parameter.context_account_id or ""
		invite_token = self._requested_join_parameter.invite_token or ""
		current_game_session_id = self._requested_join_parameter.current_game_session_id
	end

	self._stream = Managers.grpc:join_party(party_id, context_account_id, invite_token, self._compatibility_string, optional_matchmaking_ticket, current_game_session_id)
end

PartyImmateriumConnection.abort = function (self)
	if not self._aborted then
		if self._stream then
			self._stream:abort()

			self._stream = nil
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

PartyImmateriumConnection.party_invite_list = function (self)
	return self._invite_list
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
	if self._aborted then
		return Promise.rejected(self._error)
	end

	self._started = true

	self:_internal_start()
end

PartyImmateriumConnection.update = function (self, dt)
	if self._stream then
		if self._stream:alive() then
			local party_events = self._stream:get_stream_messages()

			if party_events then
				for i, event in ipairs(party_events) do
					self:_handle_party_event(event)
				end
			end
		else
			local error = self._stream:error()
			self._stream = nil

			if error then
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
			else
				Managers.grpc:delay_with_jitter_and_backoff("party_stream"):next(function ()
					return self:_internal_start()
				end)
			end
		end
	end
end

PartyImmateriumConnection._requires_mission_hot_join_ticket_error = function (self, error)
	local prefix = "REQUIRES_MISSION_HOT_JOIN_TICKET:"

	if type(error) == "table" and error.error_details and string.starts_with(error.error_details, prefix) then
		return string.sub(error.error_details, #prefix + 1, #error.error_details)
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
	elseif event.event_type == "party_invite_list_update" then
		self:_handle_party_invite_list_update_event(event)
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

PartyImmateriumConnection.have_recieved_game_state = function (self)
	return self._game_state_version > -1
end

PartyImmateriumConnection._handle_party_game_state_update_event = function (self, event)
	if event.version < self._game_state_version then
		return
	end

	self._game_state = event
	self._game_state_version = event.version

	table.insert(self._event_buffer, event)
end

PartyImmateriumConnection._handle_party_invite_list_update_event = function (self, event)
	if event.version < self._invite_list_version then
		return
	end

	self._invite_list = event
	self._invite_list_version = event.version

	table.insert(self._event_buffer, event)
end

return PartyImmateriumConnection
