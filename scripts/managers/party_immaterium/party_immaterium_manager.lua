-- chunkname: @scripts/managers/party_immaterium/party_immaterium_manager.lua

local CommonJoinPermission = require("scripts/managers/party_immaterium/join_permission/common_join_permission")
local ImmateriumMissionMatchmakingError = require("scripts/managers/error/errors/immaterium_mission_matchmaking_error")
local LocalizedErrorCodes = require("scripts/managers/party_immaterium/party_immaterium_localized_error_codes")
local MatchmakingNotificationHandler = require("scripts/multiplayer/matchmaking_notification_handler")
local PartyConstants = require("scripts/settings/network/party_constants")
local PartyImmateriumConnection = require("scripts/managers/party_immaterium/party_immaterium_connection")
local PartyImmateriumInviteNotificationHandler = require("scripts/managers/party_immaterium/party_immaterium_invite_notification_handler")
local PartyImmateriumManagerTestify = GameParameters.testify and require("scripts/managers/party_immaterium/party_immaterium_manager_testify")
local PartyImmateriumMember = require("scripts/managers/party_immaterium/party_immaterium_member")
local PartyImmateriumMemberMyself = require("scripts/managers/party_immaterium/party_immaterium_member_myself")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local PlaystationJoinPermission = require("scripts/managers/party_immaterium/join_permission/playstation_join_permission")
local Promise = require("scripts/foundation/utilities/promise")
local SteamJoinPermission = require("scripts/managers/party_immaterium/join_permission/steam_join_permission")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local XboxJoinPermission = require("scripts/managers/party_immaterium/join_permission/xbox_join_permission")
local PartyImmateriumManager = class("PartyImmateriumManager")
local ADVERTISEMENT_STATE = table.enum("SEARCHING", "CANCELED")
local JOIN_REQUESTS_STATE = table.enum("PENDING", "ACCEPTED", "DECLINED")

local function _info(...)
	Log.info("PartyImmateriumManager", ...)
end

local function _error(...)
	Log.error("PartyImmateriumManager", ...)
end

local function _warn(...)
	Log.warning("PartyImmateriumManager", ...)
end

PartyImmateriumManager.init = function (self)
	self._myself = PartyImmateriumMemberMyself:new()
	self._cached_debug_get_parties = {}
	self._cached_debug_get_parties_time = 0
	self._advertisement_join_requests_event_version = -1
	self._advertisement_join_requests_by_account_id = {}
	self._advertisement_join_requests_presence_version = -1
	self._last_party_connection_retry = 0
	self._last_party_connection_wait_done = false
	self._party_error_count = 0
	self._started = false
	self._last_join_permission_ensure = 0
	self._party_connection = nil
	self._joining_party_connection = nil
	self._current_party_id = nil
	self._game_session_promises = {}
	self._invite_popups = {}
	self._invite_notification_handler = PartyImmateriumInviteNotificationHandler:new()
	self._request_to_join_popups = {}
	self._party_join_request_parties_by_id = {}
	self._other_members = {}
	self._resolved_join_permissions = {}
	self._matchmaking_notification_handler = MatchmakingNotificationHandler:new()

	self:_reset_party_data()
	Managers.event:register(self, "party_immaterium_request_to_join", "_handle_request_to_join")
	Managers.event:register(self, "party_immaterium_request_to_join_popup_cancel", "_handle_request_to_join_popup_cancel")
	Managers.event:register(self, "party_immaterium_member_joined", "_handle_member_joined")
	Managers.event:register(self, "party_immaterium_member_left", "_handle_member_left")
	Managers.event:register(self, "party_immaterium_member_kicked", "_handle_member_kicked")
	Managers.event:register(self, "party_immaterium_member_disconnected", "_handle_member_disconnected")
	Managers.event:register(self, "party_immaterium_invite_created", "_handle_invite_created")
	Managers.event:register(self, "party_immaterium_invite_timeout", "_handle_invite_timeout")
	Managers.event:register(self, "party_immaterium_invite_canceled", "_handle_invite_canceled")
	Managers.event:register(self, "party_immaterium_invite_accepted", "_handle_invite_accepted")
	Managers.event:register(self, "backend_party_invite", "_handle_immaterium_invite")
	Managers.event:register(self, "backend_party_invite_canceled", "_handle_immaterium_invite_canceled")
	Managers.event:register(self, "backend_party_invite_timeout", "_handle_immaterium_invite_timeout")
	Managers.event:register(self, "event_stay_in_party_voting_started", "_handle_stay_in_party_voting_started")
	Managers.event:register(self, "event_stay_in_party_voting_completed", "_handle_stay_in_party_voting_completed")
	Managers.event:register(self, "event_stay_in_party_voting_aborted", "_handle_stay_in_party_voting_aborted")
	Managers.event:register(self, "backend_game_session_aborted", "_handle_game_session_aborted")
end

PartyImmateriumManager.destroy = function (self)
	Managers.event:unregister(self, "party_immaterium_request_to_join")
	Managers.event:unregister(self, "party_immaterium_request_to_join_popup_cancel")
	Managers.event:unregister(self, "party_immaterium_member_joined")
	Managers.event:unregister(self, "party_immaterium_member_left")
	Managers.event:unregister(self, "party_immaterium_member_kicked")
	Managers.event:unregister(self, "party_immaterium_member_disconnected")
	Managers.event:unregister(self, "party_immaterium_invite_created")
	Managers.event:unregister(self, "party_immaterium_invite_timeout")
	Managers.event:unregister(self, "party_immaterium_invite_canceled")
	Managers.event:unregister(self, "party_immaterium_invite_accepted")
	Managers.event:unregister(self, "backend_party_invite")
	Managers.event:unregister(self, "backend_party_invite_canceled")
	Managers.event:unregister(self, "backend_party_invite_timeout")
	Managers.event:unregister(self, "event_stay_in_party_voting_started")
	Managers.event:unregister(self, "event_stay_in_party_voting_completed")
	Managers.event:unregister(self, "event_stay_in_party_voting_aborted")
	Managers.event:unregister(self, "backend_game_session_aborted")
	self._matchmaking_notification_handler:delete()

	self._matchmaking_notification_handler = nil

	self._invite_notification_handler:delete()

	self._invite_notification_handler = nil
end

PartyImmateriumManager._resolve_join_permission = function (self, presence_entry, context)
	if not Managers.data_service.social:local_player_is_joinable() and context == "JOIN_REQUEST" then
		local context_suffix = context and "_" .. context or ""

		return Promise.rejected({
			error_details = "NOT_JOINABLE" .. context_suffix,
		})
	end

	if not presence_entry:is_online() then
		return Promise.resolved(nil)
	end

	if (IS_GDK or IS_XBS) and (context == "INVITE" or context == "JOIN_REQUEST") then
		local inviter_platform = presence_entry:platform()

		if inviter_platform == "xbox" then
			local platform_user_id = presence_entry:platform_user_id()

			if Managers.account:is_blocked(platform_user_id) then
				return Promise.rejected({
					error_details = "XBOX_BLOCKED_" .. context,
				})
			end
		end
	end

	local promises = {}

	table.insert(promises, CommonJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context))

	local authenticate_method = Managers.backend:get_auth_method()

	if authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE then
		table.insert(promises, XboxJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context))
	elseif authenticate_method == Managers.backend.AUTH_METHOD_STEAM then
		table.insert(promises, SteamJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context))
	elseif authenticate_method == Managers.backend.AUTH_METHOD_PSN then
		table.insert(promises, PlaystationJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context))
	end

	if #promises == 0 then
		return Promise.resolved(nil)
	end

	return Promise.all(unpack(promises)):catch(function (results)
		for _, result in ipairs(results) do
			if result == "declined" then
				return Promise.rejected({
					error_details = "PERMISSION_CHECK_FAILED",
				})
			elseif result ~= "OK" then
				return Promise.rejected({
					error_details = result,
				})
			end
		end
	end)
