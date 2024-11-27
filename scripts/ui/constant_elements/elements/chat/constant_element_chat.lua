-- chunkname: @scripts/ui/constant_elements/elements/chat/constant_element_chat.lua

local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local Definitions = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local Promise = require("scripts/foundation/utilities/promise")
local StringVerification = require("scripts/managers/localization/string_verification")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ConstantElementChat = class("ConstantElementChat", "ConstantElementBase")
local States = table.enum("hidden", "idle", "active")
local StateSettings = {
	[States.hidden] = {
		target_alpha = 0,
		target_background_alpha = 0,
	},
	[States.idle] = {
		target_alpha = ChatSettings.idle_text_alpha / 255,
		target_background_alpha = ChatSettings.idle_background_alpha,
	},
	[States.active] = {
		target_alpha = 1,
		target_background_alpha = ChatSettings.background_color[1],
	},
}

ConstantElementChat.init = function (self, parent, draw_layer, start_scale, definitions)
	ConstantElementChat.super.init(self, parent, draw_layer, start_scale, Definitions)
	Managers.event:register(self, "chat_manager_connection_state_change", "cb_chat_manager_connection_state_change")
	Managers.event:register(self, "chat_manager_login_state_change", "cb_chat_manager_login_state_change")
	Managers.event:register(self, "chat_manager_removed_channel", "cb_chat_manager_removed_channel")
	Managers.event:register(self, "chat_manager_updated_channel_state", "cb_chat_manager_updated_channel_state")
	Managers.event:register(self, "chat_manager_message_recieved", "cb_chat_manager_message_recieved")
	Managers.event:register(self, "chat_manager_participant_added", "cb_chat_manager_participant_added")
	Managers.event:register(self, "chat_manager_participant_update", "cb_chat_manager_participant_update")
	Managers.event:register(self, "chat_manager_participant_removed", "cb_chat_manager_participant_removed")
	Managers.event:register(self, "system_chat_message", "cb_system_message_recieved")

	self._active_state = States.hidden
	self._message_widget_blueprints = Definitions.message_widget_blueprints
	self._messages = {}
	self._message_widgets = {}
	self._last_message_index = 0
	self._scroll_length_from_top = 0
	self._scroll_extra_vertical_offset = 0
	self._first_visible_chat_message = 0
	self._has_scrolled_back_in_history = false
	self._total_chat_height = 0
	self._removed_height_since_last_frame = 0
	self._selected_channel_handle = nil
	self._is_cursor_pushed = false
	self._is_always_visible = ChatSettings.is_always_visible
	self._alpha = 0
	self._time_since_last_update = ChatSettings.inactivity_timeout
	self._input_field_widget = nil
	self._reported_left_channel_handles = {}
	self._virtual_keyboard_promise = nil

	self:_setup_input()

	for channel_handle, channel in pairs(Managers.chat:connected_chat_channels()) do
		self:cb_chat_manager_added_channel(channel_handle, channel)
		self:_on_connect_to_channel(channel_handle)
	end
end

ConstantElementChat.destroy = function (self)
	self:_enable_mouse_cursor(false)
	Managers.event:unregister(self, "chat_manager_connection_state_change")
	Managers.event:unregister(self, "chat_manager_login_state_change")
	Managers.event:unregister(self, "chat_manager_removed_channel")
	Managers.event:unregister(self, "chat_manager_updated_channel_state")
	Managers.event:unregister(self, "chat_manager_message_recieved")
	Managers.event:unregister(self, "chat_manager_participant_added")
	Managers.event:unregister(self, "chat_manager_participant_update")
	Managers.event:unregister(self, "chat_manager_participant_removed")
	Managers.event:unregister(self, "system_chat_message")

	local virtual_keyboard_promise = self._virtual_keyboard_promise

	if virtual_keyboard_promise and virtual_keyboard_promise:is_pending() then
		virtual_keyboard_promise:cancel()

		self._virtual_keyboard_promise = nil
	end
end

ConstantElementChat.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	ConstantElementChat.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local is_visible = self._is_visible

	if is_visible then
		self:_handle_input(input_service, ui_renderer)
	end

	self:_update_message_widgets_sizes(ui_renderer)
	self:_update_scrollbar(render_settings)

	local input_widget = self._input_field_widget
	local is_input_field_active = input_widget.content.is_writing

	if self._refresh_to_channel_text then
		input_widget.content.force_caret_update = true

		self:_update_input_field(ui_renderer, input_widget)

		self._refresh_to_channel_text = nil
	end

	local time_since_last_update = is_input_field_active and 0 or self._time_since_last_update

	if is_visible then
		self._time_since_last_update = time_since_last_update + dt
	end

	local target_state
	local inactivity_timeout = ChatSettings.inactivity_timeout
	local idle_timeout = ChatSettings.idle_timeout

	if inactivity_timeout <= time_since_last_update and inactivity_timeout >= 0 and not is_input_field_active or not is_visible then
		target_state = States.hidden
	elseif idle_timeout <= time_since_last_update and idle_timeout >= 0 and not is_input_field_active then
		target_state = States.idle
	else
		target_state = States.active
	end

	local is_state_changing = self:_is_state_changing()

	if not is_state_changing and target_state ~= self._active_state then
		self:_change_state(target_state)
	end
end

ConstantElementChat._is_state_changing = function (self)
	return self:_is_animation_active(self._chat_window_animation_id) or self:_is_animation_active(self._input_field_animation_id)
end

