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
local BackendInterface = require("scripts/backend/backend_interface")
local ConnectionClient = require("scripts/multiplayer/connection/connection_client")
local SessionBootBase = require("scripts/multiplayer/session_boot_base")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local STATES = table.enum("idle", "fetchingserverdetails", "handshake", "searching", "joining", "ready", "failed")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES

local function _info(...)
	Log.info("PartyImmateriumMissionSessionBoot", ...)
end

local function _error(...)
	Log.info("PartyImmateriumMissionSessionBoot", ...)
end

local PartyImmateriumMissionSessionBoot = class("PartyImmateriumMissionSessionBoot", "SessionBootBase")

PartyImmateriumMissionSessionBoot.init = function (self, event_object, matched_game_session_id)
	PartyImmateriumMissionSessionBoot.super.init(self, STATES, event_object)

	self._matched_game_session_id = matched_game_session_id
	self._backend_interface = BackendInterface:new()

	self:_set_state(STATES.idle)
	self:_fetch_server_details()

	self._host_type = HOST_TYPES.mission_server
	self._network_hash = Managers.connection.combined_hash
	self._wan_client = Managers.connection:client()
	self._wan_lobby_browser = LanClient.create_lobby_browser(self._wan_client)
	self._server_details_promise = nil
end

PartyImmateriumMissionSessionBoot._fetch_server_details = function (self)
	self._server_details_promise = self._backend_interface.gameplay_session:fetch_server_details(self._matched_game_session_id)

	self._server_details_promise:next(function (response)
		self._server_details = response

		_info("Got server details: %s", table.tostring(self._server_details, 3))

		if not response.ticket then
			_error("Got empty ticket, meaning that we are not a part of this session. or some other error occured")
			self:_failed("empty_ticket")
		else
			self:_start_handshaking()
		end
	end):catch(function (error)
		if type(error) == "table" then
			error = error.message
		end

		_info("Failed fetching server info, error: %s", error)
		self:_failed("failed_fetching_server_details")
	end)
	self:_set_state(STATES.fetchingserverdetails)
end

PartyImmateriumMissionSessionBoot._start_handshaking = function (self, noAcceleratedConnection)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-16, warpins: 1 ---
	self._jwt_ticket = self._server_details.ticket
	local properties = self._server_details.serverDetails.properties
	local network_hash = properties.network_hash
	local host_type = properties.host_type
	local server_name = properties.instance_id
	local fast_server_ip = properties.fast_ip
	local fast_server_port = properties.fast_port
	local server_ip = properties.ip
	local server_port = properties.port
	local game_udp_cert = properties.game_udp_cert or Managers.connection:default_game_udp_cert()

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 22-23, warpins: 2 ---
	if not game_udp_cert then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 24-28, warpins: 1 ---
		self:_failed("missing_cert")

		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 29-31, warpins: 2 ---
	if properties.dedicated_type ~= "remote-dev" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 32-34, warpins: 1 ---
		if network_hash ~= self._network_hash then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 35-46, warpins: 1 ---
			_info("network hash mismatch %s ~= %s", network_hash, self._network_hash, server_name)
			self:_failed("server_mismatch")

			return
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 47-49, warpins: 1 ---
			if host_type ~= self._host_type then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 50-60, warpins: 1 ---
				_info("host_type mismatch %s ~= %s", host_type, self._host_type, server_name)
				self:_failed("server_mismatch")

				return
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 61-63, warpins: 4 ---
	self._server_name = server_name

	if fast_server_ip and fast_server_port and not noAcceleratedConnection and not GameParameters.wan_disable_accelerated_endpoint then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 72-81, warpins: 1 ---
		_info("Searching for WAN lobby on %s:%s", fast_server_ip, fast_server_port)

		self._accelerated = true
		self._server_ip = fast_server_ip
		self._server_port = fast_server_port
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 82-90, warpins: 4 ---
		_info("Searching for WAN lobby on %s:%s", server_ip, server_port)

		self._accelerated = false
		self._server_ip = server_ip
		self._server_port = server_port
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 91-103, warpins: 2 ---
	self._wan_lobby_browser:start_client_handshake(self._server_ip, self._server_port, game_udp_cert)
	self:_set_state(STATES.handshake)

	return
	--- END OF BLOCK #4 ---



end

PartyImmateriumMissionSessionBoot._create_connection = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-24, warpins: 1 ---
	local event_delegate = Managers.connection:network_event_delegate()
	local network_hash = Managers.connection.combined_hash
	self._connection_client = ConnectionClient:new(event_delegate, self._engine_lobby, Network.leave_lan_lobby, network_hash, self._host_type, nil, self._jwt_ticket, self._matched_game_session_id, self._accelerated)

	return
	--- END OF BLOCK #0 ---



