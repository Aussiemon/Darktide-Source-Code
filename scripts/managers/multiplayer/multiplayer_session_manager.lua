require("scripts/foundation/utilities/parameters/parameter_resolver")

local BreedLoader = require("scripts/loading/loaders/breed_loader")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local SingleplayerSessionBoot = require("scripts/multiplayer/singleplayer_session_boot")
local HudLoader = require("scripts/loading/loaders/hud_loader")
local LevelLoader = require("scripts/loading/loaders/level_loader")
local LoadingClient = require("scripts/loading/loading_client")
local LoadingHost = require("scripts/loading/loading_host")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local Missions = require("scripts/settings/mission/mission_templates")
local MultiplayerSession = require("scripts/managers/multiplayer/multiplayer_session")
local MultiplayerSessionDisconnectError = require("scripts/managers/error/errors/multiplayer_session_disconnect_error")
local MultiplayerSessionBootError = require("scripts/managers/error/errors/multiplayer_session_boot_error")
local MultiplayerSessionManagerTestify = GameParameters.testify and require("scripts/managers/multiplayer/multiplayer_session_manager_testify")
local NameGenerator = require("scripts/multiplayer/utilities/name_generator")
local PartyImmateriumMissionSessionBoot = require("scripts/multiplayer/party_immaterium_mission_session_boot")
local PartyImmateriumHubSessionBoot = require("scripts/multiplayer/party_immaterium_hub_session_boot")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local StateLoading = require("scripts/game_states/game/state_loading")
local ViewLoader = require("scripts/loading/loaders/view_loader")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local MultiplayerSessionManager = class("MultiplayerSessionManager")

local function _info(...)
	Log.info("MultiplayerSessionManager", ...)
end

MultiplayerSessionManager.init = function (self)
	self._session = nil
	self._session_boot = nil
	self._breed_loader = BreedLoader:new()
end

MultiplayerSessionManager.destroy = function (self)
	if self._session_boot then
		self._session_boot:delete()
	end

	self._breed_loader:delete()
end

MultiplayerSessionManager._rpc_ignore_slot_reservation = function (self, leave_reason)
	local rpc_sent = false
	local host_type = self:host_type()

	if host_type == HOST_TYPES.mission_server and (leave_reason == "leave_mission" or leave_reason == "leave_mission_stay_in_party") then
		local host_channel = Managers.connection:host_channel()

		if host_channel then
			for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do
				local account_id = player:account_id()

				if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID then
					RPC.rpc_ignore_disconnected_slot_reservation(host_channel, account_id)

					rpc_sent = true
				end
			end
		end
	end

	return rpc_sent
end

MultiplayerSessionManager.leave = function (self, reason)
	Log.info("MultiplayerSessionManager", "Leaving multiplayer session on next post update with reason %s ...", reason)

	self._leave_reason = reason

	if self:_rpc_ignore_slot_reservation(reason) then
		self._leave_delay = 2
	else
		self._leave_delay = 0
	end
end

MultiplayerSessionManager._leave = function (self, reason)
	Log.info("MultiplayerSessionManager", "Leaving multiplayer session now!")

	if self._session_boot then
		self._session_boot:delete()

		self._session_boot = nil
	end

	Managers.connection:shutdown_connections(reason)
end

MultiplayerSessionManager.reset = function (self, reason)
	Log.info("MultiplayerSessionManager", "Resetting multiplayer session with reason %s ...", reason)

	if self._session_boot then
		self._session_boot:delete()

		self._session_boot = nil
	end

	Managers.connection:shutdown_connections(reason)

	self._session = nil
end

MultiplayerSessionManager.boot_singleplayer_session = function (self)
	local new_session = MultiplayerSession:new()
	self._session_boot = SingleplayerSessionBoot:new(new_session)

	_info("Booting multiplayer session as host")

	return new_session
end

MultiplayerSessionManager.party_immaterium_hot_join_hub_server = function (self)
	self:clear_session_boot()

	local new_session = MultiplayerSession:new()
	self._session_boot = PartyImmateriumHubSessionBoot:new(new_session, Managers.party_immaterium:consume_matched_hub_server_session_id())

	return new_session
end

MultiplayerSessionManager.party_immaterium_join_server = function (self, matched_game_session_id, party_id)
	self:clear_session_boot()

	local new_session = MultiplayerSession:new()
	self._session_boot = PartyImmateriumMissionSessionBoot:new(new_session, matched_game_session_id, party_id)

	return new_session
end

MultiplayerSessionManager.is_booting_session = function (self)
	return self._session_boot ~= nil
end

MultiplayerSessionManager.clear_session_boot = function (self)
	if self._session_boot then
		_info("Clearing current session_boot")
		self._session_boot:delete()

		self._session_boot = nil
	end
end

MultiplayerSessionManager.is_ready = function (self)
	return self._session and not self._session_boot and Managers.package_synchronization:is_ready()
end

MultiplayerSessionManager.is_stranded = function (self)
	return not self._session and not self._session_boot
end

MultiplayerSessionManager.host_type = function (self)
	return self._session and self._session:host_type()
end

MultiplayerSessionManager.error_transition = function (self)
	return Managers.mechanism:wanted_transition()
end

MultiplayerSessionManager.start_singleplayer_session = function (self, mission_name, singeplay_type)
	self:boot_singleplayer_session()

	local mechanism_manager = Managers.mechanism
	local mission_settings = Missions[mission_name]
	local mechanism_name = mission_settings.mechanism_name

	mechanism_manager:change_mechanism(mechanism_name, {
		mission_name = mission_name,
		singleplay_type = singeplay_type
	})

	return mechanism_manager:wanted_transition()
