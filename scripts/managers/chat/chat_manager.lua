local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local ChatManagerInterface = require("scripts/foundation/managers/chat/chat_manager_interface")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local ChatManager = class("ChatManager")
local SOUND_SETTING_OPTIONS_VOICE_CHAT = table.enum("muted", "voice_activated", "push_to_talk")

local function _sound_setting_option_voice_chat()
	if Application.user_setting and Application.user_setting("sound_settings") and Application.user_setting("sound_settings").voice_chat then
		local option = Application.user_setting and Application.user_setting("sound_settings") and Application.user_setting("sound_settings").voice_chat

		if option == 0 then
			return SOUND_SETTING_OPTIONS_VOICE_CHAT.muted
		elseif option == 1 then
			return SOUND_SETTING_OPTIONS_VOICE_CHAT.voice_activated
		elseif option == 2 then
			return SOUND_SETTING_OPTIONS_VOICE_CHAT.push_to_talk
		end
	end

	if IS_XBS then
		return SOUND_SETTING_OPTIONS_VOICE_CHAT.voice_activated
	else
		return SOUND_SETTING_OPTIONS_VOICE_CHAT.push_to_talk
	end
end

ChatManager.init = function (self)
	self._initialized = false
	self._t = 0
	self._account_handle = nil
	self._privileges_manager = nil
	self._sessions = {}
	self._join_queue = {}
	self._channel_tags = {}
	self._channel_host_peer_id = {}
	self._input_service = Managers.input:get_input_service("Ingame")
	self._party_id_session_handles = {}
	self._capture_devices = {}
	self._time_since_mute_local_mic = nil

	Managers.event:register(self, "player_mute_status_changed", "player_mute_status_changed")
end

ChatManager.destroy = function (self)
	Managers.event:unregister(self, "player_mute_status_changed")
end

ChatManager.split_displayname = function (self, input)
	if not input then
		return nil
	end

	local parts = string.split(input, "|")

	if #parts == 2 then
		return parts[1], parts[2]
	else
		return nil
	end
end

ChatManager.peer_id_from_session_handle = function (self, session_handle)
	return self._channel_host_peer_id[session_handle]
end

ChatManager.tag_from_session_handle = function (self, session_handle)
	return self._channel_tags[session_handle]
end

ChatManager.initialize = function (self)
	if rawget(_G, "Vivox") then
		local verbose_chat_log = true

		if Vivox.initialize(verbose_chat_log) then
			self._initialized = true
			self._privileges_manager = PrivilegesManager:new()

			Managers.backend:authenticate():next(function (auth_data)
				local domain = auth_data.vivox_domain
				local issuer = auth_data.vivox_issuer

				Vivox.create_connector(domain, issuer)
			end):catch(function (error)
				Log.error("ChatManager", "Could not create connector: " .. tostring(error))
			end)
		end
	else
		Log.error("ChatManager", "Vivox not available")
	end
end

ChatManager.is_initialized = function (self)
	return self._initialized
end

ChatManager.connection_state = function (self)
	return self._connection_state
end

ChatManager.is_connected = function (self)
	return self._connection_state == ChatManagerConstants.ConnectionState.CONNECTED or self._connection_state == ChatManagerConstants.ConnectionState.RECOVERED
end

ChatManager.login_state = function (self)
	return self._login_state
end

ChatManager.is_logged_in = function (self)
	return self:login_state() == ChatManagerConstants.LoginState.LOGGED_IN and self._account_handle ~= nil
end

ChatManager.login = function (self, peer_id, account_id, vivox_token)
	if not self._login_state or self._login_state == ChatManagerConstants.LoginState.LOGGED_OUT then
		if not peer_id then
			Log.warning("ChatManager", "Could not login: missing peer_id.")

			return
		end

		if not account_id then
			Log.warning("ChatManager", "Could not login: missing account_id.")

			return
		end

		if type(vivox_token) ~= "string" or #vivox_token <= 0 then
			Log.error("ChatManager", "Could not login: missing vivox_token.")

			return
		end

		local login_name = string.format("%s|%s", peer_id, account_id)

		Vivox.login_with_access_token(login_name, account_id, vivox_token)
	else
		Log.warning("ChatManager", "Already logged in.")
	end
end

ChatManager.logout = function (self)
	if not self:is_logged_in() then
		Log.warning("ChatManager", "Already logged out")

		return
	end

	Vivox.logout(self._account_handle)
end

