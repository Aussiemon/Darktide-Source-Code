-- chunkname: @scripts/multiplayer/party_immaterium_mission_session_boot.lua

local BackendInterface = require("scripts/backend/backend_interface")
local ConnectionClient = require("scripts/multiplayer/connection/connection_client")
local SessionBootBase = require("scripts/multiplayer/session_boot_base")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local JWTTicketUtils = require("scripts/multiplayer/utilities/jwt_ticket_utils")
local STATES = table.enum("idle", "fetchingserverdetails", "handshake", "searching", "joining", "ready", "failed")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES

local function _info(...)
	Log.info("PartyImmateriumMissionSessionBoot", ...)
end

local function _error(...)
	Log.info("PartyImmateriumMissionSessionBoot", ...)
end

local PartyImmateriumMissionSessionBoot = class("PartyImmateriumMissionSessionBoot", "SessionBootBase")

PartyImmateriumMissionSessionBoot.init = function (self, event_object, matched_game_session_id, party_id)
	PartyImmateriumMissionSessionBoot.super.init(self, STATES, event_object)

	self._matched_game_session_id = matched_game_session_id
	self._party_id = party_id
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

		if response.vivoxToken then
			self._event_object:set_vivox_backend_info(response.vivoxToken)
		end

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

	if not game_udp_cert then
		self:_failed("missing_cert")

		return
	end

	if properties.dedicated_type ~= "remote-dev" then
		if network_hash ~= self._network_hash then
			_info("network hash mismatch %s ~= %s", network_hash, self._network_hash, server_name)
			self:_failed("server_mismatch")

			return
		elseif host_type ~= self._host_type then
			_info("host_type mismatch %s ~= %s", host_type, self._host_type, server_name)
			self:_failed("server_mismatch")

			return
		end
	end

	local _, jwt_payload = JWTTicketUtils.decode_jwt_ticket(self._jwt_ticket)
	local mission_name = jwt_payload.sessionSettings.missionJson.map

	if not MissionTemplates[mission_name] then
		Managers.party_immaterium:leave_party()

		return self:_failed("mission_not_found", mission_name)
	end

	self._server_name = server_name

	if fast_server_ip and fast_server_port and not noAcceleratedConnection and not GameParameters.wan_disable_accelerated_endpoint then
		_info("Searching for WAN lobby on %s:%s", fast_server_ip, fast_server_port)

		self._accelerated = true
		self._server_ip = fast_server_ip
		self._server_port = fast_server_port
	else
		_info("Searching for WAN lobby on %s:%s", server_ip, server_port)

		self._accelerated = false
		self._server_ip = server_ip
		self._server_port = server_port
	end

	self._wan_lobby_browser:start_client_handshake(self._server_ip, self._server_port, game_udp_cert)
	self:_set_state(STATES.handshake)
end

PartyImmateriumMissionSessionBoot._create_connection = function (self)
	local event_delegate = Managers.connection:network_event_delegate()
	local network_hash = Managers.connection.combined_hash
	local client = self._wan_client
	local server_ip = self._server_ip
	local server_port = self._server_port

	local function cleanup(lobby)
		local browser = LanClient.create_lobby_browser(client)

		browser:disconnect(server_ip, server_port)
		LanClient.destroy_lobby_browser(client, browser)
		Network.leave_lan_lobby(lobby)
	end

	self._connection_client = ConnectionClient:new(event_delegate, self._engine_lobby, cleanup, network_hash, self._host_type, nil, self._jwt_ticket, self._matched_game_session_id, self._accelerated, self._party_id)
end

PartyImmateriumMissionSessionBoot._start_reserve = function (self)
	self:_create_connection()
	self:_set_state(STATES.reserving)
end

PartyImmateriumMissionSessionBoot._failed = function (self, reason, optional_error_details)
	local is_error = true

	self._event_object:failed_to_boot(is_error, "game", reason, optional_error_details)
	self:_set_state(STATES.failed)
end

PartyImmateriumMissionSessionBoot._fail_or_retry_non_accelerated = function (self, reason)
	if self._wan_lobby_browser and self._server_ip and self._server_port then
		self._wan_lobby_browser:disconnect(self._server_ip, self._server_port)
	end

	if self._accelerated then
		self:_start_handshaking(true)
	else
		self:_failed(reason)
	end
end

PartyImmateriumMissionSessionBoot.update = function (self, dt)
	local state = self._state
	local states = STATES
	local browser = self._wan_lobby_browser

	if state == states.handshake then
		local status = browser:client_handshake_status(self._server_ip, self._server_port)

		if status == 1 then
			-- Nothing
		elseif status == 2 then
			browser:establish_connection_to_server(self._server_ip, self._server_port)
			self:_set_state(STATES.searching)
		else
			local reason = "failed_handshake"

			if status == 3 then
				reason = "failed_handshake_timeout"
			end

			self:_fail_or_retry_non_accelerated(reason)
		end
	elseif state == states.searching then
		if not browser:is_refreshing() then
			if browser:num_lobbies() == 0 then
				_info("Found no lobby, search finished.")
				self:_fail_or_retry_non_accelerated("failed_found_no_lobby")
			else
				_info("Found lobby, joining...")

				local lobby_data = browser:lobby(1)

				self._engine_lobby = Network.join_lan_lobby(lobby_data.id)

				self:_set_state(STATES.joining)
			end
		end
	elseif state == states.joining then
		local lobby_state = self._engine_lobby:state()

		if lobby_state == "failed" then
			_info("Failed to join lobby")
			self:_failed("failed_joining_lobby")
		elseif lobby_state == "joined" then
			local host_peer_id = self._engine_lobby:lobby_host()

			if host_peer_id then
				_info("Joined lobby %s", host_peer_id)
				self:_create_connection()
				self:_set_state(STATES.ready)
				self._event_object:set_booted()
			else
				_info("Failed to join lobby due to missing host_peer_id")
				self:_failed("failed_joining_lobby_no_host_peer")
			end
		end
	end

	PartyImmateriumMissionSessionBoot.super.update(self, dt)
end

PartyImmateriumMissionSessionBoot.result = function (self)
	self:_set_window_title("client %s", Network.peer_id())

	local connection_client = self._connection_client

	self._connection_client = nil
	self._engine_lobby = nil

	return connection_client
end

PartyImmateriumMissionSessionBoot._clear = function (self)
	if self._server_details_promise then
		self._server_details_promise:cancel()

		self._server_details_promise = nil
	end

	if self._connection_client then
		self._connection_client:delete()

		self._connection_client = nil
		self._engine_lobby = nil
	elseif self._engine_lobby then
		Network.leave_lan_lobby(self._engine_lobby)

		self._engine_lobby = nil
	end

	if self._wan_lobby_browser then
		LanClient.destroy_lobby_browser(self._wan_client, self._wan_lobby_browser)

		self._wan_lobby_browser = nil
	end

	self:_set_state(STATES.idle)
end

PartyImmateriumMissionSessionBoot.destroy = function (self)
	self:_clear()
end

implements(PartyImmateriumMissionSessionBoot, SessionBootBase.INTERFACE)

return PartyImmateriumMissionSessionBoot
