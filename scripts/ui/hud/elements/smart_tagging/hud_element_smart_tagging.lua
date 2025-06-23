-- chunkname: @scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging.lua

local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local Definitions = require("scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_definitions")
local Hud = require("scripts/utilities/ui/hud")
local HudElementSmartTaggingSettings = require("scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Vo = require("scripts/utilities/vo")
local VoQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local ChannelTags = ChatManagerConstants.ChannelTag
local DOUBLE_TAP_DELAY = 0.3
local INSTANT_WHEEL_THRESHOLD = 8
local HOVER_GRACE_PERIOD = 0.4
local HudElementSmartTagging = class("HudElementSmartTagging", "HudElementBase")

HudElementSmartTagging.init = function (self, parent, draw_layer, start_scale)
	HudElementSmartTagging.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._wheel_active_progress = 0
	self._wheel_active = false
	self._entries = {}
	self._last_widget_hover_data = {}
	self._interaction_scan_delay = HudElementSmartTaggingSettings.scan_delay
	self._interaction_scan_delay_duration = 0
	self._presented_smart_tags_by_tag_id = {}
	self._presented_smart_tags_by_marker_id = {}

	local wheel_slots = HudElementSmartTaggingSettings.wheel_slots

	self:_setup_entries(wheel_slots)

	local wheel_options = {
		{
			icon = "content/ui/materials/hud/communication_wheel/icons/for_the_emperor",
			display_name = "loc_communication_wheel_display_name_cheer",
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_for_the_emperor
			},
			start_angle = -(math.pi / 8) * 3
		},
		{
			display_name = "loc_communication_wheel_display_name_need_health",
			icon = "content/ui/materials/hud/communication_wheel/icons/health",
			chat_message_data = {
				text = "loc_communication_wheel_need_health",
				channel = ChannelTags.MISSION
			},
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_need_health
			}
		},
		{
			display_name = "loc_communication_wheel_display_name_thanks",
			icon = "content/ui/materials/hud/communication_wheel/icons/thanks",
			chat_message_data = {
				text = "loc_communication_wheel_thanks",
				channel = ChannelTags.MISSION
			},
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_thank_you
			}
		},
		{
			display_name = "loc_communication_wheel_display_name_need_ammo",
			icon = "content/ui/materials/hud/communication_wheel/icons/ammo",
			chat_message_data = {
				text = "loc_communication_wheel_need_ammo",
				channel = ChannelTags.MISSION
			},
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_need_ammo
			}
		},
		{
			display_name = "loc_communication_wheel_display_name_enemy",
			icon = "content/ui/materials/hud/communication_wheel/icons/enemy",
			tag_type = "location_threat",
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_enemy_over_here
			},
			start_angle = -(math.pi / 8) * 2
		},
		{
			icon = "content/ui/materials/hud/communication_wheel/icons/location",
			display_name = "loc_communication_wheel_display_name_location",
			tag_type = "location_ping",
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_lets_go_this_way
			}
		},
		{
			icon = "content/ui/materials/hud/communication_wheel/icons/attention",
			display_name = "loc_communication_wheel_display_name_attention",
			tag_type = "location_attention",
			voice_event_data = {
				voice_tag_concept = VoQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VoQueryConstants.trigger_ids.com_wheel_vo_over_here
			}
		}
	}

	self:_populate_wheel(wheel_options)

	self._interaction_line_widget = self:_create_widget("interaction_line", Definitions.interaction_line_definition)

	self:_register_event("event_smart_tag_created")
	self:_register_event("event_smart_tag_removed")
	self:_register_event("event_smart_tag_reply_added")

	self._tag_context = {}
	self._com_wheel_context = {}
end

HudElementSmartTagging._populate_wheel = function (self, options)
	local entries = self._entries
	local wheel_slots = HudElementSmartTaggingSettings.wheel_slots

	for i = 1, wheel_slots do
		local option = options[i]
		local entry = entries[i]
		local widget = entry.widget
		local content = widget.content

		content.visible = option ~= nil
		entry.option = option

		if option then
			content.icon = option.icon
		end
	end
end

HudElementSmartTagging._setup_entries = function (self, num_entries)
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

HudElementSmartTagging.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementSmartTagging.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_active_progress(dt)
	self:_update_widget_locations()

	if self._wheel_active then
		self:_update_wheel_presentation(dt, t, ui_renderer, render_settings, input_service)
	end

	self:_handle_input(t, dt, ui_renderer, render_settings)
end

HudElementSmartTagging.destroy = function (self, ui_renderer)
	self:_clear_all_smart_tag_presentations()
	self:_on_wheel_closed()
	HudElementSmartTagging.super.destroy(self, ui_renderer)
end

HudElementSmartTagging._on_tag_start = function (self, t)
	local tag_context = self._tag_context

	tag_context.enemy_tagged = false
	tag_context.marker_handled = false
	tag_context.input_start_time = t
	tag_context.is_double_tap = tag_context.input_stop_time and t - tag_context.input_stop_time <= DOUBLE_TAP_DELAY
