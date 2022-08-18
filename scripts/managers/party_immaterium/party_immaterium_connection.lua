-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
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

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if not self._aborted then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-6, warpins: 1 ---
		if self._party_operation then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 7-12, warpins: 1 ---
			Managers.grpc:abort_operation(self._party_operation)
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 13-16, warpins: 2 ---
		self:_on_error({
			aborted = true,
			error_details = "ABORTED"
		})
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 17-17, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection._on_error = function (self, error)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	self._aborted = true
	self._error = error

	if self._join_promises then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-10, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 11-16, warpins: 0 ---
		for _, join_promise in ipairs(self._join_promises) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 11-14, warpins: 1 ---
			join_promise:reject(error)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 15-16, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 17-18, warpins: 1 ---
		self._join_promises = nil
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 19-19, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection.party = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._party
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.party_vote = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._party_vote
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.party_game_state = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._game_state
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.event_buffer = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._event_buffer
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.error = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._error
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.reset_event_buffer = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	table.clear(self._event_buffer)

	return
	--- END OF BLOCK #0 ---



end

PartyImmateriumConnection.join_promise = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if not self._join_promises then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-7, warpins: 1 ---
		return Promise.resolved(self)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-17, warpins: 2 ---
	local promise = Promise:new()

	table.insert(self._join_promises, promise)

	return promise
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection.start = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	assert(not self._started, "already started")

	if self._aborted then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-12, warpins: 1 ---
		return Promise.rejected(self._error)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-18, warpins: 2 ---
	self._started = true

	self:_internal_start()

	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection.update = function (self, dt)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._party_operation then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-11, warpins: 1 ---
		local party_events = Managers.grpc:get_party_events(self._party_operation)

		if party_events then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 12-15, warpins: 1 ---
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 16-21, warpins: 0 ---
			for i, event in ipairs(party_events) do

				-- Decompilation error in this vicinity:
				--- BLOCK #0 16-19, warpins: 1 ---
				self:_handle_party_event(event)
				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 20-21, warpins: 2 ---
				--- END OF BLOCK #1 ---



			end
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 22-22, warpins: 3 ---
	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection._requires_mission_hot_join_ticket_error = function (self, error)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local prefix = "REQUIRES_MISSION_HOT_JOIN_TICKET:"

	if type(error) == "table" and error.error_details and string.starts_with(error.error_details, prefix) then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 17-29, warpins: 1 ---
		return string.sub(error.error_details, string.len(prefix) + 1, string.len(error.error_details))
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 30-31, warpins: 4 ---
	return nil
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection._handle_party_event = function (self, event)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-9, warpins: 1 ---
	Managers.grpc:reset_retry_count("party_stream")

	if event.event_type == "party_update" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 10-14, warpins: 1 ---
		self:_handle_party_update_event(event)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 15-17, warpins: 1 ---
		if event.event_type == "party_vote_update" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 18-22, warpins: 1 ---
			self:_handle_party_vote_update_event(event)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 23-25, warpins: 1 ---
			if event.event_type == "party_game_state_update" then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 26-30, warpins: 1 ---
				self:_handle_party_game_state_update_event(event)
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 31-35, warpins: 1 ---
				table.insert(self._event_buffer, event)
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 36-36, warpins: 4 ---
	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection._handle_party_update_event = function (self, event)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	if event.version < self._party_version then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-5, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-11, warpins: 2 ---
	self._party = event
	self._party_version = event.version

	if self._join_promises then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 12-15, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 16-21, warpins: 0 ---
		for _, join_promise in ipairs(self._join_promises) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 16-19, warpins: 1 ---
			join_promise:resolve(self)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 20-21, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 22-23, warpins: 1 ---
		self._join_promises = nil
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 24-29, warpins: 2 ---
	table.insert(self._event_buffer, event)

	return
	--- END OF BLOCK #2 ---



end

PartyImmateriumConnection._handle_party_vote_update_event = function (self, event)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	if event.version < self._party_vote_version then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-5, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-14, warpins: 2 ---
	self._party_vote = event
	self._party_vote_version = event.version

	table.insert(self._event_buffer, event)

	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumConnection._handle_party_game_state_update_event = function (self, event)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	if event.version < self._game_state_version then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-5, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-14, warpins: 2 ---
	self._game_state = event
	self._game_state_version = event.version

	table.insert(self._event_buffer, event)

	return
	--- END OF BLOCK #1 ---



end

return PartyImmateriumConnection