ChatManager.join_chat_channel = function (self, channel, host_peer_id, voice, text, tag, vivox_token)
	if not self:is_logged_in() then
		return
	end

	if not text and not voice then
		return
	end

	Log.info("ChatManager", "Joining channel %s peer_id: %s tag: %s enabling voice: %s enabling text: %s", channel, tostring(host_peer_id), tag, voice and "true" or "false", text and "true" or "false")

	self._channel_tags[channel] = tag

	self._privileges_manager:communications_privilege(false):next(function (results)
		if results.has_privilege == true then
			self._channel_host_peer_id[channel] = host_peer_id

			if self:is_logged_in() then
				Vivox.add_channel_session(self._account_handle, channel, text, voice, vivox_token)
			else
				table.insert(self._join_queue, {
					channel,
					text,
					voice,
					vivox_token
				})
			end
		else
			local error = string.format("Communications privilege denied: %s", results.deny_reason or "Unknown reason")

			Log.error("ChatManager", "Error joining channel %s: %s", channel, error)
		end
	end):catch(function (error)
		Log.error("ChatManager", "Error joining channel %s: %s", channel, error)
	end)
end

ChatManager.leave_channel = function (self, channel_handle)
	if self:is_logged_in() then
		Log.info("ChatManager", "Leaving channel %s", channel_handle)
		Vivox.remove_session(channel_handle)
	end
end

ChatManager.sessions = function (self)
	return self._sessions
end

ChatManager.connected_chat_channels = function (self)
	local channels = {}

	for channel_handle, channel in pairs(self._sessions) do
		local session_text_state = channel.session_text_state

		if session_text_state and session_text_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			channels[channel_handle] = channel
		end
	end

	return channels
end

ChatManager.connected_voip_channels = function (self)
	local channels = {}

	for channel_handle, channel in pairs(self._sessions) do
		local session_media_state = channel.session_media_state

		if session_media_state and session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			channels[channel_handle] = channel
		end
	end

	return channels
end

local function _update_local_render_volume(session_handle)
	local volume = 50

	if Application.user_setting and Application.user_setting("sound_settings") and Application.user_setting("sound_settings").options_voip_volume_slider_v2 ~= nil then
		local voip_volume = Application.user_setting("sound_settings").options_voip_volume_slider_v2
		volume = voip_volume <= 0.01 and 0 or math.lerp(25, 75, voip_volume / 100)
	end

	Vivox.session_set_local_render_volume(session_handle, volume)
end

ChatManager.mic_volume_changed = function (self)
	for session_handle, channel in pairs(self._sessions) do
		local session_media_state = channel.session_media_state

		if session_media_state and session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			_update_local_render_volume(session_handle)
		end
	end
end

ChatManager.send_channel_message = function (self, channel_handle, message_body)
	Managers.telemetry_events:chat_message_sent(message_body)
	Vivox.send_session_message(channel_handle, message_body)
end

ChatManager.send_loc_channel_message = function (self, channel_handle, key, context)
	local status, result = pcall(cjson.encode, context or {})

	if not status then
		Log.error("ChatManager", "Could not encode context: " .. result)

		return
	end

	local message_body = "<loc|" .. key .. "|" .. result

	Managers.telemetry_events:chat_message_sent(message_body)
	Vivox.send_session_message(channel_handle, message_body)
end

ChatManager.update = function (self, dt, t)
	self._t = t

	if self._privileges_manager then
		self._privileges_manager:update(dt, t)
	end

	if self._time_since_mute_local_mic ~= nil then
		self._time_since_mute_local_mic = self._time_since_mute_local_mic + dt

		if self._time_since_mute_local_mic >= 0.5 then
			Vivox.get_local_audio_info()

			self._time_since_mute_local_mic = nil
		end
	end

	local muted_setting = _sound_setting_option_voice_chat()

	if muted_setting == SOUND_SETTING_OPTIONS_VOICE_CHAT.push_to_talk then
		local should_mute = true

		if self._input_service and self._input_service:has("voip_push_to_talk") and self._input_service:get("voip_push_to_talk") then
			should_mute = false
		end

		if self._local_audio_info and self._local_audio_info.is_mic_muted ~= should_mute then
			self:mute_local_mic(should_mute)
		end
	end

	if not self._last_update then
		self._last_update = 0
	else
		self._last_update = self._last_update + dt
	end

	if self._last_update > 0.1 then
		self._last_update = 0

		if self._initialized then
			local message = Vivox.get_message()

			if message then
				if message.type == Vivox.MessageType_EVENT then
					self:_handle_event(message)
				elseif message.type == Vivox.MessageType_RESPONSE then
					self:_handle_response(message)
				elseif message.type == Vivox.MessageType_RESPONSE_ERROR then
					self:_handle_response_error(message)
				end
			end

			self:_validate_participants()
			self:_poll_party()
		end
	end