end

HudElementSmartTagging._on_com_wheel_start = function (self, t, input_service)
	local wheel_context = self._com_wheel_context

	wheel_context.input_start_time = t
	wheel_context.is_double_tap = wheel_context.input_stop_time and t - wheel_context.input_stop_time <= DOUBLE_TAP_DELAY
	wheel_context.camera_still_on_tag = Vector3.length_squared(input_service:get("look_raw") + input_service:get("look_raw_controller")) <= 0
	wheel_context.single_tap_location_tag = nil

	local tag_context = self._tag_context

	wheel_context.simultaneous_press = tag_context.input_start_time and math.abs(tag_context.input_start_time - t) < 0.001
end

HudElementSmartTagging._trigger_smart_tag = function (self, template_name, target_unit, target_location)
	local parent = self._parent
	local player_unit = parent:player_unit()
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	smart_tag_system:set_tag(template_name, player_unit, target_unit, target_location)
end

HudElementSmartTagging._trigger_smart_tag_interaction = function (self, tag_id, target_unit)
	local parent = self._parent
	local player_unit = parent:player_unit()
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	smart_tag_system:trigger_tag_interaction(tag_id, player_unit, target_unit)
end

HudElementSmartTagging._trigger_smart_tag_unit_contextual = function (self, target_unit, alternate)
	local parent = self._parent
	local player_unit = parent:player_unit()
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	smart_tag_system:set_contextual_unit_tag(player_unit, target_unit, alternate)
end

HudElementSmartTagging._on_tag_stop = function (self, t, ui_renderer, render_settings)
	local cb = callback(self, "_on_tag_stop_callback", t, ui_renderer, render_settings)

	Managers.state.game_mode:register_physics_safe_callback(cb)
end

HudElementSmartTagging._on_com_wheel_stop = function (self, t, ui_renderer, render_settings, input_service)
	local cb = callback(self, "_on_com_wheel_stop_callback", t, ui_renderer, render_settings, input_service)

	Managers.state.game_mode:register_physics_safe_callback(cb)
end

HudElementSmartTagging._on_tag_stop_callback = function (self, t, ui_renderer, render_settings)
	if self.destroyed then
		return
	end

	local tag_context = self._tag_context
	local target_marker, target_unit, target_position
	local parent = self._parent
	local player_unit = parent:player_unit()
	local interactor_extension = ScriptUnit.extension(player_unit, "interactor_system")
	local interactor_target_unit = interactor_extension:target_unit()
	local interactor_smart_tag_extension = interactor_target_unit and ScriptUnit.has_extension(interactor_target_unit, "smart_tag_system")

	if interactor_smart_tag_extension then
		target_unit = interactor_target_unit
	else
		local force_update_targets = true

		target_marker, target_unit, target_position = self:_find_best_smart_tag_interaction(ui_renderer, render_settings, force_update_targets)
	end

	local double_tap = tag_context.is_double_tap

	if target_unit then
		local account_data = Managers.save:account_data()
		local single_tap = account_data.input_settings.companion_command_tap == "single"
		local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

		if unit_data_extension and (double_tap or single_tap) then
			self:_trigger_smart_tag_unit_contextual(target_unit, "companion_order")
		else
			self:_handle_selected_unit(target_unit)

			tag_context.enemy_tagged = true
		end
	elseif target_marker then
		self:_handle_selected_marker(target_marker)

		tag_context.marker_handled = true
	end

	tag_context.double_tapped_unit = double_tap and target_unit
	tag_context.input_stop_time = t
	tag_context.input_start_time = nil
	tag_context.is_double_tap = nil
end