end

PartyImmateriumManager._ensure_join_permission_on_current_party = function (self, dt)
	self._last_join_permission_ensure = self._last_join_permission_ensure + dt

	if self._last_join_permission_ensure > 1 then
		for _, member in ipairs(self._other_members) do
			local presence = member:presence()

			if presence:is_online() and not presence:is_myself() then
				local id = presence:account_and_platform_composite_id()

				if not self._resolved_join_permissions[id] then
					self:_resolve_join_permission(presence):catch(function (error)
						_warn("Leaving party since I don't like %s, code=%s", table.tostring(presence, 5), error.error_details)

						self._resolved_join_permissions[id] = false

						self:leave_party()
					end)

					self._resolved_join_permissions[id] = true
				end
			end
		end

		self._last_join_permission_ensure = 0
	end
end

PartyImmateriumManager._resolve_join_permission_on_whole_party = function (self, party)
	local presence_promises = {}
	local my_account_id = self._myself:account_id()

	for _, member in ipairs(party.members) do
		if my_account_id ~= member.account_id then
			local _, presence_promise = Managers.presence:get_presence(member.account_id)
			local promise = presence_promise:catch(function (error)
				_warn("could not get presence for %s, error=%s, letting it pass as fallback", member.account_id, table.tostring(error))

				return Promise.resolved(nil)
			end):next(function (presence_entry)
				if presence_entry then
					return self:_resolve_join_permission(presence_entry)
				end

				return Promise.resolved(nil)
			end)

			table.insert(presence_promises, promise)
		end
	end

	return Promise.all(unpack(presence_promises)):catch(function (packed_results)
		for _, result in ipairs(packed_results) do
			if result and result.error_details then
				return Promise.rejected(result)
			end
		end
	end)
end

PartyImmateriumManager.start = function (self)
	if self._started then
		self:reset()
	end

	self._started = true

	local default_party_id = ""

	if GameParameters.testify then
		Testify:poll_requests_through_handler(PartyImmateriumManagerTestify, self)
	end

	return self:join_party(default_party_id, true):catch(function (error)
		Log.error("PartyImmateriumManager", "could not join default party, trying an empty party instead.. error=%s", table.tostring(error, 5))

		return self:leave_party()
	end)
end

PartyImmateriumManager.is_started = function (self)
	return self._started
end

PartyImmateriumManager.reset = function (self)
	self:_reset_party_data()

	if self._joining_party_connection then
		self._joining_party_connection:abort()

		self._joining_party_connection = nil
	end

	if self._party_connection then
		self._party_connection:abort()

		self._party_connection = nil
	end

	self._started = false
end

PartyImmateriumManager._reset_party_data = function (self)
	table.clear(self._other_members)
	table.clear(self._resolved_join_permissions)

	self._triggered_game_state_status = ""

	local last_state = self._last_state

	if last_state and last_state ~= PartyConstants.State.none then
		self._matchmaking_notification_handler:state_changed(last_state, PartyConstants.State.none)
	end

	self._last_state = PartyConstants.State.none

	for joiner_account_id, _ in pairs(self._request_to_join_popups) do
		self:_close_request_to_join_popup(joiner_account_id)
	end

	table.clear(self._request_to_join_popups)

	for _, game_session_promise in ipairs(self._game_session_promises) do
		game_session_promise:reject({
			error_details = "PARTY_RESET",
		})
	end

	table.clear(self._game_session_promises)

	if self._standing_invite_code_promise then
		self._standing_invite_code_promise:cancel()

		self._standing_invite_code_promise = nil
	end

	self._standing_invite_code = nil
	self._matched_hub_session_id = nil
	self._advertising_state = nil
	self._advertisement_request_to_join_list = nil
end

PartyImmateriumManager.other_members = function (self)
	return self._other_members
end

PartyImmateriumManager.num_other_members = function (self)
	return #self._other_members
end

local temp_all_members = {}

PartyImmateriumManager.all_members = function (self)
	table.clear(temp_all_members)

	temp_all_members[1] = self._myself

	local other_members = self._other_members

	for i = 1, #other_members do
		temp_all_members[i + 1] = other_members[i]
	end

	return temp_all_members
end

PartyImmateriumManager.member_from_account_id = function (self, account_id)
	if self._myself:unique_id() == account_id then
		return self._myself
	end

	for _, member in ipairs(self._other_members) do
		if member:unique_id() == account_id then
			return member
		end
	end

	return false
end

PartyImmateriumManager.member_from_peer_id = function (self, peer_id)
	if self._myself:peer_id() == peer_id then
		return self._myself
	end

	for _, member in ipairs(self._other_members) do
		if member:peer_id() == peer_id then
			return member
		end
	end

	return false
end

PartyImmateriumManager.other_member_from_unique_id = function (self, unique_id)
	for _, member in ipairs(self._other_members) do
		if member:unique_id() == unique_id then
			return member
		end
	end

	return false
end