end

local function login_state_enum(vx_login_state_change_state)
	if vx_login_state_change_state == 0 then
		return ChatManagerConstants.LoginState.LOGGED_OUT
	elseif vx_login_state_change_state == 1 then
		return ChatManagerConstants.LoginState.LOGGED_IN
	elseif vx_login_state_change_state == 2 then
		return ChatManagerConstants.LoginState.LOGGING_IN
	elseif vx_login_state_change_state == 3 then
		return ChatManagerConstants.LoginState.LOGGING_OUT
	elseif vx_login_state_change_state == 4 then
		return ChatManagerConstants.LoginState.RESETTING
	else
		return ChatManagerConstants.LoginState.ERROR
	end
end

local function session_text_state_enum(vx_session_text_state)
	if vx_session_text_state == 0 then
		return ChatManagerConstants.ChannelConnectionState.DISCONNECTED
	elseif vx_session_text_state == 1 then
		return ChatManagerConstants.ChannelConnectionState.CONNECTED
	elseif vx_session_text_state == 2 then
		return ChatManagerConstants.ChannelConnectionState.CONNECTING
	elseif vx_session_text_state == 3 then
		return ChatManagerConstants.ChannelConnectionState.DISCONNECTING
	else
		return nil
	end
end

local function session_media_state_enum(vx_session_media_state)
	if vx_session_media_state == 1 then
		return ChatManagerConstants.ChannelConnectionState.DISCONNECTED
	elseif vx_session_media_state == 2 then
		return ChatManagerConstants.ChannelConnectionState.CONNECTED
	elseif vx_session_media_state == 3 then
		return ChatManagerConstants.ChannelConnectionState.RINGING
	elseif vx_session_media_state == 6 then
		return ChatManagerConstants.ChannelConnectionState.CONNECTING
	elseif vx_session_media_state == 7 then
		return ChatManagerConstants.ChannelConnectionState.DISCONNECTING
	else
		return nil
	end
end

local function connection_state_enum(vx_connection_state)
	if vx_connection_state == 0 then
		return ChatManagerConstants.ConnectionState.DISCONNECTED
	elseif vx_connection_state == 1 then
		return ChatManagerConstants.ConnectionState.CONNECTED
	elseif vx_connection_state == 3 then
		return ChatManagerConstants.ConnectionState.RECOVERING
	elseif vx_connection_state == 4 then
		return ChatManagerConstants.ConnectionState.FAILED_TO_RECOVER
	elseif vx_connection_state == 5 then
		return ChatManagerConstants.ConnectionState.RECOVERED
	else
		return nil
	end
end

ChatManager.is_mic_muted = function (self)
	return self:is_connected() and self._local_audio_info and self._local_audio_info.is_mic_muted
end

ChatManager.mute_local_mic = function (self, mute)
	if not self:is_connected() then
		return
	end

	Vivox.mute_local_mic(mute)

	if self._local_audio_info then
		self._local_audio_info.is_mic_muted = mute
	end

	self._time_since_mute_local_mic = 0
end

ChatManager.channel_text_mute_participant = function (self, channel_handle, participant_uri, mute)
	Log.info("ChatManager", "Text %s participant %s in channel %s", mute and "muting" or "unmuting", participant_uri, channel_handle)
	Vivox.text_session_set_participant_mute_for_me(channel_handle, participant_uri, mute)
end

ChatManager.channel_voip_mute_participant = function (self, channel_handle, participant_uri, mute)
	Log.info("ChatManager", "Voip %s participant %s in channel %s", mute and "muting" or "unmuting", participant_uri, channel_handle)
	Vivox.audio_session_set_participant_mute_for_me(channel_handle, participant_uri, mute)
end

ChatManager.player_mute_status_changed = function (self, account_id)
	for session_handle, channel in pairs(self._sessions) do
		for participant_uri, participant in pairs(channel.participants) do
			local skip = participant.is_current_user or account_id and account_id ~= "" and account_id ~= "n/a" and account_id ~= participant.account_id

			if not skip then
				participant.is_validated = false
				participant.is_mute_status_set = false
			end
		end
	end
end

ChatManager.get_capture_devices = function (self)
	return self._capture_devices
