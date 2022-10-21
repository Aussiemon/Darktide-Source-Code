local PartyImmateriumMember = require("scripts/managers/party_immaterium/party_immaterium_member")
local PartyImmateriumConnection = require("scripts/managers/party_immaterium/party_immaterium_connection")
local PartyImmateriumMemberMyself = require("scripts/managers/party_immaterium/party_immaterium_member_myself")
local LocalizedErrorCodes = require("scripts/managers/party_immaterium/party_immaterium_localized_error_codes")
local CommonJoinPermission = require("scripts/managers/party_immaterium/join_permission/common_join_permission")
local XboxJoinPermission = require("scripts/managers/party_immaterium/join_permission/xbox_join_permission")
local SteamJoinPermission = require("scripts/managers/party_immaterium/join_permission/steam_join_permission")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local PartyConstants = require("scripts/settings/network/party_constants")
local PartyImmateriumManagerTestify = GameParameters.testify and require("scripts/managers/party_immaterium/party_immaterium_manager_testify")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Promise = require("scripts/foundation/utilities/promise")
local PartyImmateriumManager = class("PartyImmateriumManager")

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
	self._last_party_connection_retry = 0
	self._last_party_connection_wait_done = false
	self._party_error_count = 0
	self._started = false
	self._last_join_permission_ensure = 0
	self._party_connection = nil
	self._joining_party_connection = nil
	self._game_session_promises = {}
	self._invite_popups = {}
	self._request_to_join_popups = {}
	self._other_members = {}
	self._resolved_join_permissions = {}

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
end