PartyImmateriumManager.other_members_by_platform = function (self, platform)
	local other_members = Managers.party_immaterium:other_members()
	local platform_members = {}

	for i = 1, #other_members do
		local member = other_members[i]

		if platform == member:platform() then
			platform_members[#platform_members + 1] = member
		end
	end

	return platform_members
end

PartyImmateriumManager.other_members_account_ids = function (self)
	local other_members = Managers.party_immaterium:other_members()
	local account_ids = {}

	for i = 1, #other_members do
		local member = other_members[i]

		account_ids[i] = member:account_id()
	end

	return account_ids
end

PartyImmateriumManager._generate_compabillity_string = function (self)
	return Managers.connection.combined_hash
end

PartyImmateriumManager.debug_get_parties = function (self)
	if BUILD == "release" then
		return {}
	end

	return Managers.grpc:debug_get_parties(self:_generate_compabillity_string())
end

PartyImmateriumManager.cached_debug_get_parties = function (self)
	return self._cached_debug_get_parties
end

PartyImmateriumManager._fetch_cached_debug_get_parties = function (self, dt, force)
	if BUILD == "release" then
		return
	end

	self._cached_debug_get_parties_time = self._cached_debug_get_parties_time + dt

	if self._cached_debug_get_parties_time > 10 or force then
		self:debug_get_parties():next(function (result)
			self._cached_debug_get_parties = result.parties
		end):catch(function (error)
			Log.error("PartyImmateriumManager", "Could not fetch debug get parties %s", self:_table_tostring_or_string(error))
		end)

		self._cached_debug_get_parties_time = 0
	end
end

PartyImmateriumManager.leave_party = function (self)
	if self._leave_party_promise then
		return self._leave_party_promise
	end

	local leaving_party_connection = self._party_connection

	self._party_connection = nil

	local default_party_id = ""

	self._leave_party_promise = Managers.grpc:leave_party(self:party_id() or ""):next(function ()
		if leaving_party_connection then
			leaving_party_connection:abort()
		end

		return self:join_party(default_party_id)
	end):catch(function (error)
		if leaving_party_connection then
			leaving_party_connection:abort()
		end

		Log.error("PartyImmateriumManager", "failed to leave party %s", table.tostring(error, 3))

		return self:join_party(default_party_id)
	end):next(function (join_party_result)
		self._leave_party_promise = nil

		return Promise.resolved(join_party_result)
	end):catch(function (error)
		self._leave_party_promise = nil

		return Promise.rejected(error)
	end)

	return self._leave_party_promise
end

PartyImmateriumManager._parse_join_parameter_string = function (self, join_parameter, is_reconnect)
	local join_parameter_as_string = string.gsub(join_parameter, "%%3A", ":")

	if string.starts_with(join_parameter_as_string, "i:") then
		local split = string.split(join_parameter_as_string, ":")

		if #split >= 3 then
			return {
				party_id = split[2],
				invite_token = split[3],
			}
		else
			return {
				malformed = true,
			}
		end
	else
		return {
			party_id = join_parameter,
		}
	end
end

local PRESENCE_TO_JOIN_ERROR = {
	cinematic = "YOU_ARE_IN_CINEMATIC",
	loading = "YOU_ARE_IN_LOADING",
	matchmaking = "YOU_ARE_IN_MATCHMAKING",
	mission = "YOU_ARE_IN_MISSION",
	onboarding = "YOU_ARE_IN_ONBOARDING",
	splash_screen = "YOU_ARE_IN_SPLASH_SCREEN",
	title_screen = "YOU_ARE_IN_TITLE_SCREEN",
}

PartyImmateriumManager._can_join_new_party_check = function (self, join_parameter, is_reconnect)
	local is_new_empty_party = join_parameter.party_id == ""

	if join_parameter.malformed then
		return Promise.rejected({
			error_details = "INVALID_INVITE_CODE",
		})
	elseif is_new_empty_party or is_reconnect then
		return Promise.resolved()
	elseif Managers.data_service.social:local_player_can_join_party() then
		return Promise.resolved()
	else
		local presence_id = Managers.presence:presence()
		local error_details = PRESENCE_TO_JOIN_ERROR[presence_id]

		return Promise.rejected({
			error_details = error_details,
		})
	end
end

PartyImmateriumManager.join_party = function (self, join_parameter, is_reconnect)
	if type(join_parameter) == "string" then
		join_parameter = self:_parse_join_parameter_string(join_parameter)
	end

	local party_connection

	return self:_can_join_new_party_check(join_parameter, is_reconnect):next(function ()
		local party_id = join_parameter.party_id
		local accept_party_promise
		local is_party_id = party_id and party_id ~= ""

		if is_party_id then
			accept_party_promise = Managers.grpc:get_party(party_id):next(function (party)
				return self:_resolve_join_permission_on_whole_party(party)
			end)
		else
			accept_party_promise = Promise.resolved()
		end

		return accept_party_promise
	end):next(function ()
		if self._joining_party_connection then
			self._joining_party_connection:abort()
		end

		party_connection = PartyImmateriumConnection:new(join_parameter, self:_generate_compabillity_string(), function (session_id)
			return self:_hot_join_ticket(session_id)
		end)
		self._joining_party_connection = party_connection

		party_connection:start()

		return party_connection:join_promise()
	end):next(function ()
		if party_connection == self._joining_party_connection then
			self._joining_party_connection = nil
		end

		if self._party_connection then
			self._party_connection:abort()
		end

		self._party_connection = party_connection

		self:_reset_party_data()
		self:_on_join_party(is_reconnect and party_connection:party().version > 1)
	end):catch(function (error)
		if party_connection and party_connection == self._joining_party_connection then
			self._joining_party_connection = nil
		end

		if not error.aborted then
			self:_on_join_party_error(error.error_details)
		end

		_error("could not join party %s", table.tostring(error, 5))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager._hot_join_ticket = function (self, mission_session_id)
	_info("Getting ticket for mission_session_id=%s", mission_session_id)

	local profile = Managers.player:local_player_backend_profile()
	local character_id = profile and profile.character_id

	if not character_id then
		return Promise.rejected({
			error_details = "NO_CHARACTER_SELECTED",
		})
	end

	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_mission_hotjoin(mission_session_id, character_id):next(function (response)
		return response.ticket
	end)
end

local empty_object = {}

PartyImmateriumManager.party_id = function (self)
	return self._party_connection and self._party_connection:party().party_id or ""
end

PartyImmateriumManager._party_version = function (self)
	return self._party_connection and self._party_connection:party().version or 0
end

PartyImmateriumManager.party_vote_state = function (self)
	return self._party_connection and self._party_connection:party_vote() or empty_object
end

PartyImmateriumManager.party_game_state = function (self)
	return self._party_connection and self._party_connection:party_game_state() or empty_object
end

PartyImmateriumManager.party_invite_list = function (self)
	return self._party_connection and self._party_connection:party_invite_list() or nil
end

PartyImmateriumManager.broadcast = function (self, type, payload)
	return Managers.grpc:party_broadcast(self:party_id(), self:_party_version(), type, payload)
end

PartyImmateriumManager.start_vote = function (self, type, params, myParams)
	return Managers.grpc:start_party_vote(self:party_id(), self:_party_version(), type, params, myParams)
end

PartyImmateriumManager.answer_vote = function (self, vote_id, yes, myParams)
	return Managers.grpc:answer_party_vote(vote_id, self:party_id(), yes, myParams)
end

PartyImmateriumManager._handle_party_event = function (self, event)
	if event.event_type == "party_update" then
		self:_handle_party_update_event(event)
	elseif event.event_type == "party_game_state_update" then
		self:_handle_party_game_state_update_event(event)
	elseif event.event_type == "party_client_event_trigger" then
		self:_handle_party_client_event_trigger(event)
	elseif event.event_type == "advertisement_state_update" then
		self:_handle_advertisement_state_update_event_trigger(event)
	elseif event.event_type == "advertisement_request_to_join_list_update" then
		self:_handle_advertisement_request_to_join_list_update_event_trigger(event)
	elseif event.event_type == "party_vote_update" then
		self:_handle_party_vote_update_event(event)
	end
end

PartyImmateriumManager._handle_advertisement_state_update_event_trigger = function (self, event)
	if not self._advertising_state or event.version >= self._advertising_state.version then
		event.party_id = self:party_id()
		self._advertising_state = event
	end
end

PartyImmateriumManager._handle_advertisement_request_to_join_list_update_event_trigger = function (self, event)
	if event and event.version >= self._advertisement_join_requests_event_version then
		self._advertisement_join_requests_event_version = event.version

		local advertisement_join_requests_by_account_id = self._advertisement_join_requests_by_account_id
		local entries = event.entries

		for account_id, join_request in pairs(advertisement_join_requests_by_account_id) do
			local keep_existing_request = false

			for i = 1, #entries do
				local participant = entries[i]

				if participant.account_id == account_id then
					if participant.status == JOIN_REQUESTS_STATE.PENDING then
						keep_existing_request = true
					end

					break
				end
			end

			if not keep_existing_request then
				self:_remove_advertisement_request(account_id)
			end
		end

		for i = 1, #entries do
			local participant = entries[i]

			if participant.status == JOIN_REQUESTS_STATE.PENDING then
				local account_id = participant.account_id
				local join_request = advertisement_join_requests_by_account_id[account_id]

				if not join_request then
					join_request = join_request or {
						presence = nil,
						presence_synced = false,
						account_id = account_id,
					}
					advertisement_join_requests_by_account_id[account_id] = join_request

					local _, promise = Managers.presence:get_presence(account_id)

					promise:next(function (data)
						if self.__deleted then
							return
						end

						if data and data:is_online() then
							join_request.presence = data
							join_request.presence_synced = true
							self._advertisement_join_requests_presence_version = self._advertisement_join_requests_presence_version + 1
						else
							self:_remove_advertisement_request(account_id)
						end
					end):catch(function (error)
						Log.error("PartyImmateriumManager", "Fetching presence for join request failed")
						self:_remove_advertisement_request(account_id)
					end)
				end
			end
		end
	end
end

PartyImmateriumManager._update_advertisement_request_to_join_list = function (self)
	if self._advertisement_join_requests_event_version == -1 then
		return
	end

	local advertisement_join_requests_by_account_id = self._advertisement_join_requests_by_account_id

	for account_id, join_request in pairs(advertisement_join_requests_by_account_id) do
		if join_request.presence_synced then
			local presence = join_request.presence
			local is_alive = presence:is_alive()
			local is_online = is_alive and presence:is_online()

			if not is_online then
				self:_remove_advertisement_request(account_id)
			end
		end
	end
end

PartyImmateriumManager.party_finder_respond_to_join_request = function (self, party_id, account_id, accept)
	local promise, id = Managers.grpc:party_finder_respond_to_join_request(party_id, account_id, accept)

	promise:next(function ()
		self:_remove_advertisement_request(account_id)
		_info("Invited player from finder.")
	end):catch(function (error)
		self:_remove_advertisement_request(account_id)
		_error("Could not accept join request: %s", table.tostring(error, 10))
	end)

	return promise, id
end

PartyImmateriumManager._handle_party_update_event = function (self, event)
	local members = event.members
	local new_other_member_list = {}

	for _, immaterium_entry in ipairs(members) do
		local account_id = immaterium_entry.account_id

		if account_id ~= gRPC.get_account_id() then
			local member = self:other_member_from_unique_id(account_id)

			member = member or PartyImmateriumMember:new(account_id)

			member:update_immaterium_entry(immaterium_entry)
			table.insert(new_other_member_list, member)
		end
	end

	self._other_members = new_other_member_list

	Managers.presence:set_party(event.party_id, #members)

	if #members >= 4 then
		for joiner_account_id, _ in pairs(self._request_to_join_popups) do
			local party_id = self:party_id()

			Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "PARTY_FULL")
			self:_close_request_to_join_popup(joiner_account_id)
		end

		table.clear(self._request_to_join_popups)
	end

	if self._current_party_id ~= event.party_id then
		Managers.event:trigger("party_immaterium_joined")

		if table.size(self._other_members) > 0 then
			Managers.ui:play_2d_sound(UISoundEvents.notification_player_join_party)
		end

		self._current_party_id = event.party_id
	end

	Managers.event:trigger("party_immaterium_other_members_updated", self._other_members)
	PlayerCompositions.trigger_change_event("party")

	if #members >= 4 then
		self:cancel_party_finder_advertise()
	end
end

PartyImmateriumManager._handle_party_vote_update_event = function (self, event)
	if (event.state == "COMPLETED_REJECTED" or event.state == "FAILED_TIMEOUT") and event.started_by_account_id == self:get_myself():unique_id() then
		local params = event.params

		if params.mission_data and string.find(params.mission_data, "havoc-rank", nil, true) then
			Managers.data_service.havoc:delete_personal_mission(params.backend_mission_id):next(function ()
				Managers.event:trigger("event_auto_cancel_havoc_mission")
			end)
		end
	end
end

PartyImmateriumManager._handle_party_game_state_update_event = function (self, event)
	self:_execute_triggers_for_game_state()
end

PartyImmateriumManager._handle_party_client_event_trigger = function (self, event)
	Managers.event:trigger("party_immaterium_" .. event.trigger_event_name, unpack(event.args))
end

PartyImmateriumManager._handle_request_to_join = function (self, joiner_account_id, popup, context_account_id)
	if self._myself:account_id() == joiner_account_id then
		return
	end

	Log.info("###", "_handle_request_to_join")

	local _, inviteePresencePromise = Managers.presence:get_presence(joiner_account_id)
	local party_id = self:party_id()

	inviteePresencePromise:next(function (requester_presence)
		if popup then
			Log.info("###", "POPUP!")

			if self:current_state() == PartyConstants.State.in_mission then
				Log.info("###", "IN MISSION")

				if self:is_in_private_session() then
					Managers.data_service.social:fetch_friends():next(function (friends)
						local found = false

						for i = 1, #friends do
							local player_info = friends[i]

							if player_info:account_id() == joiner_account_id or player_info:platform() == requester_presence:platform() and player_info:platform_user_id() == requester_presence:platform_user_id() then
								_info("Is friend, answer OK_POPUP")

								found = true

								Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK_POPUP")

								break
							end
						end

						if not found then
							_info("Not friend, answer NEUTRAL_POPUP_PRIVATE_SESSION_NOT_FRIEND")
							Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "NEUTRAL_POPUP_PRIVATE_SESSION_NOT_FRIEND")
						end
					end):catch(function (error)
						_error("could not fetch friends for resolving private session permission, defaulting to OK")
						Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK_POPUP")
					end)
				else
					Log.info("###", "OK_POPUP")
					Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK_POPUP")
				end
			elseif context_account_id == "" or context_account_id == self._myself:account_id() then
				if IS_GDK or IS_XBS then
					XboxJoinPermission.check_join_request_communication_allowed(joiner_account_id, requester_presence):next(function (is_allowed)
						if is_allowed then
							self:_request_to_join_popup(joiner_account_id)
						else
							_info("Denying request to join, communication not allowed")
							Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "COMMUNICATION_BLOCKED_JOIN_REQUEST")
						end
					end):catch(function (err)
						_error("Ignoring request to join, communication permissions check failed: %s", table.tostring(err, 10))
					end)
				else
					self:_request_to_join_popup(joiner_account_id)
				end
			end
		else
			Log.info("###", "NOT POPUP!")
			self:_resolve_join_permission(requester_presence, "JOIN_REQUEST"):next(function ()
				Log.info("###", "YES!")
				Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK")
			end):catch(function (error)
				Log.info("###", "NO!")
				Managers.grpc:answer_request_to_join(party_id, joiner_account_id, error.error_details)
			end)
		end
	end)