end

ChatManager.set_capture_device = function (self, device_id)
	local found_device, default_device = nil

	for _, device in ipairs(self:get_capture_devices()) do
		if device.device == device_id then
			found_device = device
		end

		if device.device == "Default System Device" then
			default_device = device
		end
	end

	if not found_device then
		Log.error("ChatManager", "Could not find capture device with id: %s. Resetting to default", device_id)

		self._current_capture_device = default_device

		Vivox.set_capture_device(self._account_handle, default_device.device)
	else
		Log.info("ChatManager", "Setting capture device to: %s, previously: %s", found_device.display_name, self._current_capture_device.display_name)

		self._current_capture_device = found_device

		Vivox.set_capture_device(self._account_handle, device_id)
	end
end

ChatManager._poll_party = function (self)
	if Managers.party_immaterium then
		local party_id = Managers.party_immaterium:party_id()

		if party_id and Managers.party_immaterium:num_other_members() > 0 then
			if not self._party_id_session_handles[party_id] then
				Managers.party_immaterium:request_vivox_party_token():next(function (vivox_data)
					if self._party_id_session_handles[party_id] then
						return
					end

					local channel = vivox_data.channelSip
					local token = vivox_data.token
					local voice = true
					local text = true

					self:join_chat_channel(channel, nil, voice, text, ChatManagerConstants.ChannelTag.PARTY, token)

					self._party_id_session_handles[party_id] = channel
				end):catch(function (error)
					Log.error("ChatManager", "Error connecting to party channel: " .. tostring(error))
				end)
			end
		else
			for _, session_handle in pairs(self._party_id_session_handles) do
				self:leave_channel(session_handle)
			end

			self._party_id_session_handles = {}
		end
	end
end

