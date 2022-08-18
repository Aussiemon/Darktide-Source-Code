local Definitions = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_definitions")
local ConstantElementNotificationFeedSettings = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ItemUtils = require("scripts/utilities/items")
local DEBUG_RELOAD = true
local ConstantElementNotificationFeed = class("ConstantElementNotificationFeed", "ConstantElementBase")
local MESSAGE_TYPES = table.enum("default", "alert", "mission", "item_granted")
ConstantElementNotificationFeed.MESSAGE_TYPES = MESSAGE_TYPES

ConstantElementNotificationFeed.init = function (self, parent, draw_layer, start_scale)
	ConstantElementNotificationFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._notifications = {}
	self._num_notifications = 0
	self._notification_id_counter = 0
	self._notification_templates = {
		default = {
			total_time = 5,
			fade_in = 0.5,
			fade_out = 1,
			priority_order = 2,
			widget_definition = Definitions.notification_message_default,
			min_height = ConstantElementNotificationFeedSettings.header_size[2]
		},
		alert = {
			animate_x_axis = true,
			total_time = 5,
			fade_in = 0.5,
			fade_out = 1,
			priority_order = 1,
			widget_definition = Definitions.notification_message_alert,
			min_height = ConstantElementNotificationFeedSettings.header_size[2]
		},
		mission = {
			animate_x_axis = true,
			fade_in = 0.5,
			fade_out = 1,
			priority_order = 1,
			widget_definition = Definitions.notification_message_alert,
			min_height = ConstantElementNotificationFeedSettings.header_size[2]
		},
		item_granted = {
			animate_x_axis = true,
			total_time = 5,
			fade_in = 0.5,
			fade_out = 1,
			min_height = 100,
			priority_order = 1,
			widget_definition = Definitions.notification_message_item_granted
		}
	}
	local event_manager = Managers.event
	local events = ConstantElementNotificationFeedSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

ConstantElementNotificationFeed.event_add_notification_message = function (self, message_type, data, callback, sound_event)
	local notification, notification_id = self:_add_notification_message(message_type)

	if message_type == MESSAGE_TYPES.default then
		self:_set_text(notification_id, data)
	elseif message_type == MESSAGE_TYPES.mission then
		self:_set_text(notification_id, data)
	elseif message_type == MESSAGE_TYPES.alert then
		self:_set_text(notification_id, data)
	elseif message_type == MESSAGE_TYPES.item_granted then
		local parser_string = "loc_character_news_feed_new_item"
		local sub_display_name = ItemUtils.sub_display_name(data)
		local display_name = ItemUtils.display_name(data)
		local new_item_string_context = {
			item_name = display_name,
			sub_name = sub_display_name
		}
		local no_cache = true
		local text = Localize(parser_string, no_cache, new_item_string_context)

		self:_set_text(notification_id, text)

		local rarity_frame_texture, rarity_side_texture = ItemUtils.rarity_textures(data)
		local widget = notification.widget
		slot16 = widget.style.icon
	end

	if callback then
		callback(notification_id)
	end
end

ConstantElementNotificationFeed.event_update_notification_message = function (self, notification_id, text, sound_event)
	self:_set_text(notification_id, text)
end

ConstantElementNotificationFeed.event_remove_notification = function (self, notification_id)
	local notification = self:_notification_by_id(notification_id)
	local fade_out = notification.fade_out
	local remove = not fade_out or fade_out == 0

	if remove then
		self:_remove_notification(notification_id)
	else
		local fade_in = notification.fade_in or 0
		notification.time = 0
		notification.total_time = fade_in + fade_out
	end
end

ConstantElementNotificationFeed.destroy = function (self)
	ConstantElementNotificationFeed.super.destroy(self)

	local event_manager = Managers.event
	local events = ConstantElementNotificationFeedSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

ConstantElementNotificationFeed._add_notification_message = function (self, type)
	local notification = self:_create_notification_entry(type)
	local notification_id = notification.id

	return notification, notification_id
end

ConstantElementNotificationFeed._remove_notification = function (self, notification_id)
	local remove = true
	local notification = self:_notification_by_id(notification_id, remove)
end

ConstantElementNotificationFeed._create_notification_entry = function (self, notification_type)
	local notification_template = self._notification_templates[notification_type]

	fassert(notification_template, "Invalid notification type %q", notification_type)

	local widget_definition = notification_template.widget_definition
	local priority_order = notification_template.priority_order
	local animate_x_axis = notification_template.animate_x_axis
	local name = "notification_" .. self._notification_id_counter
	self._notification_id_counter = self._notification_id_counter + 1
	local widget = self:_create_widget(name, widget_definition)
	local notification = table.clone(notification_template)
	notification.widget = widget
	notification.id = self._notification_id_counter
	notification.time = 0
	notification.min_height = notification_template.min_height
	local notifications = self._notifications
	local num_notifications = #notifications
	local start_index = nil

	if num_notifications > 0 then
		for i = 1, num_notifications, 1 do
			if priority_order <= notifications[i].priority_order then
				start_index = i

				break
			elseif i == num_notifications then
				start_index = i + 1
			end
		end
	end

	start_index = start_index or 1
	local start_height = self:_get_height_of_notification_index(start_index)

	self:_set_widget_position(widget, nil, start_height)
	table.insert(notifications, start_index, notification)

	return notification