end

PartyImmateriumManager._check_for_invites = function (self)
	if Managers.account:user_detached() then
		return
	end

	local social_service = Managers.data_service.social

	if social_service:has_invite() then
		local invite_address = social_service:get_invite()

		self:join_party(invite_address)
	end
end

PartyImmateriumManager.update = function (self, dt, t)
	if not self._started then
		return
	end

	local current_state = self:current_state()

	if self._last_state ~= current_state then
		_info("State changed from %s to %s", self._last_state, current_state)
		self._matchmaking_notification_handler:state_changed(self._last_state, current_state)

		self._last_state = current_state
	end

	self._matchmaking_notification_handler:update(dt)
	self._invite_notification_handler:update(dt, t)
	self:_ensure_join_permission_on_current_party(dt)
	self:_check_for_invites()

	self._last_party_connection_retry = self._last_party_connection_retry + dt

	if self._last_party_connection_retry > 10 then
		local party_connection = self._party_connection

		if not self._last_party_connection_wait_done then
			self._last_party_connection_wait_done = true
		elseif party_connection and party_connection:error() then
			_error("party connection failed with error %s", table.tostring(self._party_connection:error(), 5))

			self._last_party_connection_wait_done = false

			self:leave_party()
		elseif not party_connection then
			_error("party_connection is missing")

			self._last_party_connection_wait_done = false

			self:leave_party()
		end

		self._last_party_connection_retry = 0
	end

	self._myself:update_account_id(gRPC.get_account_id())

	local joining_party_connection = self._joining_party_connection

	if joining_party_connection then
		joining_party_connection:update(dt)
	end

	local party_connection = self._party_connection

	if party_connection then
		if not self._standing_invite_code_promise then
			self:get_your_standing_invite_code()
		end

		party_connection:update(dt)

		local event_buffer = party_connection:event_buffer()

		if #event_buffer > 0 then
			for _, event in ipairs(event_buffer) do
				self:_handle_party_event(event)
			end

			party_connection:reset_event_buffer()
		end
	end

	self:_update_advertisement_request_to_join_list()

	if GameParameters.testify then
		Testify:poll_requests_through_handler(PartyImmateriumManagerTestify, self)
	end
