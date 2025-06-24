-- chunkname: @scripts/managers/account/account_manager_psn.lua

local AccountManagerBase = require("scripts/managers/account/account_manager_base")
local InputDevice = require("scripts/managers/input/input_device")
local PlayerSessionPSN = require("scripts/managers/account/player_session_psn")
local Promise = require("scripts/foundation/utilities/promise")
local PsnBlockUsersStatesManager = require("scripts/managers/account/psn_block_users_states_manager")
local PSNRestrictions = require("scripts/managers/account/psn_restrictions")
local RegionRestrictionsPSN = require("scripts/settings/region/region_restrictions_psn")
local ScriptWebApiPsn = require("scripts/managers/account/script_web_api_psn")
local SoundSettings = require("scripts/settings/options/sound_settings")
local ExternalPaymentPlatformPlaystation = require("scripts/backend/platform/external_payment_platform_playstation")
local SIGNIN_STATES = {
	acquiring_storage = "loc_signin_acquire_storage",
	deleting_save = "loc_signin_delete_save",
	fetching_privileges = "loc_signin_fetch_privileges",
	fetching_sandbox_id = "loc_signin_fetch_sandbox_id",
	idle = "",
	loading_save = "loc_signin_load_save",
	querying_storage = "loc_signin_query_storage",
	signin_profile = "loc_signin_acquiring_user_profile",
}
local FRIEND_REQUEST_STATES = table.enum("idle", "fetching_friends")
local BLOCKED_PROFILES_REQUEST_STATES = table.enum("idle", "fetching_blocked_profiles")
local FRIEND_LIST_REQUEST_DELAY = 10
local BLOCKED_PROFILES_REQUEST_DELAY = 10
local PUBLIC_PROFILES_REQUEST_DELAY = 0
local FRIEND_LIST_REQUEST_LIMIT = 500
local BLOCKED_PROFILES_REQUEST_LIMIT = 100
local PUBLIC_PROFILES_REQUEST_LIMIT = 100
local PORFILE_PRESENCES_REQUEST_LIMIT = 100
local PREMIUM_NOTIFICATION_TIMER = 5
local VERIFY_SIGNED_IN_TIMER = 5
local AccountManagerPSN = class("AccountManagerPSN", "AccountManagerBase")

AccountManagerPSN.init = function (self)
	self._web_api = ScriptWebApiPsn:new()
	self._controller_popup_id = nil
	self._fatal_error_popup_id = nil
	self._dialog_status = MsgDialog.NONE
	self._restrictions = {}
	self._restrictions.communication = nil
	self._restrictions.cross_play = false
	self._psn_block_users_states_manager = PsnBlockUsersStatesManager:new()

	PlaystationDLC.initialize()
	Managers.save:load(callback(self, "_apply_audio_settings"))
end

AccountManagerPSN.reset = function (self)
	self._signed_in = false

	if Playstation.signed_in() then
		self._online_id = Playstation.online_id()

		local account_id_hex = Playstation.account_id()
		local account_id = Application.hex64_to_dec(account_id_hex)

		self._account_id = account_id
		self._signed_in = true

		self._psn_block_users_states_manager:set_account_id(account_id)
	end

	self._initial_user_id = PS5.initial_user_id()

	self:_setup_region()

	self._signin_state = SIGNIN_STATES.idle
	self._signin_callback = nil
	self._friend_profiles = {}
	self._friends_promise = nil
	self._next_friend_list_request = 0

	self:_change_friend_request_state(FRIEND_REQUEST_STATES.idle)

	self._blocked_profiles = {}
	self._blocked_profiles_promise = nil
	self._next_blocked_profiles_request = 0

	self:_change_blocked_profiles_request_state(BLOCKED_PROFILES_REQUEST_STATES.idle)

	self._public_profiles = {}
	self._public_profiles_promise = nil
	self._next_public_profiles_request = 0
	self._wanted_state = nil
	self._wanted_state_params = nil
	self._leave_game = false

	if self._session_id then
		self:leave_psn_session()
	end

	self._restrictions = {}
	self._restrictions.communication = nil
	self._restrictions.cross_play = false
	self._premium_verified = false
	self._premium_notification_active = false
	self._premium_notification_timer = 0
	self._verify_signed_in_timer = 0
