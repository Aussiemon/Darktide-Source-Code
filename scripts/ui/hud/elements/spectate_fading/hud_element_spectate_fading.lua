-- chunkname: @scripts/ui/hud/elements/spectate_fading/hud_element_spectate_fading.lua

local Definitions = require("scripts/ui/hud/elements/spectate_fading/hud_element_spectate_fading_definitions")
local HudElementSpectateFadingSettings = require("scripts/ui/hud/elements/spectate_fading/hud_element_spectate_fading_settings")
local ViewTransitionUI = require("scripts/ui/view_transition_ui")
local HudElementSpectateFading = class("HudElementSpectateFading", "HudElementBase")

HudElementSpectateFading.init = function (self, parent, draw_layer, start_scale)
	HudElementSpectateFading.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._player = parent:player()

	local fade_render_settings = HudElementSpectateFadingSettings.render_settings

	self._view_transition_ui = ViewTransitionUI:new(fade_render_settings)

	self:_register_event("event_spectate_fade_in")
	self:_register_event("event_spectate_fade_out")
	self:_register_event("event_spectate_fade_out_at")
	self:event_spectate_fade_out(0.1, math.easeCubic)
end

HudElementSpectateFading.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementSpectateFading.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local fade_progress

	if self._fade_duration then
		if self._fading_in then
			fade_progress = 1 - math.clamp(self._fade_duration / self._fade_time, 0, 1)
		else
			fade_progress = math.clamp(self._fade_duration / self._fade_time, 0, 1)
		end

		self._fade_duration = self._fade_duration - dt

		if self._fade_duration < 0 then
			self._fade_duration = nil
			self._fade_time = nil
		end
	elseif self._fading_in then
		fade_progress = 1
	end

	local anim_progress = fade_progress or 0

	if self._fade_easing_function then
		anim_progress = self._fade_easing_function(anim_progress)
	end

	self._view_transition_ui:update(dt, t, fade_progress ~= nil, anim_progress)

	local fade_out = self._fade_out_data

	if fade_out and t < fade_out.fade_out_at then
		self:event_spectate_fade_out(fade_out.player, fade_out.duration, fade_out.easing_function)

		self._fade_out_data = nil
	end
end

HudElementSpectateFading.event_spectate_fade_in = function (self, duration, easing_function)
	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = true
end

HudElementSpectateFading.event_spectate_fade_out = function (self, duration, easing_function)
	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = false
	self._fade_out_data = nil
end

HudElementSpectateFading.event_spectate_fade_out_at = function (self, player, duration, easing_function, fade_out_at)
	self._fade_out_data = {
		player = player,
		duration = duration,
		easing_function = easing_function,
		fade_out_at = fade_out_at
	}
end

HudElementSpectateFading.destroy = function (self, ui_renderer)
	self._view_transition_ui:destroy()

	self._view_transition_ui = nil

	HudElementSpectateFading.super.destroy(self, ui_renderer)
end

HudElementSpectateFading.draw = nil

return HudElementSpectateFading