HudElementSmartTagging._on_com_wheel_stop_callback = function (self, t, ui_renderer, render_settings, input_service)
	if self.destroyed then
		return
	end

	local wheel_active = self._wheel_active
	local wheel_hovered_entry = wheel_active and self:_is_wheel_entry_hovered(t)
	local wheel_context = self._com_wheel_context

	if wheel_hovered_entry then
		local option = wheel_hovered_entry.option

		if option then
			local tag_type = option.tag_type

			if tag_type then
				local force_update_targets = true
				local raycast_data = self:_find_raycast_targets(force_update_targets)
				local hit_position = raycast_data.static_hit_position

				if hit_position then
					self:_trigger_smart_tag(tag_type, nil, Vector3Box.unbox(hit_position))
				end
			end

			local chat_message_data = option.chat_message_data

			if chat_message_data then
				local text = chat_message_data.text
				local channel_tag = chat_message_data.channel
				local channel, channel_handle = self:_get_chat_channel_by_tag(channel_tag)

				if channel then
					Managers.chat:send_loc_channel_message(channel_handle, text, nil)
				end
			end

			local voice_event_data = option.voice_event_data

			if voice_event_data then
				local parent = self._parent
				local player_unit = parent:player_unit()

				if player_unit then
					Vo.on_demand_vo_event(player_unit, voice_event_data.voice_tag_concept, voice_event_data.voice_tag_id)
				end
			end

			Managers.telemetry_reporters:reporter("com_wheel"):register_event(option.voice_event_data.voice_tag_id)
		end
	elseif t - wheel_context.input_start_time <= DOUBLE_TAP_DELAY then
		local account_data = Managers.save:account_data()
		local com_wheel_single_tap = account_data.input_settings.com_wheel_single_tap
		local com_wheel_double_tap = account_data.input_settings.com_wheel_double_tap
		local tag_context = self._tag_context
		local double_tapped_unit = tag_context.double_tapped_unit
		local allow_single_tap = com_wheel_single_tap ~= "none"
		local allow_double_tap = com_wheel_double_tap ~= "none" and not double_tapped_unit

		if wheel_context.simultaneous_press and tag_context.enemy_tagged then
			-- Nothing
		elseif wheel_context.is_double_tap then
			if allow_double_tap then
				local force_update_targets = true
				local raycast_data = self:_find_raycast_targets(force_update_targets)
				local hit_position = raycast_data.static_hit_position

				if hit_position then
					self:_trigger_smart_tag(com_wheel_double_tap, nil, Vector3Box.unbox(hit_position))
				end
			end
		else
			local force_update_targets = true
			local _, _, target_position = self:_find_best_smart_tag_interaction(ui_renderer, render_settings, force_update_targets)
			local marker_handled = wheel_context.simultaneous_press and tag_context.marker_handled

			if target_position and allow_single_tap and not marker_handled then
				wheel_context.single_tap_location_tag = {
					tag_type = com_wheel_single_tap,
					spawn_time = t + (DOUBLE_TAP_DELAY - (t - wheel_context.input_start_time)),
					position = Vector3Box(target_position)
				}
			end
		end

		wheel_context.input_stop_time = t
	end

	wheel_context.input_start_time = nil
	wheel_context.is_double_tap = nil
	wheel_context.instant_drew = nil
	wheel_context.camera_still_on_tag = nil
	wheel_context.simultaneous_press = nil

	Managers.event:trigger("event_set_communication_wheel_state", "inactive")
end

HudElementSmartTagging._get_chat_channel_by_tag = function (self, channel_tag)
	local channels = Managers.chat:connected_chat_channels()

	if channels then
		for channel_handle, channel in pairs(channels) do
			if channel.tag == channel_tag then
				return channel, channel_handle
			end
		end
	end
end

HudElementSmartTagging._cb_world_markers_list_request = function (self, world_markers)
	self._world_markers_list = world_markers
end

HudElementSmartTagging._find_marker_by_unit = function (self, unit)
	local world_markers_list = self._world_markers_list

	for i = 1, #world_markers_list do
		local marker = world_markers_list[i]

		if marker.unit == unit and marker.template.using_smart_tag_system then
			return marker
		end
	end
end

HudElementSmartTagging._handle_input = function (self, t, dt, ui_renderer, render_settings)
	if self._close_delay then
		self._close_delay = self._close_delay - dt

		if self._close_delay <= 0 then
			self._close_delay = nil

			self:_pop_cursor()
			Managers.event:trigger("event_set_communication_wheel_state", "inactive")
		end

		return
	end

	local service_type = "Ingame"
	local input_service = Managers.input:get_input_service(service_type)
	local ignore_hud_input = true
	local is_input_blocked = Managers.ui:using_input(ignore_hud_input)

	self:_handle_tagging(t, ui_renderer, render_settings, is_input_blocked and input_service:null_service() or input_service)
	self:_handle_com_wheel(t, ui_renderer, render_settings, is_input_blocked and input_service:null_service() or input_service)
end

HudElementSmartTagging._handle_tagging = function (self, t, ui_renderer, render_settings, input_service)
	local input_pressed = input_service:get("smart_tag")
	local tag_context = self._tag_context
	local start_time = tag_context.input_start_time

	if input_pressed and not start_time then
		self:_on_tag_start(t)
	elseif not input_pressed and start_time then
		self:_on_tag_stop(t, ui_renderer, render_settings)
	end
end

HudElementSmartTagging._handle_com_wheel = function (self, t, ui_renderer, render_settings, input_service)
	local input_pressed = input_service:get("com_wheel")
	local wheel_context = self._com_wheel_context
	local start_time = wheel_context.input_start_time

	if input_pressed and not start_time then
		self:_on_com_wheel_start(t, input_service)
	elseif not input_pressed and start_time then
		self:_on_com_wheel_stop(t, ui_renderer, render_settings, input_service)
	end

	local draw_wheel = false
	local start_time = wheel_context.input_start_time

	if start_time then
		draw_wheel = self._wheel_active

		local account_data = Managers.save:account_data()
		local com_wheel_delay = account_data.input_settings.com_wheel_delay
		local always_draw_t = start_time + com_wheel_delay

		if always_draw_t < t then
			draw_wheel = true
		elseif InputDevice.gamepad_active then
			draw_wheel = draw_wheel or self:_should_draw_wheel_gamepad(input_service)
		end
	end

	if draw_wheel and not self._wheel_active then
		self._wheel_active = true

		if not InputDevice.gamepad_active then
			self:_push_cursor()
		end

		Managers.event:trigger("event_set_communication_wheel_state", "active")
	elseif not draw_wheel and self._wheel_active then
		self._wheel_active = false
		self._close_delay = InputDevice.gamepad_active and 0.15 or 0
	end

	local location_tag = wheel_context.single_tap_location_tag

	if location_tag and t >= location_tag.spawn_time then
		local position = Vector3Box.unbox(location_tag.position)

		self:_trigger_smart_tag(location_tag.tag_type, nil, position)

		wheel_context.single_tap_location_tag = nil
	end