end

AccountManagerPSN.destroy = function (self)
	if self._session_id then
		self:leave_psn_session()
	end

	self._web_api:destroy()

	self._web_api = nil
end

AccountManagerPSN.update = function (self, dt, t)
	if self._leave_game then
		return
	end

	self._web_api:update(dt)
	self._psn_block_users_states_manager:update(dt, t)

	if self._premium_verified then
		self._premium_notification_timer = self._premium_notification_timer + dt
		self._verify_signed_in_timer = self._verify_signed_in_timer + dt

		if self._premium_notification_timer >= PREMIUM_NOTIFICATION_TIMER then
			if self:_is_premium_feature() then
				if self:has_crossplay_restriction() then
					Playstation.notify_premium_feature(self._initial_user_id, NpMultiplayProperty.NONE)
				else
					Playstation.notify_premium_feature(self._initial_user_id, NpMultiplayProperty.CROSS_PLATFORM_PLAY)
				end

				self._premium_notification_active = true
				self._premium_notification_timer = 0
			else
				self._premium_notification_active = false
			end
		end

		if self._verify_signed_in_timer >= VERIFY_SIGNED_IN_TIMER then
			if not Playstation.signed_in(self._initial_user_id) and self._signed_in == true then
				self:_show_fatal_error("loc_popup_header_error", "loc_psn_not_connected")

				self._signed_in = false
			end

			self._verify_signed_in_timer = 0
		end
	end

	if self._restrictions.communication and self._dialog_status == MsgDialog.RUNNING then
		self._dialog_status = MsgDialog.update()
	end

	self:_check_input()
end

AccountManagerPSN._is_premium_feature = function (self)
	local in_a_party = false

	if Managers.party_immaterium then
		local party_id = Managers.party_immaterium:party_id()

		if party_id and Managers.party_immaterium:num_other_members() > 0 then
			in_a_party = true
		end
	end

	local current_state_name = Managers.ui:get_current_state_name()

	if current_state_name == "StateLoading" then
		return self._premium_notification_active and in_a_party
	elseif current_state_name == "StateGameScore" or current_state_name == "StateVictoryDefeat" then
		return self._premium_notification_active and in_a_party
	elseif current_state_name == "StateGameplay" then
		if Managers.ui:view_active("loading_view") or Managers.ui:view_active("mission_intro_view") then
			return self._premium_notification_active and in_a_party
		end

		local cinematic_manager = Managers.state and Managers.state.cinematic

		if cinematic_manager then
			local waiting_for_player_input = cinematic_manager.waiting_for_player_input and cinematic_manager:waiting_for_player_input()
			local is_playing = cinematic_manager.is_playing and cinematic_manager:is_playing()

			if waiting_for_player_input or is_playing then
				return self._premium_notification_active
			end
		end

		local game_mode_manager = Managers.state.game_mode

		if game_mode_manager ~= nil and game_mode_manager.is_premium_feature and game_mode_manager:is_premium_feature() then
			return true
		end
	end

	return false
end

AccountManagerPSN._check_input = function (self)
	if not self._controller_popup_id and not Managers.input:has_active_gamepad() then
		local online_id = Playstation.online_id()
		local description_text = online_id and "loc_popup_desc_signed_out_error_sony" or "loc_popup_desc_controller_disconnect_error_sony"
		local context = {
			title_text = "loc_popup_header_controller_disconnect_error_sony",
			description_text = description_text,
			priority_order = math.huge,
			description_text_params = {
				gamertag = online_id,
			},
			options = {
				{
					close_on_pressed = true,
					hotkey = "validate",
					text = "loc_alias_view_close_view",
					callback = callback(self, "cb_validate_input_reconnected"),
				},
			},
		}

		Managers.event:trigger("event_show_ui_popup", context, function (id)
			self._controller_popup_id = id
		end)
	end
end