end

PartyImmateriumManager.is_in_matchmaking = function (self)
	return self:current_state() == PartyConstants.State.matchmaking
end

PartyImmateriumManager._reject_game_session_promises = function (self, error)
	for _, game_session_promise in ipairs(self._game_session_promises) do
		game_session_promise:reject(error)
	end

	table.clear(self._game_session_promises)
end

PartyImmateriumManager._resolve_game_session_promises = function (self)
	for _, game_session_promise in ipairs(self._game_session_promises) do
		game_session_promise:resolve(self)
	end

	table.clear(self._game_session_promises)
end

PartyImmateriumManager._execute_triggers_for_game_state = function (self)
	local game_state = self:party_game_state()
	local game_state_status = game_state.status

	if self._triggered_game_state_status ~= game_state_status then
		if game_state_status == "" and self._triggered_game_state_status == "MATCHMAKING_IN_PROGRESS" then
			if game_state.matchmaking.matchmaking_status == "CANCELLED" then
				self:_mission_matchmaking_aborted("CANCELLED")
				self:_reject_game_session_promises({
					error_details = "MATCHMAKING_CANCELLED",
				})
			else
				self:_mission_matchmaking_aborted(game_state.matchmaking.failed_message)
				self:_reject_game_session_promises({
					error_details = game_state.matchmaking.failed_message,
				})
			end
		elseif game_state_status == "" then
			self:_reject_game_session_promises({
				error_details = "UNDEFINED_ERROR",
			})
		elseif game_state_status == "GAME_SESSION_IN_PROGRESS" then
			self:_resolve_game_session_promises()
		end

		self._triggered_game_state_status = game_state_status
	end
end

PartyImmateriumManager.is_in_private_session = function (self)
	local game_state = self:party_game_state()

	if game_state.status == "GAME_SESSION_IN_PROGRESS" then
		return game_state.params and game_state.params.private_session == "true"
	end

	return false
end

PartyImmateriumManager.current_state = function (self)
	local game_state = self:party_game_state()

	if game_state.status == "MATCHMAKING_IN_PROGRESS" then
		return PartyConstants.State.matchmaking
	end

	if game_state.status == "GAME_SESSION_IN_PROGRESS" then
		return PartyConstants.State.in_mission
	end

	if game_state.status == "ACCEPTANCE_VOTE_IN_PROGRESS" then
		return PartyConstants.State.matchmaking_acceptance_vote
	end

	local party_vote_state = self:party_vote_state()

	if party_vote_state.type == "accept_matchmaking" and party_vote_state.state == "ONGOING" then
		return PartyConstants.State.matchmaking_acceptance_vote
	end

	return PartyConstants.State.none
end

PartyImmateriumManager.are_all_members_in_hub = function (self)
	if self:get_myself():presence_name() ~= "hub" then
		return false
	end

	for _, member in ipairs(self._other_members) do
		if member:presence_name() ~= "hub" and member:presence_name() ~= "training_grounds" then
			return false
		end
	end

	return true
end

PartyImmateriumManager.are_all_members_in_mission = function (self)
	local my_presence = self:get_myself():presence_name()
	local in_mission = my_presence == "mission" or my_presence == "end_of_round"

	if not in_mission then
		return false
	end

	for _, member in ipairs(self._other_members) do
		local member_presence = member:presence_name()
		local member_in_mission = member_presence == "mission" or member_presence == "end_of_round"

		if not member_in_mission then
			return false
		end
	end

	return true
end

PartyImmateriumManager.num_party_members_in_mission = function (self)
	local num_party_members_in_mission = 0
	local my_presence = self:get_myself():presence_name()

	if my_presence == "mission" then
		num_party_members_in_mission = num_party_members_in_mission + 1
	end

	local members = self._other_members

	for _, member in ipairs(members) do
		local member_presence = member:presence_name()

		if member_presence == "mission" then
			num_party_members_in_mission = num_party_members_in_mission + 1
		end
	end

	return num_party_members_in_mission
end

PartyImmateriumManager.hot_join_party_hub_server = function (self)
	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_hub():next(function (response)
		return Managers.grpc:hot_join_party_hub_server(response.ticket)
	end):next(function (response)
		if response.success then
			_info("Hot joined hub session, matched_hub_session_id = %s", response.matched_hub_session_id)

			return Promise.resolved(response.matched_hub_session_id)
		else
			return Promise.rejected({
				error_details = response.failed_message,
			})
		end
	end)
end