end

HudElementSmartTagging._should_draw_wheel = function (self, input_service)
	return input_service:get("smart_tag")
end

HudElementSmartTagging._should_draw_wheel_gamepad = function (self, input_service)
	local look_delta = input_service:get("look_raw_controller") * INSTANT_WHEEL_THRESHOLD * 2
	local is_dragging = Vector3.length(look_delta) > INSTANT_WHEEL_THRESHOLD
	local wheel_context = self._com_wheel_context

	if not wheel_context.camera_still_on_tag then
		return false
	end

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

			if visible and half_entry_hover_angle > math.abs(entry_angle - look_angle) then
				wheel_context.instant_drew = true

				break
			end
		end
	end

	return should_instant_draw
end

HudElementSmartTagging._on_wheel_closed = function (self)
	if self._wheel_active or self._close_delay then
		self:_pop_cursor()
		Managers.event:trigger("event_set_communication_wheel_state", false)
	end

	self._wheel_active = false
	self._close_delay = nil
end

HudElementSmartTagging._handle_selected_marker = function (self, marker)
	local marker_template = marker.template
	local tag_id = marker_template.get_smart_tag_id(marker)

	if tag_id then
		self:_trigger_smart_tag_interaction(tag_id)
	else
		local marker_unit = marker.unit

		if marker_unit then
			self:_trigger_smart_tag_unit_contextual(marker_unit)
		end
	end
end

HudElementSmartTagging._handle_selected_unit = function (self, unit)
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")
	local tag_id = smart_tag_system:unit_tag_id(unit)

	if tag_id then
		self:_trigger_smart_tag_interaction(tag_id, unit)
	else
		self:_trigger_smart_tag_unit_contextual(unit)
	end
end

HudElementSmartTagging._is_marker_valid_for_tagging = function (self, player_unit, marker, distance)
	local template = marker.template

	if not template.using_smart_tag_system then
		return false
	end

	local marker_unit = marker.unit
	local smart_tag_extension = marker_unit and ScriptUnit.has_extension(marker_unit, "smart_tag_system")

	if marker_unit and not smart_tag_extension then
		return false
	end

	local tag_id = template.get_smart_tag_id(marker)
	local in_line_of_sight = not marker.raycast_result

	if not tag_id and not in_line_of_sight then
		return false
	end

	if not marker.is_inside_frustum or marker.is_clamped then
		return false
	end

	if not tag_id then
		if smart_tag_extension and not smart_tag_extension:can_tag(player_unit) then
			return false
		end

		local max_distance = template.max_distance

		if max_distance and distance and max_distance <= distance then
			return false
		end
	end

	return true
end

HudElementSmartTagging._find_world_marker_target = function (self, ui_renderer, render_settings)
	Managers.event:trigger("request_world_markers_list", callback(self, "_cb_world_markers_list_request"))

	local world_markers_list = self._world_markers_list
	local hud_scale = Hud.hud_scale()
	local selected_marker_distance = math.huge
	local selected_marker
	local parent = self._parent
	local player = parent:player()
	local player_unit = player.player_unit

	for i = 1, #world_markers_list do
		local marker = world_markers_list[i]
		local widget = marker.widget

		if widget then
			local distance = widget.content.distance

			if self:_is_marker_valid_for_tagging(player_unit, marker, distance) then
				local template = marker.template
				local size = template.size
				local offset = widget.offset
				local marker_scale = marker.scale or 1
				local x = offset[1] * hud_scale
				local y = offset[2] * hud_scale
				local width = size[1] * marker_scale * hud_scale
				local height = size[2] * marker_scale * hud_scale
				local x1 = x - width * 0.5
				local x2 = x + width * 0.5
				local y1 = y - height * 0.5
				local y2 = y + height * 0.5
				local radius = HudElementSmartTaggingSettings.cursor_tag_radius
				local resolution_width, resolution_height = RESOLUTION_LOOKUP.width, RESOLUTION_LOOKUP.height

				if math.box_overlap_point_radius(x1, y1, x2, y2, 0.5 * resolution_width, 0.5 * resolution_height, radius) and distance < selected_marker_distance then
					selected_marker_distance = distance
					selected_marker = marker
				end
			end
		end
	end

	return selected_marker, selected_marker_distance
end

