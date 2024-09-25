-- chunkname: @scripts/managers/presence/presence_manager.lua

local PresenceEntryMyself = require("scripts/managers/presence/presence_entry_myself")
local PresenceEntryImmaterium = require("scripts/managers/presence/presence_entry_immaterium")
local PresenceManagerInterface = require("scripts/managers/presence/presence_manager_interface")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local LoggedInFromAnotherLocationError = require("scripts/managers/error/errors/logged_in_from_another_location_error")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local PresenceManager = class("PresenceManager")
local PRESENCE_UPDATE_INTERVAL = 30
local ACTIVITY_CHECK_INTERVAL = 0.5
local CROSS_PLAY_CHECK_INTERVAL = 3
local BATCHED_PRESENCE_STREAM_MAX_SIZE = 200

local function _info(...)
	Log.info("PresenceManager", ...)
end

local function _error(...)
	Log.error("PresenceManager", ...)
end

local function remove_empty_values(t)
	if table.is_empty(t) then
		return t
	end

	local result = {}

	for k, v in pairs(t) do
		if v ~= nil then
			result[k] = v
		end
	end

	return result
end

PresenceManager.init = function (self)
	self._myself = PresenceEntryMyself:new()
	self._presences_by_account_id = {}
	self._presences_by_platform_id = {}
	self._character_name_update_interval = 0
	self._update_interval = 0
	self._next_activity_check = 0
	self._next_cross_play_check = 0
	self._advertise_playing = false

	if IS_XBS or IS_GDK then
		self._load_buffer_in_flight = nil
		self._load_buffer_request_xbox_gamertag = {}
		self._load_buffer_request_xbox_gamertag_length = 0
		self._last_request_xbox_gamertag = 0
		self._loaded_xbox_gamertags = {}
	end

	self._batched_presence_streams = {}
	self._entry_to_stream_id = {}
	self._initialized = false
end

PresenceManager.destroy = function (self)
	if self._advertise_playing then
		self:_delete_platform_presence()

		self._advertise_playing = false
	end
end

PresenceManager.initialize = function (self)
	self._initialized = true

	self:_init_immaterium_presence()
	self:_init_batched_get_presence(nil)
end

PresenceManager.reset = function (self)
	if not self._initialized then
		return
	end

	self._initialized = false

	if self._my_presence_stream then
		self._my_presence_stream:abort()

		self._my_presence_stream = nil
	end

	local batched_presence_streams = self._batched_presence_streams

	for i = 1, #batched_presence_streams do
		local data = batched_presence_streams[i]

		data.stream:abort()
	end

	table.clear(batched_presence_streams)
	table.clear(self._entry_to_stream_id)

	for id, presence in pairs(self._presences_by_account_id) do
		presence:destroy()

		self._presences_by_account_id[id] = nil
	end

	for platform, platform_table in pairs(self._presences_by_platform_id) do
		for id, presence in pairs(platform_table) do
			presence:destroy()

			platform_table[id] = nil
		end
	end

	self._myself:reset()

	if IS_PLAYSTATION then
		Managers.account:leave_psn_session()
	end
end

PresenceManager.presence = function (self)
	return self._myself:activity_id()
end

PresenceManager.presence_entry_myself = function (self)
	return self._myself
end

PresenceManager.set_party = function (self, party_id, num_party_members)
	local joined_new_party = party_id ~= self._myself:party_id()

	self._myself:set_party_id(party_id)
	self._myself:set_num_party_members(num_party_members)
	self:_update_my_presence({
		num_party_members = true,
		party_id = true,
	})

	if self._advertise_playing then
		self:_update_platform_presence()
	end

	if IS_PLAYSTATION then
		if joined_new_party then
			self:_create_or_join_psn_session()
		else
			Managers.account:is_psn_session_leader():next(function (is_leader)
				if is_leader then
					self:_max_psn_session_players():next(function (max_players)
						Managers.account:update_psn_session_max_players(max_players)
					end)
				end
			end)
		end
	end
end

PresenceManager.set_character_profile = function (self, character_profile)
	self._myself:set_character_profile(character_profile)
	self:_update_my_presence({
		character_profile = true,
	})
