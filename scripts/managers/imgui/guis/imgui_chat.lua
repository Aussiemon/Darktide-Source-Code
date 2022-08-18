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

	if Managers.chat == nil then
		Imgui.text("ChatManager not initialized")

		return
	end

	Imgui.begin_child_window("form", 400, 80, false)

	local connection_state = nil

	if Managers.chat:is_connected() then
		connection_state = "Connected to Vivox"
		local login_state = Managers.chat:login_state()

		if login_state == ChatManagerConstants.LoginState.LOGGED_OUT then
			connection_state = connection_state .. ", Logged out"
		elseif login_state == ChatManagerConstants.LoginState.LOGGED_IN then
			connection_state = connection_state .. ", Logged in"
		elseif login_state == ChatManagerConstants.LoginState.LOGGING_IN then
			connection_state = connection_state .. ", Logging in"
		elseif login_state == ChatManagerConstants.LoginState.LOGGING_OUT then
			connection_state = connection_state .. ", Logging out"
		end
	else
		connection_state = "Not connected to Vivox"
	end

	Imgui.text(connection_state)

	local is_mic_muted = Managers.chat:is_mic_muted()

	Imgui.text(string.format("Mic muted: %s", (is_mic_muted and "yes") or "no"))
	Imgui.end_child_window()

	for session_handle, session in pairs(Managers.chat._sessions) do
		self._session_expanded[session_handle] = Imgui.collapsing_header(session.channel_name or session_handle, true)

		if self._session_expanded[session_handle] then
			Imgui.text("Participants:")
			Imgui.indent()

			for participant_uri, participant in pairs(session.participants) do
				local name = (participant.is_current_user and "Me") or participant.displayname or participant_uri
				local peer_id = (participant.peer_id and participant.peer_id) or "nil"
				local speaking = (participant.is_speaking and ", Speaking") or ""
				local voip_muted = participant.is_muted_for_me or participant.is_moderator_muted
				local voip_muted_text = (voip_muted and ", voip muted") or ""
				local text_muted = participant.is_text_muted_for_me or participant.is_moderator_text_muted
				local text_muted_text = (text_muted and ", text muted") or ""
				local text = string.format("%s (%s)%s%s%s", name, peer_id, speaking, voip_muted_text, text_muted_text)

				Imgui.text(text)

				if Imgui.button(((voip_muted and "Unmute voip") or "Mute voip") .. "##" .. participant_uri) then
					Managers.chat:channel_voip_mute_participant(session_handle, participant_uri, not voip_muted)
				end

				Imgui.same_line()

				if Imgui.button(((text_muted and "Unmute text") or "Mute text") .. "##" .. participant_uri) then
					Managers.chat:channel_text_mute_participant(session_handle, participant_uri, not text_muted)
				end

				Imgui.text("")
			end

			Imgui.unindent()
		end
	end
end

return ImguiChat
