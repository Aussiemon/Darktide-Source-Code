local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local ImguiChat = class("ImguiChat")

ImguiChat.init = function (self)
	self._window_width = 800
	self._window_height = 400
	self._form_channel = ""
	self._channel_inputs = {}
	self._session_expanded = {}
end

ImguiChat.update = function (self, dt, t)
	Imgui.set_window_size(self._window_width, self._window_height, "once")

	if Managers.chat == nil or not rawget(_G, "Vivox") then
		Imgui.text("ChatManager not initialized")

		return
	end

	Imgui.begin_child_window("form", 400, 85, false)

	local connection_string = Managers.chat:connection_state() or "No connection state"

	Imgui.text(connection_string)

	local login_string = Managers.chat:login_state() or "No login state"

	Imgui.text(login_string)

	local is_mic_muted = Managers.chat:is_mic_muted()

	Imgui.text(string.format("Mic muted: %s", is_mic_muted and "yes" or "no"))

	if Managers.chat._local_audio_info then
		Imgui.text(string.format("Mic volume: %s%%", tostring(Managers.chat._local_audio_info.mic_volume)))
		Imgui.text(string.format("Speaker volume: %s%%", tostring(Managers.chat._local_audio_info.speaker_volume)))
	end

	Imgui.end_child_window()

	for session_handle, session in pairs(Managers.chat._sessions) do
		self._session_expanded[session_handle] = Imgui.collapsing_header(session.channel_name or session_handle, true)

		if self._session_expanded[session_handle] then
			local voice_connected = session.session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED

			Imgui.text(string.format("Connected voice: %s", voice_connected and "true" or "false"))
			Imgui.text("Participants:")
			Imgui.indent()

			for participant_uri, participant in pairs(session.participants) do
				local name = participant.is_current_user and "Me" or participant.displayname or participant_uri
				local peer_id = participant.peer_id and participant.peer_id or "nil"
				local voip_muted = participant.is_muted_for_me or participant.is_moderator_muted
				local text_muted = participant.is_text_muted_for_me or participant.is_moderator_text_muted
				local text = string.format("%s (%s)", name, peer_id)

				Imgui.text(text)
				Imgui.same_line()

				if Imgui.button((voip_muted and "Unmute voip" or "Mute voip") .. "##" .. participant_uri) then
					Managers.chat:channel_voip_mute_participant(session_handle, participant_uri, not voip_muted)
				end

				Imgui.same_line()

				if Imgui.button((text_muted and "Unmute text" or "Mute text") .. "##" .. participant_uri) then
					Managers.chat:channel_text_mute_participant(session_handle, participant_uri, not text_muted)
				end

				Imgui.same_line()

				local speaking = participant.is_speaking and "Speaking" or ""

				Imgui.text(speaking)
				Imgui.indent()
				Imgui.text(string.format("account_id: %s", participant.account_id))
				Imgui.text(string.format("account_name: %s", participant.account_name))
				Imgui.text(string.format("player_info: %s", participant.player_info))
				Imgui.text(string.format("packed_displayname: %s", participant.packed_displayname))
				Imgui.text(string.format("displayname: %s", participant.displayname))
				Imgui.text(string.format("displayname_set: %s", participant.displayname_set))
				Imgui.text(string.format("participant_uri: %s", participant.participant_uri))
				Imgui.text(string.format("peer_id: %s", participant.peer_id))
				Imgui.text(string.format("is_current_user: %s", participant.is_current_user and "true" or "false"))
				Imgui.text(string.format("is_speaking: %s", participant.is_speaking and "true" or "false"))
				Imgui.text(string.format("is_mute_status_set: %s", participant.is_mute_status_set and "true" or "false"))
				Imgui.text(string.format("is_moderator_muted: %s", participant.is_moderator_muted and "true" or "false"))
				Imgui.text(string.format("is_moderator_text_muted: %s", participant.is_moderator_text_muted and "true" or "false"))
				Imgui.text(string.format("is_muted_for_me: %s", participant.is_muted_for_me and "true" or "false"))
				Imgui.text(string.format("is_text_muted_for_me: %s", participant.is_text_muted_for_me and "true" or "false"))
				Imgui.text("")
				Imgui.unindent()
			end

			Imgui.unindent()
		end
	end
end

return ImguiChat
