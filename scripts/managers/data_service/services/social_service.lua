-- chunkname: @scripts/managers/data_service/services/social_service.lua

local PartyConstants = require("scripts/settings/network/party_constants")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local PlayerInfo = require("scripts/managers/data_service/services/social/player_info")
local PresenceEntryMyself = require("scripts/managers/presence/presence_entry_myself")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local Promise = require("scripts/foundation/utilities/promise")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local PartyState = PartyConstants.State
local Platforms = SocialConstants.Platforms
local OnlineStatus = SocialConstants.OnlineStatus
local PartyStatus = SocialConstants.PartyStatus
local FriendStatus = SocialConstants.FriendStatus
local HOST_TYPE_HUB_SERVER = "hub_server"
local HOST_TYPE_MISSION_SERVER = "mission_server"
local HOST_TYPE_SINGLEPLAY = "singleplay"
local PLATFORM_FRIENDS = 1
local PLATFORM_BLOCKED = 2
local SocialService = class("SocialService")

local function _warning(...)
	Log.warning("SocialService", ...)
end

SocialService.init = function (self, backend_interfaces)
	if LEVEL_EDITOR_TEST then
		local SocialDummy = require("scripts/managers/data_service/services/social/social_dummy")

		self._platform_social = SocialDummy:new()

		local InvitesDummy = require("scripts/managers/data_service/services/invites/invites_dummy")

		self._invites = InvitesDummy:new()
	else
		local platform = PresenceEntryMyself.get_platform()

		self._platform = platform

		if platform == Platforms.steam then
			local SocialSteam = require("scripts/managers/data_service/services/social/social_steam")

			self._platform_social = SocialSteam:new()

			local InvitesSteam = require("scripts/managers/data_service/services/invites/invites_steam")

			self._invites = InvitesSteam:new()
		elseif platform == Platforms.xbox then
			local SocialXboxLive = require("scripts/managers/data_service/services/social/social_xbox_live")

			self._platform_social = SocialXboxLive:new()

			local InvitesXboxLive = require("scripts/managers/data_service/services/invites/invites_xbox_live")

			self._invites = InvitesXboxLive:new()
		elseif platform == Platforms.psn then
			local SocialPSN = require("scripts/managers/data_service/services/social/social_psn")

			self._platform_social = SocialPSN:new()

			local InvitesPSN = require("scripts/managers/data_service/services/invites/invites_psn")

			self._invites = InvitesPSN:new()
		else
			local SocialDummy = require("scripts/managers/data_service/services/social/social_dummy")

			self._platform_social = SocialDummy:new()

			local InvitesDummy = require("scripts/managers/data_service/services/invites/invites_dummy")

			self._invites = InvitesDummy:new()
		end
	end

	self._backend_interfaces = backend_interfaces.social
	self._cached_group_finder_tags = nil
	self._friends_list = {}
	self._friends_list_promise = Promise.resolved()
	self._fatshark_friends_promise = Promise.resolved()
	self._friends_list_has_changed = true
	self._num_fatshark_friends = 0
	self._max_fatshark_friends = 0
	self._friend_invites_promise = Promise.resolved()
	self._friend_invites_has_changed = true
	self._recent_companions_promise = Promise.resolved()
	self._recent_companions_character_id = nil
	self._recent_companions_has_changed = true
	self._players_by_account_id = {}
	self._players_by_platform_user_id = {}
	self._party_members = {}
	self._num_party_members = 0
	self._blocked_accounts_list = {}
	self._blocked_accounts_list_promise = Promise.resolved()
	self._blocked_accounts_list_changed = true
	self._num_blocked_accounts = 0
	self._max_blocked_accounts = 0
	self._blocked_players_list = {}
	self._cb_presence_account_id_change = callback(self, "cb_presence_account_id_change")

	Managers.event:register(self, "party_immaterium_other_members_updated", "_party_immaterium_other_members_updated")
	Managers.event:register(self, "backend_friend_invite", "_event_friend_invite")
	Managers.event:register(self, "backend_friend_invite_accepted", "_event_friend_invite_accepted")
	Managers.event:register(self, "backend_friend_removed", "_event_friend_removed")
	Managers.event:register(self, "event_new_immaterium_entry", "_event_new_immaterium_entry")
	Managers.event:register(self, "event_on_social_blocklist_update", "_event_on_social_blocklist_update")
end

SocialService.destroy = function (self)
	self._platform_social:delete()

	self._platform_social = nil

	self._invites:delete()

	self._invites = nil
	self._backend_interfaces = nil

	Managers.event:unregister(self, "party_immaterium_other_members_updated")
	Managers.event:unregister(self, "backend_friend_invite")
	Managers.event:unregister(self, "backend_friend_invite_accepted")
	Managers.event:unregister(self, "backend_friend_removed")
	Managers.event:unregister(self, "event_new_immaterium_entry")
	Managers.event:unregister(self, "event_on_social_blocklist_update")
end

SocialService.reset = function (self)
	self._platform_social:reset()
end

SocialService.update = function (self, dt, t)
	if self._voting_id and not Managers.voting:voting_exists(self._voting_id) then
		self._voting_id = nil
	end

	self._platform_social:update(dt, t)
	self._invites:update()
	self:_check_split_party()
end

SocialService.on_profile_signed_in = function (self)
	local platform_user_id = Managers.account:platform_user_id()

	self._invites:on_profile_signed_in(platform_user_id)
end

SocialService.platform = function (self)
	return self._platform
end

