local Definitions = require("scripts/ui/hud/elements/onboarding_popup/hud_element_onboarding_popup_definitions")
local HudElementOnboardingPopupSettings = require("scripts/ui/hud/elements/onboarding_popup/hud_element_onboarding_popup_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local InputUtils = require("scripts/managers/input/input_utils")
local HudElementOnboardingPopup = class("HudElementOnboardingPopup", "HudElementBase")

HudElementOnboardingPopup.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementOnboardingPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false
	self._player = parent:player()
	self._popup_queue = {}
	self._ingame_input_service = Managers.input:get_input_service("Ingame")
	self._ui_renderer = parent._ui_renderer

	self:_register_events()
end

HudElementOnboardingPopup.destroy = function (self, ui_renderer)
	self:_unregister_events()
	HudElementOnboardingPopup.super.destroy(self, ui_renderer)
end

HudElementOnboardingPopup.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementOnboardingPopup.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local time_left = self._time_left

	if time_left then
		if time_left <= 0 then
			self:event_player_hide_onboarding_message(self._player)
		else
			time_left = time_left - dt
			self._time_left = time_left
			local duration = self._duration
			local progress = math.clamp(time_left / duration, 0, 1)
			local widgets_by_name = self._widgets_by_name
			local widget = widgets_by_name.popup
			local content = widget.content
			content.progress = progress
		end
	end

	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil

		if #self._popup_queue > 0 then
			if self._active then
				self:_hide_message()
			else
				local area_data = table.remove(self._popup_queue, #self._popup_queue)
				local text = area_data.text
				local duration = area_data.duration
				local on_close_callback = area_data.on_close_callback

				self:_present_new_message(text, duration, on_close_callback)
			end
		end
	end
end

HudElementOnboardingPopup.event_player_display_onboarding_message = function (self, player, text, optional_duration, on_close_callback)
	if not self._player or self._player ~= player then
		return
	end

	if self._popup_animation_id or self._active then
		if self._popup_animation_id == nil then
			self:_hide_message()
		end

		table.insert(self._popup_queue, 1, {
			text = text,
			duration = optional_duration,
			on_close_callback = on_close_callback
		})
	else
		self:_present_new_message(text, optional_duration, on_close_callback)
	end
end

HudElementOnboardingPopup.event_player_hide_onboarding_message = function (self, player)
	if not self._player or self._player ~= player then
		return
	end

	if self._active and self._popup_animation_id == nil then
		self:_hide_message()
	end
end

HudElementOnboardingPopup._present_new_message = function (self, text, duration, on_close_callback)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.popup
	local content = widget.content
	content.text = text
	content.duration = duration
	content.progress = duration and 0 or nil

	self:_play_sound(UISoundEvents.onboarding_popup_message_enter)
	self:_set_widget_size_from_content(text)

	self._active = true
	self._time_left = duration
	self._duration = duration
	self._on_close_callback = on_close_callback
end

HudElementOnboardingPopup._hide_message = function (self)
	if self._on_close_callback then
		self._on_close_callback()
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.popup

	self:_play_sound(UISoundEvents.onboarding_popup_message_exit)

	self._popup_animation_id = self:_start_animation("popup_exit", widget)
	self._active = false
	self._time_left = nil
	self._duration = nil
	self._on_close_callback = nil
end

HudElementOnboardingPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._popup_animation_id and not self._active then
		return
	end

	HudElementOnboardingPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementOnboardingPopup._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementOnboardingPopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementOnboardingPopup._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementOnboardingPopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

HudElementOnboardingPopup._set_widget_size_from_content = function (self, title)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.popup
	local scenegraph_id = widget.scenegraph_id
	local default_scenegraph = Definitions.scenegraph_definition[scenegraph_id]
	local size = default_scenegraph.size
	local total_height = 0
	local style = widget.style
	local text_style = style.text
	local _, text_height, _, _ = UIRenderer.text_size(self._ui_renderer, title, text_style.font_type, text_style.font_size, size)
	total_height = text_height + text_height + 40

	if size[2] < total_height then
		widget.style.background.size[2] = total_height
		widget.content.resize_size = {
			size[1],
			math.floor(total_height)
		}

		self:_set_scenegraph_size(scenegraph_id, nil, total_height)
	end

	self._popup_animation_id = self:_start_animation("popup_enter", widget)
end

return HudElementOnboardingPopup