ChatManager._handle_event = function (self, message)
	if message.event == Vivox.EventType_LOGIN_STATE_CHANGE then
		local state = login_state_enum(message.state)
		self._login_state = state

		Managers.event:trigger("chat_manager_login_state_change", state)

		if state == ChatManagerConstants.LoginState.LOGGED_IN then
			for _, queued_channel in ipairs(self._join_queue) do
				local channel = queued_channel[1]
				local text = queued_channel[2]
				local voice = queued_channel[3]
				local vivox_token = queued_channel[4]

				Vivox.add_channel_session(self._account_handle, channel, text, voice, vivox_token)
			end

			Vivox.get_local_audio_info()
			Vivox.get_capture_devices(self._account_handle)

			local muted_setting = _sound_setting_option_voice_chat()

			if muted_setting == SOUND_SETTING_OPTIONS_VOICE_CHAT.voice_activated then
				self:mute_local_mic(false)
			else
				self:mute_local_mic(true)
			end
		end
	elseif message.event == Vivox.EventType_CONNECTION_STATE_CHANGE then
		local state = connection_state_enum(message.state)

		if self._connection_state ~= state then
			self._connection_state = state

			Managers.event:trigger("chat_manager_connection_state_change", state)
		end
	elseif message.event == Vivox.EventType_SESSION_ADDED then
		local tag = self:tag_from_session_handle(message.session_handle)
		local session = {
			participants = {},
			is_channel = message.is_channel,
			session_handle = message.session_handle,
			sessiongroup_handle = message.sessiongroup_handle,
			name = message.name,
			tag = tag
		}
		self._sessions[message.session_handle] = session

		Managers.event:trigger("chat_manager_added_channel", message.session_handle, session)
	elseif message.event == Vivox.EventType_SESSION_REMOVED then
		Managers.event:trigger("chat_manager_removed_channel", message.session_handle)

		self._sessions[message.session_handle] = nil
		self._channel_host_peer_id[message.session_handle] = nil
	elseif message.event == Vivox.EventType_TEXT_STREAM_UPDATED then
		local state = session_text_state_enum(message.session_text_state)

		if self._sessions[message.session_handle] then
			self._sessions[message.session_handle].session_text_state = state

			Managers.event:trigger("chat_manager_updated_channel_state", message.session_handle, state)
		end
	elseif message.event == Vivox.EventType_MEDIA_STREAM_UPDATED then
		local state = session_media_state_enum(message.session_media_state)

		if self._sessions[message.session_handle] then
			self._sessions[message.session_handle].session_media_state = state
			self._sessions[message.session_handle].incoming = message.incoming

			Managers.event:trigger("voip_manager_updated_channel_state", message.session_handle, state, message.incoming)
		end

		if state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			Vivox.get_local_audio_info()
			_update_local_render_volume(message.session_handle)
			self:_update_transmitting_channel_priority()
		elseif state == ChatManagerConstants.ChannelConnectionState.DISCONNECTED then
			self:_update_transmitting_channel_priority()
		end
	elseif message.event == Vivox.EventType_MESSAGE then
		if not self._sessions[message.session_handle] then
			return
		end

		local participant = self._sessions[message.session_handle].participants[message.participant_uri]

		if not participant then
			return
		end

		if participant.is_validated == true then
			if string.sub(message.message_body, 1, 5) == "<loc|" then
				local parts = string.split(message.message_body, "|")

				if #parts == 3 then
					local key = parts[2]
					local status, result = pcall(cjson.decode, parts[3])

					if not status then
						Log.error("ChatManager", "Could not decode context: " .. parts[3])

						return
					end

					local localized_message_body = Managers.localization:localize(key, false, result)
					message.message_body = localized_message_body
				else
					return
				end
			end

			Managers.event:trigger("chat_manager_message_recieved", message.session_handle, participant, message)
		end
	elseif message.event == Vivox.EventType_PARTICIPANT_ADDED then
		if not self._sessions[message.session_handle] then
			return
		end

		local peer_id, account_id = self:split_displayname(message.displayname)
		local participant = {
			is_speaking = false,
			is_muted_for_me = false,
			is_validated = false,
			is_moderator_muted = false,
			is_text_muted_for_me = false,
			is_moderator_text_muted = false,
			is_mute_status_set = false,
			account_name = message.account_name,
			participant_uri = message.participant_uri,
			packed_displayname = message.displayname,
			peer_id = peer_id,
			account_id = account_id,
			joined_time = self._t,
			is_current_user = message.is_current_user
		}
		self._sessions[message.session_handle].participants[message.participant_uri] = participant

		if participant.is_current_user then
			participant.is_validated = true
			participant.is_mute_status_set = true
		end
	elseif message.event == Vivox.EventType_PARTICIPANT_UPDATED then
		if not self._sessions[message.session_handle] then
			return
		end

		local participant = self._sessions[message.session_handle].participants[message.participant_uri]
		participant.is_speaking = message.is_speaking
		participant.is_moderator_muted = message.is_moderator_muted
		participant.is_moderator_text_muted = message.is_moderator_text_muted
		participant.is_muted_for_me = message.is_muted_for_me
		participant.is_text_muted_for_me = message.is_text_muted_for_me

		Managers.event:trigger("chat_manager_participant_update", message.session_handle, participant)
	elseif message.event == Vivox.EventType_PARTICIPANT_REMOVED then
		if not self._sessions[message.session_handle] then
			return
		end

		local session = self._sessions[message.session_handle]
		local participant = session.participants[message.participant_uri]
		session.participants[message.participant_uri] = nil

		Managers.event:trigger("chat_manager_participant_removed", message.session_handle, message.participant_uri, participant)
	end
end

ChatManager._handle_response = function (self, message)
	if message.response == Vivox.ResponseType_CONNECTOR_CREATE then
		if self._connection_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED then
			self._connection_state = ChatManagerConstants.ChannelConnectionState.CONNECTED

			Managers.event:trigger("chat_manager_connection_state_change", self._connection_state)
		end
	elseif message.response == Vivox.ResponseType_ACCOUNT_ANONYMOUS_LOGIN then
		self._account_handle = message.account_handle
	elseif message.response == Vivox.ResponseType_GET_LOCAL_AUDIO_INFO then
		if self._local_audio_info and self._local_audio_info.is_mic_muted ~= message.is_mic_muted then
			local assumed_muted = self._local_audio_info.is_mic_muted and "muted" or "unmuted"
			local got_muted = message.is_mic_muted and "muted" or "unmuted"

			Log.warning("ChatManager", "Assumed our local mic was %s but local audio info says it was %s.", assumed_muted, got_muted)
			self:mute_local_mic(message.is_mic_muted)
		end

		self._local_audio_info = {
			is_mic_muted = message.is_mic_muted,
			is_speaker_muted = message.is_speaker_muted,
			mic_volume = message.mic_volume,
			speaker_volume = message.speaker_volume
		}
	elseif message.response == Vivox.ResponseType_GET_CAPTURE_DEVICES then
		self._capture_devices = message.capture_devices
		self._current_capture_device = message.current_capture_device

		if Application.user_setting and Application.user_setting("sound_settings") and Application.user_setting("sound_settings").capture_device then
			local option = Application.user_setting("sound_settings").capture_device

			if option ~= self._current_capture_device.device then
				self:set_capture_device(option)
			end
		end
	end