PartyImmateriumManager.create_single_player_game = function (self, mission_id)
	local profile = Managers.player:local_player_backend_profile()
	local character_id = profile and profile.character_id

	if not character_id then
		return Promise.rejected({
			error_details = "NO_CHARACTER_SELECTED",
		})
	end

	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_single_player(mission_id, character_id):next(function (response)
		return Managers.grpc:create_single_player_game(self:party_id(), response.ticket)
	end):catch(function (error)
		_error("Could not create single player game, error=%s", table.tostring(error, 3))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.request_vivox_party_token = function (self)
	return Managers.grpc:request_vivox_token(self:party_id(), "party")
end

PartyImmateriumManager.game_session_in_progress = function (self)
	local game_state = self:party_game_state()

	return game_state.status == "GAME_SESSION_IN_PROGRESS"
end

PartyImmateriumManager.have_recieved_game_state = function (self)
	return self._party_connection and self._party_connection:have_recieved_game_state() or false
end

PartyImmateriumManager.join_game_session = function (self)
	local game_session_id = self:current_game_session_id()
	local game_state = self:party_game_state()
	local party_id = game_state.party_id

	return Managers.multiplayer_session:party_immaterium_join_server(game_session_id, party_id)
end

PartyImmateriumManager.current_game_session_id = function (self)
	local game_state = self:party_game_state()

	if game_state.status == "GAME_SESSION_IN_PROGRESS" then
		return game_state.game_session.game_session_id
	else
		return nil
	end
end

PartyImmateriumManager.current_game_session_mission_data = function (self)
	local game_state = self:party_game_state()

	if game_state.status == "GAME_SESSION_IN_PROGRESS" then
		local mission_data = game_state.params and game_state.params.mission_data

		return mission_data and cjson.decode(mission_data) or nil
	else
		return nil
	end
end

PartyImmateriumManager.consume_matched_hub_server_session_id = function (self)
	local matched_hub_session_id = self._matched_hub_session_id

	self._matched_hub_session_id = nil

	return matched_hub_session_id
end

PartyImmateriumManager.cancel_matchmaking = function (self)
	return Managers.grpc:cancel_matchmaking(self:party_id()):catch(function (error)
		_error("Could not cancel matchmaking, error=%s", table.tostring(error, 3))
	end)
end

PartyImmateriumManager.latched_hub_server_matchmaking = function (self)
	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_hub():next(function (response)
		return Managers.grpc:latched_hub_server_matchmaking(response.ticket)
	end):next(function (response)
		if response.success then
			_info("Hub Server Latched matchmaking, matched_hub_session_id = %s", response.matched_hub_session_id)

			self._matched_hub_session_id = response.matched_hub_session_id

			return Promise.resolved(response.matched_hub_session_id)
		else
			return Promise.rejected({
				error_details = response.failed_message,
			})
		end
	end):catch(function (error)
		_error("Hub Server Latched matchmaking, error=%s", table.tostring(error, 3))
	end)
end

PartyImmateriumManager._table_tostring_or_string = function (self, table_or_string)
	if type(table_or_string) == "table" then
		return table.tostring(table_or_string, 3)
	else
		return table_or_string
	end
end

PartyImmateriumManager._game_session_promise = function (self)
	local game_session_promise = Promise:new()

	table.insert(self._game_session_promises, game_session_promise)

	return game_session_promise
end

PartyImmateriumManager.wanted_mission_selected = function (self, backend_mission_id, private_session, reef)
	local vote_state = self:party_vote_state()

	if vote_state.state == "ONGOING" then
		_info("Wanted mission rejected, already in process of booting a multiplayer session")

		return Promise.rejected()
	end

	return Managers.voting:start_voting("mission_vote_matchmaking_immaterium", {
		backend_mission_id = backend_mission_id,
		private_session = private_session and "true" or "false",
		reef = reef,
	}):catch(function (error)
		_error("Could not start voting, error=%s", self:_table_tostring_or_string(error))
	end):next(function ()
		return self:_game_session_promise()
	end)
end

PartyImmateriumManager.start_hub_group_up_vote = function (self)
	return Managers.voting:start_voting("new_hub_session_immaterium", {})
end

PartyImmateriumManager.get_myself = function (self)
	return self._myself
end

PartyImmateriumManager._mission_matchmaking_started = function (self, mission_name)
	return
end

PartyImmateriumManager._mission_matchmaking_completed = function (self, matched_game_session_id)
	return
end

PartyImmateriumManager._mission_matchmaking_aborted = function (self, reason)
	if reason == "CANCELLED" then
		local info_string = Localize("loc_matchmaking_cancelled")

		Managers.event:trigger("event_add_notification_message", "default", info_string, nil, UISoundEvents.notification_matchmaking_failed)
		_info("Mission Matchmaking aborted, fail reason: %s", reason)
	else
		Managers.error:report_error(ImmateriumMissionMatchmakingError:new(reason))
	end
end

PartyImmateriumManager.ready_voting_completed = function (self)
	return
end

PartyImmateriumManager.get_your_standing_invite_code = function (self)
	local party_id = self:party_id()

	if self._standing_invite_code_promise then
		return self._standing_invite_code_promise
	end

	local promise = Promise:new()

	self._standing_invite_code_promise = promise

	self:_retry_get_your_standing_invite_code(party_id, promise)

	return promise
end

PartyImmateriumManager._retry_get_your_standing_invite_code = function (self, party_id, promise)
	if promise:is_canceled() then
		return
	end

	local invite_list = self:party_invite_list()

	if invite_list then
		for i, invite in ipairs(invite_list.invites) do
			if invite.platform == "invite-code" and invite.inviter_account_id == self._myself:account_id() then
				self._standing_invite_code = "i:" .. party_id .. ":" .. invite.invite_token

				promise:resolve(self._standing_invite_code)

				return
			end
		end
	end

	Managers.grpc:invite_to_party(party_id, "invite-code", ""):next(function (response)
		if promise:is_canceled() then
			return
		end

		self._standing_invite_code = "i:" .. party_id .. ":" .. response.invite_token

		promise:resolve(self._standing_invite_code)
	end):catch(function (error)
		_warn("could not invite_to_party, error=%s", table.tostring(error, 3))

		return Managers.grpc:delay_with_jitter_and_backoff("get_your_standing_invite_code"):next(function ()
			self:_retry_get_your_standing_invite_code(party_id, promise)
		end)
	end)
end

PartyImmateriumManager.get_invite_code_for_platform_invite = function (self, platform, platform_user_id)
	local promise = Promise:new()

	if self._standing_invite_code then
		promise:resolve(self._standing_invite_code)
	else
		local error = {
			error_code = -1,
			error_details = "NO_STANDING_INVITE_FOUND",
		}

		_warn("could not get_invite_code_for_platform_invite, error=%s", table.tostring(error, 3))
		promise:reject(error)
	end

	return promise
end

PartyImmateriumManager.invite_to_party = function (self, invitee_account_id)
	local party_id = self:party_id()

	if party_id == "" then
		return Promise.rejected({
			error_details = "NOT_IN_A_PARTY",
		})
	end

	return self:_get_presence_promise(invitee_account_id):next(function (presence_entry)
		return self:_resolve_join_permission(presence_entry)
	end):next(function ()
		return Managers.grpc:invite_to_party(party_id, "", invitee_account_id)
	end):catch(function (error)
		_warn("could not invite, error=%s", table.tostring(error, 3))
		self:_on_invite_party_error(error.error_details)

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.cancel_party_invite = function (self, invite_token)
	local party_id = self:party_id()

	if party_id == "" then
		return Promise.rejected({
			error_details = "NOT_IN_A_PARTY",
		})
	end

	return Managers.grpc:cancel_invite_to_party(party_id, invite_token, "PARTY_CANCELED"):catch(function (error)
		_warn("could not cancel invite, error=%s", table.tostring(error, 3))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.get_invite_by_account_id = function (self, invitee_account_id)
	local invite_list = self:party_invite_list()

	if not invite_list then
		return false
	end

	for i, invite in ipairs(invite_list.invites) do
		if invite.platform == "" and invite.platform_user_id == invitee_account_id then
			return invite
		end
	end

	return false
end

PartyImmateriumManager._decline_party_invite = function (self, party_id, invite_token, answer_code)
	return Managers.grpc:cancel_invite_to_party(party_id, invite_token, answer_code):catch(function (error)
		_warn("could not decline invite, error=%s", table.tostring(error, 3))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager._get_presence_promise = function (self, account_id)
	local _, promise = Managers.presence:get_presence(account_id)

	return promise
end

PartyImmateriumManager._handle_member_joined = function (self, member_account_id)
	if self._myself:account_id() == member_account_id then
		return
	end

	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_joined", true, {
			member_character_name = presence:character_name(),
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_join_party)
	end)
	Managers.event:trigger("party_immaterium_member_added", member_account_id)
end

PartyImmateriumManager._handle_member_left = function (self, member_account_id)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_left", true, {
			member_character_name = presence:character_name(),
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
	self:_validate_advertisement_on_member_left(member_account_id)
end

PartyImmateriumManager._handle_member_kicked = function (self, member_account_id, reason)
	_info("party member %s was kicked for reason: %s", member_account_id, reason)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_kicked", true, {
			member_character_name = presence:character_name(),
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
end

PartyImmateriumManager._handle_member_disconnected = function (self, member_account_id)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_disconnected", true, {
			member_character_name = presence:character_name(),
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
	self:_validate_advertisement_on_member_left(member_account_id)
end

PartyImmateriumManager._handle_invite_created = function (self, invite_token, platform, platform_user_id, inviter_account_id)
	return
end

PartyImmateriumManager._handle_invite_canceled = function (self, invite_token, platform, platform_user_id, inviter_account_id, canceler_account_id, answer_code)
	if self._myself:account_id() ~= inviter_account_id or platform ~= "" then
		return
	end

	if answer_code == "PARTY_FULL" then
		return
	end

	if answer_code and answer_code ~= "" then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = LocalizedErrorCodes.loc_invite_error(answer_code),
		}, nil, UISoundEvents.notification_join_party_failed)
	else
		self:_get_presence_promise(platform_user_id):next(function (invitee_presence)
			local invitee_character_name = invitee_presence:character_name()
			local message, sound_event

			if platform_user_id == canceler_account_id then
				message = Localize("loc_party_notification_invite_declined", true, {
					invitee_character_name = invitee_character_name,
				})
				sound_event = UISoundEvents.notification_join_party_failed
			else
				message = Localize("loc_party_notification_invite_canceled", true, {
					invitee_character_name = invitee_character_name,
				})
				sound_event = UISoundEvents.notification_invite_canceled
			end

			Managers.event:trigger("event_add_notification_message", "default", message, nil, sound_event)
		end)
	end
end