end

MultiplayerSessionManager._find_available_immaterium_session = function (self)
	if Managers.party_immaterium:game_session_in_progress() then
		Managers.party_immaterium:join_game_session()

		return StateLoading, {}
	end

	self:party_immaterium_hot_join_hub_server()

	return StateLoading, {}
end

MultiplayerSessionManager.find_available_session = function (self)
	if GameParameters.prod_like_backend then
		return self:_find_available_immaterium_session()
	end
end

MultiplayerSessionManager._handle_session_error = function (self, session)
	local disconnection_info = session:disconnection_info()
	local is_error = disconnection_info.is_error

	if is_error and not DEDICATED_SERVER then
		self:_show_session_error(disconnection_info)
	else
		local source = disconnection_info.source
		local reason = disconnection_info.reason
		local session_was_booting = disconnection_info.session_was_booting

		_info("Left all sessions! is_error: %s, source: %s, reason: %s, session_was_booting: %s", is_error, source, reason, session_was_booting)
	end

	local params = {
		left_session_reason = disconnection_info.reason,
		session_was_booting = disconnection_info.session_was_booting
	}
	local session_errors = (self._session_errors or 0) + 1
	params.session_errors = session_errors

	Managers.mechanism:change_mechanism("left_session", params)

	self._session_errors = session_errors
end

MultiplayerSessionManager.update = function (self, dt)
	local current_session = self._session
	local session_boot = self._session_boot

	if current_session and current_session:is_dead() then
		self._session = nil

		if not session_boot then
			self:_handle_session_error(current_session)
		end
	end

	if session_boot then
		session_boot:update(dt)

		local boot_state = session_boot:state()

		if boot_state == "ready" then
			if Managers.state.game_session and not session_boot.leaving_game_session then
				session_boot.leaving_game_session = true

				Managers.mechanism:trigger_event("client_exit_gameplay")
			end

			if Managers.state.game_session then
				return
			end

			local connection_object = session_boot:result()
			local session_object = session_boot:event_object()

			session_boot:delete()

			self._session_boot = nil
			self._session_errors = nil
			local connection_class_name = connection_object.__class_name

			if connection_class_name == "ConnectionSingleplayer" then
				Managers.connection:set_connection_host(connection_object, session_object)

				self._session = session_object
				local loaders = {
					ViewLoader:new(),
					LevelLoader:new(),
					self._breed_loader,
					HudLoader:new()
				}
				local loading_host = LoadingHost:new(Managers.connection:network_event_delegate(), loaders, connection_class_name)

				Managers.loading:set_host(loading_host)
			elseif connection_class_name == "ConnectionHost" then
				Managers.connection:set_connection_host(connection_object, session_object)

				self._session = session_object
				local loaders = {
					ViewLoader:new(),
					LevelLoader:new(),
					self._breed_loader,
					HudLoader:new()
				}
				local loading_host = LoadingHost:new(Managers.connection:network_event_delegate(), loaders, connection_class_name)

				Managers.loading:set_host(loading_host)
			elseif connection_class_name == "ConnectionClient" then
				Managers.connection:set_connection_client(connection_object, session_object)

				self._session = session_object

				connection_object:boot_complete()

				if connection_object:has_reserved() then
					connection_object:ready_to_join()
				end

				local host_channel_id = Managers.connection:host_channel()
				local loaders = {
					ViewLoader:new(),
					LevelLoader:new(),
					self._breed_loader,
					HudLoader:new()
				}
				local loading_client = LoadingClient:new(Managers.connection:network_event_delegate(), host_channel_id, loaders)

				Managers.loading:set_client(loading_client)
			end
		elseif boot_state == "failed" then
			local session_object = session_boot:event_object()

			session_boot:delete()

			self._session_boot = nil
			local mode = GameParameters.multiplayer_mode

			if mode ~= "join" then
				if self._session then
					local disconnection_info = session_object:disconnection_info()
					local is_error = disconnection_info.is_error

					if is_error and not DEDICATED_SERVER then
						self:_show_session_error(disconnection_info)
					else
						local source = disconnection_info.source
						local reason = disconnection_info.reason

						_info("Failed booting new session while in another session. is_error: %s, source: %s, reason: %s", is_error, source, reason)
					end
				else
					self:_handle_session_error(session_object)
				end
			end
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MultiplayerSessionManagerTestify, self)
	end
end

MultiplayerSessionManager._show_session_error = function (self, disconnection_info)
	local source = disconnection_info.source
	local reason = disconnection_info.reason
	local error_details = disconnection_info.error_details
	local session_was_booting = disconnection_info.session_was_booting

	if session_was_booting then
		Managers.error:report_error(MultiplayerSessionBootError:new(source, reason, error_details))
	else
		Managers.error:report_error(MultiplayerSessionDisconnectError:new(source, reason, error_details))
	end
end

MultiplayerSessionManager.is_leaving = function (self)
	return not not self._leave_reason
end

MultiplayerSessionManager.post_update = function (self)
	if self._leave_reason then
		if self._leave_delay > 0 then
			self._leave_delay = self._leave_delay - 1
		else
			self:_leave(self._leave_reason)

			self._leave_reason = nil
			self._leave_delay = nil
		end
	end
end

MultiplayerSessionManager.aws_matchmaking = function (self)
	return true
end

MultiplayerSessionManager.use_hub_server = function (self)
	return self:aws_matchmaking()
end

return MultiplayerSessionManager