ConstantElementChat._change_state = function (self, target_state)
	local params = {
		target_state = target_state,
		target_alpha = StateSettings[target_state].target_alpha,
		target_background_alpha = StateSettings[target_state].target_background_alpha,
		message_widgets = self._message_widgets,
	}
	local is_visible = self._is_visible
	local speed = target_state == States.hidden and is_visible and ChatSettings.inactive_fade_speed or 1

	self._chat_window_animation_id = self:_start_animation("fade_chat_window", self._widgets_by_name, params, nil, speed)
	self._input_field_animation_id = self:_start_animation("fade_input_field", self._widgets_by_name, params, nil, speed)
end

ConstantElementChat.using_input = function (self)
	return self._input_field_widget.content.is_writing and self._is_visible
end

ConstantElementChat.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	ConstantElementChat.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementChat.set_visible = function (self, visible, optional_visibility_parameters)
	ConstantElementChat.super.set_visible(self, visible, optional_visibility_parameters)
	self:_cancel_animations_if_necessary(true)

	if not visible then
		self:_enable_mouse_cursor(false)
	end

	local need_to_update_scenegraph = self:_apply_visibility_parameters(optional_visibility_parameters)
	local active_state = self._active_state

	if need_to_update_scenegraph and active_state ~= States.hidden then
		local fade_out_params = {
			target_alpha = 0,
			target_background_alpha = 0,
			target_state = active_state,
			message_widgets = self._message_widgets,
		}
		local fade_in_params = {
			target_state = active_state,
			target_alpha = active_state == States.idle and ChatSettings.idle_text_alpha / 255 or 1,
			target_background_alpha = active_state == States.idle and ChatSettings.idle_background_alpha or ChatSettings.background_color[1],
			message_widgets = self._message_widgets,
		}

		local function on_complete_callback()
			self._update_scenegraph = need_to_update_scenegraph
			self._chat_window_animation_id = self:_start_animation("fade_chat_window", self._widgets_by_name, fade_in_params, nil, 1)
			self._input_field_animation_id = self:_start_animation("fade_input_field", self._widgets_by_name, fade_in_params, nil, 1)
		end

		self._chat_window_animation_id = self:_start_animation("fade_chat_window", self._widgets_by_name, fade_out_params, on_complete_callback, 1)
		self._input_field_animation_id = self:_start_animation("fade_input_field", self._widgets_by_name, fade_out_params, nil, 1)
	end

	self._update_scenegraph = self._update_scenegraph or need_to_update_scenegraph
end

ConstantElementChat.should_draw = function (self)
	return self._is_visible and self._alpha > 0
end

ConstantElementChat.cb_chat_manager_login_state_change = function (self, login_state)
	return
end

ConstantElementChat.cb_chat_manager_removed_channel = function (self, channel_handle)
	self._reported_left_channel_handles[channel_handle] = nil
end

ConstantElementChat.cb_chat_manager_updated_channel_state = function (self, channel_handle, state)
	if state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
		self:_on_connect_to_channel(channel_handle)
	elseif state == ChatManagerConstants.ChannelConnectionState.DISCONNECTED then
		self:_on_disconnect_from_channel(channel_handle)
	end
end

ConstantElementChat.cb_system_message_recieved = function (self, message, channel_tag)
	self:_add_notification(message, channel_tag)
end

ConstantElementChat.cb_chat_manager_message_recieved = function (self, channel_handle, participant, message)
	StringVerification.verify(message.message_body):next(function (message_text)
		local channel = Managers.chat:sessions()[channel_handle]

		if not channel or channel.session_text_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED and channel.session_media_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED then
			return
		end

		local sender

		if message.is_current_user and channel.tag then
			local channel_name = self:_channel_name(channel.tag, false, channel.channel_name)

			sender = Managers.localization:localize("loc_chat_own_player", true, {
				channel_name = channel_name,
			})
		else
			sender = self:_participant_displayname(participant)

			if not sender then
				return
			end
		end

		self:_add_message(message_text, sender, channel)
	end):catch(function (error)
		Log.warning("ConstantElementChat", "Could not verify string, error: %s, string: %s", tostring(error), tostring(message.message_body))
	end)
end

ConstantElementChat.cb_chat_manager_participant_added = function (self, channel_handle, participant)
	if not participant.is_current_user and not participant.is_text_muted_for_me then
		local channel = Managers.chat:sessions()[channel_handle]

		if not channel or channel.session_text_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED and channel.session_media_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED then
			return
		end

		local show_notification = true

		if channel.tag == ChatManagerConstants.ChannelTag.HUB then
			show_notification = false
		else
			for _, other_channel in pairs(Managers.chat:sessions()) do
				if channel.session_handle ~= other_channel.session_handle and (channel.tag == ChatManagerConstants.ChannelTag.MISSION or channel.tag == ChatManagerConstants.ChannelTag.PARTY) and (other_channel.tag == ChatManagerConstants.ChannelTag.MISSION or other_channel.tag == ChatManagerConstants.ChannelTag.PARTY) and other_channel.participants[participant.participant_uri] ~= nil then
					show_notification = false

					break
				end
			end
		end

		if show_notification and channel.tag then
			local displayname = self:_participant_displayname(participant)

			if not displayname then
				return
			end

			local channel_name = self:_channel_name(channel.tag, true, channel.channel_name)
			local message = Managers.localization:localize("loc_chat_user_joined_channel", true, {
				channel_name = channel_name,
				display_name = displayname,
			})

			self:_add_notification(message)
		end
	end