SocialService.platform_display_name = function (self)
	local platform = self._platform

	if platform == Platforms.steam then
		return Localize("loc_platform_name_steam")
	elseif platform == Platforms.xbox then
		return Localize("loc_platform_name_xbox_live")
	elseif platform == Platforms.psn then
		return Localize("loc_platform_name_psn")
	end

	return ""
end

SocialService.is_in_hub = function (self)
	local host_type = Managers.connection:host_type()

	return host_type == HOST_TYPE_HUB_SERVER
end

SocialService.is_in_training_grounds = function (self)
	local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()

	return game_mode_name == "shooting_range"
end

SocialService.is_in_mission = function (self)
	local host_type = Managers.connection:host_type()

	return host_type == HOST_TYPE_MISSION_SERVER
end

SocialService.is_in_singleplay = function (self)
	local host_type = Managers.connection:host_type()

	return host_type == HOST_TYPE_SINGLEPLAY
end

SocialService.is_in_matchmaking = function (self)
	local immaterium_party_manager = Managers.party_immaterium
	local matchmaking_state = immaterium_party_manager:current_state()
	local is_in_matchmaking = matchmaking_state == PartyState.matchmaking or matchmaking_state == PartyState.matchmaking_acceptance_vote

	return is_in_matchmaking
end

local _temp_team_members = {}

SocialService.fetch_party_members = function (self)
	local promise = Promise:new()
	local temp_team_members = PlayerCompositions.players("party", _temp_team_members)

	if self:is_in_mission() then
		local dont_clear_table = true

		temp_team_members = PlayerCompositions.players("players", _temp_team_members, dont_clear_table)

		for unique_id_1, player_1 in pairs(temp_team_members) do
			for unique_id_2, player_2 in pairs(temp_team_members) do
				if unique_id_2 ~= unique_id_1 then
					local player_1_account_id = player_1:account_id()
					local player_2_account_id = player_2:account_id()

					if player_1_account_id == player_2_account_id then
						temp_team_members[unique_id_2] = nil
					end
				end
			end
		end

		for unique_id, player in pairs(temp_team_members) do
			if not player:is_human_controlled() then
				temp_team_members[unique_id] = nil
			end
		end
	end

	local party_members = self._party_members

	for current_member_unique_id, current_party_member in pairs(party_members) do
		if not temp_team_members[current_member_unique_id] then
			local player_info = party_members[current_member_unique_id]

			player_info:set_is_party_member(false)

			party_members[current_member_unique_id] = nil
		end
	end

	local num_party_members = 0

	for unique_id, player in pairs(temp_team_members) do
		if not party_members[unique_id] then
			local player_info = self:_get_player_info_for_player(player)

			player_info:set_is_party_member(true)

			party_members[unique_id] = player_info
		end

		num_party_members = num_party_members + 1
	end

	self._num_party_members = num_party_members

	promise:resolve(self._party_members)

	return promise
end