HudElementSmartTagging._check_box_overlap = function (self, x1, y1, x2, y2, px, py, radius)
	local center_x = px * 0.5
	local center_y = py * 0.5
	local Xn = math.max(x1, math.min(center_x, x2))
	local Yn = math.max(y1, math.min(center_y, y2))
	local Dx = Xn - center_x
	local Dy = Yn - center_y
	local is_overlapping = Dx * Dx + Dy * Dy <= radius * radius

	return is_overlapping
end

HudElementSmartTagging._update_wheel_presentation = function (self, dt, t, ui_renderer, render_settings, input_service)
	local screen_width, screen_height = RESOLUTION_LOOKUP.width, RESOLUTION_LOOKUP.height
	local scale = render_settings.scale
	local cursor = input_service and input_service:get("cursor")

	if input_service and InputDevice.gamepad_active then
		cursor = input_service:get("navigate_controller_right")
		cursor[1] = screen_width * 0.5 + cursor[1] * screen_width * 0.5
		cursor[2] = screen_height * 0.5 - cursor[2] * screen_height * 0.5
	end

	if not cursor then
		return
	end

	local cursor_distance_from_center = math.distance_2d(screen_width * 0.5, screen_height * 0.5, cursor[1], cursor[2])
	local cursor_angle_from_center = math.angle(screen_width * 0.5, screen_height * 0.5, cursor[1], cursor[2]) - math.pi * 0.5
	local cursor_angle_degrees_from_center = math.radians_to_degrees(cursor_angle_from_center) % 360
	local entry_hover_degrees = 44
	local entry_hover_degrees_half = entry_hover_degrees * 0.5
	local any_hover = false
	local hovered_entry
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

			if angle_diff <= entry_hover_degrees_half and angle_diff >= -entry_hover_degrees_half then
				is_hover = true
				any_hover = true
				hovered_entry = entry
			end
		end

		widget.content.hotspot.force_hover = is_hover
	end

	local wheel_background_widget = self._widgets_by_name.wheel_background

	wheel_background_widget.content.angle = cursor_angle_from_center
	wheel_background_widget.content.force_hover = any_hover
	wheel_background_widget.style.mark.color[1] = any_hover and 255 or 0

	if hovered_entry then
		local option = hovered_entry.option
		local display_name = option.display_name

		wheel_background_widget.content.text = Localize(display_name)
	end
end

HudElementSmartTagging._is_wheel_entry_hovered = function (self, t)
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

HudElementSmartTagging._update_active_progress = function (self, dt)
	local active = self._wheel_active
	local anim_speed = HudElementSmartTaggingSettings.anim_speed
	local progress = self._wheel_active_progress

	if active then
		progress = math.min(progress + dt * anim_speed, 1)
	else
		progress = math.max(progress - dt * anim_speed, 0)
	end

	self._wheel_active_progress = progress
end

HudElementSmartTagging._update_widget_locations = function (self)
	local entries = self._entries
	local start_angle = 0
	local num_entries = #entries
	local radians_per_widget = math.pi * 2 / num_entries
	local active_progress = self._wheel_active_progress
	local anim_progress = math.smoothstep(active_progress, 0, 1)
	local wheel_slots = HudElementSmartTaggingSettings.wheel_slots
	local min_radius = HudElementSmartTaggingSettings.min_radius
	local max_radius = HudElementSmartTaggingSettings.max_radius
	local radius = min_radius + anim_progress * (max_radius - min_radius)

	for i = 1, wheel_slots do
		local entry = entries[i]

		if entry then
			local option = entry.option

			start_angle = option and option.start_angle or start_angle

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

HudElementSmartTagging._push_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name
	local position = Vector3(0.5, 0.5, 0)

	input_manager:push_cursor(name)
	input_manager:set_cursor_position(name, position)

	self._cursor_pushed = true
end

HudElementSmartTagging._pop_cursor = function (self)
	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end
end

HudElementSmartTagging._find_best_smart_tag_interaction = function (self, ui_renderer, render_settings, force_update_targets)
	local raycast_data = self:_find_raycast_targets(force_update_targets)
	local target_marker, _ = self:_find_world_marker_target(ui_renderer, render_settings)
	local best_marker = target_marker
	local best_unit = ALIVE[raycast_data.unit] and raycast_data.unit
	local best_position

	if raycast_data.static_hit_position then
		best_position = Vector3Box.unbox(raycast_data.static_hit_position)
	end

	return best_marker, best_unit, best_position
end