end

ChatManager._handle_response_error = function (self, message)
	local filter_exception = false

	if message.response_type_string == "resp_session_set_participant_mute_for_me" and message.response_status_code == 20000 then
		filter_exception = true
	elseif message.response_type_string == "resp_sessiongroup_set_tx_no_session" and message.response_status_code == 1001 then
		filter_exception = true
	elseif message.response_status_code == 1001 then
		filter_exception = true
	end

	local exception_message = string.format("Vivox response error %s (%s): %s (%s)", tostring(message.response_type_string), tostring(message.response_type), tostring(message.response_error_string), tostring(message.response_status_code))

	if filter_exception then
		Log.error("ChatManager", exception_message)
	else
		Crashify.print_exception("Vivox", exception_message)
	end
end

ChatManager._validate_participants = function (self)
	local my_platform = Managers.data_service.social:platform()

	for session_handle, channel in pairs(self._sessions) do
		for participant_uri, participant in pairs(channel.participants) do
			if not participant.is_validated then
				if not participant.player_info and participant.account_id and Managers.data_service.social then
					local player_info = Managers.data_service.social:get_player_info_by_account_id(participant.account_id)
					participant.player_info = player_info
				end

				if not participant.player_info then
					Log.warning("ChatManager", "Invalid participant %s, could not get PlayerInfo", participant_uri)

					return
				end

				local player_info = participant.player_info

				if not participant.displayname then
					local displayname = player_info:character_name()

					if displayname and displayname ~= "" and displayname ~= "N/A" then
						participant.displayname = displayname
					end
				end

				if not participant.is_mute_status_set then
					local text_mute = player_info:is_text_muted()
					local voice_mute = player_info:is_voice_muted()

					if IS_GDK or IS_XBS then
						local platform = player_info:platform()
						local platform_user_id = player_info:platform_user_id()

						if platform ~= my_platform then
							local relation = player_info:is_friend() and XblAnonymousUserType.CrossNetworkFriend or XblAnonymousUserType.CrossNetworkUser
							text_mute = Managers.account:has_crossplay_restriction(relation, XblPermission.CommunicateUsingText) or text_mute
							voice_mute = Managers.account:has_crossplay_restriction(relation, XblPermission.CommunicateUsingVoice) or voice_mute
						else
							local platform_muted = Managers.account:is_muted(platform_user_id)
							local communication_restricted = Managers.account:user_has_restriction(platform_user_id, XblPermission.CommunicateUsingVoice)
							text_mute = communication_restricted or text_mute
							voice_mute = platform_muted or voice_mute

							if not Managers.account:user_restriction_verified(platform_user_id, XblPermission.CommunicateUsingVoice) then
								local batch_type = "CHAT_" .. channel.tag

								Managers.account:verify_user_restriction_batched(platform_user_id, XblPermission.CommunicateUsingVoice, batch_type)
							end
						end
					end

					if text_mute ~= participant.is_text_muted_for_me then
						self:channel_text_mute_participant(session_handle, participant.participant_uri, text_mute)
					end

					if voice_mute ~= participant.is_muted_for_me then
						self:channel_voip_mute_participant(session_handle, participant.participant_uri, voice_mute)
					end

					participant.is_mute_status_set = true
				end

				if participant.displayname and participant.is_mute_status_set then
					participant.is_validated = true
					participant.player_info = nil

					if not participant.joined_announced then
						Managers.event:trigger("chat_manager_participant_added", session_handle, participant)

						participant.joined_announced = true
					end
				end
			end
		end
	end
end

ChatManager._update_transmitting_channel_priority = function (self)
	local priority = {
		[ChatManagerConstants.ChannelTag.MISSION] = 1,
		[ChatManagerConstants.ChannelTag.PARTY] = 2
	}
	local priority_channel = nil

	for session_handle, channel in pairs(self._sessions) do
		local session_media_state = channel.session_media_state

		if session_media_state and session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			local new_priority = priority[channel.tag]

			if new_priority then
				if not priority_channel then
					priority_channel = channel
				elseif new_priority < priority[priority_channel.tag] then
					priority_channel = channel
				end
			end
		end
	end

	if priority_channel then
		Vivox.set_tx_session(priority_channel.session_handle)
	end
end

implements(ChatManager, ChatManagerInterface)

return ChatManager