PartyImmateriumManager._resolve_join_permission = function (self, presence_entry, context_suffix)
	context_suffix = not context_suffix and "" or "_" .. context_suffix

	if not presence_entry:is_online() then
		return Promise.resolved(nil)
	end

	local promises = {}

	table.insert(promises, CommonJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context_suffix))

	local authenticate_method = Managers.backend:get_auth_method()

	if authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE then
		table.insert(promises, XboxJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context_suffix))
	elseif authenticate_method == Managers.backend.AUTH_METHOD_STEAM then
		table.insert(promises, SteamJoinPermission.test_play_mutliplayer_permission(presence_entry:account_id(), presence_entry:platform(), presence_entry:platform_user_id(), context_suffix))
	end

	if #promises == 0 then
		return Promise.resolved(nil)
	end

	return Promise.all(unpack(promises)):catch(function (results)
		for _, result in ipairs(results) do
			if result ~= "OK" then
				return Promise.rejected({
					error_details = result
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
		Testify:poll_requests_through_handler(PartyImmateriumManagerTestify, self, true)
	end

	return self:join_party(default_party_id, true):catch(function (error)
		Log.error("PartyImmateriumManager", "could not join default party, trying an empty party instead.. error=" .. table.tostring(error, 5))

		return self:leave_party()
	end)
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
	self._last_state = PartyConstants.State.none

	for joiner_account_id, _ in pairs(self._request_to_join_popups) do
		self:_close_request_to_join_popup(joiner_account_id)
	end

	table.clear(self._request_to_join_popups)

	for _, game_session_promise in ipairs(self._game_session_promises) do
		game_session_promise:reject({
			error_details = "PARTY_RESET"
		})
	end

	table.clear(self._game_session_promises)
end

PartyImmateriumManager.other_members = function (self)
	return self._other_members
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
			Log.error("[PartyImmateriumManager] Could not fetch debug get parties " .. self:_table_tostring_or_string(error))
		end)

		self._cached_debug_get_parties_time = 0
	end
end

PartyImmateriumManager.leave_party = function (self)
	local leaving_party_connection = self._party_connection
	self._party_connection = nil
	local default_party_id = ""

	return Managers.grpc:leave_party(self:party_id() or ""):next(function ()
		if leaving_party_connection then
			leaving_party_connection:abort()
		end

		return self:join_party(default_party_id)
	end):catch(function (error)
		if leaving_party_connection then
			leaving_party_connection:abort()
		end

		Log.error("PartyImmateriumManager", "failed to leave party " .. table.tostring(error, 3))

		return self:join_party(default_party_id)
	end)
end

PartyImmateriumManager.join_party = function (self, join_parameter, is_reconnect)
	local party_id = nil

	if type(join_parameter) == "string" then
		if string.starts_with(join_parameter, "i:") then
			local split = string.split(join_parameter, ":")
			join_parameter = {
				party_id = split[2],
				invite_token = split[3]
			}
		else
			party_id = join_parameter
			join_parameter = {
				party_id = party_id
			}
		end
	else
		party_id = join_parameter.party_id
	end

	local party_connection, accept_party_promise = nil
	local is_party_id = party_id ~= ""

	if is_party_id then
		accept_party_promise = Managers.grpc:get_party(party_id):next(function (party)
			return self:_resolve_join_permission_on_whole_party(party)
		end)
	else
		accept_party_promise = Promise.resolved()
	end

	return accept_party_promise:next(function ()
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

		_error("could not join party " .. table.tostring(error, 5))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager._hot_join_ticket = function (self, mission_session_id)
	_info("Getting ticket for mission_session_id=" .. mission_session_id)

	local profile = Managers.player:local_player_backend_profile()
	local character_id = profile and profile.character_id

	if not character_id then
		return Promise.rejected({
			error_details = "NO_CHARACTER_SELECTED"
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
	end
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

	PlayerCompositions.trigger_change_event("party")
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

	local _, inviteePresencePromise = Managers.presence:get_presence(joiner_account_id)
	local party_id = self:party_id()

	inviteePresencePromise:next(function (requester_presence)
		if popup and (context_account_id == "" or context_account_id == self._myself:account_id()) then
			if self:current_state() == PartyConstants.State.in_mission or self:current_state() == PartyConstants.State.matchmaking_acceptance_vote then
				Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK_POPUP")
			else
				self:_request_to_join_popup(joiner_account_id)
			end
		else
			self:_resolve_join_permission(requester_presence, "JOIN_REQUEST"):next(function ()
				Managers.grpc:answer_request_to_join(party_id, joiner_account_id, "OK")
			end):catch(function (error)
				Managers.grpc:answer_request_to_join(party_id, joiner_account_id, error.error_details)
			end)
		end
	end)
end

PartyImmateriumManager._check_for_invites = function (self)
	local social_service = Managers.data_service.social

	if social_service:has_invite() then
		local invite_address = social_service:get_invite()

		_info("Joining party %s through invite", invite_address)
		self:join_party(invite_address)
	end
end

PartyImmateriumManager.update = function (self, dt, t)
	if not self._started then
		return
	end

	local current_state = self:current_state()

	if self._last_state ~= current_state then
		_info("State changed from " .. self._last_state .. " to " .. current_state)

		self._last_state = current_state
	end

	self:_ensure_join_permission_on_current_party(dt)
	self:_matchmaking_status_notifier()
	self:_check_for_invites()

	self._last_party_connection_retry = self._last_party_connection_retry + dt

	if self._last_party_connection_retry > 10 then
		local party_connection = self._party_connection

		if not self._last_party_connection_wait_done then
			self._last_party_connection_wait_done = true
		elseif party_connection and party_connection:error() then
			_error("party connection failed with error " .. table.tostring(self._party_connection:error(), 5))

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

	if self._joining_party_connection then
		self._joining_party_connection:update(dt)
	end

	if self._party_connection then
		self._party_connection:update(dt)

		local event_buffer = self._party_connection:event_buffer()

		if #event_buffer > 0 then
			for i, event in ipairs(event_buffer) do
				_info("recevied party event " .. table.tostring(event, 3))
				self:_handle_party_event(event)
			end

			self._party_connection:reset_event_buffer()
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(PartyImmateriumManagerTestify, self)
	end
end

PartyImmateriumManager.is_in_matchmaking = function (self)
	return self:current_state() == PartyConstants.State.matchmaking
end

PartyImmateriumManager._matchmaking_status_notifier = function (self)
	local is_in_matchmaking = self:is_in_matchmaking()

	if is_in_matchmaking and not self._is_in_matchmaking_message_id then
		Managers.event:trigger("event_add_notification_message", "mission", "Party is in matchmaking, please wait...", function (id)
			self._is_in_matchmaking_message_id = id
		end)
	elseif not is_in_matchmaking and self._is_in_matchmaking_message_id then
		Managers.event:trigger("event_remove_notification", self._is_in_matchmaking_message_id)

		self._is_in_matchmaking_message_id = nil
	end
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
					error_details = "MATCHMAKING_CANCELLED"
				})
			else
				self:_mission_matchmaking_aborted(game_state.matchmaking.failed_message)
				self:_reject_game_session_promises({
					error_details = game_state.matchmaking.failed_message
				})
			end
		elseif game_state_status == "" then
			self:_reject_game_session_promises({
				error_details = "UNDEFINED_ERROR"
			})
		elseif game_state_status == "GAME_SESSION_IN_PROGRESS" then
			self:_resolve_game_session_promises()
		end

		self._triggered_game_state_status = game_state_status
	end
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
		if member:presence_name() ~= "hub" then
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
			_info("Hot joined hub session, response = " .. table.tostring(response, 3))

			return Promise.resolved(response.matched_hub_session_id)
		else
			return Promise.rejected({
				error_details = response.failed_message
			})
		end
	end)
end

PartyImmateriumManager.create_single_player_game = function (self, mission_id)
	local profile = Managers.player:local_player_backend_profile()
	local character_id = profile and profile.character_id

	if not character_id then
		return Promise.rejected({
			error_details = "NO_CHARACTER_SELECTED"
		})
	end

	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_single_player(mission_id, character_id):next(function (response)
		return Managers.grpc:create_single_player_game(self:party_id(), response.ticket)
	end):catch(function (error)
		_error("Could not create single player game, error=" .. table.tostring(error, 3))

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

PartyImmateriumManager.join_game_session = function (self)
	local game_session_id = self:current_game_session_id()

	return Managers.multiplayer_session:party_immaterium_join_server(game_session_id)
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
		return cjson.decode(game_state.params.mission_data)
	else
		return nil
	end
end

PartyImmateriumManager.current_hub_server_session_id = function (self)
	local game_state = self:party_game_state()

	if game_state.hub_session then
		return game_state.hub_session.hub_session_id
	else
		return nil
	end
end

PartyImmateriumManager.cancel_matchmaking = function (self)
	return Managers.grpc:cancel_matchmaking(self:party_id()):catch(function (error)
		_error("Could not cancel matchmaking, error=" .. table.tostring(error, 3))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.latched_hub_server_matchmaking = function (self)
	return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_hub():next(function (response)
		return Managers.grpc:latched_hub_server_matchmaking(response.ticket)
	end):next(function (response)
		if response.success then
			_info("Hub Server Latched matchmaking, response = " .. table.tostring(response, 3))

			return Promise.resolved(response.matched_hub_session_id)
		else
			return Promise.rejected({
				error_details = response.failed_message
			})
		end
	end):catch(function (error)
		_error("Hub Server Latched matchmaking, error=" .. table.tostring(error, 3))
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

PartyImmateriumManager.wanted_mission_selected = function (self, backend_mission_id)
	local vote_state = self:party_vote_state()

	if vote_state.state == "ONGOING" then
		_info("Wanted mission rejected, already in process of booting a multiplayer session")

		return Promise.rejected()
	end

	return Managers.voting:start_voting("mission_vote_matchmaking_immaterium", {
		backend_mission_id = backend_mission_id
	}):catch(function (error)
		_error("Could not start voting, error=" .. self:_table_tostring_or_string(error))
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
	local info_string = string.format("Matchmaking failed, %s", reason)

	Managers.event:trigger("event_add_notification_message", "alert", {
		text = info_string
	}, nil, UISoundEvents.notification_matchmaking_failed)
	_info("Mission Matchmaking aborted, fail reason: %s", reason)
end

PartyImmateriumManager.ready_voting_completed = function (self)
	return
end

PartyImmateriumManager.get_invite_code_for_platform_invite = function (self, platform, platform_user_id)
	local party_id = self:party_id()

	return Managers.grpc:invite_to_party(party_id, platform, platform_user_id):next(function (response)
		return "i:" .. party_id .. ":" .. response.invite_token
	end):catch(function (error)
		_warn("could not get_invite_code_for_platform_invite, error=" .. table.tostring(error, 3))

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.invite_to_party = function (self, invitee_account_id)
	local party_id = self:party_id()

	if party_id == "" then
		return Promise.rejected({
			error_details = "NOT_IN_A_PARTY"
		})
	end

	return self:_get_presence_promise(invitee_account_id):next(function (presence_entry)
		return self:_resolve_join_permission(presence_entry)
	end):next(function ()
		return Managers.grpc:invite_to_party(party_id, "", invitee_account_id)
	end):catch(function (error)
		_warn("could not invite, error=" .. table.tostring(error, 3))
		self:_on_invite_party_error(error.error_details)

		return Promise.rejected(error)
	end)
end

PartyImmateriumManager.cancel_party_invite = function (self, invite_token)
	local party_id = self:party_id()

	if party_id == "" then
		return Promise.rejected({
			error_details = "NOT_IN_A_PARTY"
		})
	end

	return Managers.grpc:cancel_invite_to_party(party_id, invite_token):catch(function (error)
		_warn("could not cancel invite, error=" .. table.tostring(error, 3))

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
		_warn("could not decline invite, error=" .. table.tostring(error, 3))

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
			member_character_name = presence:character_name()
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_join_party)
	end)
end

PartyImmateriumManager._handle_member_left = function (self, member_account_id)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_left", true, {
			member_character_name = presence:character_name()
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
end

PartyImmateriumManager._handle_member_kicked = function (self, member_account_id, reason)
	_info("party member %s was kicked for reason: %s", member_account_id, reason)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_kicked", true, {
			member_character_name = presence:character_name()
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
end

PartyImmateriumManager._handle_member_disconnected = function (self, member_account_id)
	self:_get_presence_promise(member_account_id):next(function (presence)
		local message = Localize("loc_party_notification_member_disconnected", true, {
			member_character_name = presence:character_name()
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_leave_party)
	end)
end

PartyImmateriumManager._handle_invite_created = function (self, invite_token, platform, platform_user_id, inviter_account_id)
	return
end

PartyImmateriumManager._handle_invite_canceled = function (self, invite_token, platform, platform_user_id, inviter_account_id, canceler_account_id, answer_code)
	if self._myself:account_id() ~= inviter_account_id or platform ~= "" then
		return
	end

	if answer_code and answer_code ~= "" then
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = LocalizedErrorCodes.loc_invite_error(answer_code)
		}, nil, UISoundEvents.notification_join_party_failed)
	else
		self:_get_presence_promise(platform_user_id):next(function (invitee_presence)
			local invitee_character_name = invitee_presence:character_name()
			local message, sound_event = nil

			if platform_user_id == canceler_account_id then
				message = Localize("loc_party_notification_invite_declined", true, {
					invitee_character_name = invitee_character_name
				})
				sound_event = UISoundEvents.notification_join_party_failed
			else
				message = Localize("loc_party_notification_invite_canceled", true, {
					invitee_character_name = invitee_character_name
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
			invitee_character_name = invitee_presence:character_name()
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
		local message = Localize("loc_party_notification_invite_accepted", true, {
			invitee_character_name = invitee_presence:character_name()
		})

		Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_player_join_party)
	end)
end

PartyImmateriumManager._on_join_party = function (self, reconnect)
	if reconnect then
		Log.info("PartyImmateriumManager", "Reconnected to strike team")
	elseif table.size(self._other_members) > 0 then
		Log.info("PartyImmateriumManager", "Joined new strike team")
		Managers.event:trigger("party_immaterium_join")

		if table.size(self._other_members) > 0 then
			Managers.ui:play_2d_sound(UISoundEvents.notification_player_join_party)
		end
	end

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._on_join_party_error = function (self, error_code)
	Managers.event:trigger("event_add_notification_message", "alert", {
		text = LocalizedErrorCodes.loc_join_error(error_code)
	}, nil, UISoundEvents.notification_join_party_failed)

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._handle_stay_in_party_voting_started = function (self, voting_id, new_party_id, new_party_invite_token)
	self._new_party_id = new_party_id
	self._new_party_invite_token = new_party_invite_token
end

PartyImmateriumManager._handle_stay_in_party_voting_completed = function (self, result)
	local new_party_id = self._new_party_id
	local new_party_invite_token = self._new_party_invite_token

	if result == "approved" then
		self:join_party({
			party_id = new_party_id,
			invite_token = new_party_invite_token
		})
		Log.info("PartyImmateriumManager", "stay_in_party_voting_completed -> joining new party %s:%s", new_party_id, new_party_invite_token or "")
	end

	self._new_party_id = nil
end

PartyImmateriumManager._handle_stay_in_party_voting_aborted = function (self)
	self._new_party_id = nil
end

PartyImmateriumManager._on_invite_party_error = function (self, error_code)
	Managers.event:trigger("event_add_notification_message", "alert", {
		text = LocalizedErrorCodes.loc_invite_error(error_code)
	}, nil, UISoundEvents.notification_join_party_failed)

	self._cached_debug_get_parties_time = 9.7
end

PartyImmateriumManager._handle_immaterium_invite = function (self, party_id, invite_token, inviter_account_id)
	Log.info("PartyImmateriumManager", "Got invite, party_id=%s, inviter_account_id=%s, invite_token=%s", party_id, inviter_account_id, invite_token)

	if self:current_state() == PartyConstants.State.in_mission then
		self:_decline_party_invite(party_id, invite_token, "IN_MISSION")
	else
		self:_close_invite_popup(party_id)

		local _, promise = Managers.presence:get_presence(inviter_account_id)

		promise:next(function (inviter_presence)
			return self:_resolve_join_permission(inviter_presence, "INVITE"):next(function ()
				local character_name = inviter_presence:character_name()
				local character_profile = inviter_presence:character_profile()
				local character_level = character_profile and character_profile.current_level
				local player_name_and_level = nil

				if character_level then
					player_name_and_level = Localize("loc_social_menu_character_name_format", true, {
						character_level = character_level,
						character_name = character_name
					})
				end

				local context = {
					title_text = "loc_social_party_invite_received_header",
					description_text = "loc_social_party_invite_received_description",
					description_text_params = {
						player_name = player_name_and_level or character_name
					},
					enter_popup_sound = UISoundEvents.social_menu_receive_invite,
					options = {
						{
							text = "loc_social_party_invite_received_accept_button",
							close_on_pressed = true,
							hotkey = "confirm_pressed",
							callback = function ()
								self:join_party({
									party_id = party_id,
									invite_token = invite_token
								})

								self._invite_popups[party_id] = nil
							end
						},
						{
							text = "loc_social_party_invite_received_decline_button",
							close_on_pressed = true,
							hotkey = "back",
							callback = function ()
								self:_decline_party_invite(party_id, invite_token)

								self._invite_popups[party_id] = nil
							end
						},
						{
							text = "loc_social_party_invite_received_decline_and_block_button",
							close_on_pressed = true,
							hotkey = "hotkey_menu_special_2",
							on_pressed_sound = UISoundEvents.social_menu_block_player,
							callback = function ()
								self:_decline_party_invite(party_id, invite_token)
								Managers.data_service.social:block_account(inviter_account_id)

								self._invite_popups[party_id] = nil
							end
						}
					}
				}

				Managers.event:trigger("event_show_ui_popup", context, function (id)
					self._invite_popups[party_id] = id
				end)
			end):catch(function (error)
				self:_decline_party_invite(party_id, invite_token, error.error_details)
			end)
		end)
	end
end

PartyImmateriumManager._handle_immaterium_invite_canceled = function (self, party_id, invite_token, inviter_account_id, canceler_account_id)
	Log.info("PartyImmateriumManager", "invite canceled, party_id=%s, invite_token=%s, inviter_account_id=%s, canceler_account_id=%s", party_id, invite_token, inviter_account_id, canceler_account_id)
	self:_close_invite_popup(party_id)
end

PartyImmateriumManager._handle_immaterium_invite_timeout = function (self, party_id, invite_token, inviter_account_id)
	Log.info("PartyImmateriumManager", "invite timeout, party_id=%s, inviter_account_id=%s, inviter_account_id=%s", party_id, invite_token, inviter_account_id)
	self:_close_invite_popup(party_id)
end

PartyImmateriumManager._close_invite_popup = function (self, party_id)
	local popup = self._invite_popups[party_id]

	if popup then
		Managers.event:trigger("event_remove_ui_popup", popup)

		self._invite_popups[party_id] = nil
	end
end

PartyImmateriumManager._request_to_join_popup = function (self, joiner_account_id)
	Log.info("SocialService", "Got invite, joiner_account_id=%s", joiner_account_id)
	self:_close_request_to_join_popup(joiner_account_id)

	local _, promise = Managers.presence:get_presence(joiner_account_id)

	promise:next(function (inviter_presence)
		local character_name = inviter_presence:character_name()
		local character_profile = inviter_presence:character_profile()
		local character_level = character_profile and character_profile.current_level
		local player_name_and_level = nil

		if character_level then
			player_name_and_level = Localize("loc_social_menu_character_name_format", true, {
				character_level = character_level,
				character_name = character_name
			})
		end

		local context = {
			title_text = "loc_party_request_to_join_header",
			description_text = "loc_party_request_to_join_description",
			description_text_params = {
				player_name = player_name_and_level or character_name
			},
			enter_popup_sound = UISoundEvents.social_menu_receive_invite,
			options = {
				{
					text = "loc_party_request_to_join_accept_button",
					close_on_pressed = true,
					hotkey = "confirm_pressed",
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "OK_POPUP")

						self._request_to_join_popups[joiner_account_id] = nil
					end
				},
				{
					text = "loc_party_request_to_join_decline_button",
					close_on_pressed = true,
					hotkey = "back",
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "MEMBER_DECLINED_REQUEST_TO_JOIN")

						self._request_to_join_popups[joiner_account_id] = nil
					end
				},
				{
					text = "loc_social_party_request_to_join_decline_and_block_button",
					close_on_pressed = true,
					hotkey = "hotkey_menu_special_2",
					on_pressed_sound = UISoundEvents.social_menu_block_player,
					callback = function ()
						Managers.grpc:answer_request_to_join(self:party_id(), joiner_account_id, "MEMBER_DECLINED_REQUEST_TO_JOIN")
						Managers.data_service.social:block_account(joiner_account_id)

						self._request_to_join_popups[joiner_account_id] = nil
					end
				}
			}
		}

		Managers.event:trigger("event_show_ui_popup", context, function (id)
			self._request_to_join_popups[joiner_account_id] = id
		end)
	end)
end

PartyImmateriumManager._handle_request_to_join_popup_cancel = function (self, joiner_account_id)
	Log.info("SocialService", " request to join canceled joiner_account_id=%s", joiner_account_id)
	self:_close_request_to_join_popup(joiner_account_id)
end

PartyImmateriumManager._close_request_to_join_popup = function (self, joiner_account_id)
	local popup = self._request_to_join_popups[joiner_account_id]

	if popup then
		Managers.event:trigger("event_remove_ui_popup", popup)

		self._request_to_join_popups[joiner_account_id] = nil
	end
end

return PartyImmateriumManager