HudElementSmartTagging._handle_interaction_draw = function (self, dt, t, input_service, ui_renderer, render_settings)
	local can_present_tag_interaction = self:_can_present_tag_interaction()

	if not can_present_tag_interaction then
		self._active_interaction_data = nil

		return
	end

	if self._interaction_scan_delay_duration > 0 then
		self._interaction_scan_delay_duration = self._interaction_scan_delay_duration - dt
	else
		local force_update_targets = false
		local best_marker, best_unit, _ = self:_find_best_smart_tag_interaction(ui_renderer, render_settings, force_update_targets)
		local parent = self._parent
		local player = parent:player()
		local player_unit = player.player_unit
		local smart_tag_system = Managers.state.extension:system("smart_tag_system")
		local previous_active_interaction_data = self._active_interaction_data

		if not best_marker and best_unit then
			local marker = self:_find_marker_by_unit(best_unit)

			best_marker = marker
		end

		if best_marker then
			if not previous_active_interaction_data or previous_active_interaction_data.marker ~= best_marker then
				local marker_id = best_marker.id
				local smart_tag_presentation_data = self._presented_smart_tags_by_marker_id[marker_id]
				local tag_id = smart_tag_presentation_data and smart_tag_presentation_data.tag_id
				local tag_template, display_name

				if tag_id then
					local tag = smart_tag_system:tag_by_id(tag_id)

					display_name = tag:display_name()
					tag_template = tag:template()
				else
					local marker_unit = best_marker.unit
					local smart_tag_extension = ScriptUnit.has_extension(marker_unit, "smart_tag_system")

					tag_template = smart_tag_extension:contextual_tag_template(player_unit)
					display_name = smart_tag_extension:display_name(player_unit)
				end

				self._active_interaction_data = {
					intro_anim_time = 0,
					intro_anim_progress = 0,
					intro_anim_duration = 0.2,
					unit = best_unit or best_marker.unit,
					marker_id = best_marker.id,
					marker = best_marker,
					tag_id = tag_id,
					tag_template = tag_template,
					display_name = display_name
				}
			end
		else
			self._active_interaction_data = nil
		end

		self._interaction_scan_delay_duration = self._interaction_scan_delay
	end

	self:_update_tags_interaction_hover_status()

	local active_interaction_data = self._active_interaction_data
	local marker = active_interaction_data and active_interaction_data.marker

	if marker and marker.deleted then
		self._active_interaction_data = nil
	elseif marker then
		self:_update_tag_interaction_information(active_interaction_data)
		self:_update_tag_interaction_animation(dt, t)
		self:_draw_active_interaction_line(dt, t, input_service, ui_renderer, render_settings)
	end
end

HudElementSmartTagging._update_tags_interaction_hover_status = function (self)
	local active_interaction_data = self._active_interaction_data
	local presented_smart_tags_by_tag_id = self._presented_smart_tags_by_tag_id

	for tag_id, tag_presentation_data in pairs(presented_smart_tags_by_tag_id) do
		local tag_marker_id = tag_presentation_data.marker_id

		tag_presentation_data.is_hovered = active_interaction_data and active_interaction_data.marker_id == tag_marker_id
	end
end

HudElementSmartTagging._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	self:_handle_interaction_draw(dt, t, input_service, ui_renderer, render_settings)

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

	HudElementSmartTagging.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementSmartTagging._find_raycast_targets = function (self, force_update_targets)
	local player_unit = self._parent:player_unit()
	local smart_targeting_extension = ScriptUnit.extension(player_unit, "smart_targeting_system")

	if force_update_targets then
		smart_targeting_extension:force_update_smart_tag_targets()
	end

	local targeting_data = smart_targeting_extension:smart_tag_targeting_data()

	return targeting_data
end

HudElementSmartTagging._physics_world = function (self)
	local world_manager = Managers.world
	local world_name = "level_world"

	if world_manager:has_world(world_name) then
		local world = world_manager:world(world_name)
		local physics_world = World.physics_world(world)

		return physics_world
	end
end

HudElementSmartTagging.event_smart_tag_created = function (self, tag_instance, is_hotjoin_synced)
	self:_add_smart_tag_presentation(tag_instance, is_hotjoin_synced)
end

HudElementSmartTagging.event_smart_tag_removed = function (self, tag_instance, reason)
	local tag_template = tag_instance:template()
	local tag_id = tag_instance:id()

	if self._active_interaction_data and self._active_interaction_data.tag_id == tag_id then
		self._active_interaction_data = nil
	end

	self:_remove_smart_tag_presentation(tag_id)

	local parent = self._parent
	local player = parent:player()
	local tagger_player = tag_instance:tagger_player()
	local is_my_tag = tagger_player and tagger_player:unique_id() == player:unique_id()

	if is_my_tag then
		local sound_exit_tagger = tag_template.sound_exit_tagger

		if sound_exit_tagger then
			self:_play_tag_sound(tag_instance, sound_exit_tagger)
		end
	else
		local sound_exit_others = tag_template.sound_exit_others

		if sound_exit_others then
			self:_play_tag_sound(tag_instance, sound_exit_others)
		end
	end
end

HudElementSmartTagging.event_smart_tag_reply_added = function (self, tag_instance, reply, replier_player)
	local parent = self._parent
	local player = parent:player()
	local is_my_reply = replier_player and replier_player:unique_id() == player:unique_id()

	if is_my_reply then
		local player_unit = parent:player_unit()

		if player_unit then
			local voice_tag_concept = reply.voice_tag_concept
			local voice_tag_id = reply.voice_tag_id

			if voice_tag_concept and voice_tag_id then
				Vo.on_demand_vo_event(player_unit, voice_tag_concept, voice_tag_id)
			end
		end
	end
