local ChatManagerInterface = require("scripts/foundation/managers/chat/chat_manager_interface")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local VivoxManager = class("VivoxManager")

VivoxManager.init = function (self)
	self._initialized = false
	self._connected = false
	self._login_state = 0
	self._account_handle = nil
	self._privileges_manager = nil
	self._sessions = {}
	self._join_queue = {}
end

VivoxManager.split_peer_id_display_name = function (self, input)
	local separator = string.find(input, "|")

	if separator and separator < string.len(input) and separator > 1 then
		local peer_id = string.sub(input, 1, separator - 1)
		local displayname = string.sub(input, separator + 1)

		return peer_id, displayname
	end

	return nil
end

VivoxManager.split_session_handle = function (self, input)
	local separator = string.find(input, "~")

	if separator and separator < string.len(input) and separator > 1 then
		local name = string.sub(input, 1, separator - 1)
		local tag = string.sub(input, separator + 1)
		tag = string.match(tag, "(.+)@")

		return name, tag
	end

	return nil
end

VivoxManager.peer_id_from_session_handle = function (self, input)
	return input and string.match(input, "%.(.+)~")
end

VivoxManager.tag_from_session_handle = function (self, input)
	return input and string.match(input, "~(.+)@")
end

VivoxManager.initialize = function (self)
	if rawget(_G, "Vivox") then
		local verbose_chat_log = DevParameters.verbose_chat_log == true

		if Vivox.initialize(verbose_chat_log) then
			self._initialized = true

			Vivox.create_connector()

			self._privileges_manager = PrivilegesManager:new()
		end
	else
		Log.error("VivoxManager", "Vivox not available")
	end
end

VivoxManager.is_initialized = function (self)
	return self._initialized
end

VivoxManager.is_connected = function (self)
	return self._connected
end

VivoxManager.login_state = function (self)
	return self._login_state
end

VivoxManager.is_logged_in = function (self)
	return self:login_state() == ChatManagerConstants.LoginState.LOGGED_IN and self._account_handle ~= nil
end

VivoxManager.login = function (self, peer_id, displayname)
	assert(self:is_initialized() and self:is_connected(), "VivoxManager not connected")

	local login_name = peer_id .. "|" .. displayname

	Vivox.login(login_name)
end

VivoxManager.join_chat_channel = function (self, channel, voice, tag)
	if not self:is_logged_in() then
		return
	end

	assert(tag, "Joining a channel requires a tag")
	self._privileges_manager:communications_privilege(false):next(function (results)
		if results.has_privilege == true then
			local channel_name = channel .. "~" .. tostring(tag)

			if self:is_logged_in() then
				Vivox.add_channel_session(self._account_handle, channel_name, true, voice)
			else
				table.insert(self._join_queue, {
					channel_name,
					true,
					voice
				})
			end
		else
			local error = string.format("Communications privilege denied: %s", results.deny_reason or "Unknown reason")

			Log.error("VivoxManager", "Error joining channel %s: %s", channel, error)
		end
	end):catch(function (error)
		Log.error("VivoxManager", "Error joining channel %s: %s", channel, error)
	end)
end

VivoxManager.leave_channel = function (self, channel_handle)
	if self:is_logged_in() then
		Vivox.remove_session(channel_handle)

		self._sessions[channel_handle] = nil
	end
end

VivoxManager.connected_chat_channels = function (self)
	local channels = {}

	for channel_handle, channel in pairs(self._sessions) do
		local session_text_state = channel.session_text_state

		if session_text_state and session_text_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			channels[channel_handle] = channel
		end
	end

	return channels
end

VivoxManager.connected_voip_channels = function (self)
	local channels = {}

	for channel_handle, channel in pairs(self._sessions) do
		local session_media_state = channel.session_media_state

		if session_media_state and session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			channels[channel_handle] = channel
		end
	end

	return channels
end

VivoxManager.connected_to_chat_channel = function (self, peer_id, tag)
	return self:_connected_to_channel(peer_id, tag, "session_text_state")
end

VivoxManager.connected_to_voip_channel = function (self, peer_id, tag)
	return self:_connected_to_channel(peer_id, tag, "session_media_state")