AccountManagerPSN.cb_validate_input_reconnected = function (self)
	local controller_popup_id = self._controller_popup_id

	self._controller_popup_id = nil

	Managers.event:trigger("event_remove_ui_popup", controller_popup_id)
end

AccountManagerPSN.signin_profile = function (self, signin_callback, optional_input_device)
	self._signin_state = SIGNIN_STATES.signin_profile
	self._signin_callback = signin_callback

	PSNRestrictions:psn_signin():next(function (_)
		self._online_id = Playstation.online_id()

		local account_id_hex = Playstation.account_id()
		local account_id = Application.hex64_to_dec(account_id_hex)

		self._account_id = account_id
		self._signed_in = true

		self:cb_signin_complete()
	end):catch(function (error)
		local fail_cb

		fail_cb = callback(self, "_show_fatal_error", "loc_popup_header_error", error.message)

		fail_cb()
	end)
end

AccountManagerPSN._show_fatal_error = function (self, title_text, description_text)
	local context = {
		priority_order = 1000,
		title_text = title_text,
		description_text = description_text,
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_button_close",
				callback = callback(self, "return_to_title_screen"),
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._fatal_error_popup_id = id
	end)
end

AccountManagerPSN.cb_signin_complete = function (self)
	if self._signin_callback then
		self._signin_callback()

		self._signin_callback = nil
		self._signin_state = SIGNIN_STATES.idle

		local user_id = PS5.initial_user_id()

		WebApi.set_push_event_filters(user_id, "np:service:friendlist:friend", "np:service:blocklist")
	end
end

AccountManagerPSN.user_id = function (self)
	return self._initial_user_id or PS5.initial_user_id()
end

AccountManagerPSN.platform_user_id = function (self)
	return self._account_id
end

AccountManagerPSN.user_display_name = function (self)
	return self._online_id
end

AccountManagerPSN.wanted_transition = function (self)
	return self._wanted_state, self._wanted_state_params
end

AccountManagerPSN.do_re_signin = function (self)
	return false
end

AccountManagerPSN.user_detached = function (self)
	return self._leave_game
end

AccountManagerPSN.leaving_game = function (self)
	return self._leave_game
end

AccountManagerPSN.signin_state = function (self)
	return self._signin_state
end

AccountManagerPSN.set_premium_verified = function (self, new_value)
	self._premium_verified = new_value
end

AccountManagerPSN.is_guest = function (self)
	return false
end

AccountManagerPSN.show_profile_picker = function (self)
	return
end

AccountManagerPSN.return_to_title_screen = function (self)
	self._wanted_state = CLASSES.StateError
	self._wanted_state_params = {}
	self._leave_game = true
end

AccountManagerPSN.get_friends = function (self)
	local friends_promise = self._friends_promise

	if friends_promise and friends_promise:is_pending() then
		return friends_promise
	end

	local t = Managers.time:time("main")

	if self._friend_request_state ~= FRIEND_REQUEST_STATES.idle or t < self._next_friend_list_request then
		return Promise.resolved(self._friend_profiles)
	else
		table.clear(self._friend_profiles)

		self._friends_promise = self:_fetch_friends()

		self._friends_promise:next(function (result)
			self._friend_profiles = result
			self._next_friend_list_request = t + FRIEND_LIST_REQUEST_DELAY
			self._friends_promise = nil
		end)

		return self._friends_promise
	end
end