end

HudElementSmartTagging._clear_all_smart_tag_presentations = function (self)
	local presented_smart_tags_by_tag_id = self._presented_smart_tags_by_tag_id

	for tag_id, presented_tag in pairs(presented_smart_tags_by_tag_id) do
		self:_remove_smart_tag_presentation(tag_id)
	end
end

HudElementSmartTagging._play_tag_sound = function (self, tag_instance, event_name)
	local target_location = tag_instance:target_location()

	if target_location then
		self:_play_3d_sound(event_name, target_location)
	else
		local target_unit = tag_instance:target_unit()

		if ALIVE[target_unit] then
			local unit_position = Unit.world_position(target_unit, 1)

			self:_play_3d_sound(event_name, unit_position)
		else
			self:_play_sound(event_name)
		end
	end
end

HudElementSmartTagging._add_smart_tag_presentation = function (self, tag_instance, is_hotjoin_synced)
	local presented_smart_tags_by_tag_id = self._presented_smart_tags_by_tag_id
	local tag_id = tag_instance:id()
	local target_location = tag_instance:target_location()
	local tag_template = tag_instance:template()
	local marker_type = tag_template.marker_type
	local parent = self._parent
	local player = parent:player()
	local tagger_player = tag_instance:tagger_player()
	local is_my_tag = tagger_player and tagger_player:unique_id() == player:unique_id()
	local data = {
		spawned = false,
		tag_template = tag_template,
		tag_instance = tag_instance,
		tag_id = tag_id,
		player = player,
		tagger_player = tagger_player,
		is_my_tag = is_my_tag
	}

	presented_smart_tags_by_tag_id[tag_id] = data

	if not is_hotjoin_synced then
		if is_my_tag then
			local sound_enter_tagger = tag_template.sound_enter_tagger

			if sound_enter_tagger then
				self:_play_tag_sound(tag_instance, sound_enter_tagger)
			end

			local voice_tag_concept = tag_template.voice_tag_concept

			if voice_tag_concept then
				local player_unit = parent:player_unit()

				if player_unit then
					local voice_tag_id = tag_template.voice_tag_id
					local target_unit

					if not voice_tag_id then
						target_unit = tag_instance:target_unit()

						if target_unit then
							local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

							if unit_data_extension then
								local breed = unit_data_extension:breed()
								local breed_name = breed.name

								voice_tag_id = breed_name
							end
						end
					end

					if voice_tag_id then
						Vo.on_demand_vo_event(player_unit, voice_tag_concept, voice_tag_id, target_unit)
					end
				end
			end
		else
			local sound_enter_others = tag_template.sound_enter_others

			if sound_enter_others then
				self:_play_tag_sound(tag_instance, sound_enter_others)
			end
		end
	end

	if marker_type then
		if target_location then
			local callback = callback(self, "_cb_presentation_tag_spawned", tag_instance)

			Managers.event:trigger("add_world_marker_position", marker_type, target_location, callback, data)
		else
			local target_unit = tag_instance:target_unit()
			local callback = callback(self, "_cb_presentation_tag_spawned", tag_instance)

			Managers.event:trigger("add_world_marker_unit", marker_type, target_unit, callback, data)
		end
	else
		data.spawned = true
	end
end

HudElementSmartTagging._cb_presentation_tag_spawned = function (self, tag_instance, marker_id)
	local tag_id = tag_instance:id()
	local presentation_data = self._presented_smart_tags_by_tag_id[tag_id]

	presentation_data.spawned = true
	presentation_data.marker_id = marker_id
	self._presented_smart_tags_by_marker_id[marker_id] = presentation_data
end

HudElementSmartTagging._remove_smart_tag_presentation = function (self, tag_id)
	local presented_smart_tags_by_tag_id = self._presented_smart_tags_by_tag_id
	local presented_smart_tags_by_marker_id = self._presented_smart_tags_by_marker_id
	local presentation_data = presented_smart_tags_by_tag_id[tag_id]

	if presentation_data then
		presented_smart_tags_by_tag_id[tag_id] = nil

		local marker_id = presentation_data.marker_id

		if marker_id then
			presented_smart_tags_by_marker_id[marker_id] = nil

			Managers.event:trigger("remove_world_marker", marker_id)
		end
	end
end

HudElementSmartTagging._draw_active_interaction_line = function (self, dt, t, input_service, ui_renderer, render_settings)
	local active_interaction_data = self._active_interaction_data
	local marker = active_interaction_data.marker
	local pivot_screen_position = self:scenegraph_world_position("line_pivot")
	local line_widget = self._interaction_line_widget
	local line_widget_offset = line_widget.offset
	local line_widget_style = line_widget.style
	local marker_widget = marker.widget
	local marker_widget_offset = marker_widget.offset
	local line_target_x = pivot_screen_position[1]
	local line_target_y = pivot_screen_position[2]

	line_widget_offset[1] = line_target_x
	line_widget_offset[2] = line_target_y

	UIWidget.draw(line_widget, ui_renderer)