end

PresenceManager.set_cross_play_disabled = function (self, disabled)
	self._myself:set_cross_play_disabled(disabled)
	self:_update_my_presence({
		cross_play_disabled = true,
	})
end

PresenceManager._set_cross_play_disabled_in_party = function (self, disabled)
	self._myself:set_cross_play_disabled_in_party(disabled)
	self:_update_my_presence({
		cross_play_disabled_in_party = true,
	})
end

PresenceManager._set_is_cross_playing = function (self, value)
	self._myself:set_is_cross_playing(value)
	self:_update_my_presence({
		is_cross_playing = true,
	})
end

PresenceManager.set_psn_session_id = function (self, session_id)
	self._myself:set_psn_session_id(session_id)
	self:_update_my_presence({
		psn_session_id = true,
	})
end

PresenceManager.get_presence = function (self, account_id)
	if account_id == gRPC.get_account_id() then
		local myself = self:presence_entry_myself()

		return myself, Promise.resolved(myself)
	end

	local presence_entry = self._presences_by_account_id[account_id]

	if not presence_entry then
		presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), "", account_id)
		self._presences_by_account_id[account_id] = presence_entry

		presence_entry:start_stream()
	end

	return presence_entry, presence_entry:first_update_promise()
end

PresenceManager.get_presences = function (self, account_ids)
	local promises = {}

	for i = 1, #account_ids do
		local account_id = account_ids[i]
		local _, promise = self:get_presence(account_id)

		promises[i] = promise
	end

	return Promise.all(unpack(promises))
end

PresenceManager.get_presence_by_platform = function (self, platform, platform_user_id)
	local platform_table = self._presences_by_platform_id[platform]

	if not platform_table then
		platform_table = {}
		self._presences_by_platform_id[platform] = platform_table
	end

	local presence_entry = platform_table[platform_user_id]

	if not presence_entry then
		presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), platform, platform_user_id)
		platform_table[platform_user_id] = presence_entry

		presence_entry:start_stream()
	end

	return presence_entry, presence_entry:first_update_promise()
end

PresenceManager._init_immaterium_presence = function (self)
	self._my_presence_stream = Managers.grpc:start_presence(self._myself:create_key_values())
end

PresenceManager._init_batched_get_presence = function (self, stream_id)
	local batched_presence_streams = self._batched_presence_streams

	if stream_id then
		if batched_presence_streams[stream_id] then
			batched_presence_streams[stream_id].stream:abort()
		end
	else
		stream_id = #batched_presence_streams + 1
	end

	batched_presence_streams[stream_id] = {
		restarting = false,
		stream = Managers.grpc:get_batched_presence_stream(),
		entry_to_request_id = {},
	}

	return stream_id
end

PresenceManager._get_batched_presence = function (self, entry, platform, platform_user_id)
	local stream_id = self._entry_to_stream_id[entry]
	local batched_presence_streams = self._batched_presence_streams

	if not stream_id then
		for i = 1, #batched_presence_streams do
			local data = batched_presence_streams[i]

			if table.size(data.entry_to_request_id) < BATCHED_PRESENCE_STREAM_MAX_SIZE then
				stream_id = i

				break
			end
		end

		stream_id = stream_id or self:_init_batched_get_presence(nil)
		self._entry_to_stream_id[entry] = stream_id
	end

	local data = batched_presence_streams[stream_id]
	local request_id = data.entry_to_request_id[entry]

	if not request_id then
		request_id = data.stream:request_presence(platform, platform_user_id)
		data.entry_to_request_id[entry] = request_id
	end

	return data.stream:get_presence(request_id)
end

PresenceManager._abort_batched_presence = function (self, entry)
	local stream_id = self._entry_to_stream_id[entry]

	if not stream_id then
		return
	end

	local data = self._batched_presence_streams[stream_id]
	local request_id = data.entry_to_request_id[entry]

	if request_id then
		data.stream:abort_presence(request_id)
	end

	data.entry_to_request_id[entry] = nil
	self._entry_to_stream_id[entry] = nil
end