PartyImmateriumManager._handle_invite_timeout = function (self, invite_token, platform, platform_user_id, inviter_account_id)
	if self._myself:account_id() ~= inviter_account_id or platform ~= "" then
		return
	end

	self:_get_presence_promise(platform_user_id):next(function (invitee_presence)
		local message = Localize("loc_party_notification_invite_expired", true, {
			invitee_character_name = invitee_presence:character_name(),
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_join_party_failed)
	end)
end

PartyImmateriumManager._handle_invite_accepted = function (self, invite_token, invitee_account_id, inviter_account_id)
	if self._myself:account_id() ~= inviter_account_id then
		self:_handle_member_joined(invitee_account_id)

		return
	end

	self:_get_presence_promise(invitee_account_id):next(function (invitee_presence)
		local character_name = invitee_presence:character_name()
		local message

		if not character_name or character_name == "" then
			message = Localize("loc_party_notification_invite_accepted_no_character")
		else
			message = Localize("loc_party_notification_invite_accepted", true, {
				invitee_character_name = character_name,
			})
		end

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_join_party)
	end)
	Managers.event:trigger("party_immaterium_member_added", invitee_account_id)
end

PartyImmateriumManager._on_join_party = function (self, reconnect)
	if reconnect then
		_info("Reconnected to strike team")
	else
		_info("Joined new strike team")
	end

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._on_join_party_error = function (self, error_code)
	Managers.event:trigger("event_add_notification_message", "alert", {
		text = LocalizedErrorCodes.loc_join_error(error_code),
	}, nil, UISoundEvents.notification_join_party_failed)

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._handle_stay_in_party_voting_started = function (self, voting_id, new_party_id, new_party_invite_token)
	self._active_party_vote = {
		voting_id = voting_id,
		party_id = new_party_id,
		party_invite_token = new_party_invite_token,
	}
end

PartyImmateriumManager._handle_stay_in_party_voting_completed = function (self, result)
	local new_party_id = self._active_party_vote.party_id
	local new_party_invite_token = self._active_party_vote.party_invite_token

	if result == "approved" then
		self:join_party({
			stay_in_party_join = true,
			party_id = new_party_id,
			invite_token = new_party_invite_token,
		}):next(function ()
			Promise.delay(2):next(function ()
				self:latched_hub_server_matchmaking()
			end)
		end)
		_info("stay_in_party_voting_completed -> joining new party %s:%s", new_party_id, new_party_invite_token or "")
	end

	self._active_party_vote = nil
end

PartyImmateriumManager._handle_stay_in_party_voting_aborted = function (self)
	self._active_party_vote = nil
end

PartyImmateriumManager.active_stay_in_party_vote = function (self)
	return self._active_party_vote
end

PartyImmateriumManager._on_invite_party_error = function (self, error_code)
	Managers.event:trigger("event_add_notification_message", "alert", {
		text = LocalizedErrorCodes.loc_invite_error(error_code),
	}, nil, UISoundEvents.notification_join_party_failed)

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._handle_immaterium_invite = function (self, party_id, invite_token, inviter_account_id)
	_info("Got invite, party_id=%s, inviter_account_id=%s, invite_token=%s", party_id, inviter_account_id, invite_token)
	self:_close_invite_popup(party_id)

	local _, promise = Managers.presence:get_presence(inviter_account_id)

	promise:next(function (inviter_presence)
		return self:_resolve_join_permission(inviter_presence, "INVITE"):next(function ()
			local account_id = inviter_presence:account_id()
			local party_data = self._party_join_request_parties_by_id[party_id]

			self._party_join_request_parties_by_id[party_id] = nil

			local context
			local is_group_finder_invite = account_id == "00000000-0000-0000-0000-000000000000"
			local character_name = inviter_presence:character_name()
			local character_profile = inviter_presence:character_profile()
			local character_level = character_profile and character_profile.current_level
			local player_name_and_level

			if character_level then
				player_name_and_level = Localize("loc_social_menu_character_name_format", true, {
					character_level = character_level,
					character_name = character_name,
				})
			end

			if self:current_state() == PartyConstants.State.in_mission then
				local inviter_name = player_name_and_level or character_name

				self._invite_notification_handler:add_invite(party_id, invite_token, inviter_name)

				return
			elseif is_group_finder_invite then
				local GroupFinderBlueprintsGenerateFunction = require("scripts/ui/views/group_finder_view/group_finder_blueprints")
				local ConstantElementPopupHandlerSettings = require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_settings")
				local grid_width = ConstantElementPopupHandlerSettings.text_max_width
				local grid_size = {
					grid_width,
					500,
				}
				local group_size = {
					480,
					120,
				}
				local grid_blueprints = GroupFinderBlueprintsGenerateFunction(grid_size)
				local grid_layout = {}

				grid_layout[#grid_layout + 1] = {
					horizontal_alignment = "center",
					texture = "content/ui/materials/dividers/skull_center_01",
					vertical_alignment = "center",
					widget_type = "texture",
					texture_size = {
						380,
						30,
					},
					color = Color.terminal_text_body_sub_header(nil, true),
					size = {
						grid_width,
						30,
					},
				}
				grid_layout[#grid_layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_width,
						10,
					},
				}
				grid_layout[#grid_layout + 1] = {
					widget_type = "body_centered",
					text = Localize("loc_group_finder_group_invite_popup_desc"),
					size = {
						grid_width,
						20,
					},
				}
				grid_layout[#grid_layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_width,
						30,
					},
				}
				grid_layout[#grid_layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						(grid_width - group_size[1]) * 0.5,
						10,
					},
				}

				if party_data then
					grid_layout[#grid_layout + 1] = {
						disabled = true,
						widget_type = "group",
						size = group_size,
						description = party_data.description,
						id = party_data.id,
						level_requirement_met = party_data.level_requirement_met,
						group = party_data,
						required_level = party_data.required_level,
						restrictions = party_data.restrictions,
						tags = party_data.tags,
						metadata = party_data.metadata,
						version = party_data.version,
					}
				end

				grid_layout[#grid_layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_width,
						30,
					},
				}
				grid_layout[#grid_layout + 1] = {
					horizontal_alignment = "center",
					texture = "content/ui/materials/dividers/skull_center_03",
					vertical_alignment = "center",
					widget_type = "texture",
					texture_size = {
						468,
						16,
					},
					color = Color.terminal_text_body_sub_header(nil, true),
					size = {
						grid_width,
						30,
					},
				}
				context = {
					title_text = "loc_group_finder_group_invite_popup_title",
					type = "grid",
					grid_layout = grid_layout,
					grid_blueprints = grid_blueprints,
					description_text_params = {},
					enter_popup_sound = UISoundEvents.social_menu_receive_invite,
					options = {
						{
							close_on_pressed = true,
							text = "loc_social_party_invite_received_accept_button",
							callback = function ()
								self:join_party({
									party_id = party_id,
									invite_token = invite_token,
								})

								self._invite_popups[party_id] = nil
							end,
						},
						{
							close_on_pressed = true,
							hotkey = "back",
							text = "loc_social_party_invite_received_decline_button",
							callback = function ()
								self:_decline_party_invite(party_id, invite_token)

								self._invite_popups[party_id] = nil
							end,
						},
					},
				}
			else
				context = {
					description_text = "loc_social_party_invite_received_description",
					title_text = "loc_social_party_invite_received_header",
					description_text_params = {
						player_name = player_name_and_level or character_name,
					},
					enter_popup_sound = UISoundEvents.social_menu_receive_invite,
					options = {
						{
							close_on_pressed = true,
							text = "loc_social_party_invite_received_accept_button",
							callback = function ()
								self:join_party({
									party_id = party_id,
									invite_token = invite_token,
								})

								self._invite_popups[party_id] = nil
							end,
						},
						{
							close_on_pressed = true,
							hotkey = "back",
							text = "loc_social_party_invite_received_decline_button",
							callback = function ()
								self:_decline_party_invite(party_id, invite_token)

								self._invite_popups[party_id] = nil
							end,
						},
						{
							close_on_pressed = true,
							stop_exit_sound = true,
							template_type = "terminal_button_hold_small",
							text = "loc_social_party_invite_received_decline_and_block_button",
							on_complete_sound = UISoundEvents.social_menu_block_player,
							callback = function ()
								self:_decline_party_invite(party_id, invite_token)
								Managers.data_service.social:block_account(inviter_account_id)

								self._invite_popups[party_id] = nil
							end,
						},
					},
				}
			end

			Managers.event:trigger("event_show_ui_popup", context, function (id)
				self._invite_popups[party_id] = id
			end)
		end):catch(function (error)
			self:_decline_party_invite(party_id, invite_token, error.error_details)
		end)
	end)
