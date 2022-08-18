local Breed = require("scripts/utilities/breed")
local Definitions = require("scripts/ui/hud/elements/combat_feed/hud_element_combat_feed_definitions")
local HudElementCombatFeedSettings = require("scripts/ui/hud/elements/combat_feed/hud_element_combat_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local DEBUG_RELOAD = true
local HudElementCombatFeed = class("HudElementCombatFeed", "HudElementBase")

HudElementCombatFeed.init = function (self, parent, draw_layer, start_scale)
	HudElementCombatFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._notifications = {}
	self._num_notifications = 0
	self._notification_id_counter = 0
	self._max_messages = HudElementCombatFeedSettings.max_messages
	self._notification_templates = {
		default = {
			fade_out = 1,
			fade_in = 0.5,
			total_time = 5,
			widget_definition = Definitions.notification_message_default
		}
	}
	local event_manager = Managers.event
	local events = HudElementCombatFeedSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementCombatFeed._can_spawn_message = function (self)
	local notifications = self._notifications
	local num_notifications = #notifications

	return num_notifications < self._max_messages
end

local kill_message_localization_key = "loc_hud_combat_feed_kill_message"
local temp_kill_message_localization_params = {
	killer = "n/a",
	victim = "n/a"
}
local player_default_color = Color.ui_hud_green_light(255, true)
local enemy_default_color = Color.red(255, true)

HudElementCombatFeed._get_unit_presentation_name = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = unit and player_unit_spawn_manager:owner(unit)

	if player then
		local player_name = player:name()
		local player_slot = player:slot()
		local player_slot_color = UISettings.player_slot_colors[player_slot] or player_default_color

		return TextUtilities.apply_color_to_text(player_name, player_slot_color)
	else
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local breed_or_nil = unit_data_extension and unit_data_extension:breed()
		local target_is_minion = breed_or_nil and Breed.is_minion(breed_or_nil)

		if target_is_minion then
			local display_name = breed_or_nil.display_name
			local tags = breed_or_nil.tags
			local color = self:_color_by_enemy_tags(tags)

			return display_name and TextUtilities.apply_color_to_text(Localize(display_name), color)
		end
	end
end

HudElementCombatFeed._color_by_enemy_tags = function (self, tags)
	local color = nil

	if tags then
		local colors_by_enemy_type = HudElementCombatFeedSettings.colors_by_enemy_type

		for key, enemy_color in pairs(colors_by_enemy_type) do
			if tags[key] then
				color = enemy_color

				break
			end
		end
	end

	return color or enemy_default_color
end

HudElementCombatFeed.event_combat_feed_kill = function (self, attacking_unit, attacked_unit)
	local killer = self:_get_unit_presentation_name(attacking_unit)
	local victim = self:_get_unit_presentation_name(attacked_unit)
	temp_kill_message_localization_params.killer = killer
	temp_kill_message_localization_params.victim = victim
	local text = self:_localize(kill_message_localization_key, true, temp_kill_message_localization_params)

	self:_add_combat_feed_message(text)
end

HudElementCombatFeed.event_add_combat_feed_message = function (self, text)
	self:_add_combat_feed_message(text)
end

HudElementCombatFeed._add_combat_feed_message = function (self, text)
	local _, notification_id = self:_add_notification_message("default")

	self:_set_text(notification_id, text)
end

HudElementCombatFeed.destroy = function (self)
	HudElementCombatFeed.super.destroy(self)

	local event_manager = Managers.event
	local events = HudElementCombatFeedSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

HudElementCombatFeed._add_notification_message = function (self, type)
	local notification = self:_create_notification_entry(type)
	local notification_id = notification.id

	return notification, notification_id
end

HudElementCombatFeed._remove_notification = function (self, notification_id)
	local remove = true

	self:_notification_by_id(notification_id, remove)
end

HudElementCombatFeed._create_notification_entry = function (self, notification_type)
	local notification_template = self._notification_templates[notification_type]
	local widget_definition = notification_template.widget_definition
	local name = "notification_" .. self._notification_id_counter
	self._notification_id_counter = self._notification_id_counter + 1
	local widget = self:_create_widget(name, widget_definition)
	local notification = table.clone(notification_template)
	notification.widget = widget
	notification.id = self._notification_id_counter
	notification.time = 0
	local notifications = self._notifications
	local start_index = 1
	local start_height = self:_get_height_of_notification_index(start_index)

	self:_set_widget_position(widget, nil, start_height)
	table.insert(notifications, start_index, notification)

	return notification
end

HudElementCombatFeed._notification_by_id = function (self, notification_id, remove)
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

HudElementCombatFeed._set_text = function (self, notification_id, text)
	local notification = self:_notification_by_id(notification_id)
	local widget = notification.widget
	widget.content.text = text
end

HudElementCombatFeed._set_icon = function (self, notification_id, icon)
	local notification = self:_notification_by_id(notification_id)
	local widget = notification.widget
	widget.content.icon = icon
end

HudElementCombatFeed._get_notifications_text_height = function (self, notification, ui_renderer)
	local widget = notification.widget
	local content = widget.content
	local text = content.text
	local style = widget.style
	local text_style = style.text
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, text_size, text_options)

	return text_height
end

HudElementCombatFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if DEBUG_RELOAD then
		DEBUG_RELOAD = false

		while #self._notifications > 0 do
			local notification = self._notifications[1]

			self:_remove_notification(notification.id)
		end
	end

	self:_align_notification_widgets(dt)
	HudElementCombatFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementCombatFeed._align_notification_widgets = function (self, dt)
	local ui_renderer = self._parent:ui_renderer()
	local entry_spacing = HudElementCombatFeedSettings.entry_spacing
	local text_height_spacing = HudElementCombatFeedSettings.text_height_spacing
	local header_size = HudElementCombatFeedSettings.header_size
	local offset_y = 0
	local notifications = self._notifications

	for i = 1, #notifications, 1 do
		local notification = notifications[i]

		if notification then
			local widget = notification.widget
			local widget_offset = widget.offset
			local text_height = self:_get_notifications_text_height(notification, ui_renderer)
			local widget_height = text_height
			local style = widget.style

			if style.background then
				widget_height = math.max(header_size[2], widget_height + text_height_spacing * 2)
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

HudElementCombatFeed._get_height_of_notification_index = function (self, index)
	local notifications = self._notifications
	local notification = notifications[index - 1]

	if not notification then
		return 0
	else
		local widget = notification.widget
		local widget_offset = widget.offset

		return widget_offset[2]
	end
end

HudElementCombatFeed._set_widget_position = function (self, widget, x, y)
	local widget_offset = widget.offset

	if x then
		widget_offset[1] = x
	end

	if y then
		widget_offset[2] = y
	end
end

HudElementCombatFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementCombatFeed.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local header_size = HudElementCombatFeedSettings.header_size
	local notifications = self._notifications

	for i = #notifications, 1, -1 do
		local notification = notifications[i]

		if notification then
			notification.time = (notification.time or 0) + dt
			local total_time = notification.total_time
			local time = notification.time

			if (time and total_time and total_time <= time) or self._max_messages < i then
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
					self:_set_widget_position(widget, -header_size[1] + math.easeCubic(alpha_multiplier) * header_size[1])
				end

				widget.alpha_multiplier = alpha_multiplier

				UIWidget.draw(widget, ui_renderer)
			end
		end
	end
end

return HudElementCombatFeed