end

VivoxManager._connected_to_channel = function (self, peer_id, tag, state)
	for channel_handle, channel in pairs(self._sessions) do
		local channel_tag = self:tag_from_session_handle(channel_handle)

		if channel_tag == tag then
			local channel_peer_id = self:peer_id_from_session_handle(channel_handle)

			if channel_peer_id == peer_id then
				local session_state = channel[state]

				if session_state and session_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
					return channel_handle
				end
			end
		end
	end

	return nil
end

VivoxManager.send_channel_message = function (self, channel_handle, message_body)
	assert(self:is_logged_in(), "VivoxManager not logged in")
	Vivox.send_session_message(channel_handle, message_body)
end

VivoxManager.update = function (self, dt, t)
	if self._privileges_manager then
		self._privileges_manager:update(dt, t)
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
				assert(message.type, "Vivox message missing type")

				if message.type == Vivox.MessageType_EVENT then
					self:_handle_event(message)
				elseif message.type == Vivox.MessageType_RESPONSE then
					self:_handle_response(message)
				end
			end
		end
	end
end

local function login_state(vx_login_state_change_state)
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

local function session_text_state(vx_session_text_state)
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

local function session_media_state(vx_session_media_state)
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

VivoxManager.is_mic_muted = function (self)
	return self._local_audio_info and self._local_audio_info.is_mic_muted
end

VivoxManager.mute_local_mic = function (self, mute)
	Vivox.mute_local_mic(mute)
end

VivoxManager.channel_text_mute_participant = function (self, channel_handle, participant_uri, mute)
	Vivox.text_session_set_participant_mute_for_me(channel_handle, participant_uri, mute)
end

VivoxManager.channel_voip_mute_participant = function (self, channel_handle, participant_uri, mute)
	Vivox.audio_session_set_participant_mute_for_me(channel_handle, participant_uri, mute)
end