end

PartyImmateriumManager._handle_immaterium_invite_canceled = function (self, party_id, invite_token, inviter_account_id, canceler_account_id, answer_code)
	_info("invite canceled, party_id=%s, invite_token=%s, inviter_account_id=%s, canceler_account_id=%s", party_id, invite_token, inviter_account_id, canceler_account_id)
	self:_close_invite_popup(party_id)

	if answer_code == "PARTY_FULL" then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_party_notification_canceled_invite_party_full"),
		}, nil, UISoundEvents.notification_join_party_failed)
	elseif answer_code == "PARTY_CANCELED" then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_party_notification_canceled_invite"),
		}, nil, UISoundEvents.notification_join_party_failed)
	end
end

PartyImmateriumManager._handle_immaterium_invite_timeout = function (self, party_id, invite_token, inviter_account_id)
	_info("invite timeout, party_id=%s, inviter_account_id=%s, inviter_account_id=%s", party_id, invite_token, inviter_account_id)
	self:_close_invite_popup(party_id)
end

PartyImmateriumManager._close_invite_popup = function (self, party_id)
	local popup = self._invite_popups[party_id]

	if popup then
		Managers.event:trigger("event_remove_ui_popup", popup)

		self._invite_popups[party_id] = nil
	end

	self._invite_notification_handler:clear_invite_by_party_id(party_id)
end

PartyImmateriumManager._request_to_join_popup = function (self, joiner_account_id)
	_info("Got invite, joiner_account_id=%s", joiner_account_id)
	self:_close_request_to_join_popup(joiner_account_id)

	local _, promise = Managers.presence:get_presence(joiner_account_id)

	promise:next(function (inviter_presence)
		local character_name = inviter_presence:character_name()
		local character_profile = inviter_presence:character_profile()
		local character_level = character_profile and character_profile.current_level
		local player_name_and_level

		if character_level then
			player_name_and_level = Localize("loc_social_menu_character_name_format", true, {
				character_level = character_level,
				character_name = character_name,
			})
		end

		local context = {
			description_text = "loc_party_request_to_join_description",
			title_text = "loc_party_request_to_join_header",
			description_text_params = {
				player_name = player_name_and_level or character_name,
			},
			enter_popup_sound = UISoundEvents.social_menu_receive_invite,
			options = {
				{
					close_on_pressed = true,
					text = "loc_party_request_to_join_accept_button",
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "OK_POPUP")

						self._request_to_join_popups[joiner_account_id] = nil
					end,
				},
				{
					close_on_pressed = true,
					hotkey = "back",
					text = "loc_party_request_to_join_decline_button",
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "MEMBER_DECLINED_REQUEST_TO_JOIN")

						self._request_to_join_popups[joiner_account_id] = nil
					end,
				},
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					template_type = "terminal_button_hold_small",
					text = "loc_social_party_request_to_join_decline_and_block_button",
					on_complete_sound = UISoundEvents.social_menu_block_player,
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "MEMBER_DECLINED_REQUEST_TO_JOIN")
						Managers.data_service.social:block_account(joiner_account_id)

						self._request_to_join_popups[joiner_account_id] = nil
					end,
				},
			},
		}

		Managers.event:trigger("event_show_ui_popup", context, function (id)
			self._request_to_join_popups[joiner_account_id] = id
		end)
	end)
end

PartyImmateriumManager._handle_request_to_join_popup_cancel = function (self, joiner_account_id)
	_info("request to join canceled joiner_account_id=%s", joiner_account_id)
	self:_close_request_to_join_popup(joiner_account_id)
end

PartyImmateriumManager._close_request_to_join_popup = function (self, joiner_account_id)
	local popup = self._request_to_join_popups[joiner_account_id]

	if popup then
		Managers.event:trigger("event_remove_ui_popup", popup)

		self._request_to_join_popups[joiner_account_id] = nil
	end
end

PartyImmateriumManager._handle_game_session_aborted = function (self, payload)
	local context = {
		description_text = "loc_game_session_aborted_popup_description",
		title_text = "loc_game_session_aborted_popup_title",
		options = {
			{
				close_on_pressed = true,
				text = "loc_game_session_aborted_popup_close_button",
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

PartyImmateriumManager.start_party_finder_advertise = function (self, config, tags, category)
	self._advertisement_join_requests_by_account_id = {}
	self._advertisement_join_requests_event_version = -1
	self._advertisement_join_requests_presence_version = -1

	return Managers.grpc:party_finder_start_advertisement(self:party_id(), config, tags, category)
end

PartyImmateriumManager.cancel_party_finder_advertise = function (self)
	local promise = Managers.grpc:party_finder_cancel_advertisement(self:party_id())

	promise:next(function (response)
		self._advertisement_join_requests_by_account_id = {}
		self._advertisement_join_requests_event_version = -1
		self._advertisement_join_requests_presence_version = -1
		self._advertising_state = nil
	end):catch(function (error)
		self._advertisement_join_requests_by_account_id = {}
		self._advertisement_join_requests_event_version = -1
		self._advertisement_join_requests_presence_version = -1
		self._advertising_state = nil
	end)

	return promise
end

PartyImmateriumManager.advertise_state = function (self)
	return self._advertising_state
end

PartyImmateriumManager.is_party_advertisement_active = function (self)
	local advertising_state = self._advertising_state

	return advertising_state and advertising_state.status == ADVERTISEMENT_STATE.SEARCHING
end

PartyImmateriumManager.advertisement_request_to_join_list = function (self)
	return self._advertisement_join_requests_by_account_id, self._advertisement_join_requests_presence_version
end

PartyImmateriumManager._remove_advertisement_request = function (self, account_id)
	local advertisement_join_requests_by_account_id = self._advertisement_join_requests_by_account_id

	if advertisement_join_requests_by_account_id[account_id] then
		local request = advertisement_join_requests_by_account_id[account_id]

		if request.presence_synced then
			self._advertisement_join_requests_presence_version = self._advertisement_join_requests_presence_version + 1
		end

		advertisement_join_requests_by_account_id[account_id] = nil
	end
end

PartyImmateriumManager.send_request_to_join_party = function (self, data, account_id)
	local id = data.id

	if not self._party_join_request_parties_by_id then
		self._party_join_request_parties_by_id = {}
	end

	self._party_join_request_parties_by_id[id] = data

	return Managers.grpc:party_finder_request_to_join(id, account_id)
end

PartyImmateriumManager._validate_advertisement_on_member_left = function (self, member_account_id)
	local advertising_state = self._advertising_state

	if not advertising_state then
		return
	end

	local havoc_order_owner = advertising_state.config.havoc_order_owner

	if not havoc_order_owner then
		return
	end

	if havoc_order_owner == member_account_id then
		Log.info("PartyImmateriumManager", "Havoc order owner no longer in the party, cancelling advertisement")
		self:cancel_party_finder_advertise()
	end
end

return PartyImmateriumManager