SocialService.fetch_friends = function (self, force_update)
	local platform_friends_manager = self._platform_social
	local friends_list_has_changed = force_update or self._friends_list_has_changed or platform_friends_manager:friends_list_has_changes()
	local friends_list_promise = self._friends_list_promise

	if not friends_list_has_changed or friends_list_promise:is_pending() then
		return friends_list_promise
	end

	local platform_friends_promise = self:_fetch_platform_friends()
	local fatshark_friends_promise = self:_fetch_fatshark_friends(force_update)
	local num_promises = 2

	local function aggregate_function(friends_data)
		local PLATFORM_FRIEND_LIST = 1
		local friends = {}

		self._friends_list_has_changed = false

		for friends_data_index = 1, num_promises do
			local friends_data_list = friends_data[friends_data_index]

			if friends_data_list then
				for friends_list_index = 1, #friends_data_list do
					local friend = friends_data_list[friends_list_index]

					if friends_data_index == PLATFORM_FRIEND_LIST then
						self:_get_player_info_by_platform_friend(friend:platform_social())
					end

					self:_update_player_info_platform_information(friend)
					self:_remove_friend_request_if_friends_or_blocked(friend)

					if friend:is_friend() then
						local is_duplicate = false
						local friend_platform_user_id = friend:platform_user_id()

						if friends_data_index > 1 then
							for i = 1, #friends do
								is_duplicate = is_duplicate or friends[i]:account_id() == friend:account_id()

								if friend_platform_user_id ~= "" and friends[i]:platform_user_id() == friend_platform_user_id then
									is_duplicate = true
									friends[i] = friend
								end
							end
						end

						if not is_duplicate then
							local is_blocked_friend = false

							if friends_data_index == PLATFORM_FRIEND_LIST then
								for _, playerinfo in pairs(self._blocked_accounts_list) do
									if playerinfo:platform_user_id() == friend:platform_user_id() then
										is_blocked_friend = true

										break
									end
								end
							end

							if not is_blocked_friend then
								friends[#friends + 1] = friend
							end
						end
					end
				end

				if friends_data_index == PLATFORM_FRIEND_LIST then
					self:_update_platform_players(friends_data_list, PLATFORM_FRIENDS)
				end
			else
				self._friends_list_has_changed = true
			end
		end

		self._friends_list = friends
		self._friend_invites_has_changed = true
		self._recent_companions_has_changed = true

		return friends
	end

	friends_list_promise = Promise.all(platform_friends_promise, fatshark_friends_promise):next(aggregate_function, aggregate_function)
	self._friends_list_promise = friends_list_promise

	return friends_list_promise
end

local _fetch_friend_invites_friend_invites = {}

SocialService.fetch_friend_invites = function (self, force_update)
	local friend_invites_promise = self._friend_invites_promise

	if not self._friend_invites_has_changed and not force_update or friend_invites_promise:is_pending() then
		return friend_invites_promise
	end

	friend_invites_promise = self:_fetch_fatshark_friends():next(function (friends_data)
		self._friend_invites_has_changed = false

		local friend_invites = _fetch_friend_invites_friend_invites

		if not friends_data then
			return friend_invites
		end

		table.clear_array(friend_invites, #friend_invites)

		for i = 1, #friends_data do
			local friend = friends_data[i]

			self:_update_player_info_platform_information(friend)
			self:_remove_friend_request_if_friends_or_blocked(friend)

			local friend_status = friend:friend_status()

			if friend_status == FriendStatus.invite or friend_status == FriendStatus.invited then
				friend_invites[#friend_invites + 1] = friend
			end
		end

		return friend_invites
	end)
	self._friend_invites_promise = friend_invites_promise

	return friend_invites_promise
end

local _seen_account_ids = {}
local _fetch_recent_companions_recent_companions = {}

SocialService.fetch_recent_companions = function (self, character_id, force_refresh)
	local recent_companions_promise = self._recent_companions_promise

	if self._recent_companions_character_id == character_id and not self._recent_companions_has_changed and (not force_refresh or recent_companions_promise:is_pending()) then
		return recent_companions_promise
	end

	recent_companions_promise = self._backend_interfaces:fetch_recently_played(character_id):next(function (data)
		self._recent_companions_has_changed = false

		local recent_companions = _fetch_recent_companions_recent_companions
		local seen_account_ids = _seen_account_ids

		table.clear(seen_account_ids)
		table.clear_array(recent_companions, #recent_companions)

		local recent_participants = data.recentParticipants

		table.sort(recent_participants, function (a, b)
			return a.playedAt > b.playedAt
		end)

		for i = 1, #recent_participants do
			local recent_companion = recent_participants[i]
			local account_id = recent_companion.accountId
			local account_name = recent_companion.accountName
			local player_info = self:get_player_info_by_account_id(account_id)

			self:_update_player_info_platform_information(player_info)
			player_info:set_account(account_id, account_name)

			if not _seen_account_ids[account_id] and not player_info:is_blocked() then
				local last_time_played_with = math.floor(tonumber(recent_companion.playedAt) / 1000)

				player_info:set_last_time_played_with(last_time_played_with)

				_seen_account_ids[account_id] = true
				recent_companions[#recent_companions + 1] = player_info
			end
		end

		return recent_companions
	end):catch(function (error)
		_warning(string.format("Failed fetching recently played with accounts: %s", error))

		return {}
	end)
	self._recent_companions_promise = recent_companions_promise
	self._recent_companions_character_id = character_id

	return recent_companions_promise
end

local _fetch_players_on_server_players_on_server = {}
local _fetch_players_on_server_composition_players = {}

SocialService.fetch_players_on_server = function (self)
	local players_on_server = _fetch_players_on_server_players_on_server
	local composition_players = _fetch_players_on_server_composition_players

	table.clear(players_on_server)

	local promise = Promise:new()
	local is_in_hub = self:is_in_hub()

	if is_in_hub then
		PlayerCompositions.players("players", composition_players)

		local players = Managers.player:human_players()

		for unique_id, player in pairs(players) do
			if player:is_human_controlled() then
				local player_info = self:_get_player_info_for_player(player)

				self:_update_player_info_platform_information(player_info)

				if not player_info:is_blocked() then
					players_on_server[#players_on_server + 1] = player_info
				end
			end
		end

		promise:resolve(players_on_server)
	else
		promise:resolve(players_on_server)
	end

	return promise
end

SocialService.fetch_blocked_accounts = function (self, force_update, skip_platform)
	local communication_restriction_iteration = Managers.account:communication_restriction_iteration()
	local platform_friends_manager = self._platform_social
	local blocked_list_has_changed = force_update or self._blocked_accounts_list_changed or self._current_communication_restriction_iteration ~= communication_restriction_iteration or platform_friends_manager:blocked_list_has_changes()
	local blocked_accounts_promise = self._blocked_accounts_list_promise

	if not blocked_list_has_changed or blocked_accounts_promise:is_pending() then
		return blocked_accounts_promise
	end

	local fatshark_blocked_promise = self._backend_interfaces:fetch_blocked_accounts()
	local platform_blocked_promise = skip_platform and Promise.resolved(nil) or self._platform_social:fetch_blocked_list()

	blocked_accounts_promise = Promise.all(platform_blocked_promise, fatshark_blocked_promise):next(function (data)
		local PLATFORM_BLOCKED_LIST = 1
		local FATSHARK_BLOCKED_LIST = 2

		self._blocked_accounts_list_changed = false
		self._current_communication_restriction_iteration = Managers.account:communication_restriction_iteration()

		local platform_blocked_data = data[PLATFORM_BLOCKED_LIST]
		local fatshark_blocked_data = data[FATSHARK_BLOCKED_LIST]
		local blocked_accounts = fatshark_blocked_data and fatshark_blocked_data.blockList or {}

		self._max_blocked_accounts = fatshark_blocked_data.maxBlocks or 0

		self:_update_blocked_players(blocked_accounts, platform_blocked_data)

		if not fatshark_blocked_data or not platform_blocked_data then
			self._blocked_accounts_list_changed = true
		end

		self._friend_invites_has_changed = true
		self._recent_companions_has_changed = true
		self._friends_list_has_changed = true

		return blocked_accounts
	end):catch(function (error)
		_warning(string.format("Failed fetching blocked accounts: %s", error))

		return Promise.rejected(error)
	end)
	self._blocked_accounts_list_promise = blocked_accounts_promise

	return blocked_accounts_promise
end

SocialService.fetch_blocked_players = function (self, force_update)
	return self:fetch_blocked_accounts(force_update):next(function (data)
		return self._blocked_players_list
	end)
end

SocialService.has_invite = function (self)
	return self._invites:has_invite()
end

SocialService.get_invite = function (self)
	return self._invites:get_invite()
end

SocialService.can_join_party = function (self, player_info)
	if player_info:online_status() ~= OnlineStatus.online then
		return false, nil
	end

	local player_party_id = player_info:party_id()

	if not player_party_id then
		return false, nil
	end

	local player_party_status = player_info:party_status()

	if player_party_status == PartyStatus.mine then
		local reason = "loc_social_party_join_rejection_reason_same_party"

		return false, reason
	elseif player_party_status == PartyStatus.invite_pending then
		local reason = "loc_social_party_join_rejection_reason_invite_pending"

		return false, reason
	end

	local cross_play_ok, fail_reason = self:_check_cross_play_join(player_info)

	if not cross_play_ok then
		return false, fail_reason
	end

	local player_activity = player_info:player_activity_id()
	local presence_settings = PresenceSettings.settings[player_activity]

	if not presence_settings.can_be_joined then
		return false, presence_settings.fail_reason_other
	end

	if player_activity == "mission" then
		local player_num_party_members = player_info:num_mission_members()

		if player_num_party_members == SocialConstants.max_num_party_members then
			local reason = "loc_social_party_join_rejection_reason_party_full"

			return false, reason
		end
	else
		local player_num_party_members = player_info:num_party_members()

		if player_num_party_members == SocialConstants.max_num_party_members then
			local reason = "loc_social_party_join_rejection_reason_party_full"

			return false, reason
		end
	end

	local local_player_can_join, fail_reason = self:local_player_can_join_party()

	if not local_player_can_join then
		return false, fail_reason
	end

	return true
end

SocialService.local_player_can_join_party = function (self)
	local activity_id = Managers.presence:presence()
	local presence_settings = PresenceSettings.settings[activity_id]

	if not presence_settings.can_be_invited then
		local reason = presence_settings.fail_reason_myself

		return false, reason, activity_id
	end

	return true
end

SocialService.local_player_is_joinable = function (self)
	local activity_id = Managers.presence:presence()
	local presence_settings = PresenceSettings.settings[activity_id]
	local can_be_joined = presence_settings.can_be_joined

	return can_be_joined
end

SocialService._check_split_party = function (self)
	if GameParameters.prod_like_backend and Managers.party_immaterium and Managers.party_immaterium:num_other_members() > 0 then
		local activity_id = Managers.presence:presence()
		local presence_settings = PresenceSettings.settings[activity_id]

		if presence_settings.split_party then
			Managers.party_immaterium:leave_party()
		end
	end
end

SocialService.can_invite_to_party = function (self, player_info)
	local player_online_status = player_info:online_status()

	if player_online_status ~= OnlineStatus.online and player_online_status ~= OnlineStatus.platform_online then
		return false, nil
	end

	local player_party_status = player_info:party_status()

	if player_party_status == PartyStatus.mine then
		local reason = "loc_social_party_join_rejection_reason_same_party"

		return false, reason
	elseif player_party_status == PartyStatus.invite_pending then
		local reason = "loc_social_party_join_rejection_reason_invite_pending"

		return false, reason
	end

	local player_num_party_members = self._num_party_members

	if player_num_party_members == SocialConstants.max_num_party_members then
		local reason = "loc_social_party_join_rejection_reason_party_full"

		return false, reason
	end

	local cross_play_ok, fail_reason = self:_check_cross_play_invite(player_info)

	if not cross_play_ok then
		return false, fail_reason
	end

	if player_online_status == OnlineStatus.online then
		local player_activity = player_info:player_activity_id()
		local presence_settings = PresenceSettings.settings[player_activity]

		if not presence_settings.can_be_invited then
			return false, presence_settings.fail_reason_other
		end
	end

	local my_activity = Managers.presence:presence()
	local my_presence_settings = PresenceSettings.settings[my_activity]

	if not my_presence_settings.can_be_joined then
		return false, my_presence_settings.fail_reason_myself
	end

	return true
end

SocialService._check_cross_play_invite = function (self, other_player_info)
	local platform_myself = self:platform()
	local platform_other = other_player_info:platform()
	local presence_myself = Managers.presence:presence_entry_myself()

	if other_player_info:cross_play_disabled() then
		if platform_myself ~= platform_other then
			return false, "loc_cross_play_disabled_by_other"
		elseif presence_myself:is_cross_playing() then
			return false, "loc_cross_play_disabled_by_other_my_team_is_cross_platform"
		end
	end

	if presence_myself:cross_play_disabled_in_party() and platform_myself ~= platform_other then
		if presence_myself:cross_play_disabled() then
			return false, "loc_cross_play_disabled_by_me"
		else
			return false, "loc_cross_play_disabled_in_my_team"
		end
	end

	return true
end

SocialService._check_cross_play_join = function (self, other_player_info)
	local platform_myself = self:platform()
	local platform_other = other_player_info:platform()
	local presence_myself = Managers.presence:presence_entry_myself()

	if presence_myself:cross_play_disabled() then
		if platform_myself ~= platform_other then
			return false, "loc_cross_play_disabled_by_me"
		elseif other_player_info:is_cross_playing() then
			return false, "loc_cross_play_disabled_by_me_other_team_is_cross_platform"
		end
	end

	if other_player_info:cross_play_disabled_in_party() and platform_myself ~= platform_other then
		if other_player_info:cross_play_disabled() then
			return false, "loc_cross_play_disabled_by_other"
		else
			return false, "loc_cross_play_disabled_in_other_team"
		end
	end

	return true
end

SocialService.send_party_invite = function (self, invitee_player_info)
	local has_party_id = Managers.party_immaterium:party_id() ~= nil

	if not has_party_id then
		return
	end

	local invitee_online_status = invitee_player_info:online_status()
	local invitee_platform = invitee_player_info:platform()
	local invitee_platform_id = invitee_player_info:platform_user_id()
	local same_platform = self._platform == invitee_platform
	local is_online = invitee_online_status == OnlineStatus.online

	if is_online and (not same_platform or self._platform ~= Platforms.xbox and self._platform ~= Platforms.psn) then
		Managers.party_immaterium:invite_to_party(invitee_player_info:account_id()):catch(function (error)
			_warning("invite_to_party failed with %s", table.tostring(error, 3))
		end)

		return
	end

	local has_platform = self._platform and self._platform ~= Platforms.lan
	local is_available = is_online or invitee_online_status == OnlineStatus.platform_online

	if has_platform and is_available and same_platform then
		Managers.party_immaterium:get_invite_code_for_platform_invite(invitee_platform, invitee_platform_id):next(function (invite_code)
			self._invites:send_invite(invitee_platform_id, invite_code)
		end):catch(function (error)
			_warning("invite_platform_user_to_party failed with %s", table.tostring(error, 3))
		end)

		return
	end

	_warning("Failed to send invite.")
end

SocialService.cancel_party_invite = function (self, invitee_player_info)
	local invite = Managers.party_immaterium:get_invite_by_account_id(invitee_player_info:account_id())

	if invite then
		Managers.party_immaterium:cancel_party_invite(invite.invite_token)
	end
end

SocialService.join_party = function (self, party_id, context_account_id)
	return Managers.party_immaterium:join_party({
		party_id = party_id,
		context_account_id = context_account_id
	})
end

SocialService.leave_party = function (self)
	Managers.party_immaterium:leave_party()
end

SocialService._get_kick_voting_template = function (self, player_info)
	local party_status = player_info:party_status()
	local is_in_mission = self:is_in_mission()
	local voting_template

	if is_in_mission and (party_status == PartyStatus.same_mission or party_status == PartyStatus.mine) then
		voting_template = "kick_from_mission"
	end

	return voting_template
end

SocialService.can_kick_from_party = function (self, player_info)
	local party_status = player_info:party_status()

	if party_status ~= PartyStatus.same_mission and party_status ~= PartyStatus.mine then
		return false
	end

	if self._num_party_members < SocialConstants.min_num_party_members_to_vote then
		return false, "loc_social_fail_too_few_to_kick_vote"
	end

	if self:_is_havoc_mission_order_owner(player_info) then
		return false, "loc_havoc_cannot_kick_order_owner"
	end

	local peer_id = player_info:peer_id()
	local voting_template = self:_get_kick_voting_template(player_info)

	if not voting_template or not Managers.voting:can_start_voting("kick_from_mission", {
		kick_peer_id = peer_id
	}) then
		return false
	end

	return true
end

SocialService._is_havoc_mission_order_owner = function (self, player_info)
	if not GameParameters.prod_like_backend then
		return false
	end

	local mission_data = Managers.party_immaterium:current_game_session_mission_data()
	local mission = mission_data and mission_data.mission

	if not mission or mission.category ~= "havoc" then
		return false
	end

	if mission.flags then
		for flag_key, _ in pairs(mission.flags) do
			if flag_key:find("^order%-owner%-") then
				local owner_account_id = flag_key:sub(#"order-owner-" + 1)
				local is_order_owner = math.is_uuid(owner_account_id) and owner_account_id == player_info:account_id()

				return is_order_owner
			end
		end
	end

	return false
end

SocialService.initiate_kick_vote = function (self, player_info)
	local peer_id = player_info:peer_id()

	if self._voting_id or not peer_id then
		return
	end

	local voting_template = self:_get_kick_voting_template(player_info)

	if voting_template then
		Managers.voting:start_voting(voting_template, {
			kick_peer_id = peer_id
		}):next(function (data)
			self._voting_id = data
		end):catch(function (fail_reason)
			Log.info("SocialService", fail_reason)

			self._voting_id = nil
		end)
	end
end

SocialService.can_befriend = function (self)
	if self._num_fatshark_friends >= self._max_fatshark_friends then
		local reason = "loc_social_cannot_befriend_reason_max_num_friends"

		return false, reason
	end

	return true
end

SocialService.send_friend_request = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]
	local friend_status

	if player_info then
		friend_status = player_info:friend_status()

		player_info:set_friend_status(FriendStatus.invited)
	end

	return self._backend_interfaces:send_friend_request(account_id, "POST"):next(function (data)
		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end):catch(function (error)
		_warning(string.format("Failed sending friend request to %s: %s", account_id, error))

		if player_info and friend_status then
			player_info:set_friend_status(friend_status)
		end

		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end)
end

SocialService.accept_friend_request = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]
	local friend_status

	if player_info then
		friend_status = player_info:friend_status()

		player_info:set_friend_status(FriendStatus.friend)
	end

	return self._backend_interfaces:send_friend_request(account_id, "PUT"):next(function (data)
		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end):catch(function (error)
		_warning(string.format("Failed sending friend request to %s: %s", account_id, error))

		if player_info and friend_status then
			player_info:set_friend_status(friend_status)
		end

		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end)
end

SocialService.reject_friend_request = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]
	local friend_status

	if player_info then
		friend_status = player_info:friend_status()

		player_info:set_friend_status(FriendStatus.none)
	end

	return self._backend_interfaces:send_friend_request(account_id, "PATCH"):next(function (data)
		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end):catch(function (error)
		_warning(string.format("Failed sending friend request to %s: %s", account_id, error))

		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end)
end

SocialService.cancel_friend_request = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]

	if player_info then
		player_info:set_friend_status(FriendStatus.none)
	end

	return self._backend_interfaces:send_friend_request(account_id, "DELETE"):next(function (data)
		player_info:set_friend_status(FriendStatus.none)

		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end):catch(function (error)
		_warning(string.format("Failed canceling friend request to %s: %s", account_id, error))
	end)
end

SocialService.unfriend_player = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]
	local friend_status

	if player_info then
		friend_status = player_info:friend_status()

		player_info:set_friend_status(FriendStatus.none)
	end

	return self._backend_interfaces:unfriend_player(account_id):next(function (data)
		player_info:set_friend_status(FriendStatus.none)

		self._friends_list_has_changed = true
		self._friend_invites_has_changed = true
	end):catch(function (error)
		_warning(string.format("Failed to un-friend %s: %s", account_id, error))
	end)
end

SocialService.has_unread_notifications = function (self)
	return self._invites:has_invite()
end

SocialService.can_toggle_mute_in_text_chat = function (self, account_id, platform_user_id)
	local player_info = account_id and self._players_by_account_id[account_id]

	if not player_info or player_info:online_status() ~= OnlineStatus.online then
		local reason = "loc_social_fail_reason_user_not_online"

		return false, reason
	end

	if player_info:is_blocked() then
		return false
	end

	if IS_GDK or IS_XBS then
		local platform = player_info:platform()

		if platform ~= self:platform() then
			local relation = player_info:is_friend() and XblAnonymousUserType.CrossNetworkFriend or XblAnonymousUserType.CrossNetworkUser

			if Managers.account:has_crossplay_restriction(relation, XblPermission.CommunicateUsingText) then
				local reason = "loc_social_fail_reason_platform_muted"

				return false, reason
			end
		end
	elseif IS_PLAYSTATION then
		local platform = player_info:platform()

		if platform ~= self:platform() and Managers.account:has_crossplay_restriction() then
			local reason = "loc_social_fail_reason_platform_muted"

			return false, reason
		end
	end

	return true
end

SocialService.mute_player_in_text_chat = function (self, account_id, is_muted)
	local player_info = self:get_player_info_by_account_id(account_id)

	player_info:set_is_text_muted(is_muted)
end

SocialService.can_toggle_mute_in_voice_chat = function (self, account_id, platform_user_id)
	local player_info = account_id and self._players_by_account_id[account_id]

	if not player_info or player_info:online_status() ~= OnlineStatus.online then
		local reason = "loc_social_fail_reason_user_not_online"

		return false, reason
	end

	if player_info:is_blocked() then
		return false
	end

	if Managers.account:is_muted(platform_user_id) then
		local reason = "loc_social_fail_reason_platform_muted"

		return false, reason
	end

	if IS_GDK or IS_XBS then
		local platform = player_info:platform()

		if platform ~= self:platform() then
			local relation = player_info:is_friend() and XblAnonymousUserType.CrossNetworkFriend or XblAnonymousUserType.CrossNetworkUser

			if Managers.account:has_crossplay_restriction(relation, XblPermission.CommunicateUsingVoice) then
				local reason = "loc_social_fail_reason_platform_muted"

				return false, reason
			end
		end
	elseif IS_PLAYSTATION then
		local platform = player_info:platform()

		if platform ~= self:platform() and Managers.account:has_crossplay_restriction() then
			local reason = "loc_social_fail_reason_platform_muted"

			return false, reason
		end
	end

	return true
end

SocialService.mute_player_in_voice_chat = function (self, account_id, is_muted)
	local player_info = self:get_player_info_by_account_id(account_id)

	player_info:set_is_voice_muted(is_muted)
end

SocialService.can_block = function (self, account_id)
	local player_info = account_id and self._players_by_account_id[account_id]

	if not player_info or player_info:online_status() ~= OnlineStatus.online then
		local reason = "loc_social_fail_reason_user_not_online"

		return false, reason
	elseif self._num_blocked_accounts >= self._max_blocked_accounts then
		local reason = "loc_social_cannot_block_reason_max_num_reached"

		return false, reason
	end

	return true
end

SocialService.is_account_blocked = function (self, account_id)
	return self:fetch_blocked_accounts():next(function (blocked_accounts)
		if blocked_accounts[account_id] ~= nil then
			return true
		end

		local player_info = self._players_by_account_id[account_id]

		return player_info and player_info:is_blocked() or false
	end)
end

SocialService.block_account = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]

	if player_info then
		player_info:set_is_blocked(true)

		self._friends_list_has_changed = true
		self._blocked_accounts_list_changed = true
	end

	return self._backend_interfaces:add_blocked_account(account_id):catch(function (error)
		_warning(string.format("Failed blocking account %s: %s", account_id, error))

		if player_info then
			player_info:set_is_blocked(false)

			self._friends_list_has_changed = true
			self._blocked_accounts_list_changed = true
		end
	end)
end

SocialService.unblock_account = function (self, account_id)
	local player_info = self._players_by_account_id[account_id]

	if player_info then
		player_info:set_is_blocked(false)

		self._friends_list_has_changed = true
		self._blocked_accounts_list_changed = true
	end

	return self._backend_interfaces:remove_blocked_account(account_id):catch(function (error)
		_warning(string.format("Failed unblocking account %s: %s", account_id, error))
	end)
end

SocialService._fetch_platform_friends = function (self)
	local platform_friends_manager = self._platform_social

	return platform_friends_manager:fetch_friends_list():next(function (platform_friends_data)
		local friends = {}

		for i = 1, #platform_friends_data do
			local friend = platform_friends_data[i]
			local player_info = self:_get_player_info_by_platform_friend(friend)

			friends[i] = player_info
		end

		return friends
	end):catch(function (error)
		_warning(string.format("Failed fetching %s friends: %s", self._platform, error))
	end)
end

SocialService.fetch_platform_block_list_ids_forced = function (self)
	local platform_friends_manager = self._platform_social

	return platform_friends_manager:fetch_blocked_list_ids_forced()
end

SocialService._fetch_fatshark_friends = function (self, force_update)
	local fatshark_friends_promise = self._fatshark_friends_promise
	local list_has_changed = force_update or self._friends_list_has_changed or self._friend_invites_has_changed

	if not list_has_changed or fatshark_friends_promise:is_pending() then
		return fatshark_friends_promise
	end

	fatshark_friends_promise = self._backend_interfaces:fetch_friends():next(function (fatshark_friends_data)
		self._max_fatshark_friends = fatshark_friends_data.maxFriends

		local fatshark_friends = fatshark_friends_data.friends
		local friends = {}

		for i = 1, #fatshark_friends do
			local friend_data = fatshark_friends[i]
			local account_id = friend_data.accountId
			local account_name = friend_data.accountName
			local friend_status = friend_data.status
			local player_info = self:get_player_info_by_account_id(account_id)

			player_info:set_account(account_id, account_name)
			player_info:set_friend_status(friend_status)

			friends[i] = player_info
		end

		return friends
	end):catch(function (error)
		_warning(string.format("Failed fetching fatshark friends: %s", error))
	end)
	self._fatshark_friends_promise = fatshark_friends_promise

	return fatshark_friends_promise
end

SocialService._update_blocked_players = function (self, blocked_accounts, platform_blocked_accounts)
	local platform_block_count = platform_blocked_accounts and #platform_blocked_accounts or 0
	local platform_player_info = {}

	for i = 1, platform_block_count do
		local blocked_account = platform_blocked_accounts[i]
		local player_info = self:_get_player_info_by_platform_friend(blocked_account)

		self:_remove_friend_request_if_friends_or_blocked(player_info)
		table.insert(platform_player_info, player_info)
	end

	self:_update_platform_players(platform_player_info, PLATFORM_BLOCKED)

	local blocked_players_list = self._blocked_players_list

	table.clear_array(blocked_players_list, #blocked_players_list)

	local blocked_accounts_list = self._blocked_accounts_list
	local previous_blocked_players = table.clone_instance(self._blocked_accounts_list)

	for account_id, account_info in pairs(blocked_accounts) do
		local account_name = account_info.accountName

		previous_blocked_players[account_id] = nil

		local player_info = self:get_player_info_by_account_id(account_id)

		player_info:set_account(account_id, account_name)
		player_info:set_is_blocked(true)
		self:_remove_friend_request_if_friends_or_blocked(player_info)
		self:_update_player_info_platform_information(player_info)

		if not player_info:is_platform_blocked() then
			blocked_players_list[#blocked_players_list + 1] = player_info
		end

		blocked_accounts_list[account_id] = player_info
	end

	local players_by_account_id = self._players_by_account_id

	for account_id in pairs(previous_blocked_players) do
		local player_info = players_by_account_id[account_id]

		if player_info and not player_info:is_platform_blocked() then
			player_info:set_is_blocked(false)
		end

		blocked_accounts_list[account_id] = nil
	end

	for _, player_info in pairs(players_by_account_id) do
		self:_update_player_info_platform_information(player_info)
	end

	self._num_blocked_accounts = #blocked_players_list

	Managers.event:trigger("event_update_player_name")
end

SocialService._get_player_info_for_player = function (self, player)
	local account_id = player:account_id()
	local player_info = self:get_player_info_by_account_id(account_id)

	return player_info
end

SocialService._get_player_info_by_platform_friend = function (self, friend)
	local players_by_platform_user_id = self._players_by_platform_user_id
	local platform_user_id = friend:id()
	local player_info = players_by_platform_user_id[platform_user_id]

	if not player_info then
		player_info = PlayerInfo:new(self._cb_presence_account_id_change)
		players_by_platform_user_id[platform_user_id] = player_info
	end

	player_info:set_platform_social(friend)
	player_info:online_status()

	return player_info
end

SocialService.get_player_info_by_account_id = function (self, account_id)
	local players_by_account_id = self._players_by_account_id
	local player_info = players_by_account_id[account_id]

	if not player_info then
		player_info = PlayerInfo:new(self._cb_presence_account_id_change)

		player_info:set_account(account_id)

		players_by_account_id[account_id] = player_info

		self:_update_player_info_platform_information(player_info)
	end

	return player_info
end

SocialService.cb_presence_account_id_change = function (self, updated_player_info)
	local account_id = updated_player_info:account_id()
	local player_info = self._players_by_account_id[account_id]

	if not player_info then
		self._players_by_account_id[account_id] = updated_player_info
		player_info = updated_player_info
	end

	local platform_social = updated_player_info:platform_social()

	if platform_social then
		if platform_social ~= player_info:platform_social() then
			player_info:set_platform_social(platform_social)
		end

		self._players_by_platform_user_id[account_id] = player_info
	end

	self._friends_list_has_changed = true
end

SocialService.update_recent_players = function (self, account_id)
	self._platform_social:update_recent_players(account_id)
end

SocialService._party_immaterium_other_members_updated = function (self, other_immaterium_members)
	for _, member in ipairs(other_immaterium_members) do
		local account_id = member:account_id()

		self:update_recent_players(account_id)
	end
end

SocialService._event_friend_invite = function (self, data)
	self._friend_invites_has_changed = true
end

SocialService._event_friend_invite_accepted = function (self, data)
	self._friend_invites_has_changed = true
	self._friends_list_has_changed = true
end

SocialService._event_friend_removed = function (self, data)
	self._friends_list_has_changed = true
end

SocialService._event_new_immaterium_entry = function (self, new_immaterium_entry)
	local account_id = new_immaterium_entry.account_id

	if account_id ~= "" then
		local player_info = self:get_player_info_by_account_id(account_id)
		local old_platform_social = player_info:platform_social()

		self:_update_player_info_platform_information(player_info)

		if old_platform_social == nil then
			Managers.event:trigger("event_update_player_name")
		end
	end
end

SocialService._event_on_social_blocklist_update = function (self)
	self:fetch_blocked_players()
end

SocialService._update_platform_players = function (self, platform_accounts, account_type)
	local players_by_platform_user_id = self._players_by_platform_user_id

	if platform_accounts then
		for key, value in pairs(players_by_platform_user_id) do
			local current_user = players_by_platform_user_id[key]

			if current_user then
				local found_user = false

				for i = 1, #platform_accounts do
					if platform_accounts[i]:platform_user_id() == key then
						found_user = true

						break
					end
				end

				if not found_user then
					local platform_social = current_user:platform_social()

					if platform_social then
						local is_friend_account = account_type == PLATFORM_FRIENDS and not platform_social:is_blocked()
						local is_blocked_account = account_type == PLATFORM_BLOCKED and platform_social:is_blocked()

						if is_friend_account or is_blocked_account then
							players_by_platform_user_id[key] = nil
						end
					end
				end
			end
		end
	end
end

SocialService._update_player_info_platform_information = function (self, player_info)
	local players_by_platform_user_id = self._players_by_platform_user_id
	local platform_user_id = player_info:platform_user_id()
	local platform_player_info = platform_user_id and players_by_platform_user_id[platform_user_id]

	player_info:set_platform_social(platform_player_info and platform_player_info:platform_social())
end

SocialService.get_fatshark_id = function (self)
	return self._backend_interfaces:get_fatshark_id()
end

SocialService.get_player_info_by_fatshark_id = function (self, fatshark_id)
	return self._backend_interfaces:get_account_by_fatshark_id(fatshark_id):next(function (body)
		if body then
			local player_info = self:get_player_info_by_account_id(body.accountId)

			player_info:set_account(body.accountId, body.accountName)

			return player_info:first_update_promise()
		else
			return nil
		end
	end)
end

SocialService._remove_friend_request_if_friends_or_blocked = function (self, player_info)
	local platform_friend_status = player_info:platform_friend_status()
	local friend_status = player_info:friend_status()
	local is_platform_friend_and_invited = platform_friend_status == FriendStatus.friend and friend_status == FriendStatus.invited
	local is_blocked_and_invited = player_info:is_blocked() and friend_status == FriendStatus.invited
	local is_blocked_and_invite = player_info:is_blocked() and friend_status == FriendStatus.invite

	if is_platform_friend_and_invited or is_blocked_and_invited then
		self:cancel_friend_request(player_info:account_id())
	elseif is_blocked_and_invite then
		self:reject_friend_request(player_info:account_id())
	end
end

SocialService.platform_unfriend_reason_for_disabled = function (self)
	local platform = self._platform

	if platform == Platforms.steam then
		return Localize("loc_platform_unfriend_reason_for_disabled_steam")
	elseif platform == Platforms.xbox then
		return Localize("loc_platform_unfriend_reason_for_disabled_xbox")
	elseif platform == Platforms.psn then
		return Localize("loc_platform_unfriend_reason_for_disabled_psn")
	end

	return ""
end

SocialService.get_group_finder_tags = function (self)
	local promise

	if self._cached_group_finder_tags then
		promise = Promise.resolved(self._cached_group_finder_tags)
	else
		promise = self._backend_interfaces:fetch_group_finder_tags():next(function (data)
			self._cached_group_finder_tags = data

			return data
		end):catch(function (error)
			local error_string = tostring(error)

			Log.error("SocialService", "Error fetching group finder tags: %s", error_string)

			return {}
		end)
	end

	return promise:next(function (data)
		return data
	end)
end

return SocialService