VivoxManager._handle_event = function (self, message)
	assert(message.event, "Missing event")

	if message.event == Vivox.EventType_LOGIN_STATE_CHANGE then
		assert(message.state, "EventType_LOGIN_STATE_CHANGE missing state")

		local state = login_state(message.state)
		self._login_state = state

		Managers.event:trigger("chat_manager_login_state_change", state)

		if state == ChatManagerConstants.LoginState.LOGGED_IN then
			for _, queued_channel in ipairs(self._join_queue) do
				local channel = queued_channel[1]
				local text = queued_channel[2]
				local voice = queued_channel[3]

				Vivox.add_channel_session(self._account_handle, channel, text, voice)
			end

			Vivox.get_local_audio_info()

			local mute = true

			if PLATFORM == "xbs" then
				mute = false
			elseif Application.user_setting and Application.user_setting() and Application.user_setting().sound_settings and Application.user_setting().sound_settings.voice_chat then
				mute = Application.user_setting().sound_settings.voice_chat == 0
			end

			self:mute_local_mic(mute)
		end
	elseif message.event == Vivox.EventType_SESSION_ADDED then
		assert(message.session_handle, "EventType_SESSION_ADDED missing session_handle")

		local tag = self:tag_from_session_handle(message.session_handle)
		local session = {
			messages = {},
			participants = {},
			is_channel = message.is_channel,
			session_handle = message.session_handle,
			name = message.name,
			tag = tag
		}
		self._sessions[message.session_handle] = session

		Managers.event:trigger("chat_manager_added_channel", message.session_handle, session)
	elseif message.event == Vivox.EventType_SESSION_REMOVED then
		assert(message.session_handle, "EventType_SESSION_REMOVED missing session_handle")

		self._sessions[message.session_handle] = nil

		Managers.event:trigger("chat_manager_removed_channel", message.session_handle)
	elseif message.event == Vivox.EventType_TEXT_STREAM_UPDATED then
		assert(message.session_handle, "EventType_TEXT_STREAM_UPDATED missing session_handle")
		assert(message.session_text_state, "EventType_TEXT_STREAM_UPDATED missing session_text_state")

		local state = session_text_state(message.session_text_state)

		if self._sessions[message.session_handle] then
			self._sessions[message.session_handle].session_text_state = state

			Managers.event:trigger("chat_manager_updated_channel_state", message.session_handle, state)
		end
	elseif message.event == Vivox.EventType_MEDIA_STREAM_UPDATED then
		assert(message.session_handle, "EventType_MEDIA_STREAM_UPDATED missing session_handle")
		assert(message.session_media_state, "EventType_MEDIA_STREAM_UPDATED missing session_media_state")
		assert(message.incoming ~= nil, "EventType_MEDIA_STREAM_UPDATED missing incoming flag")

		local state = session_media_state(message.session_media_state)

		if self._sessions[message.session_handle] then
			self._sessions[message.session_handle].session_media_state = state
			self._sessions[message.session_handle].incoming = message.incoming

			Managers.event:trigger("voip_manager_updated_channel_state", message.session_handle, state, message.incoming)
		end
	elseif message.event == Vivox.EventType_MESSAGE then
		assert(message.session_handle, "EventType_MESSAGE missing session_handle")

		if not self._sessions[message.session_handle] then
			return
		end

		table.insert(self._sessions[message.session_handle].messages, message)

		local participant = self._sessions[message.session_handle].participants[message.participant_uri]

		Managers.event:trigger("chat_manager_message_recieved", message.session_handle, participant, message)
	elseif message.event == Vivox.EventType_PARTICIPANT_ADDED then
		assert(message.session_handle, "EventType_PARTICIPANT_ADDED missing session_handle")
		assert(message.participant_uri, "EventType_PARTICIPANT_ADDED missing participant_url")

		if not self._sessions[message.session_handle] then
			return
		end

		local peer_id, displayname = self:split_peer_id_display_name(message.displayname)
		local participant = {
			is_speaking = false,
			is_muted_for_me = false,
			is_moderator_muted = false,
			is_text_muted_for_me = false,
			is_moderator_text_muted = false,
			account_name = message.account_name,
			participant_uri = message.participant_uri,
			displayname = displayname and displayname or message.displayname,
			peer_id = peer_id,
			is_current_user = message.is_current_user
		}
		self._sessions[message.session_handle].participants[message.participant_uri] = participant

		Managers.event:trigger("chat_manager_participant_added", message.session_handle, participant)
	elseif message.event == Vivox.EventType_PARTICIPANT_UPDATED then
		assert(message.session_handle, "EventType_PARTICIPANT_UPDATED missing session_handle")
		assert(message.participant_uri, "EventType_PARTICIPANT_UPDATED missing participant_url")

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
		assert(message.session_handle, "EventType_PARTICIPANT_REMOVED missing session_handle")
		assert(message.participant_uri, "EventType_PARTICIPANT_REMOVED missing participant_url")

		if not self._sessions[message.session_handle] then
			return
		end

		local session = self._sessions[message.session_handle]
		local participant = session.participants[message.participant_uri]
		session.participants[message.participant_uri] = nil

		Managers.event:trigger("chat_manager_participant_removed", message.session_handle, message.participant_uri, participant)
	end
end

VivoxManager._handle_response = function (self, message)
	assert(message.response, "Missing response")

	if message.response == Vivox.ResponseType_CONNECTOR_CREATE then
		self._connected = true

		Managers.event:trigger("chat_manager_connected", self._connected)
	elseif message.response == Vivox.ResponseType_ACCOUNT_ANONYMOUS_LOGIN then
		assert(message.account_handle, "ResponseType_ACCOUNT_ANONYMOUS_LOGIN missing account_handle")

		self._account_handle = message.account_handle
	elseif message.response == Vivox.ResponseType_MUTED_LOCAL_MIC then
		Vivox.get_local_audio_info()
	elseif message.response == Vivox.ResponseType_GET_LOCAL_AUDIO_INFO then
		self._local_audio_info = {
			is_mic_muted = message.is_mic_muted,
			is_speaker_muted = message.is_speaker_muted,
			mic_volume = message.mic_volume,
			speaker_volume = message.speaker_volume
		}
	end
end

implements(VivoxManager, ChatManagerInterface)

return VivoxManager
