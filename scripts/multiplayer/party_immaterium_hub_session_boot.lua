local BackendInterface = require("scripts/backend/backend_interface")
local ConnectionClient = require("scripts/multiplayer/connection/connection_client")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local SessionBootBase = require("scripts/multiplayer/session_boot_base")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local STATES = table.enum("idle", "hotjoining", "fetchingserverdetails", "handshake", "searching", "joining", "ready", "failed")

local function _info(...)
	Log.info("PartyImmateriumHubSessionBoot", ...)
end

local PartyImmateriumHubSessionBoot = class("PartyImmateriumHubSessionBoot", "SessionBootBase")

PartyImmateriumHubSessionBoot.init = function (self, event_object, current_hub_session_id)
	PartyImmateriumHubSessionBoot.super.init(self, STATES, event_object)
	self:_set_state(STATES.idle)

	self._has_tried_hot_joining = false
	self._backend_interface = BackendInterface:new()
	self._host_type = HOST_TYPES.hub_server
	self._network_hash = Managers.connection.combined_hash
	self._wan_client = Managers.connection:client()
	self._wan_lobby_browser = LanClient.create_lobby_browser(self._wan_client)

	if current_hub_session_id and current_hub_session_id ~= "" then
		self._matched_hub_session_id = current_hub_session_id

		self:_fetch_server_details()
	else
		self:_start_hot_joining_party_hub_server()
	end

	self._server_details_promise = nil
end

PartyImmateriumHubSessionBoot._fetch_server_details = function (self)
	self._server_details_promise = self._backend_interface.hub_session:fetch_server_details(self._matched_hub_session_id)

	self._server_details_promise:next(function (response)
		if not response.ticket then
			_info("Got empty ticket, meaning that we are not a part of this session.")

			if self._has_tried_hot_joining then
				self:_failed("empty_ticket")
			else
				self:_start_hot_joining_party_hub_server()
			end
		else
			self._server_details = response

			_info("Got server details: %s", table.tostring(self._server_details, 3))
			self:_start_handshaking()
		end
	end):catch(function (error)
		if type(error) == "table" then
			error = table.tostring(error, 3)
		end

		_info("Failed fetching server info, error: %s", error)

		if self._has_tried_hot_joining then
			self:_failed("failed_fetching_server_details", error)
		else
			self:_start_hot_joining_party_hub_server()
		end
	end)
	self:_set_state(STATES.fetchingserverdetails)
end

PartyImmateriumHubSessionBoot._start_handshaking = function (self, noAcceleratedConnection)
	self._jwt_ticket = self._server_details.ticket
	local properties = self._server_details.serverDetails.properties
	local network_hash = properties.network_hash
	local host_type = properties.host_type
	local server_name = properties.server_name
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
			_info("network hash mismatch %s ~= %s for %s", network_hash, self._network_hash, server_name)
			self:_failed("server_mismatch")

			return
		elseif host_type ~= self._host_type then
			_info("host_type mismatch %s ~= %s for %s", host_type, self._host_type, server_name)
			self:_failed("server_mismatch")

			return
		end
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

PartyImmateriumHubSessionBoot._create_connection = function (self)
	local event_delegate = Managers.connection:network_event_delegate()
	local network_hash = Managers.connection.combined_hash
	self._connection_client = ConnectionClient:new(event_delegate, self._engine_lobby, Network.leave_lan_lobby, network_hash, self._host_type, nil, self._jwt_ticket, self._matched_game_session_id, self._accelerated)
end

PartyImmateriumHubSessionBoot._start_hot_joining_party_hub_server = function (self)
	self._has_tried_hot_joining = true

	self:_set_state(STATES.hotjoining)
	Managers.party_immaterium:hot_join_party_hub_server():next(function (response)
		self._matched_hub_session_id = response

		self:_fetch_server_details()
	end):catch(function (error)
		if error.error_details and error.error_details ~= "" then
			self:_failed(error.error_details)
		else
			self:_failed("hot_join_party_hub_failed")
		end

		_info("hot_join_party_hub_failed " .. table.tostring(error))
	end)
end

PartyImmateriumHubSessionBoot._failed = function (self, reason, optional_error_details)
	local is_error = true

	self._event_object:failed_to_boot(is_error, "game", reason, optional_error_details)
	self:_set_state(STATES.failed)
end

PartyImmateriumHubSessionBoot._fail_or_retry_non_accelerated = function (self, reason)
	if self._accelerated then
		self:_start_handshaking(true)
	else
		self:_failed(reason)
	end
end

PartyImmateriumHubSessionBoot.update = function (self, dt)
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
			_info("Failed to join server %s", self._server_name)
			self:_failed("failed_to_join_server")
		elseif lobby_state == "joined" then
			_info("Joined server %s", self._server_name)
			self:_create_connection()
			self:_set_state(STATES.ready)
		end
	end

	PartyImmateriumHubSessionBoot.super.update(self, dt)
end

PartyImmateriumHubSessionBoot.result = function (self)
	fassert(self._state == STATES.ready, "Tried to get result when not ready")
	self:_set_window_title("client %s", Network.peer_id())

	local connection_client = self._connection_client
	self._connection_client = nil
	self._engine_lobby = nil

	return connection_client
end

PartyImmateriumHubSessionBoot._clear = function (self)
	if self._server_details_promise then
		self._server_details_promise:cancel()

		self._server_details_promise = nil
	end

	if self._connection_client then
		self._connection_client:delete()

		self._connection_client = nil
	end

	if self._wan_lobby_browser then
		LanClient.destroy_lobby_browser(self._wan_client, self._wan_lobby_browser)

		self._wan_lobby_browser = nil
	end

	if self._engine_lobby then
		Network.leave_lan_lobby(self._engine_lobby)

		self._engine_lobby = nil
	end

	self:_set_state(STATES.idle)
end

PartyImmateriumHubSessionBoot.destroy = function (self)
	self:_clear()
end

implements(PartyImmateriumHubSessionBoot, SessionBootBase.INTERFACE)

return PartyImmateriumHubSessionBoot