end

local input_action_localization_params = {
	action = "input_display_text",
	input = "input_text"
}

local function _get_input_text(alias_name, input_text_key, hold_required)
	local service_type = "Ingame"
	local color_tint_text = true
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)
	local input_display_text = Localize(input_text_key)

	input_action_localization_params.input = input_text
	input_action_localization_params.action = input_display_text

	local input_type_string = hold_required and "loc_interaction_input_type_hold" or "loc_interaction_input_type"

	return Localize(input_type_string, true, input_action_localization_params)
end

local description_format_localization_params = {
	distance = "distance",
	description = "description"
}

HudElementSmartTagging._update_tag_interaction_information = function (self, active_interaction_data)
	local marker = active_interaction_data.marker
	local display_name = active_interaction_data.display_name
	local tag_id = active_interaction_data.tag_id
	local tag_template = active_interaction_data.tag_template
	local distance = marker and marker.distance
	local distance_text_localized

	if distance and distance > 1 then
		distance_text_localized = tostring(math.floor(distance)) .. "m"
	else
		distance_text_localized = ""
	end

	local description_text_localized = Localize(display_name)

	if not tag_id then
		local unit = active_interaction_data.unit

		if unit then
			local smart_tag_system = Managers.state.extension:system("smart_tag_system")

			tag_id = smart_tag_system:unit_tag_id(unit)
		end
	end

	local input_text_tag = ""

	if tag_id then
		local parent = self._parent
		local player = parent:player()
		local smart_tag_system = Managers.state.extension:system("smart_tag_system")
		local tagger_player = smart_tag_system:tagger_player_by_tag_id(tag_id)
		local is_my_tag = tagger_player and tagger_player:unique_id() == player:unique_id()

		if is_my_tag then
			if tag_template.is_cancelable then
				input_text_tag = _get_input_text("smart_tag", "loc_untag_smart_tag")
			end
		else
			local replies = tag_template.replies
			local default_reply = replies and replies[1]

			if default_reply then
				input_text_tag = _get_input_text("smart_tag", default_reply.description)
			end
		end
	else
		input_text_tag = _get_input_text("smart_tag", "loc_tag_smart_tag")
	end

	local line_widget = self._interaction_line_widget
	local line_widget_content = line_widget.content

	description_format_localization_params.distance = distance_text_localized
	description_format_localization_params.description = description_text_localized

	local final_description_text = Localize("loc_smart_tag_description_format_key", true, description_format_localization_params)

	line_widget_content.input_text = input_text_tag
	line_widget_content.description_text = final_description_text
end

HudElementSmartTagging._update_tag_interaction_animation = function (self, dt, t)
	local active_interaction_data = self._active_interaction_data
	local intro_anim_progress = active_interaction_data.intro_anim_progress

	if intro_anim_progress ~= 1 then
		local intro_anim_time = active_interaction_data.intro_anim_time
		local intro_anim_duration = active_interaction_data.intro_anim_duration

		intro_anim_time = intro_anim_time + dt
		intro_anim_progress = math.min(intro_anim_time / intro_anim_duration, 1)
		active_interaction_data.intro_anim_time = intro_anim_time
		active_interaction_data.intro_anim_progress = intro_anim_progress
	end

	local alpha_progress = math.easeInCubic(intro_anim_progress)
	local line_widget = self._interaction_line_widget

	line_widget.alpha_multiplier = alpha_progress
end

HudElementSmartTagging._can_tag_active_interaction = function (self)
	local parent = self._parent
	local player = parent:player()

	if not player then
		return false
	end

	local player_unit = player.player_unit

	if not ALIVE[player_unit] then
		return false
	end

	local interactor_extension = ScriptUnit.has_extension(player_unit, "interactor_system")

	if interactor_extension then
		local interactee_unit = interactor_extension:target_unit()
		local focus_unit = interactor_extension:focus_unit()

		if ALIVE[interactee_unit] and interactor_extension and interactor_extension:can_interact(interactee_unit) then
			if ScriptUnit.has_extension(interactee_unit, "smart_tag_system") then
				return true
			end
		elseif ALIVE[focus_unit] and interactor_extension:hud_block_text() then
			return false
		end
	end

	return false
end

HudElementSmartTagging._can_present_tag_interaction = function (self)
	local parent = self._parent
	local player = parent:player()

	if not player then
		return false
	end

	local player_unit = player.player_unit

	if not ALIVE[player_unit] then
		return false
	end

	local interactor_extension = ScriptUnit.has_extension(player_unit, "interactor_system")

	if interactor_extension then
		local interactee_unit = interactor_extension:target_unit()
		local focus_unit = interactor_extension:focus_unit()

		if ALIVE[interactee_unit] and interactor_extension and interactor_extension:can_interact(interactee_unit) then
			if ScriptUnit.has_extension(interactee_unit, "smart_tag_system") then
				return false
			end
		elseif ALIVE[focus_unit] and interactor_extension:hud_block_text() then
			return false
		end
	end

	return true
end

return HudElementSmartTagging