end

ConstantElementChat.cb_chat_manager_participant_update = function (self, channel_handle, participant)
	return
end

ConstantElementChat.cb_chat_manager_participant_removed = function (self, channel_handle, participant_uri, participant)
	if not participant.is_current_user and not participant.is_text_muted_for_me then
		local channel = Managers.chat:sessions()[channel_handle]

		if not channel or not channel.tag or channel.session_text_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED and channel.session_media_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED then
			return
		end

		local show_notification = true

		if channel.tag == ChatManagerConstants.ChannelTag.HUB then
			show_notification = false
		else
			for _, other_channel in pairs(Managers.chat:sessions()) do
				if channel.session_handle ~= other_channel.session_handle and (channel.tag == ChatManagerConstants.ChannelTag.MISSION and other_channel.tag == ChatManagerConstants.ChannelTag.MISSION or other_channel.tag == ChatManagerConstants.ChannelTag.PARTY) and other_channel.participants[participant.participant_uri] ~= nil then
					show_notification = false

					break
				end
			end
		end

		if show_notification and channel.tag then
			local displayname = self:_participant_displayname(participant)

			if not displayname then
				return
			end

			local channel_name = self:_channel_name(channel.tag, true, channel.channel_name)
			local message = Managers.localization:localize("loc_chat_user_left_channel", true, {
				channel_name = channel_name,
				display_name = displayname,
			})

			self:_add_notification(message)
		end
	end
end

ConstantElementChat.cb_chat_manager_connection_state_change = function (self, state)
	if state == ChatManagerConstants.ConnectionState.CONNECTED then
		Managers.backend:authenticate():next(Promise.delay(1)):next(function (auth_data)
			local account_id = auth_data.sub
			local peer_id = Network.peer_id()
			local vivox_token = auth_data.vivox_token

			Managers.chat:login(peer_id, account_id, vivox_token)
		end):catch(function (error)
			Log.warning("ConstantElementChat", "Could not get display name for chat login: %s", tostring(error))
		end)
	end
end

ConstantElementChat._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantElementChat.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
	self:_draw_message_widgets(ui_renderer)
end