AccountManagerPSN._fetch_friends = function (self, num_to_fetch, offset, result_promise, target_account_ids_array)
	num_to_fetch = num_to_fetch or FRIEND_LIST_REQUEST_LIMIT
	offset = offset or 0

	local limit = FRIEND_LIST_REQUEST_LIMIT
	local account_id = self._account_id
	local user_id = PS5.initial_user_id()
	local api_group = "userProfile"
	local path = string.format("/v1/users/%s/friends?offset=%s&limit=%s", account_id, offset, limit)
	local method = WebApi.GET
	local content

	result_promise = result_promise or Promise.new()
	target_account_ids_array = target_account_ids_array or {}

	self:_change_friend_request_state(FRIEND_REQUEST_STATES.fetching_friends)
	self._web_api:send_request(user_id, api_group, path, method, content):next(function (result)
		self:_change_friend_request_state(FRIEND_REQUEST_STATES.idle)

		if not result then
			result_promise.reject()

			return result
		end

		local friends_account_ids = result.friends
		local total_friends_count = result.totalItemCount or 0

		table.append(target_account_ids_array, friends_account_ids)

		if #friends_account_ids == 0 then
			result_promise:resolve({})
		elseif total_friends_count > #target_account_ids_array then
			offset = offset + #friends_account_ids
			num_to_fetch = math.min(total_friends_count - #target_account_ids_array, limit)

			self:_fetch_friends(num_to_fetch, offset, result_promise, target_account_ids_array)
		else
			local profiles_result_promise = Promise.all(self:_fetch_public_profiles(table.clone_instance(target_account_ids_array)), self:_fetch_profile_presences(table.clone_instance(target_account_ids_array))):next(function (result)
				local public_profiles_by_account_id, presences_by_account_id = unpack(result)
				local profiles = {}

				for i = 1, #target_account_ids_array do
					local account_id = target_account_ids_array[i]
					local profile = public_profiles_by_account_id[account_id]
					local presence = presences_by_account_id[account_id]
					local profile_data = table.clone_instance(profile)

					table.merge_recursive(profile_data, presence)

					profiles[#profiles + 1] = profile_data
				end

				result_promise:resolve(profiles)
			end)
		end
	end)

	return result_promise
end

AccountManagerPSN._fetch_public_profiles = function (self, account_ids, result_promise, result_data_table)
	local limit = PUBLIC_PROFILES_REQUEST_LIMIT
	local account_id = self._account_id
	local user_id = PS5.initial_user_id()
	local api_group = "userProfile"
	local account_ids_string = ""

	for i = math.min(#account_ids, limit), 1, -1 do
		local account_id = account_ids[i]

		account_ids_string = account_ids_string .. account_id

		if i > 1 then
			account_ids_string = account_ids_string .. ","
		end

		table.remove(account_ids, i)
	end

	local path = string.format("/v1/users/profiles?accountIds=%s&includeFields=accountId&includeFields=relation", account_ids_string)
	local method = WebApi.GET
	local content

	result_promise = result_promise or Promise.new()
	result_data_table = result_data_table or {}

	self._web_api:send_request(user_id, api_group, path, method, content):next(function (result)
		if not result then
			result_promise.reject()

			return result
		end

		local profiles = result.profiles

		table.append(result_data_table, profiles)

		if #account_ids > 0 then
			self:_fetch_public_profiles(account_ids, result_promise, result_data_table)
		else
			local result_by_id = {}

			for i = 1, #result_data_table do
				local data = result_data_table[i]
				local account_id = data.accountId

				if account_id then
					result_by_id[account_id] = data
				end
			end

			result_promise:resolve(result_by_id)
		end
	end)

	return result_promise
end

AccountManagerPSN._fetch_profile_presences = function (self, account_ids, result_promise, result_data_table)
	local limit = PORFILE_PRESENCES_REQUEST_LIMIT
	local account_id = self._account_id
	local user_id = PS5.initial_user_id()
	local api_group = "userProfile"
	local account_ids_string = ""

	for i = math.min(#account_ids, limit), 1, -1 do
		local account_id = account_ids[i]

		account_ids_string = account_ids_string .. account_id

		if i > 1 then
			account_ids_string = account_ids_string .. ","
		end

		table.remove(account_ids, i)
	end

	local path = string.format("/v1/users/basicPresences?accountIds=%s", account_ids_string)
	local method = WebApi.GET
	local content

	result_promise = result_promise or Promise.new()
	result_data_table = result_data_table or {}

	self._web_api:send_request(user_id, api_group, path, method, content):next(function (result)
		if not result then
			result_promise.reject()

			return result
		end

		local presences = result.basicPresences

		table.append(result_data_table, presences)

		if #account_ids > 0 then
			self:_fetch_profile_presences(account_ids, result_promise, result_data_table)
		else
			local result_by_id = {}

			for i = 1, #result_data_table do
				local data = result_data_table[i]
				local account_id = data.accountId

				if account_id then
					result_by_id[account_id] = data
				end
			end

			result_promise:resolve(result_by_id)
		end
	end)

	return result_promise
end

AccountManagerPSN._change_friend_request_state = function (self, new_state)
	self._friend_request_state = new_state
end

AccountManagerPSN._change_blocked_profiles_request_state = function (self, new_state)
	self._blocked_profiles_request_state = new_state
end

AccountManagerPSN.friends_list_has_changes = function (self)
	return
end

AccountManagerPSN.refresh_communication_restrictions = function (self)
	if self._restrictions.communication == nil then
		local web_api = self._web_api
		local account_id = self._account_id
		local restrictions = self._restrictions

		PSNRestrictions:fetch_communication_restrictions(web_api, account_id):next(function (result)
			restrictions.communication = result.restricted

			if restrictions.communication then
				self._dialog_status = MsgDialog.update()

				if self._dialog_status == MsgDialog.NONE then
					MsgDialog.initialize()
				end

				self._dialog_status = MsgDialog.update()

				if self._dialog_status == MsgDialog.INITIALIZED or self._dialog_status == MsgDialog.FINISHED then
					MsgDialog.open(MsgDialog.SYSTEM_MSG_TRC_PSN_CHAT_RESTRICTION, PS5.initial_user_id())

					self._dialog_status = MsgDialog.update()
				end
			end
		end)
	end
end

AccountManagerPSN.is_muted = function (self)
	return self:user_has_restriction()
end

AccountManagerPSN.is_blocked = function (self)
	return false
end

AccountManagerPSN.fetch_crossplay_restrictions = function (self)
	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()
		local crossplay_enabled = account_data and account_data.interface_settings.crossplay_enabled

		self._restrictions.cross_play = not crossplay_enabled
	end
end

AccountManagerPSN.set_crossplay_restriction = function (self, value)
	self._restrictions.cross_play = value
end

AccountManagerPSN.has_crossplay_restriction = function (self)
	return self._restrictions.cross_play
end

AccountManagerPSN.verify_user_restriction = function (self)
	return
end

AccountManagerPSN.verify_user_restriction_batched = function (self)
	return
end

AccountManagerPSN.user_has_restriction = function (self)
	return self._restrictions.communication or false
end

AccountManagerPSN.user_restriction_verified = function (self)
	return true
end

AccountManagerPSN.verify_connection = function (self)
	return true
end

AccountManagerPSN.communication_restriction_iteration = function (self)
	return self._communication_restriction_iteration
end

AccountManagerPSN.get_blocked_profiles = function (self)
	local blocked_profiles_promise = self._blocked_profiles_promise

	if blocked_profiles_promise and blocked_profiles_promise:is_pending() then
		return blocked_profiles_promise
	end

	local t = Managers.time:time("main")

	if t < self._next_blocked_profiles_request then
		return Promise.resolved(self._blocked_profiles)
	else
		table.clear(self._blocked_profiles)
		self:_change_blocked_profiles_request_state(BLOCKED_PROFILES_REQUEST_STATES.fetching_blocked_profiles)

		self._blocked_profiles_promise = self:_fetch_block_list()

		self._blocked_profiles_promise:next(function (result)
			self._blocked_profiles = result
			self._next_blocked_profiles_request = t + BLOCKED_PROFILES_REQUEST_DELAY
			self._blocked_profiles_promise = nil

			self:_change_blocked_profiles_request_state(BLOCKED_PROFILES_REQUEST_STATES.idle)
			Promise.resolved(self._blocked_profiles)
		end):catch(function (error)
			self._blocked_profiles_promise:reject(error)
		end)

		return self._blocked_profiles_promise
	end
end

AccountManagerPSN._fetch_block_list = function (self, num_to_fetch, offset, result_promise, target_blocked_account_ids_array)
	num_to_fetch = num_to_fetch or BLOCKED_PROFILES_REQUEST_LIMIT
	offset = offset or 0

	local limit = BLOCKED_PROFILES_REQUEST_LIMIT
	local account_id = self._account_id
	local user_id = PS5.initial_user_id()
	local api_group = "userProfile"
	local path = string.format("/v1/users/me/blocks?offset=%s&limit=%s", offset, limit)
	local method = WebApi.GET
	local content

	result_promise = result_promise or Promise.new()
	target_blocked_account_ids_array = target_blocked_account_ids_array or {}

	self._web_api:send_request(user_id, api_group, path, method, content):next(function (result)
		if not result then
			result_promise:reject()

			return result
		end

		local blocked_account_ids = result.blocks
		local total_item_count = result.totalItemCount or 0

		table.append(target_blocked_account_ids_array, blocked_account_ids)

		if #blocked_account_ids == 0 then
			result_promise:resolve({})
		elseif total_item_count > #target_blocked_account_ids_array then
			offset = offset + #blocked_account_ids
			num_to_fetch = math.min(total_item_count - #target_blocked_account_ids_array, limit)

			self:_fetch_block_list(num_to_fetch, offset, result_promise, target_blocked_account_ids_array)
		else
			local profiles_result_promise = Promise.all(self:_fetch_public_profiles(table.clone_instance(target_blocked_account_ids_array)), self:_fetch_profile_presences(table.clone_instance(target_blocked_account_ids_array))):next(function (result)
				local public_profiles_by_account_id, presences_by_account_id = unpack(result)
				local profiles = {}

				for i = 1, #target_blocked_account_ids_array do
					local account_id = target_blocked_account_ids_array[i]
					local profile = public_profiles_by_account_id[account_id]
					local presence = presences_by_account_id[account_id]
					local profile_data = table.clone_instance(profile)

					if presence then
						table.merge_recursive(profile_data, presence)
					end

					profiles[#profiles + 1] = profile_data
				end

				result_promise:resolve(profiles)
			end):catch(function (error)
				profiles_result_promise:reject(error)
			end)
		end
	end):catch(function (error)
		result_promise:reject(error)
	end)

	return result_promise
end

AccountManagerPSN.get_public_profiles = function (self, account_ids)
	local public_profiles_promise = self._public_profiles_promise

	if public_profiles_promise and public_profiles_promise:is_pending() then
		return public_profiles_promise
	end

	local t = Managers.time:time("main")

	if t < self._next_public_profiles_request then
		return Promise.resolved(self._public_profiles)
	else
		table.clear(self._public_profiles)

		self._public_profiles_promise = self:_fetch_public_profiles(account_ids)

		self._public_profiles_promise:next(function (result)
			self._public_profiles = result
			self._next_public_profiles_request = t + PUBLIC_PROFILES_REQUEST_DELAY
			self._public_profiles_promise = nil

			Promise.resolved(self._public_profiles)
		end)

		return self._public_profiles_promise
	end
end

AccountManagerPSN.is_public_profiles_promise_pending = function (self)
	local public_profiles_promise = self._public_profiles_promise

	return public_profiles_promise and public_profiles_promise:is_pending() or false
end

AccountManagerPSN.fetch_block_users_states = function (self, account_ids)
	self._psn_block_users_states_manager:fetch_block_users_states(account_ids)
end

AccountManagerPSN.is_player_blocking_me = function (self, player_info)
	local psn_block_users_states_manager = self._psn_block_users_states_manager

	return psn_block_users_states_manager:is_blocking_me(player_info:account_id()) or psn_block_users_states_manager:is_blocking_me(player_info:platform_user_id())
end

AccountManagerPSN.request_block_user_states = function (self, account_id)
	self._psn_block_users_states_manager:add_requested_account(account_id)
end

AccountManagerPSN.is_platform_id_already_requested = function (self, platform_id)
	return self._psn_block_users_states_manager:is_platform_id_already_requested(platform_id)
end

AccountManagerPSN.set_wait_to_collect_accounts = function (self, new_value)
	self._psn_block_users_states_manager:set_wait_to_collect_accounts(new_value)
end

AccountManagerPSN._setup_region = function (self)
	local country_code = Playstation.user_country(self._initial_user_id)

	country_code = country_code or "unknown"
	self._region_restrictions = RegionRestrictionsPSN[country_code] or {}
end

AccountManagerPSN.region_has_restriction = function (self, restriction)
	return not not self._region_restrictions[restriction]
end

AccountManagerPSN.create_psn_session = function (self, max_players, join_disabled, is_private)
	PlayerSessionPSN.create_session(self._web_api, self:user_id(), max_players, join_disabled, is_private, self:has_crossplay_restriction()):next(function (session_id)
		Log.info("PlayerSession", "Created session %s, max_players %s, join_disabled %s, is_private: %s", session_id, max_players, join_disabled, is_private)
		self:_set_psn_session_id(session_id)
	end)
end

AccountManagerPSN.join_psn_session = function (self, session_id)
	PlayerSessionPSN.join_session(self._web_api, self:user_id(), session_id):next(function ()
		Log.info("PlayerSession", "Joined session %s", session_id)
		self:_set_psn_session_id(session_id)
	end)
end

AccountManagerPSN.leave_psn_session = function (self)
	local session_id = self._session_id

	if not session_id then
		return
	end

	PlayerSessionPSN.leave_session(self._web_api, self:user_id(), session_id):next(function ()
		Log.info("PlayerSession", "Left session %s", session_id)
	end)
	self:_set_psn_session_id(nil)
end

AccountManagerPSN.is_psn_session_leader = function (self)
	local session_id = self._session_id

	if not session_id then
		return Promise.resolved(false)
	end

	return PlayerSessionPSN.is_session_leader(self._web_api, self:user_id(), session_id)
end

AccountManagerPSN.update_psn_session_max_players = function (self, max_players)
	local session_id = self._session_id

	if not session_id then
		return
	end

	PlayerSessionPSN.update_session_max_players(self._web_api, self:user_id(), session_id, max_players)
end

AccountManagerPSN.update_psn_session_privacy = function (self, is_private)
	local session_id = self._session_id

	if not session_id then
		return
	end

	PlayerSessionPSN.update_session_privacy(self._web_api, self:user_id(), session_id, is_private)
end

AccountManagerPSN.update_psn_session_join_disabled = function (self, join_disabled)
	local session_id = self._session_id

	if not session_id then
		return
	end

	PlayerSessionPSN.update_session_join_disabled(self._web_api, self:user_id(), session_id, join_disabled)
end

AccountManagerPSN.get_immaterium_invite_code_from_psn_session = function (self, session_id)
	return PlayerSessionPSN.get_session_invite_code(self._web_api, self:user_id(), session_id)
end

AccountManagerPSN.send_psn_session_invite = function (self, invitee_psn_account_id)
	local session_id = self._session_id

	if not session_id then
		return
	end

	PlayerSessionPSN.send_session_invite(self._web_api, self:user_id(), session_id, invitee_psn_account_id)
end

AccountManagerPSN._set_psn_session_id = function (self, session_id)
	self._session_id = session_id

	Managers.presence:set_psn_session_id(session_id)
end

AccountManagerPSN._apply_audio_settings = function (self)
	local settings = SoundSettings.settings

	for _, setting in ipairs(settings) do
		local get_function = setting.get_function

		if get_function then
			local value = get_function()

			if value ~= nil then
				local commit = setting.commit

				if commit then
					commit(value)
				end
			end
		end
	end
end

AccountManagerPSN.is_owner_of = function (self, entitlement_key)
	PlaystationDLC.fetch_owned_dlcs()

	return Promise.until_true(function ()
		return PlaystationDLC.has_fetched_dlcs()
	end):next(function ()
		return {
			is_owner = PlaystationDLC.has_dlc(entitlement_key),
		}
	end)
end

AccountManagerPSN.open_to_store = function (self, entitlement_key)
	return ExternalPaymentPlatformPlaystation:show_commerce_dialogue(entitlement_key)
end

return AccountManagerPSN
