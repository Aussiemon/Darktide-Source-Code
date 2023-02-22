local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local Definitions = require("scripts/ui/hud/elements/emote_wheel/hud_element_emote_wheel_definitions")
local HudElementEmoteWheelSettings = require("scripts/ui/hud/elements/emote_wheel/hud_element_emote_wheel_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local Vo = require("scripts/utilities/vo")
local ChannelTags = ChatManagerConstants.ChannelTag
local unit_alive = Unit.alive
local INSTANT_WHEEL_THRESHOLD = 8
local HOVER_GRACE_PERIOD = 0.4
local default_slot_data = {
	{
		slot_id = "slot_animation_emote_5",
		event_id = "emote_5"
	},
	[5] = {
		slot_id = "slot_animation_emote_1",
		event_id = "emote_1"
	},
	[4] = {
		slot_id = "slot_animation_emote_2",
		event_id = "emote_2"
	},
	[3] = {
		slot_id = "slot_animation_emote_3",
		event_id = "emote_3"
	},
	[2] = {
		slot_id = "slot_animation_emote_4",
		event_id = "emote_4"
	}
}
local HudElementEmoteWheel = class("HudElementEmoteWheel", "HudElementBase")

HudElementEmoteWheel.init = function (self, parent, draw_layer, start_scale)
	HudElementEmoteWheel.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._wheel_active_progress = 0
	self._wheel_active = false
	self._entries = {}
	self._last_widget_hover_data = {}
	self._interaction_scan_delay = HudElementEmoteWheelSettings.scan_delay
	self._interaction_scan_delay_duration = 0
	self._presented_smart_tags_by_tag_id = {}
	self._presented_smart_tags_by_marker_id = {}
	local wheel_slots = HudElementEmoteWheelSettings.wheel_slots

	self:_setup_entries(wheel_slots)

	local wheel_options = {}

	for i = 1, #default_slot_data do
		local slot_data = default_slot_data[i]
		local slot_id = slot_data.slot_id
		local event_id = slot_data.event_id
		wheel_options[#wheel_options + 1] = {
			default_display_name = "loc_item_slot_empty",
			slot_id = slot_id,
			event_id = event_id,
			default_icon = slot_data.icon
		}
	end

	self:_populate_wheel(wheel_options)

	self._interaction_line_widget = self:_create_widget("interaction_line", Definitions.interaction_line_definition)
	self._tag_context = {}
	self._wheel_context = {}
end

HudElementEmoteWheel._populate_wheel = function (self, options)
	local entries = self._entries
	local wheel_slots = HudElementEmoteWheelSettings.wheel_slots

	for i = 1, wheel_slots do
		local option = options[i]
		local entry = entries[i]
		local widget = entry.widget
		local content = widget.content
		content.visible = option ~= nil
		entry.option = option
	end
end

HudElementEmoteWheel._setup_entries = function (self, num_entries)
	if self._entries then
		for i = 1, #self._entries do
			local entry = self._entries[i]
			local widget = entry.widget
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	local entries = {}
	local definition = Definitions.entry_widget_definition

	for i = 1, num_entries do
		local name = "entry_" .. i
		local widget = self:_create_widget(name, definition)
		entries[i] = {
			widget = widget
		}
	end

	self._entries = entries
end

HudElementEmoteWheel.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementEmoteWheel.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_slot_items(ui_renderer)
	self:_update_active_progress(dt)
	self:_update_widget_locations()

	if self._wheel_active then
		self:_update_wheel_presentation(dt, t, ui_renderer, render_settings, input_service)
	end

	self:_handle_input(t, dt, ui_renderer, render_settings)
end

local function _on_item_icon_load_cb_func(widget, item)
	local content = widget.content
	local icon = item.icon
	local material_values = widget.style.icon.material_values
	material_values.texture_map = icon
	material_values.use_placeholder_texture = 0
end

local function _remove_item_icon_load_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values
	material_values.texture_map = "content/ui/textures/icons/emotes/empty"
	material_values.use_placeholder_texture = 1
end

HudElementEmoteWheel._update_slot_items = function (self, ui_renderer)
	local parent = self._parent
	local player = parent and parent:player()
	local profile = player and player:profile()
	local loadout = profile and profile.loadout
	local entries = self._entries

	for i = 1, #entries do
		local entry = entries[i]
		local widget = entry.widget
		local content = widget.content
		local option = entry.option
		local is_populated = option ~= nil

		if is_populated then
			local slot_id = option.slot_id
			local equipped_item = loadout and loadout[slot_id]
			local prevous_item = entry.item

			if equipped_item and (not prevous_item or prevous_item.gear_id ~= equipped_item.gear_id) or not equipped_item and prevous_item then
				entry.display_name = equipped_item and equipped_item.display_name
				entry.item = equipped_item

				if entry.icon_load_id then
					_remove_item_icon_load_cb_func(widget, ui_renderer)
					Managers.ui:unload_item_icon(entry.icon_load_id)

					entry.icon_load_id = nil
				end

				if equipped_item and not entry.icon_load_id then
					local cb = callback(_on_item_icon_load_cb_func, widget, equipped_item)
					entry.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end
			end
		end
	end
end

HudElementEmoteWheel.destroy = function (self, ui_renderer)
	local entries = self._entries

	for i = 1, #entries do
		local entry = entries[i]
		local widget = entry.widget

		if entry.icon_load_id then
			_remove_item_icon_load_cb_func(widget, ui_renderer)
			Managers.ui:unload_item_icon(entry.icon_load_id)

			entry.icon_load_id = nil
		end
	end

	self:_on_wheel_closed()
	HudElementEmoteWheel.super.destroy(self)
end

HudElementEmoteWheel._on_wheel_start = function (self, t, input_service)
	self._event_to_play = nil
	local entries = self._entries

	for i = 1, #entries do
		local entry = entries[i]
		local widget = entry.widget
		local content = widget.content
		local option = entry.option
		local is_populated = option ~= nil

		if is_populated then
			local slot_id = option.slot_id
			local item = entry.item
			local item_icon = entry.item_icon
		end
	end

	local wheel_context = self._wheel_context
	wheel_context.input_start_time = t
	local tag_context = self._tag_context
	wheel_context.simultaneous_press = tag_context.input_start_time and math.abs(tag_context.input_start_time - t) < 0.001
end

HudElementEmoteWheel._on_wheel_stop = function (self, t, ui_renderer, render_settings, input_service)
	if self.destroyed then
		return
	end

	local wheel_active = self._wheel_active
	local wheel_hovered_entry = wheel_active and self:_is_wheel_entry_hovered(t)
	local wheel_context = self._wheel_context

	if wheel_hovered_entry then
		local option = wheel_hovered_entry.option

		if option and wheel_hovered_entry.item then
			local event_id = option.event_id

			if event_id then
				self._event_to_play = event_id

				if UISoundEvents.emote_wheel_entry_select then
					Managers.ui:play_2d_sound(UISoundEvents.emote_wheel_entry_select)
				end
			end
		end
	end

	wheel_context.input_start_time = nil
	wheel_context.instant_drew = nil
	wheel_context.simultaneous_press = nil

	Managers.event:trigger("event_set_emote_wheel_state", "inactive")

	if self._wheel_active and UISoundEvents.emote_wheel_close then
		Managers.ui:play_2d_sound(UISoundEvents.emote_wheel_close)
	end
end

HudElementEmoteWheel._get_chat_channel_by_tag = function (self, channel_tag)
	local channels = Managers.chat:connected_chat_channels()

	if channels then
		for channel_handle, channel in pairs(channels) do
			if channel.tag == channel_tag then
				return channel, channel_handle
			end
		end
	end
end

HudElementEmoteWheel._handle_input = function (self, t, dt, ui_renderer, render_settings)
	if self._close_delay then
		self._close_delay = self._close_delay - dt

		if self._close_delay <= 0 then
			self._close_delay = nil

			self:_pop_cursor()
			Managers.event:trigger("event_set_emote_wheel_state", "inactive")

			if self._event_to_play then
				Managers.event:trigger("player_activate_emote", self._event_to_play)
			end
		end

		return
	end

	local service_type = "Ingame"
	local input_service = Managers.input:get_input_service(service_type)

	self:_handle_com_wheel(t, ui_renderer, render_settings, input_service)
end

HudElementEmoteWheel.using_input = function (self)
	return self._wheel_active or self._event_to_play and self._close_delay ~= nil
end

HudElementEmoteWheel._handle_com_wheel = function (self, t, ui_renderer, render_settings, input_service)
	local input_pressed = input_service:get("jump_held")
	local wheel_context = self._wheel_context
	local start_time = wheel_context.input_start_time

	if input_pressed and not start_time then
		self:_on_wheel_start(t, input_service)
	elseif not input_pressed and start_time then
		self:_on_wheel_stop(t, ui_renderer, render_settings, input_service)
	end

	local draw_wheel = false
	local start_time = wheel_context.input_start_time

	if start_time then
		draw_wheel = self._wheel_active
		local account_data = Managers.save:account_data()
		local com_wheel_delay = account_data.input_settings.com_wheel_delay
		local always_draw_t = start_time + com_wheel_delay

		if t > always_draw_t then
			draw_wheel = true
		elseif InputDevice.gamepad_active then
			draw_wheel = draw_wheel or self:_should_draw_wheel_gamepad(input_service)
		end
	end

	if draw_wheel and not self._wheel_active then
		self._wheel_active = true

		if UISoundEvents.emote_wheel_open then
			Managers.ui:play_2d_sound(UISoundEvents.emote_wheel_open)
		end

		if not InputDevice.gamepad_active then
			self:_push_cursor()
		end

		Managers.event:trigger("event_set_emote_wheel_state", "active")
	elseif not draw_wheel and self._wheel_active then
		self._wheel_active = false
		self._close_delay = InputDevice.gamepad_active and 0.15 or 0
	end
end

HudElementEmoteWheel._should_draw_wheel = function (self, input_service)
	return input_service:get("jump_held")
end

HudElementEmoteWheel._should_draw_wheel_gamepad = function (self, input_service)
	local look_delta = input_service:get("look_raw_controller") * INSTANT_WHEEL_THRESHOLD * 2
	local is_dragging = INSTANT_WHEEL_THRESHOLD < Vector3.length(look_delta)
	local wheel_context = self._wheel_context
	local should_instant_draw = is_dragging

	if not wheel_context.instant_drew and should_instant_draw then
		local entries = self._entries
		local look_angle = (2 * math.pi - math.angle(0, 0, look_delta[1], look_delta[2]) - math.pi * 0.5) % (2 * math.pi)
		local entry_hover_angle = math.pi * 0.275
		local half_entry_hover_angle = entry_hover_angle * 0.5

		for i = 1, #entries do
			local entry = entries[i]
			local visible = entry.widget.content.visible
			local entry_angle = entry.widget.content.angle

			if visible and math.abs(entry_angle - look_angle) < half_entry_hover_angle then
				wheel_context.instant_drew = true

				break
			end
		end
	end

	return should_instant_draw
end

HudElementEmoteWheel._on_wheel_closed = function (self)
	if self._wheel_active or self._close_delay then
		self:_pop_cursor()
		Managers.event:trigger("event_set_emote_wheel_state", false)
	end

	self._wheel_active = false
	self._close_delay = nil
end

HudElementEmoteWheel._check_box_overlap = function (self, x1, y1, x2, y2, px, py, radius)
	local center_x = px * 0.5
	local center_y = py * 0.5
	local Xn = math.max(x1, math.min(center_x, x2))
	local Yn = math.max(y1, math.min(center_y, y2))
	local Dx = Xn - center_x
	local Dy = Yn - center_y
	local is_overlapping = Dx * Dx + Dy * Dy <= radius * radius

	return is_overlapping
end

HudElementEmoteWheel._update_wheel_presentation = function (self, dt, t, ui_renderer, render_settings, input_service)
	local screen_width = RESOLUTION_LOOKUP.width
	local screen_height = RESOLUTION_LOOKUP.height
	local inverse_scale = render_settings.inverse_scale
	local scale = render_settings.scale
	local cursor = input_service and input_service:get("cursor")

	if input_service and InputDevice.gamepad_active then
		cursor = input_service:get("navigate_controller_right")
		cursor[1] = screen_width * 0.5 + cursor[1] * screen_width * 0.5
		cursor[2] = screen_height * 0.5 - cursor[2] * screen_height * 0.5
	end

	local cursor_position = IS_XBS and UIResolution.scale_vector(cursor, scale) or UIResolution.inverse_scale_vector(cursor, inverse_scale)
	local cursor_distance_from_center = math.distance_2d(screen_width * 0.5, screen_height * 0.5, cursor_position[1], cursor_position[2])
	local cursor_angle_from_center = math.angle(screen_width * 0.5, screen_height * 0.5, cursor_position[1], cursor_position[2]) - math.pi * 0.5
	local cursor_angle_degrees_from_center = math.radians_to_degrees(cursor_angle_from_center) % 360
	local entry_hover_degrees = 44
	local entry_hover_degrees_half = entry_hover_degrees * 0.5
	local any_hover = false
	local hovered_entry = nil
	local is_hover_started = false
	local entries = self._entries

	for i = 1, #entries do
		local entry = entries[i]
		local widget = entry.widget
		local content = widget.content
		local widget_angle = content.angle
		local widget_angle_degrees = -(math.radians_to_degrees(widget_angle) - math.pi * 0.5) % 360
		local is_populated = entry.option ~= nil
		local is_hover = false

		if is_populated and cursor_distance_from_center > 130 * scale then
			local angle_diff = (widget_angle_degrees - cursor_angle_degrees_from_center + 180 + 360) % 360 - 180

			if entry_hover_degrees_half >= angle_diff and angle_diff >= -entry_hover_degrees_half then
				is_hover = true
				any_hover = true
				hovered_entry = entry
			end
		end

		if is_hover and not widget.content.hotspot.force_hover then
			is_hover_started = true
		end

		widget.content.hotspot.force_hover = is_hover
	end

	local wheel_background_widget = self._widgets_by_name.wheel_background
	wheel_background_widget.content.angle = cursor_angle_from_center
	wheel_background_widget.content.force_hover = any_hover
	wheel_background_widget.style.mark.color[1] = any_hover and 255 or 0

	if hovered_entry then
		local option = hovered_entry.option
		local slot_id = option.slot_id
		local display_name = hovered_entry.display_name
		local default_display_name = option.default_display_name
		local localized_display_name = Localize(display_name or default_display_name)
		wheel_background_widget.content.text = localized_display_name

		if is_hover_started then
			Managers.ui:play_2d_sound(UISoundEvents.emote_wheel_entry_hover)
		end
	end
end

HudElementEmoteWheel._is_wheel_entry_hovered = function (self, t)
	local entries = self._entries

	for i = 1, #entries do
		local entry = entries[i]
		local widget = entry.widget

		if widget.content.hotspot.is_hover then
			return entry, i
		end
	end

	local last_hover = self._last_widget_hover_data

	if last_hover.t and t < last_hover.t + HOVER_GRACE_PERIOD then
		local i = last_hover.index

		return entries[i], i
	end
end

HudElementEmoteWheel._update_active_progress = function (self, dt)
	local active = self._wheel_active
	local anim_speed = HudElementEmoteWheelSettings.anim_speed
	local progress = self._wheel_active_progress

	if active then
		progress = math.min(progress + dt * anim_speed, 1)
	else
		progress = math.max(progress - dt * anim_speed, 0)
	end

	self._wheel_active_progress = progress
end

HudElementEmoteWheel._update_widget_locations = function (self)
	local entries = self._entries
	local start_angle = math.pi / 2
	local num_entries = #entries
	local radians_per_widget = math.pi * 2 / num_entries
	local active_progress = self._wheel_active_progress
	local anim_progress = math.smoothstep(active_progress, 0, 1)
	local wheel_slots = HudElementEmoteWheelSettings.wheel_slots
	local min_radius = HudElementEmoteWheelSettings.min_radius
	local max_radius = HudElementEmoteWheelSettings.max_radius
	local radius = min_radius + anim_progress * (max_radius - min_radius)

	for i = 1, wheel_slots do
		local entry = entries[i]

		if entry then
			local widget = entry.widget
			local angle = start_angle + (i - 1) * radians_per_widget
			local position_x = math.sin(angle) * radius
			local position_y = math.cos(angle) * radius
			local offset = widget.offset
			widget.content.angle = angle
			offset[1] = position_x
			offset[2] = position_y
		end
	end
end

HudElementEmoteWheel._push_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name
	local position = Vector3(0.5, 0.5, 0)

	input_manager:push_cursor(name)
	input_manager:set_cursor_position(name, position)

	self._cursor_pushed = true
end

HudElementEmoteWheel._pop_cursor = function (self)
	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end
end

HudElementEmoteWheel._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local active_progress = self._wheel_active_progress

	if active_progress == 0 then
		return
	end

	render_settings.alpha_multiplier = active_progress
	local entries = self._entries

	if entries then
		for i = 1, #entries do
			local entry = entries[i]
			local widget = entry.widget

			UIWidget.draw(widget, ui_renderer)

			if widget.content.hotspot.is_hover then
				local hover_data = self._last_widget_hover_data
				hover_data.t = t
				hover_data.index = i
			end
		end
	end

	HudElementEmoteWheel.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

return HudElementEmoteWheel
