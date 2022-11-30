local Definitions = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_definitions")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local InputUtils = require("scripts/managers/input/input_utils")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLive = require("scripts/foundation/utilities/xbox_live")
local StringVerification = require("scripts/managers/localization/string_verification")
local ConstantElementChat = class("ConstantElementChat", "ConstantElementBase")
local STATE_HIDDEN = "hidden"
local STATE_IDLE = "idle"
local STATE_ACTIVE = "active"

ConstantElementChat.init = function (self, parent, draw_layer, start_scale, definitions)
	ConstantElementChat.super.init(self, parent, draw_layer, start_scale, Definitions)
	Managers.event:register(self, "chat_manager_connection_state_change", "cb_chat_manager_connection_state_change")
	Managers.event:register(self, "chat_manager_login_state_change", "cb_chat_manager_login_state_change")
	Managers.event:register(self, "chat_manager_added_channel", "cb_chat_manager_added_channel")
	Managers.event:register(self, "chat_manager_removed_channel", "cb_chat_manager_removed_channel")
	Managers.event:register(self, "chat_manager_updated_channel_state", "cb_chat_manager_updated_channel_state")
	Managers.event:register(self, "chat_manager_message_recieved", "cb_chat_manager_message_recieved")
	Managers.event:register(self, "chat_manager_participant_added", "cb_chat_manager_participant_added")
	Managers.event:register(self, "chat_manager_participant_update", "cb_chat_manager_participant_update")
	Managers.event:register(self, "chat_manager_participant_removed", "cb_chat_manager_participant_removed")

	self._message_widget_blueprints = Definitions.message_widget_blueprints
	self._messages = {}
	self._message_widgets = {}
	self._last_message_index = 0
	self._scroll_length_from_top = 0
	self._scroll_extra_vertical_offset = 0
	self._first_visible_chat_message = 0
	self._has_scrolled_back_in_history = false
	self._message_presentation_format = ChatSettings.message_presentation_format .. "{#reset()}"
	self._total_chat_height = 0
	self._removed_height_since_last_frame = 0
	self._channels = {}
	self._connected_channels = {}
	self._num_connected_channels = 0
	self._is_cursor_pushed = false
	self._is_always_visible = ChatSettings.is_always_visible
	self._input_caret = ""
	self._alpha = 0
	self._time_since_last_update = ChatSettings.inactivity_timeout
	self._input_field_widget = nil

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
	Managers.event:unregister(self, "chat_manager_added_channel")
	Managers.event:unregister(self, "chat_manager_removed_channel")
	Managers.event:unregister(self, "chat_manager_updated_channel_state")
	Managers.event:unregister(self, "chat_manager_message_recieved")
	Managers.event:unregister(self, "chat_manager_participant_added")
	Managers.event:unregister(self, "chat_manager_participant_update")
	Managers.event:unregister(self, "chat_manager_participant_removed")
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
	local target_state, target_alpha, target_background_alpha_full = nil
	local time_since_last_update = is_input_field_active and 0 or self._time_since_last_update

	if is_visible then
		self._time_since_last_update = time_since_last_update + dt
	end

	local inactivity_timeout = ChatSettings.inactivity_timeout
	local idle_timeout = ChatSettings.idle_timeout

	if inactivity_timeout <= time_since_last_update and inactivity_timeout >= 0 and not is_input_field_active or not is_visible then
		target_alpha = 0
		target_background_alpha_full = 0
		target_state = STATE_HIDDEN
	elseif idle_timeout <= time_since_last_update and idle_timeout >= 0 and not is_input_field_active then
		target_alpha = ChatSettings.idle_text_alpha / 255
		target_background_alpha_full = ChatSettings.idle_background_alpha
		target_state = STATE_IDLE
	else
		target_alpha = 1
		target_background_alpha_full = ChatSettings.background_color[1]
		target_state = STATE_ACTIVE
	end

	if not self:_is_animation_active(self._chat_window_animation_id) and not self:_is_animation_active(self._input_field_animation_id) and (target_state ~= self._active_state or target_alpha ~= self._alpha) then
		local params = {
			target_state = target_state,
			target_alpha = target_alpha,
			target_background_alpha = target_background_alpha_full,
			message_widgets = self._message_widgets
		}
		local speed = target_state == STATE_HIDDEN and is_visible and ChatSettings.inactive_fade_speed or 1
		self._chat_window_animation_id = self:_start_animation("fade_chat_window", self._widgets_by_name, params, nil, speed)
		self._input_field_animation_id = self:_start_animation("fade_input_field", self._widgets_by_name, params, nil, speed)
	end
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
	self:_enable_mouse_cursor(false)

	local need_to_update_scenegraph = self:_apply_visibility_parameters(optional_visibility_parameters)
	local active_state = self._active_state

	if need_to_update_scenegraph and active_state ~= STATE_HIDDEN then
		local fade_out_params = {
			target_background_alpha = 0,
			target_alpha = 0,
			target_state = active_state,
			message_widgets = self._message_widgets
		}
		local fade_in_params = {
			target_state = active_state,
			target_alpha = active_state == STATE_IDLE and ChatSettings.idle_text_alpha / 255 or 1,
			target_background_alpha = active_state == STATE_IDLE and ChatSettings.idle_background_alpha or ChatSettings.background_color[1],
			message_widgets = self._message_widgets
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

ConstantElementChat.should_update = function (self)
	return self._num_connected_channels > 0
end

ConstantElementChat.should_draw = function (self)
	return (self._is_visible or self._alpha > 0) and self:should_update()
end

ConstantElementChat.cb_chat_manager_login_state_change = function (self, login_state)
	if login_state == ChatManagerConstants.LoginState.LOGGED_IN then
		-- Nothing
	elseif login_state == ChatManagerConstants.LoginState.LOGGED_OUT then
		-- Nothing
	end
end

ConstantElementChat.cb_chat_manager_added_channel = function (self, channel_handle, channel)
	self._channels[channel_handle] = channel
end

ConstantElementChat.cb_chat_manager_removed_channel = function (self, channel_handle)
	local channel = self._channels[channel_handle]

	if self._connected_channels[channel.tag] then
		self:_on_disconnect_from_channel(channel_handle)
	end

	self._channels[channel_handle] = nil
end

ConstantElementChat.cb_chat_manager_updated_channel_state = function (self, channel_handle, state)
	if state == ChatManagerConstants.ChannelConnectionState.CONNECTED then
		self:_on_connect_to_channel(channel_handle)
	elseif state == ChatManagerConstants.ChannelConnectionState.DISCONNECTED then
		self:_on_disconnect_from_channel(channel_handle)
	end
end

ConstantElementChat.cb_chat_manager_message_recieved = function (self, channel_handle, participant, message)
	StringVerification.verify(message.message_body):next(function (message_text)
		local channel = self._channels[channel_handle]
		local channel_tag = channel.tag or "placeholder"
		local sender = nil

		if message.is_current_user then
			local channel_name = self:_channel_name(channel_tag)
			sender = Managers.localization:localize("loc_chat_own_player", true, {
				channel_name = channel_name
			})
		else
			sender = participant.displayname
		end

		self:_add_message(message_text, sender, channel_tag)
	end):catch(function (error)
		Log.warning("ConstantElementChat", "Could not verify string, error: %s, string: %s", tostring(error), tostring(message.message_body))
	end)
end

ConstantElementChat.cb_chat_manager_participant_added = function (self, channel_handle, participant)
	if not participant.is_current_user and not participant.is_text_muted_for_me then
		local channel = self._channels[channel_handle]
		local channel_tag = channel.tag

		if channel_tag and channel_tag ~= ChatManagerConstants.ChannelTag.HUB and self._connected_channels[channel_tag] then
			local display_name = participant.displayname
			local channel_name = self:_channel_name(channel_tag, true)
			local message = Managers.localization:localize("loc_chat_user_joined_channel", true, {
				channel_name = channel_name,
				display_name = display_name
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
		local channel = self._channels[channel_handle]
		local channel_tag = channel.tag

		if channel_tag and channel_tag ~= ChatManagerConstants.ChannelTag.HUB and self._connected_channels[channel_tag] then
			local channel_name = self:_channel_name(channel_tag, true)
			local display_name = participant.displayname

			if display_name then
				local message = Managers.localization:localize("loc_chat_user_left_channel", true, {
					channel_name = channel_name,
					display_name = display_name
				})

				self:_add_notification(message)
			end
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
	if self._num_connected_channels > 1 then
		local change_channel_input = self:_get_localized_input_text("cycle_chat_channel")
		local active_placeholder_text = self:_localize("loc_chat_active_placeholder_text", true, {
			input = change_channel_input
		})
		local input_widget = self._input_field_widget
		input_widget.content.active_placeholder_text = active_placeholder_text
	else
		local input_widget = self._input_field_widget
		input_widget.content.active_placeholder_text = ""
	end
end

ConstantElementChat._get_localized_input_text = function (self, action)
	local service_type = DefaultViewInputSettings.service_type
	local alias = Managers.input:alias_object(service_type)
	local alias_array_index = 1
	local device_types = {
		"keyboard"
	}
	local key_info = alias:get_keys_for_alias(action, alias_array_index, device_types)
	local input_key = key_info and InputUtils.localized_string_from_key_info(key_info) or "n/a"

	return input_key
end

ConstantElementChat._handle_input = function (self, input_service, ui_renderer)
	local input_widget = self._input_field_widget
	local is_input_field_active = input_widget.content.is_writing

	if is_input_field_active then
		self:_handle_active_chat_input(input_service, ui_renderer)
	elseif input_service:get("show_chat") and self._num_connected_channels > 0 then
		input_widget.content.input_text = ""
		input_widget.content.caret_position = 1
		input_widget.content.is_writing = true
		self._selected_channel = self:_next_connected_channel()

		self:_cancel_animations_if_necessary()
		self:_enable_mouse_cursor(true)

		local selected_channel = self._selected_channel

		self:_update_input_field_selected_channel(ui_renderer, input_widget, selected_channel)
	end
end

ConstantElementChat._handle_active_chat_input = function (self, input_service, ui_renderer)
	local input_widget = self._input_field_widget
	local input_text = input_widget.content.input_text
	local selected_channel = self._selected_channel
	local is_input_field_active = true

	if input_service:get("cycle_chat_channel") then
		selected_channel = self:_next_connected_channel(selected_channel and selected_channel.priority_index)
		self._selected_channel = selected_channel

		self:_update_input_field_selected_channel(ui_renderer, input_widget, selected_channel)
	elseif input_service:get("send_chat_message") then
		if selected_channel and #input_text > 0 then
			input_text = self:_scrub(input_text)
			local channel_handle = selected_channel.handle

			Managers.chat:send_channel_message(channel_handle, input_text)
		end

		is_input_field_active = false
	elseif input_service:get("hotkey_system") then
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
		self._input_caret_position = nil
		input_widget.content.input_text = ""
		input_widget.content.is_writing = false
		self._selected_channel = nil

		self:_enable_mouse_cursor(false)
	end
end

ConstantElementChat._update_caret_position = function (self, ui_renderer, input_widget, caret_position, is_caret_visible)
	local input_widget_style = input_widget.style
	local input_text_style = input_widget_style.text
	local max_text_width = input_text_style.size[1]
	local font_type = input_text_style.font_type
	local font_size = input_text_style.font_size
	local input_text = input_widget.content._input_text
	local display_text, caret_offset, first_pos = self:_crop_text_width(ui_renderer, input_text, font_type, font_size, max_text_width, self._input_text_first_visible_pos, caret_position)
	local input_widget_content = input_widget.content
	input_widget_content.text = display_text
	local input_caret_style = input_widget_style.input_caret
	input_caret_style.offset[1] = input_text_style.offset[1] + caret_offset

	if is_caret_visible ~= nil then
		input_widget_content.input_caret.visible = is_caret_visible
	end

	self._input_caret_position = caret_position
	self._input_text_first_visible_pos = first_pos
end

ConstantElementChat._next_connected_channel = function (self, current_priority_index)
	local channel_priorities = ChatSettings.channel_priority
	current_priority_index = current_priority_index or #channel_priorities
	local connected_channels = self._connected_channels
	local current_tag, channel_handle = nil
	local first_index = current_priority_index

	repeat
		current_priority_index = math.index_wrapper(current_priority_index + 1, #channel_priorities)
		current_tag = channel_priorities[current_priority_index]
		channel_handle = connected_channels[current_tag]

		if current_tag == ChatManagerConstants.ChannelTag.PARTY and connected_channels[ChatManagerConstants.ChannelTag.MISSION] then
			channel_handle = nil
		end
	until channel_handle or current_priority_index == first_index

	if not channel_handle then
		return
	end

	local next_connected_channel = {
		tag = current_tag,
		priority_index = current_priority_index,
		handle = channel_handle
	}

	return next_connected_channel
end

ConstantElementChat._update_input_field_selected_channel = function (self, ui_renderer, widget, selected_channel)
	local channel_tag = selected_channel.tag
	local channel_name = self:_channel_name(channel_tag)
	local selected_channel_text = Managers.localization:localize("loc_chat_to_channel", true, {
		channel_name = channel_name
	})
	widget.content.to_channel = selected_channel_text
	local style = widget.style
	local to_channel_style = style.to_channel
	to_channel_style.text_color = self:_channel_color(channel_tag)
	local field_margin_left = ChatSettings.input_field_margins[1]
	local field_margin_right = ChatSettings.input_field_margins[4]
	local offset = self:_text_size(ui_renderer, selected_channel_text, to_channel_style)
	offset = offset + to_channel_style.offset[1] + field_margin_left
	local text_style = style.display_text
	text_style.offset[1] = offset
	text_style.size = text_style.size or {}
	text_style.size_addition[1] = -(offset + field_margin_right)
	style.active_placeholder.offset[1] = offset
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

		if window_bottom_position > message_vertical_offset then
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

	if channel_tag then
		local channel_color = self:_channel_color(channel_tag)
		widget.style.message.text_color = channel_color
	end

	local messsage_parameters = {
		message_text = message,
		channel_tag = channel_tag
	}

	self:_add_message_widget_to_message_list(messsage_parameters, widget)
end

ConstantElementChat._add_message = function (self, message, sender, channel_tag)
	local scrubbed_sender = self:_scrub(sender) or ""
	local scrubbed_message = self:_scrub(message) or ""
	local widget_name = scrubbed_sender .. "-" .. scrubbed_message
	local widget_definition = self._message_widget_blueprints.chat_message
	local new_message_widget = UIWidget.init(widget_name, widget_definition)
	local channel_color = self:_channel_color(channel_tag)
	local slug_formatted_color = channel_color[2] .. "," .. channel_color[3] .. "," .. channel_color[4]
	local message_parameters = {
		proper_channel_color = channel_color,
		channel_color = slug_formatted_color,
		channel_tag = channel_tag,
		author_name = scrubbed_sender,
		message_text = scrubbed_message
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
	if not ChatSettings.scrub_formatting_directives_from_message then
		return text
	end

	local scrubbed_text = nil

	while text ~= scrubbed_text do
		text = scrubbed_text or text
		scrubbed_text = string.gsub(text, "{#.-}", "")
	end

	scrubbed_text = string.gsub(scrubbed_text, "{#.-$", "")

	return scrubbed_text
end

ConstantElementChat._format_chat_message = function (self, message)
	local message_format = self._message_presentation_format
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
		0
	}
	local widget_size = {
		widget_max_size[1],
		message_height
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
	local channel = self._channels[channel_handle]
	local channel_tag = channel.tag
	local connected_channels = self._connected_channels

	if not connected_channels[channel_tag] then
		connected_channels[channel_tag] = channel_handle
		self._num_connected_channels = self._num_connected_channels + 1
		local channel_tags = ChatManagerConstants.ChannelTag
		local is_redunant = channel_tag == channel_tags.PARTY and connected_channels[channel_tags.MISSION] or channel_tag == channel_tags.MISSION and connected_channels[channel_tags.PARTY]

		if not is_redunant then
			local channel_name = self:_channel_name(channel_tag, true)
			local add_channel_message = Managers.localization:localize("loc_chat_joined_channel", true, {
				channel_name = channel_name
			})

			self:_add_notification(add_channel_message)
		end

		self:_setup_input_labels()
	end
end

ConstantElementChat._on_disconnect_from_channel = function (self, channel_handle)
	local connected_channels = self._connected_channels

	for channel_tag, connected_channel_handle in pairs(connected_channels) do
		if connected_channel_handle == channel_handle then
			connected_channels[channel_tag] = nil
			self._num_connected_channels = self._num_connected_channels - 1
			local channel_tags = ChatManagerConstants.ChannelTag
			local is_redunant = channel_tag == channel_tags.PARTY and connected_channels[channel_tags.MISSION] or channel_tag == channel_tags.MISSION and connected_channels[channel_tags.PARTY]
			local channel_name = self:_channel_name(channel_tag, true)
			local remove_channel_message = Managers.localization:localize("loc_chat_left_channel", true, {
				channel_name = channel_name
			})

			self:_add_notification(remove_channel_message)
		end
	end

	self:_setup_input_labels()
end

ConstantElementChat._channel_name = function (self, channel_tag, colorize)
	local channel_metadata = ChatSettings.channel_metadata[channel_tag]
	local channel_loc_key = channel_metadata and channel_metadata.name

	if not channel_loc_key then
		return
	end

	local channel_name = Managers.localization:localize(channel_loc_key)

	if colorize then
		local color = channel_metadata.color
		local formatted_color = color[2] .. "," .. color[3] .. "," .. color[4] .. "," .. color[1]
		channel_name = "{# color(" .. formatted_color .. ")}" .. channel_name .. "{#reset()}"
	end

	return channel_name
end

ConstantElementChat._channel_color = function (self, channel_tag)
	local channel_metadata = ChatSettings.channel_metadata[channel_tag]

	if not channel_metadata then
		return {
			255,
			255,
			0,
			255
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
	if self._active_state == STATE_HIDDEN or force_cancellation then
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

return ConstantElementChat