end

ConstantElementNotificationFeed._notification_by_id = function (self, notification_id, remove)
	local notifications = self._notifications

	for i = 1, #notifications, 1 do
		local notification = notifications[i]

		if notification.id == notification_id then
			if remove then
				return table.remove(notifications, i)
			else
				return notification
			end
		end
	end
end

ConstantElementNotificationFeed._set_text = function (self, notification_id, text)
	local notification = self:_notification_by_id(notification_id)
	local widget = notification.widget
	widget.content.text = text
end

ConstantElementNotificationFeed._set_icon = function (self, notification_id, icon)
	local notification = self:_notification_by_id(notification_id)
	local widget = notification.widget
	widget.content.icon = icon
end

ConstantElementNotificationFeed._get_notifications_text_height = function (self, notification, ui_renderer)
	local widget = notification.widget
	local content = widget.content
	local text = content.text
	local style = widget.style
	local text_style = style.text
	local text_font_data = UIFonts.data_by_type(text_style.font_type)
	local text_font = text_font_data.path
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, text_size, text_options)

	return text_height
end

ConstantElementNotificationFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if DEBUG_RELOAD then
		DEBUG_RELOAD = false

		while #self._notifications > 0 do
			local notification = self._notifications[1]

			self:_remove_notification(notification.id)
		end
	end

	self:_align_notification_widgets(dt)
	ConstantElementNotificationFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementNotificationFeed._align_notification_widgets = function (self, dt)
	local ui_renderer = self._parent:ui_renderer()
	local entry_spacing = ConstantElementNotificationFeedSettings.entry_spacing
	local text_height_spacing = ConstantElementNotificationFeedSettings.text_height_spacing
	local offset_y = 0
	local notifications = self._notifications

	for i = 1, #notifications, 1 do
		local notification = notifications[i]

		if notification then
			local widget = notification.widget
			local widget_offset = widget.offset
			local text_height = self:_get_notifications_text_height(notification, ui_renderer)
			local min_height = notification.min_height
			local widget_height = text_height
			local style = widget.style

			if style.background then
				widget_height = math.max(min_height, widget_height + text_height_spacing * 2)
				style.background.size[2] = widget_height
			end

			if style.text then
				style.text.size[2] = widget_height
			end

			if style.icon then
				local icon_height = style.icon.size[2]
				style.icon.offset[2] = widget_height * 0.5 - icon_height * 0.5
			end

			if widget_offset[2] < offset_y then
				widget_offset[2] = math.lerp(widget_offset[2], offset_y, dt * 6)
			else
				widget_offset[2] = math.lerp(widget_offset[2], offset_y, dt * 2)
			end

			offset_y = offset_y + widget_height + entry_spacing
		end
	end
end

ConstantElementNotificationFeed._get_height_of_notification_index = function (self, index)
	local notifications = self._notifications
	local notification = notifications[index - 1]

	if not notification then
		return 0
	else
		local widget = notification.widget
		local widget_offset = widget.offset

		return widget_offset[2]
	end

	return 0
end

ConstantElementNotificationFeed._set_widget_position = function (self, widget, x, y)
	local widget_offset = widget.offset

	if x then
		widget_offset[1] = x
	end

	if y then
		widget_offset[2] = y
	end
end

ConstantElementNotificationFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantElementNotificationFeed.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local header_size = ConstantElementNotificationFeedSettings.header_size
	local entry_spacing = ConstantElementNotificationFeedSettings.entry_spacing
	local offset_y = 0
	local notifications = self._notifications

	for i = #notifications, 1, -1 do
		local notification = notifications[i]

		if notification then
			notification.time = (notification.time or 0) + dt
			local total_time = notification.total_time
			local time = notification.time

			if time and total_time and total_time <= time then
				self:_remove_notification(notification.id)
			else
				local widget = notification.widget
				local alpha_multiplier = 1
				local fade_out = notification.fade_out
				local fade_in = notification.fade_in
				local time_passed = time

				if fade_in and time_passed <= fade_in then
					local progress = math.min(time_passed / fade_in, 1)
					alpha_multiplier = math.easeInCubic(progress)
				elseif total_time and fade_out and time_passed >= total_time - fade_out then
					alpha_multiplier = (total_time - time_passed) / fade_out
				end

				if notification.animate_x_axis then
					self:_set_widget_position(widget, header_size[1] - math.easeCubic(alpha_multiplier) * header_size[1])
				end

				render_settings.alpha_multiplier = alpha_multiplier

				UIWidget.draw(widget, ui_renderer)
			end
		end
	end
end

return ConstantElementNotificationFeed
