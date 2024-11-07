-- chunkname: @scripts/ui/constant_elements/elements/voice_chat/constant_element_voice_chat.lua

local ConstantElementVoiceChatDefinitions = require("scripts/ui/constant_elements/elements/voice_chat/constant_element_voice_chat_definitions")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local PlayerInfo = require("scripts/managers/data_service/services/social/player_info")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local ConstantElementVoiceChat = class("ConstantElementVoiceChat", "ConstantElementBase")

ConstantElementVoiceChat.init = function (self, parent, draw_layer, start_scale, data, definition_path, definition_settings)
	self._settings = definition_settings

	ConstantElementVoiceChat.super.init(self, parent, draw_layer, start_scale, ConstantElementVoiceChatDefinitions)

	self._players_speaking = {}
	self._available_players = {}
	self._players_speaking_order = {}
	self._ready = false
	self._should_render = false

	Managers.event:register(self, "chat_manager_participant_update", "_chat_manager_participant_update")
	Managers.event:register(self, "chat_manager_participant_added", "_chat_manager_participant_added")
	Managers.event:register(self, "chat_manager_participant_removed", "_chat_manager_participant_removed")
	Managers.event:register(self, "voice_chat_visible_setting_update", "_update_voice_chat_visible_setting_update")
	Managers.event:register(self, "voip_manager_updated_channel_state", "_voip_manager_updated_channel_state")
end

ConstantElementVoiceChat._update_voice_chat_visible_setting_update = function (self, value)
	self._should_render = value
end

ConstantElementVoiceChat.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	ConstantElementVoiceChat.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if not self._ready and Managers.save and self._voice_available then
		local save_manager = Managers.save

		if save_manager then
			local account_data = save_manager:account_data()
			local voice_chat_visible_all_time = account_data and account_data.interface_settings.voice_chat_visible_all_time

			self._should_render = voice_chat_visible_all_time
		end

		local player_manager = Managers.player
		local player = player_manager:local_player(1)
		local account_id = player:account_id()
		local player_info = Managers.data_service.social:get_player_info_by_account_id(account_id)

		self._available_players[account_id] = string.format("%s - %s", player_info:character_name(), player_info:user_display_name())
		self._own_player_account_id = account_id
		self._ready = true
	end

	if self._ready and self._should_render then
		self:_update_players_speaking(dt, t, ui_renderer)
	end
end

ConstantElementVoiceChat._update_players_speaking = function (self, dt, t, ui_renderer)
	local widgets_names = {
		"player_1",
		"player_2",
		"player_3",
		"player_4",
	}

	for i = 1, #widgets_names do
		local widget_name = widgets_names[i]
		local account_id = self._players_speaking_order[i]
		local widget = self._widgets_by_name[widget_name]

		if widget then
			widget.content.account_id = nil
			widget.content.display_name = ""
			widget.content.visible = false

			if account_id and self._players_speaking[account_id] then
				widget.content.account_id = account_id
				widget.content.display_name = self._available_players[account_id] or ""
				widget.content.visible = widget.content.display_name ~= ""
			end
		end
	end
end

ConstantElementVoiceChat._remove_speaking_player = function (self, removed_account_id)
	if self._players_speaking[removed_account_id] then
		self._players_speaking[removed_account_id] = nil
	end

	local check_remove_account = true

	while check_remove_account do
		local index

		for i = 1, #self._players_speaking_order do
			local account_id = self._players_speaking_order[i]

			if account_id and account_id == removed_account_id then
				index = i

				break
			end
		end

		check_remove_account = not not index

		if index then
			table.remove(self._players_speaking_order, index)
		end
	end
end

ConstantElementVoiceChat._chat_manager_participant_update = function (self, channel_handle, participant)
	if participant then
		local is_speaking = not participant.is_muted_for_me and participant.is_speaking
		local account_id = participant.account_id

		if is_speaking and account_id then
			self._players_speaking[account_id] = true

			local account_is_speaking = false

			for i = 1, #self._players_speaking_order do
				local speaking_account = self._players_speaking_order[i]

				if speaking_account == account_id then
					account_is_speaking = true

					break
				end
			end

			if not account_is_speaking then
				self._players_speaking_order[#self._players_speaking_order + 1] = account_id
			end
		elseif account_id then
			self:_remove_speaking_player(account_id)
		end
	end
end

ConstantElementVoiceChat._chat_manager_participant_removed = function (self, channel_handle, participant_uri, participant)
	local account_id = participant and participant.account_id

	self:_remove_speaking_player(account_id)
end

ConstantElementVoiceChat._chat_manager_participant_added = function (self, channel_handle, participant)
	local account_id = participant and participant.account_id

	if account_id then
		local player_info = Managers.data_service.social:get_player_info_by_account_id(account_id)

		self._available_players[account_id] = string.format("%s - %s", player_info:character_name(), player_info:user_display_name())
	end
end

ConstantElementVoiceChat.destroy = function (self, ui_renderer)
	Managers.event:unregister(self, "chat_manager_participant_update")
	Managers.event:unregister(self, "chat_manager_participant_added")
	Managers.event:unregister(self, "chat_manager_participant_removed")
	Managers.event:unregister(self, "voice_chat_visible_setting_update")
	Managers.event:unregister(self, "voip_manager_updated_channel_state")
	ConstantElementVoiceChat.super.destroy(self, ui_renderer)
end

ConstantElementVoiceChat.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._ready or not self._should_render then
		return
	end

	ConstantElementVoiceChat.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementVoiceChat._voip_manager_updated_channel_state = function (self, session_handle, state, incoming)
	self._voice_available = state == ChatManagerConstants.ChannelConnectionState.CONNECTED

	if state == ChatManagerConstants.ChannelConnectionState.DISCONNECTED then
		for account_id, name in pairs(self._available_players) do
			self:_remove_player(account_id)
		end
	end
end

ConstantElementVoiceChat._remove_player = function (self, account_id)
	if account_id then
		self:_remove_speaking_player(account_id)

		if account_id ~= self._own_player_account_id then
			self._available_players[account_id] = nil
		end
	end
end

return ConstantElementVoiceChat