PresenceManager._update_immaterium = function (self)
	local entry_remove = false

	for id, presence in pairs(self._presences_by_account_id) do
		if presence and not presence:reset_alive_queried() then
			presence:destroy()

			entry_remove = true
			self._presences_by_account_id[id] = nil
		end
	end

	if entry_remove then
		self._presences_by_account_id = remove_empty_values(self._presences_by_account_id)
	end

	for platform, platform_table in pairs(self._presences_by_platform_id) do
		entry_remove = false

		for id, presence in pairs(platform_table) do
			if presence and not presence:reset_alive_queried() then
				presence:destroy()

				entry_remove = true
				platform_table[id] = nil
			end
		end

		if entry_remove then
			self._presences_by_platform_id[platform] = remove_empty_values(platform_table)
		end
	end

	self._update_interval = PRESENCE_UPDATE_INTERVAL
end

PresenceManager._update_my_presence = function (self, ...)
	if self._my_presence_stream then
		self._my_presence_stream:send_stream_message(self._myself:create_key_values(...))
	end
end

PresenceManager._run_update_on_entries = function (self)
	for id, presence in pairs(self._presences_by_account_id) do
		presence:update()
	end

	for platform, platform_table in pairs(self._presences_by_platform_id) do
		for id, presence in pairs(platform_table) do
			presence:update()
		end
	end
end

PresenceManager.request_platform_username_async = function (self, platform, platform_user_id)
	if HAS_STEAM and platform == "steam" then
		Steam.request_user_name_async(platform_user_id)
	elseif (IS_XBS or IS_GDK) and platform == "xbox" then
		if self._load_buffer_in_flight and self._load_buffer_in_flight[platform_user_id] then
			return
		end

		if self._loaded_xbox_gamertags[platform_user_id] or self._load_buffer_request_xbox_gamertag[platform_user_id] then
			return
		end

		self._load_buffer_request_xbox_gamertag[platform_user_id] = true
		self._load_buffer_request_xbox_gamertag_length = self._load_buffer_request_xbox_gamertag_length + 1
	end
end

PresenceManager.get_requested_platform_username = function (self, platform, platform_user_id)
	if HAS_STEAM and platform == "steam" then
		return Steam.user_name(platform_user_id)
	elseif (IS_XBS or IS_GDK) and platform == "xbox" then
		return self._loaded_xbox_gamertags[platform_user_id]
	end
end