ConstantElementChat._draw_message_widgets = function (self, ui_renderer)
	local message_widgets = self._message_widgets
	local spacing = ChatSettings.message_spacing
	local message_vertical_offset = self:scenegraph_size("chat_message_area")[2] + spacing + self._scroll_extra_vertical_offset
	local i = self._first_visible_chat_message
	local last_index = self._last_message_index

	if #message_widgets > 0 then
		repeat
			local widget = message_widgets[i]
			local widget_size = widget and widget.content.size

			if widget_size then
				message_vertical_offset = message_vertical_offset - (widget_size[2] + spacing)
				widget.offset[2] = message_vertical_offset

				UIWidget.draw(widget, ui_renderer)
			end

			i = math.index_wrapper(i - 1, #message_widgets)
		until i == last_index or message_vertical_offset <= 0
	end
end

ConstantElementChat._setup_input = function (self)
	local input_manager = Managers.input

	self._input_manager = input_manager

	local scrollbar_widget = self._widgets_by_name.chat_scrollbar

	scrollbar_widget.style.mouse_scroll.scenegraph_id = "chat_window"
	scrollbar_widget.content.min_thumb_length = 0.05
	self._input_field_widget = self._widgets_by_name.input_field

	self:_setup_input_labels()
end

ConstantElementChat._setup_input_labels = function (self)
	local num_sessions = 0
	local in_mission = false
	local in_party = false

	for _, channel in pairs(Managers.chat:sessions()) do
		num_sessions = num_sessions + 1

		if channel.tag == ChatManagerConstants.ChannelTag.MISSION then
			in_mission = true
		end

		if channel.tag == ChatManagerConstants.ChannelTag.PARTY then
			in_party = true
		end
	end

	local has_session = num_sessions > 0
	local present_tab_to_cycle = num_sessions > 1

	if num_sessions == 2 and in_mission and in_party then
		present_tab_to_cycle = false
	end

	local input_widget = self._input_field_widget
	local has_virtual_keyboard = (IS_XBS or IS_PLAYSTATION) and InputDevice.gamepad_active
	local is_writing = input_widget.content.is_writing
	local active_placeholder_text = ""

	if has_virtual_keyboard and not is_writing then
		local open_chat_input = self:_get_localized_input_text("show_chat")

		active_placeholder_text = self:_localize("loc_chat_idle_placeholder_text", true, {
			input = open_chat_input,
		})
	elseif has_virtual_keyboard and is_writing and has_session and not present_tab_to_cycle then
		local confirm_input = self:_get_localized_input_text("confirm")
		local back_input = self:_get_localized_input_text("back")

		active_placeholder_text = self:_localize("loc_chat_instruction_placeholder_text", true, {
			continue_input = confirm_input,
			cancel_input = back_input,
		})
	elseif has_virtual_keyboard and not has_session or not has_virtual_keyboard and InputDevice.gamepad_active and is_writing then
		local back_input = self:_get_localized_input_text("back")

		active_placeholder_text = self:_localize("loc_chat_empty_placeholder_text", true, {
			input = back_input,
		})
	elseif present_tab_to_cycle then
		local change_channel_input = self:_get_localized_input_text("cycle_chat_channel")

		active_placeholder_text = self:_localize("loc_chat_active_placeholder_text", true, {
			input = change_channel_input,
		})
	end

	input_widget.content.active_placeholder_text = active_placeholder_text
end

ConstantElementChat._get_localized_input_text = function (self, action)
	local service_type = DefaultViewInputSettings.service_type
	local alias = Managers.input:alias_object(service_type)
	local show_controller = InputDevice.gamepad_active
	local device_types

	if IS_PLAYSTATION then
		device_types = {
			show_controller and "ps4_controller" or "keyboard",
		}
	else
		device_types = {
			show_controller and "xbox_controller" or "keyboard",
		}
	end

	local key_info = alias:get_keys_for_alias(action, device_types)
	local input_key = key_info and InputUtils.localized_string_from_key_info(key_info) or "n/a"

	return input_key
end

ConstantElementChat._start_chatting = function (self, ui_renderer)
	local input_widget = self._input_field_widget

	input_widget.content.input_text = ""
	input_widget.content.caret_position = 1
	input_widget.content.is_writing = true
	input_widget.content.force_caret_update = true

	if not self._selected_channel_handle then
		self._selected_channel_handle = self:_next_connected_channel_handle()
	end

	self:_cancel_animations_if_necessary()
	self:_enable_mouse_cursor(true)
	self:_update_input_field(ui_renderer, input_widget)
	self:_setup_input_labels()
end

ConstantElementChat._handle_keyboard_input = function (self, input_service, ui_renderer)
	local input_widget = self._input_field_widget
	local is_input_field_active = input_widget.content.is_writing

	if is_input_field_active then
		self:_handle_active_chat_input(input_service, ui_renderer)
	elseif input_service:get("show_chat") then
		self:_start_chatting(ui_renderer)
	end
end

ConstantElementChat._handle_console_input = function (self, input_service, ui_renderer)
	local input_widget = self._input_field_widget
	local is_active = self._active_state == States.active
	local using_input = self:using_input()

	if not is_active and input_service:get("show_chat") then
		self:_start_chatting(ui_renderer)
	end

	if not using_input then
		return
	end

	if input_service:get("close_view") or input_service:get("back") then
		input_widget.content.input_text = ""
		input_widget.content.is_writing = false

		self:_enable_mouse_cursor(false)
		self:_update_input_field(ui_renderer, input_widget)

		return
	end

	if input_service:get("cycle_chat_channel") then
		self._selected_channel_handle = self:_next_connected_channel_handle()
		input_widget.content.force_caret_update = true

		self:_update_input_field(ui_renderer, input_widget)

		return
	end

	if IS_XBS then
		if input_service:get("confirm_pressed") and not self._virtual_keyboard_promise then
			if not self._selected_channel_handle then
				return
			end

			local channel = Managers.chat:sessions()[self._selected_channel_handle]

			if not channel or not channel.tag or channel.session_text_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED and channel.session_media_state ~= ChatManagerConstants.ChannelConnectionState.CONNECTED then
				return
			end

			local virtual_keyboard_title = ""
			local virtual_keyboard_description = ""
			local x_game_ui = XGameUI.new_block()

			XGameUI.show_text_entry_async(x_game_ui, virtual_keyboard_title, virtual_keyboard_description, "", "default", ChatSettings.max_message_length)

			self._virtual_keyboard_promise = Managers.xasync:wrap(x_game_ui)

			self._virtual_keyboard_promise:next(function (async_block)
				local new_input_text = XGameUI.resolve_text_entry(async_block)
				local last_char = new_input_text:sub(#new_input_text)

				if last_char == "\x00" then
					new_input_text = new_input_text:sub(1, #new_input_text - 1)
				end

				Managers.chat:send_channel_message(self._selected_channel_handle, new_input_text)

				input_widget.content.input_text = ""
				input_widget.content.is_writing = false

				self:_update_input_field(ui_renderer, input_widget)

				self._virtual_keyboard_promise = nil
			end, function (hr_table)
				local hr = hr_table[1]

				if hr ~= HRESULT.E_ABORT then
					Log.warning("ConstantElementChat", "XBox virtual keyboard closed with 0x%x", hr)
				end

				input_widget.content.input_text = ""
				input_widget.content.is_writing = false

				self:_update_input_field(ui_renderer, input_widget)

				self._virtual_keyboard_promise = nil
			end)

			return
		end
	elseif IS_PLAYSTATION then
		local content = input_widget.content

		if input_service:get("confirm_pressed") and not PS5ImeDialog.is_showing() then
			local title = content.virtual_keyboard_title or content.placeholder_text
			local description = content.virtual_keyboard_description or ""
			local input_text = content.input_text or ""
			local max_length = content.max_length
			local keyboard_options = {
				title = title,
				placeholder = input_text,
				max_length = max_length,
			}

			PS5ImeDialog.show(keyboard_options)
		elseif PS5ImeDialog.is_finished() then
			local result, text = PS5ImeDialog.close()

			content.input_text = result == PS5ImeDialog.END_STATUS_OK and text or content.input_text
		elseif input_service:get("send_chat_message") and content.input_text ~= "" and self._selected_channel_handle then
			Managers.chat:send_channel_message(self._selected_channel_handle, content.input_text)

			content.input_text = ""
		end
	end
end

ConstantElementChat._handle_input = function (self, input_service, ui_renderer)
	local uses_virtual_keyboard = (IS_XBS or IS_PLAYSTATION) and InputDevice.gamepad_active

	if uses_virtual_keyboard then
		return self:_handle_console_input(input_service, ui_renderer)
	else
		return self:_handle_keyboard_input(input_service, ui_renderer)
	end
end

ConstantElementChat._handle_active_chat_input = function (self, input_service, ui_renderer)
	local input_widget = self._input_field_widget
	local input_text = input_widget.content.input_text
	local is_input_field_active = true
	local can_send_message = self._selected_channel_handle and #input_text > 0

	if input_service:get("cycle_chat_channel") then
		self._selected_channel_handle = self:_next_connected_channel_handle()
		input_widget.content.force_caret_update = true

		self:_update_input_field(ui_renderer, input_widget)
	elseif input_service:get("send_chat_message") and can_send_message then
		local command, params = self:_parse_slash_commands(input_text)

		if command then
			self:_handle_slash_command(command, params)
		else
			input_text = self:_scrub(input_text)

			Managers.chat:send_channel_message(self._selected_channel_handle, input_text)
		end

		is_input_field_active = false
	elseif input_service:get("send_chat_message") and #input_text == 0 then
		is_input_field_active = false
	elseif input_service:get("hotkey_system") or input_service:get("back") then
		is_input_field_active = false
	else
		local keystrokes = Keyboard.keystrokes()

		for _, keystroke in ipairs(keystrokes) do
			if type(keystroke) == "number" and keystroke == Keyboard.BACKSPACE and input_widget.content.input_text == "" then
				is_input_field_active = false
			end
		end
	end

	if not is_input_field_active then
		input_widget.content.input_text = ""
		input_widget.content.is_writing = false

		self:_enable_mouse_cursor(false)
	end
end

ConstantElementChat._next_connected_channel_handle = function (self, current_priority_index)
	local channels = {}

	for channel_handle, channel in pairs(Managers.chat:sessions()) do
		if channel.session_text_state == ChatManagerConstants.ChannelConnectionState.CONNECTED or channel.session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
			table.insert(channels, channel)
		end
	end

	table.sort(channels, function (a, b)
		local priority_a = ChatSettings.channel_priority[a.tag] or 0
		local priority_b = ChatSettings.channel_priority[b.tag] or 0

		if priority_a == priority_b then
			local channel_name_a = self:_channel_name(a.tag, false, a.channel_name)
			local channel_name_b = self:_channel_name(b.tag, false, b.channel_name)

			return channel_name_a < channel_name_b
		else
			return priority_a < priority_b
		end
	end)

	if #channels == 0 then
		return nil
	end

	if not self._selected_channel_handle then
		return channels[1].session_handle
	end

	local has_mission_channel = false

	for _, channel in ipairs(channels) do
		if channel.tag == ChatManagerConstants.ChannelTag.MISSION then
			has_mission_channel = true

			break
		end
	end

	if has_mission_channel then
		for index = #channels, 1, -1 do
			if channels[index].tag == ChatManagerConstants.ChannelTag.PARTY then
				channels[index] = nil
			end
		end
	end

	local current_selected_channel_handle_index

	for i, v in ipairs(channels) do
		if self._selected_channel_handle == v.session_handle then
			current_selected_channel_handle_index = i

			break
		end
	end

	if not current_selected_channel_handle_index then
		return channels[1].session_handle
	end

	local next_channel = channels[math.index_wrapper(current_selected_channel_handle_index + 1, #channels)]

	return next_channel and next_channel.session_handle
end

ConstantElementChat._update_input_field = function (self, ui_renderer, widget)
	local to_channel_text = ""
	local style = widget.style
	local to_channel_style = style.to_channel

	if self._selected_channel_handle then
		local channel = Managers.chat:sessions()[self._selected_channel_handle]

		if channel and channel.tag and (channel.session_text_state == ChatManagerConstants.ChannelConnectionState.CONNECTED or channel.session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED) then
			local channel_name = self:_channel_name(channel.tag, false, channel.channel_name)

			to_channel_text = Managers.localization:localize("loc_chat_to_channel", true, {
				channel_name = channel_name,
			})
			to_channel_style.text_color = self:_channel_color(channel.tag)
		end
	end

	widget.content.to_channel = to_channel_text

	local field_margin_left = ChatSettings.input_field_margins[1]
	local field_margin_right = ChatSettings.input_field_margins[4]
	local offset = self:_text_size(ui_renderer, to_channel_text, to_channel_style)

	offset = offset + to_channel_style.offset[1] + field_margin_left

	local text_style = style.display_text

	text_style.offset[1] = offset
	text_style.size = text_style.size or {}
	text_style.size_addition[1] = -(offset + field_margin_right)
	style.active_placeholder.offset[1] = offset

	self:_setup_input_labels()
end

ConstantElementChat._update_message_widgets_sizes = function (self, ui_renderer)
	local spacing = ChatSettings.message_spacing
	local message_widgets = self._message_widgets
	local i = self._last_message_index
	local widget = message_widgets[i]

	while widget and not widget.content.size do
		local widget_size = self:_calculate_widget_size(widget, ui_renderer)

		self._total_chat_height = self._total_chat_height + widget_size[2] + spacing
		i = math.index_wrapper(i - 1, #message_widgets)
		widget = message_widgets[i]
	end
end

ConstantElementChat._scroll_to_latest_message = function (self)
	self._first_visible_chat_message = self._last_message_index
	self._scroll_extra_vertical_offset = 0
	self._has_scrolled_back_in_history = false

	local scrollbar_widget = self._widgets_by_name.chat_scrollbar
	local scrollbar_content = scrollbar_widget.content

	scrollbar_content.scroll_value = nil
	scrollbar_content.value = 1
end

ConstantElementChat._update_scrollbar = function (self, render_settings)
	local messages = self._messages
	local total_num_messages = #messages
	local total_chat_height = self._total_chat_height
	local chat_window_height = self:scenegraph_size("chat_message_area", render_settings.scale)[2]
	local scrollbar_widget = self._widgets_by_name.chat_scrollbar
	local scrollbar_content = scrollbar_widget.content
	local scroll_value = scrollbar_content.scroll_value
	local total_scroll_length = total_chat_height - chat_window_height

	scrollbar_content.hotspot.is_focused = not InputDevice.gamepad_active or self:using_input()
	scrollbar_content.focused = InputDevice.gamepad_active and self:using_input()
	scrollbar_content.scroll_length = total_scroll_length
	scrollbar_content.area_length = chat_window_height
	scrollbar_content.scroll_amount = 1 / (total_num_messages * 3)

	local is_scrollbar_active = scrollbar_content.drag_active or scroll_value

	if self._has_scrolled_back_in_history then
		if scroll_value and scroll_value == 1 or not is_scrollbar_active and scrollbar_content.value == 1 then
			self:_scroll_to_latest_message()
		else
			local scroll_length_from_top = self._scroll_length_from_top

			if not is_scrollbar_active then
				scroll_length_from_top = math.max(scroll_length_from_top - self._removed_height_since_last_frame, 0)
				scrollbar_content.value = scroll_length_from_top / total_scroll_length
			else
				scroll_length_from_top = total_scroll_length * scrollbar_content.value
			end

			self:_calculate_first_visible_widget(scroll_length_from_top, chat_window_height)

			self._scroll_length_from_top = scroll_length_from_top
		end
	elseif is_scrollbar_active then
		self._scroll_length_from_top = total_scroll_length * scrollbar_content.value
		self._total_height_last_frame = total_chat_height
		self._has_scrolled_back_in_history = true
	else
		self:_scroll_to_latest_message()
	end

	self._removed_height_since_last_frame = 0
end

ConstantElementChat._calculate_first_visible_widget = function (self, scroll_length_from_top, chat_window_height)
	local message_widgets = self._message_widgets
	local total_num_messages = #message_widgets
	local message_vertical_offset = self._total_chat_height
	local index = self._last_message_index
	local spacing = ChatSettings.message_spacing
	local window_bottom_position = scroll_length_from_top + chat_window_height

	for i = 1, total_num_messages do
		local widget = message_widgets[index]
		local widget_height = widget.content.size[2]

		message_vertical_offset = message_vertical_offset - (widget_height + spacing)

		if message_vertical_offset < window_bottom_position then
			self._first_visible_chat_message = index
			self._scroll_extra_vertical_offset = message_vertical_offset + widget_height + spacing - window_bottom_position

			break
		end

		index = math.index_wrapper(index - 1, total_num_messages)
	end
end

ConstantElementChat._add_notification = function (self, message, channel_tag)
	local widget_definition = self._message_widget_blueprints.notification
	local widget = UIWidget.init(message, widget_definition)

	widget.content.message = message

	local channel_meta_data = ChatSettings.channel_metadata[channel_tag]
	local channel_color = channel_meta_data and channel_meta_data.color

	if channel_color then
		widget.style.message.text_color = channel_meta_data.color
	end

	local messsage_parameters = {
		message_text = message,
		channel_tag = channel_tag,
	}
	local always_notify = channel_meta_data and channel_meta_data.always_notify
	local uses_controller = (IS_XBS or IS_PLAYSTATION) and InputDevice.gamepad_active

	if always_notify or uses_controller then
		self._time_since_last_update = 0
	end

	self:_add_message_widget_to_message_list(messsage_parameters, widget)
end

ConstantElementChat._add_message = function (self, message, sender, channel)
	local channel_tag = channel.tag
	local widget_name = sender .. "-" .. message
	local widget_definition = self._message_widget_blueprints.chat_message
	local new_message_widget = UIWidget.init(widget_name, widget_definition)
	local channel_color = self:_channel_color(channel_tag)
	local slug_formatted_color = channel_color[2] .. "," .. channel_color[3] .. "," .. channel_color[4]
	local message_parameters = {
		proper_channel_color = channel_color,
		channel_color = slug_formatted_color,
		channel_tag = channel_tag,
		author_name = sender,
		message_text = message,
	}
	local message_format = self:_format_chat_message(message_parameters)
	local widget_content = new_message_widget.content

	widget_content.message_format = message_format
	widget_content.message = message_format
	new_message_widget.alpha_multiplier = self._alpha

	self:_add_message_widget_to_message_list(message_parameters, new_message_widget)

	self._time_since_last_update = 0

	self:_cancel_animations_if_necessary()
end

ConstantElementChat._scrub = function (self, text)
	local scrubbed_text

	while text ~= scrubbed_text do
		text = scrubbed_text or text
		scrubbed_text = string.gsub(text, "{#.-}", "")
	end

	scrubbed_text = string.gsub(scrubbed_text, "{#.-$", "")

	return scrubbed_text
end

ConstantElementChat._format_chat_message = function (self, message)
	local message_format = ChatSettings.message_presentation_format
	local formatted_message = message_format:gsub("%[([a-zA-Z_]+)%]", function (key)
		return message[key]
	end)

	return formatted_message
end

ConstantElementChat._add_message_widget_to_message_list = function (self, new_message, new_message_widget)
	local messages = self._messages
	local message_widgets = self._message_widgets
	local last_message_index = self._last_message_index
	local message_index = math.index_wrapper(last_message_index + 1, ChatSettings.history_limit)
	local first_visible_message_index = self._first_visible_chat_message

	if message_index <= #self._message_widgets then
		local last_widget_size = message_widgets[message_index].content.size

		if last_widget_size then
			local removed_message_height = last_widget_size[2] + ChatSettings.message_spacing

			self._total_chat_height = self._total_chat_height - removed_message_height
			self._removed_height_since_last_frame = self._removed_height_since_last_frame + removed_message_height
		end
	end

	messages[message_index] = new_message
	message_widgets[message_index] = new_message_widget

	local input_widget = self._input_field_widget

	if not input_widget.content.is_writing or first_visible_message_index == last_message_index then
		self:_scroll_to_latest_message()
	end

	self._last_message_index = message_index
end

ConstantElementChat._calculate_widget_size = function (self, widget, ui_renderer)
	local widget_content = widget.content
	local widget_style = widget.style
	local message_style = widget_style.message
	local widget_max_size = self:scenegraph_size("chat_message_area")
	local _, message_height, min = self:_text_size(ui_renderer, widget_content.message, message_style, widget_max_size)

	message_style.offset = {
		-min.x,
		-min.y,
		0,
	}

	local widget_size = {
		widget_max_size[1],
		message_height,
	}

	widget_content.size = widget_size

	return widget_size
end

ConstantElementChat._enable_mouse_cursor = function (self, is_mouse_cursor_enabled)
	if is_mouse_cursor_enabled == self._is_cursor_pushed then
		return
	end

	local input_manager = Managers.input
	local name = self.__class_name

	if is_mouse_cursor_enabled then
		input_manager:push_cursor(name)

		self._is_cursor_pushed = true
	else
		input_manager:pop_cursor(name)

		self._is_cursor_pushed = false
	end
end

ConstantElementChat._on_connect_to_channel = function (self, channel_handle)
	local channel = Managers.chat:sessions()[channel_handle]

	if not channel then
		return
	end

	local show_notification = true

	if channel.tag == ChatManagerConstants.ChannelTag.MISSION or channel.tag == ChatManagerConstants.ChannelTag.PARTY then
		for _, other_channel in pairs(Managers.chat:sessions()) do
			if channel_handle ~= other_channel.session_handle and channel.tag ~= other_channel.tag and (other_channel.tag == ChatManagerConstants.ChannelTag.MISSION or other_channel.tag == ChatManagerConstants.ChannelTag.PARTY) then
				show_notification = false

				if self._selected_channel_handle then
					local selected_channel = Managers.chat:sessions()[self._selected_channel_handle]

					if selected_channel then
						local selected_channel_tag = selected_channel.tag

						if selected_channel_tag == ChatManagerConstants.ChannelTag.PARTY and channel.tag == ChatManagerConstants.ChannelTag.MISSION then
							self._selected_channel_handle = other_channel.channel_handle
						end
					end
				end
			end
		end
	end

	if show_notification and channel.tag then
		local channel_name = self:_channel_name(channel.tag, true, channel.channel_name)
		local add_channel_message = Managers.localization:localize("loc_chat_joined_channel", true, {
			channel_name = channel_name,
		})

		self:_add_notification(add_channel_message)
	end

	if not self._selected_channel_handle then
		self._selected_channel_handle = channel_handle
		self._refresh_to_channel_text = true
	end

	self:_setup_input_labels()
end

ConstantElementChat._on_disconnect_from_channel = function (self, channel_handle)
	local channel = Managers.chat:sessions()[channel_handle]

	if not channel then
		return
	end

	if not self._reported_left_channel_handles[channel_handle] then
		local show_notification = true

		if channel.tag == ChatManagerConstants.ChannelTag.MISSION or channel.tag == ChatManagerConstants.ChannelTag.PARTY then
			for _, other_channel in pairs(Managers.chat:sessions()) do
				if channel_handle ~= other_channel.session_handle and channel.tag ~= other_channel.tag and (other_channel.tag == ChatManagerConstants.ChannelTag.MISSION or other_channel.tag == ChatManagerConstants.ChannelTag.PARTY) then
					show_notification = false

					if self._selected_channel_handle and self._selected_channel_handle == channel_handle then
						local selected_channel_tag = Managers.chat:sessions()[self._selected_channel_handle].tag

						if selected_channel_tag == ChatManagerConstants.ChannelTag.MISSION and other_channel.tag == ChatManagerConstants.ChannelTag.PARTY then
							self._selected_channel_handle = other_channel.channel_handle
						end
					end
				end
			end
		end

		if show_notification and channel.tag then
			local channel_name = self:_channel_name(channel.tag, true, channel.channel_name)
			local remove_channel_message = Managers.localization:localize("loc_chat_left_channel", true, {
				channel_name = channel_name,
			})

			self:_add_notification(remove_channel_message)

			self._reported_left_channel_handles[channel_handle] = true
		end
	end

	if self._selected_channel_handle == channel_handle then
		self._selected_channel_handle = nil
	end

	self._refresh_to_channel_text = true

	self:_setup_input_labels()
end

ConstantElementChat._channel_name = function (self, channel_tag, colorize, channel_name)
	local name = channel_name
	local channel_metadata = ChatSettings.channel_metadata[channel_tag]

	if not name then
		local channel_loc_key = channel_metadata and channel_metadata.name

		name = Managers.localization:localize(channel_loc_key)
	end

	if colorize then
		local color = channel_metadata.color
		local formatted_color = color[2] .. "," .. color[3] .. "," .. color[4] .. "," .. color[1]

		name = "{# color(" .. formatted_color .. ")}" .. name .. "{#reset()}"
	end

	return name
end

ConstantElementChat._channel_color = function (self, channel_tag)
	local channel_metadata = ChatSettings.channel_metadata[channel_tag]

	if not channel_metadata then
		return {
			255,
			255,
			0,
			255,
		}
	end

	return channel_metadata.color
end

ConstantElementChat._text_size = function (self, ui_renderer, text, font_style, max_width)
	local scale = ui_renderer.scale or 1
	local scaled_font_size = UIFonts.scaled_size(font_style.font_size, scale)
	local sender_font_options = UIFonts.get_font_options_by_style(font_style)

	return UIRenderer.text_size(ui_renderer, text, font_style.font_type, scaled_font_size, max_width, sender_font_options)
end

ConstantElementChat._cancel_animations_if_necessary = function (self, force_cancellation)
	if self._active_state == States.hidden or force_cancellation then
		if self:_is_animation_active(self._chat_window_animation_id) then
			self:_complete_animation(self._chat_window_animation_id)
		end

		if self:_is_animation_active(self._input_field_animation_id) then
			self:_complete_animation(self._input_field_animation_id)
		end
	end
end

ConstantElementChat._apply_visibility_parameters = function (self, optional_visibility_parameters)
	if not optional_visibility_parameters then
		return false
	end

	local horizontal_alignment = optional_visibility_parameters.horizontal_alignment
	local vertical_alignment = optional_visibility_parameters.vertical_alignment
	local chat_window_offset = optional_visibility_parameters.chat_window_offset
	local chat_window_size = optional_visibility_parameters.chat_window_size
	local chat_window = self._ui_scenegraph.chat_window
	local need_to_update_scenegraph = false

	if horizontal_alignment and horizontal_alignment ~= chat_window.horizontal_alignment then
		chat_window.horizontal_alignment = horizontal_alignment
		need_to_update_scenegraph = true
	end

	if vertical_alignment and vertical_alignment ~= chat_window.vertical_alignment then
		chat_window.vertical_alignment = vertical_alignment
		need_to_update_scenegraph = true
	end

	if chat_window_offset then
		if chat_window_offset[1] and chat_window_offset[1] ~= chat_window.position[1] then
			chat_window.position[1] = chat_window_offset[1]
			need_to_update_scenegraph = true
		end

		if chat_window_offset[2] and chat_window_offset[2] ~= chat_window.position[2] then
			chat_window.position[2] = chat_window_offset[2]
			need_to_update_scenegraph = true
		end

		if chat_window_offset[3] and chat_window_offset[3] ~= chat_window.position[3] then
			chat_window.position[3] = chat_window_offset[3]
			need_to_update_scenegraph = true
		end
	end

	if chat_window_size then
		if chat_window_size[1] and chat_window_size[1] ~= chat_window.size[1] then
			chat_window.size[1] = chat_window_size[1]
			need_to_update_scenegraph = true
		end

		if chat_window_size[2] and chat_window_size[2] ~= chat_window.size[2] then
			chat_window.size[2] = chat_window_size[2]
			need_to_update_scenegraph = true
		end
	end

	return need_to_update_scenegraph
end

ConstantElementChat._parse_slash_commands = function (self, text)
	if text:sub(1, 1) == "/" then
		local parts = string.split(text:sub(2), " ")

		if #parts > 0 then
			local command = parts[1]
			local params = {}

			for i = 2, #parts do
				params[i - 1] = parts[i]
			end

			return command, params
		end
	end

	return nil
end

ConstantElementChat._find_participant_in_current_channel = function (self, character_name)
	local lowercase_character_name = string.lower(character_name)
	local social_service = Managers.data_service.social

	if not social_service then
		return nil, nil
	end

	local found_participant
	local singular = true

	if self._selected_channel_handle and Managers.chat:sessions()[self._selected_channel_handle] then
		local channel = Managers.chat:sessions()[self._selected_channel_handle]

		for participant_uri, participant in pairs(channel.participants) do
			if not participant.is_current_user then
				local account_id = participant.account_id

				if account_id then
					local player_info = social_service:get_player_info_by_account_id(account_id)

					if player_info then
						local participant_character_name = player_info:character_name()

						if participant_character_name and lowercase_character_name == string.lower(participant_character_name) then
							if found_participant then
								singular = false
							end

							found_participant = participant
						end
					end
				end
			end
		end
	end

	return found_participant, singular
end

ConstantElementChat._participant_displayname = function (self, participant)
	if not participant then
		return nil
	end

	local player_info = self:_find_participant_player_info(participant)

	if player_info then
		local console = player_info:platform()
		local displayname = IS_PLAYSTATION and (console == "psn" or console == "ps5") and player_info:user_display_name() or player_info:character_name()

		if displayname and displayname ~= "" then
			return displayname
		end
	end

	Log.error("ConstantElementChat", "Missing displayname for participant %s", participant.displayname)

	return nil
end

ConstantElementChat._find_participant_player_info = function (self, participant)
	if Managers.data_service.social then
		local recipient_account_id = participant.account_id
		local recipient_player_info = Managers.data_service.social:get_player_info_by_account_id(recipient_account_id)

		if recipient_player_info then
			return recipient_player_info
		end
	end

	return nil
end

ConstantElementChat._handle_slash_command = function (self, command, params)
	return
end

return ConstantElementChat