end

PartyImmateriumMissionSessionBoot._start_reserve = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-9, warpins: 1 ---
	self:_create_connection()
	self:_set_state(STATES.reserving)

	return
	--- END OF BLOCK #0 ---



end

PartyImmateriumMissionSessionBoot._failed = function (self, reason, optional_error_details)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-15, warpins: 1 ---
	local is_error = true

	self._event_object:failed_to_boot(is_error, "game", reason, optional_error_details)
	self:_set_state(STATES.failed)

	return
	--- END OF BLOCK #0 ---



end

PartyImmateriumMissionSessionBoot._fail_or_retry_non_accelerated = function (self, reason)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._accelerated then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-8, warpins: 1 ---
		self:_start_handshaking(true)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-12, warpins: 1 ---
		self:_failed(reason)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-13, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumMissionSessionBoot.update = function (self, dt)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local state = self._state
	local states = STATES
	local browser = self._wan_lobby_browser

	if state == states.handshake then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-13, warpins: 1 ---
		local status = browser:client_handshake_status(self._server_ip, self._server_port)

		if status == 1 then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 14-14, warpins: 1 ---
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 15-16, warpins: 1 ---
			if status == 2 then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 17-27, warpins: 1 ---
				browser:establish_connection_to_server(self._server_ip, self._server_port)
				self:_set_state(STATES.searching)
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 28-30, warpins: 1 ---
				local reason = "failed_handshake"

				if status == 3 then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 31-31, warpins: 1 ---
					reason = "failed_handshake_timeout"
					--- END OF BLOCK #0 ---



				end

				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 32-36, warpins: 2 ---
				self:_fail_or_retry_non_accelerated(reason)
				--- END OF BLOCK #1 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 37-39, warpins: 1 ---
		if state == states.searching then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 40-44, warpins: 1 ---
			if not browser:is_refreshing() then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 45-49, warpins: 1 ---
				if browser:num_lobbies() == 0 then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 50-57, warpins: 1 ---
					_info("Found no lobby, search finished.")
					self:_fail_or_retry_non_accelerated("failed_found_no_lobby")
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 58-75, warpins: 1 ---
					_info("Found lobby, joining...")

					local lobby_data = browser:lobby(1)
					self._engine_lobby = Network.join_lan_lobby(lobby_data.id)

					self:_set_state(STATES.joining)
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 76-78, warpins: 1 ---
			if state == states.joining then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 79-84, warpins: 1 ---
				local lobby_state = self._engine_lobby:state()

				if lobby_state == "failed" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 85-93, warpins: 1 ---
					_info("Failed to join server %s", self._server_name)
					self:_failed("failed_to_join_lobby")
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 94-95, warpins: 1 ---
					if lobby_state == "joined" then

						-- Decompilation error in this vicinity:
						--- BLOCK #0 96-105, warpins: 1 ---
						_info("Joined server %s", self._server_name)
						self:_create_connection()

						self._state = STATES.ready
						--- END OF BLOCK #0 ---



					end
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 106-112, warpins: 10 ---
	PartyImmateriumMissionSessionBoot.super.update(self, dt)

	return
	--- END OF BLOCK #1 ---



end

PartyImmateriumMissionSessionBoot.result = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	fassert(self._state == STATES.ready, "Tried to get result when not ready")
	self:_set_window_title("client %s", Network.peer_id())

	local connection_client = self._connection_client
	self._connection_client = nil
	self._engine_lobby = nil

	return connection_client
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-24, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PartyImmateriumMissionSessionBoot._clear = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._server_details_promise then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-9, warpins: 1 ---
		self._server_details_promise:cancel()

		self._server_details_promise = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-12, warpins: 2 ---
	if self._connection_client then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 13-18, warpins: 1 ---
		self._connection_client:delete()

		self._connection_client = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 19-21, warpins: 2 ---
	if self._wan_lobby_browser then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 22-28, warpins: 1 ---
		LanClient.destroy_lobby_browser(self._wan_client, self._wan_lobby_browser)

		self._wan_lobby_browser = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 29-31, warpins: 2 ---
	if self._engine_lobby then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 32-37, warpins: 1 ---
		Network.leave_lan_lobby(self._engine_lobby)

		self._engine_lobby = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 38-43, warpins: 2 ---
	self:_set_state(STATES.idle)

	return
	--- END OF BLOCK #4 ---



end

PartyImmateriumMissionSessionBoot.destroy = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	self:_clear()

	return
	--- END OF BLOCK #0 ---



end

implements(PartyImmateriumMissionSessionBoot, SessionBootBase.INTERFACE)

return PartyImmateriumMissionSessionBoot