PresenceManager.update = function (self, dt, t)
	self._character_name_update_interval = self._character_name_update_interval - dt

	if self._character_name_update_interval <= 0 then
		local profile = Managers.player:local_player_backend_profile()

		self._character_name_update_interval = 1

		local prev_character_profile = self._myself:character_profile()

		if profile and (not prev_character_profile or prev_character_profile ~= profile) then
			self:set_character_profile(profile)
		end
	end

	local batched_presence_streams = self._batched_presence_streams

	for i = 1, #batched_presence_streams do
		local data = batched_presence_streams[i]
		local stream = data.stream

		if not stream:alive() and not data.restarting then
			local error = stream:error()

			if error then
				if error.aborted then
					_info("Aborted batched presence operation")
				else
					_info("Disconnected from batched get presence - %s", table.tostring(error, 3))

					data.restarting = true

					Managers.grpc:delay_with_jitter_and_backoff("batched_get_presence"):next(function ()
						self:_init_batched_get_presence(i)
					end)
				end
			else
				self:_init_batched_get_presence(i)
			end
		end
	end

	self._update_interval = self._update_interval - dt

	if self._update_interval <= 0 then
		self:_update_immaterium()
	end

	self:_run_update_on_entries()

	if self._my_presence_stream then
		if self._my_presence_stream:alive() then
			local push_messages = self._my_presence_stream:get_stream_messages()

			if push_messages then
				for i, push_message in ipairs(push_messages) do
					_info("received push message=%s", table.tostring(push_message, 3))

					if push_message.type == "event_trigger" then
						local payload = cjson.decode(push_message.payload)

						Managers.event:trigger("backend_" .. payload.event_name, unpack(payload.args))
					end
				end
			end
		else
			local error = self._my_presence_stream:error()

			self._my_presence_stream = nil

			if error then
				if error.aborted then
					_info("Aborted presence operation")
				elseif error.error_code == 10 then
					_info("Logged in from another location, sending fatal error...")
					Managers.error:report_error(LoggedInFromAnotherLocationError:new())
				else
					_error("Disconnected from presence - %s", table.tostring(error, 3))
					Managers.grpc:delay_with_jitter_and_backoff("my_presence_stream"):next(function ()
						self:_init_immaterium_presence()
					end)
				end
			else
				self:_init_immaterium_presence()
			end
		end
	end

	if self._load_buffer_request_xbox_gamertag_length and self._load_buffer_request_xbox_gamertag_length > 0 then
		self._last_request_xbox_gamertag = self._last_request_xbox_gamertag + dt

		if self._last_request_xbox_gamertag > 0.2 then
			local buffer = {}

			self._load_buffer_in_flight = {}

			for id, _ in pairs(self._load_buffer_request_xbox_gamertag) do
				table.insert(buffer, id)

				self._load_buffer_in_flight[id] = true
			end

			self._load_buffer_request_xbox_gamertag_length = 0
			self._load_buffer_request_xbox_gamertag = {}

			Log.info("PresenceManager", "Doing batched call to get_user_profiles with %s xuids", tostring(#buffer))
			XboxLiveUtils.get_user_profiles(buffer):next(function (profiles)
				self._load_buffer_in_flight = nil

				for i, profile in ipairs(profiles) do
					self._loaded_xbox_gamertags[profile.xuid] = profile.gamertag
				end
			end):catch(function (error)
				self._load_buffer_in_flight = nil

				_error("error when getting gamertags for xuids", table.tostring(buffer, 2))

				self._last_request_xbox_gamertag = -10
			end)

			self._last_request_xbox_gamertag = 0
		end
	end

	if t >= self._next_activity_check then
		self:_check_activity()

		self._next_activity_check = t + ACTIVITY_CHECK_INTERVAL
	end

	if t >= self._next_cross_play_check then
		self:_check_cross_play()

		self._next_cross_play_check = t + CROSS_PLAY_CHECK_INTERVAL
	end
end

PresenceManager._check_cross_play = function (self)
	local disabled_in_party = false
	local is_cross_playing = false
	local my_platform = self._myself:platform()
	local all_members = Managers.party_immaterium:all_members()

	for i = 1, #all_members do
		local member = all_members[i]
		local presence = member:presence()

		if presence:cross_play_disabled() then
			disabled_in_party = true
		end

		if presence:platform() ~= my_platform then
			is_cross_playing = true
		end
	end

	if disabled_in_party ~= self._myself:cross_play_disabled_in_party() then
		self:_set_cross_play_disabled_in_party(disabled_in_party)
	end

	if is_cross_playing ~= self._myself:is_cross_playing() then
		self:_set_is_cross_playing(is_cross_playing)
	end
end

PresenceManager._check_activity = function (self)
	local myself = self._myself
	local activity_id = PresenceSettings.evaluate_presence(self._current_game_state_name)
	local old_activity_id = myself:activity_id()
	local updated_presence_keys = {}

	if activity_id ~= old_activity_id then
		Log.info("PresenceManager", "Activity changed %s -> %s", old_activity_id, activity_id)
		myself:set_activity_id(activity_id)

		updated_presence_keys.activity_id = true

		if activity_id == "mission" then
			local num_mission_members = Managers.connection:num_members()

			myself:set_num_mission_members(num_mission_members)

			updated_presence_keys.num_mission_members = true
		elseif old_activity_id == "mission" then
			myself:set_num_mission_members(nil)

			updated_presence_keys.num_mission_members = true
		end

		local advertise_playing = PresenceSettings.settings[activity_id].advertise_playing

		if advertise_playing ~= self._advertise_playing then
			if advertise_playing then
				self:_update_platform_presence()
			else
				self:_delete_platform_presence()
			end

			self._advertise_playing = advertise_playing
		end

		if IS_PLAYSTATION then
			Managers.account:is_psn_session_leader():next(function (is_leader)
				if not is_leader then
					return
				end

				if activity_id == "mission" then
					self:_max_psn_session_players():next(function (max_players)
						Managers.account:update_psn_session_max_players(max_players)
					end)

					local is_private = Managers.party_immaterium:is_in_private_session()

					Managers.account:update_psn_session_privacy(is_private)
				elseif old_activity_id == "mission" then
					self:_max_psn_session_players():next(function (max_players)
						Managers.account:update_psn_session_max_players(max_players)
					end)
					Managers.account:update_psn_session_privacy(false)
				end

				if activity_id == "onboarding" then
					Managers.account:update_psn_session_join_disabled(true)
					Managers.account:update_psn_session_max_players(1)
				elseif old_activity_id == "onboarding" then
					Managers.account:update_psn_session_join_disabled(false)
					Managers.account:update_psn_session_max_players(4)
				end
			end)
		end
	elseif activity_id == "mission" then
		local num_mission_members = Managers.connection:num_members()

		if num_mission_members ~= myself:num_mission_members() then
			myself:set_num_mission_members(num_mission_members)

			updated_presence_keys.num_mission_members = true

			if self._advertise_playing and (IS_XBS or IS_GDK) then
				self:_update_platform_presence()
			end

			if IS_PLAYSTATION then
				Managers.account:is_psn_session_leader():next(function (is_leader)
					if is_leader then
						self:_max_psn_session_players():next(function (max_players)
							Managers.account:update_psn_session_max_players(max_players)
						end)
					end
				end)
			end
		end
	end

	if not table.is_empty(updated_presence_keys) then
		self:_update_my_presence(updated_presence_keys)
	end
end

PresenceManager._update_platform_presence = function (self)
	local myself = self._myself
	local party_id = myself:party_id()

	if not party_id then
		return
	end

	if HAS_STEAM then
		Presence.advertise_immaterium_party(party_id)
	elseif IS_XBS or IS_GDK then
		Managers.party_immaterium:get_your_standing_invite_code():next(function (party_id_with_invite_code)
			local num_other_members = (myself:activity_id() == "mission" and myself:num_mission_members() or myself:num_party_members()) - 1
			local join_restrictions = Managers.party_immaterium and Managers.party_immaterium:is_in_private_session() and XblMultiplayerActivityJoinRestriction.JOIN_RESTRICTION_FOLLOWED

			XboxLiveUtils.set_activity(party_id_with_invite_code, party_id, num_other_members, join_restrictions)
		end)
	end
end

PresenceManager._delete_platform_presence = function (self)
	if HAS_STEAM then
		Presence.stop_advertise_playing()
	elseif IS_XBS or IS_GDK then
		XboxLiveUtils.delete_activity()
	end
end

PresenceManager._create_or_join_psn_session = function (self)
	local psn_party_members = Managers.party_immaterium:other_members_by_platform("psn")

	if #psn_party_members == 0 then
		local activity_id = self._myself:activity_id()
		local join_disabled = activity_id == "onboarding"
		local is_private = activity_id == "mission" and Managers.party_immaterium:is_in_private_session() or false

		self:_max_psn_session_players():next(function (max_members)
			Managers.account:create_psn_session(max_members, join_disabled, is_private)
		end)
	else
		local session_id = psn_party_members[1]:psn_session_id()

		Managers.account:join_psn_session(session_id)
	end
end

PresenceManager._max_psn_session_players = function (self)
	local activity_id = self._myself:activity_id()
	local account_ids = activity_id == "mission" and Managers.connection:member_peers() or Managers.party_immaterium:other_members_account_ids()
	local max_players = 4

	if #account_ids == 0 then
		return Promise.resolved(max_players)
	else
		return self:get_presences(account_ids):next(function (presences)
			for i = 1, #presences do
				local presence = presences[i]

				if presence:platform() ~= "psn" then
					max_players = max_players - 1
				end
			end

			return max_players
		end)
	end
end

PresenceManager.cb_on_game_state_change = function (self, previous_state_name, next_state_name)
	self._current_game_state_name = next_state_name

	self:_check_activity()
end

implements(PresenceManager, PresenceManagerInterface)

return PresenceManager
