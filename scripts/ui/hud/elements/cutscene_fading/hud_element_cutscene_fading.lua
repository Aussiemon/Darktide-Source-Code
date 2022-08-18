local Definitions = require("scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading_definitions")
local HudElementCutsceneFadingSettings = require("scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading_settings")
local ViewTransitionUI = require("scripts/ui/view_transition_ui")
local HudElementCutsceneFading = class("HudElementCutsceneFading", "HudElementBase")

HudElementCutsceneFading.init = function (self, parent, draw_layer, start_scale)
	HudElementCutsceneFading.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._player = parent:player()
	local fade_render_settings = HudElementCutsceneFadingSettings.render_settings
	self._fade_ui = ViewTransitionUI:new(fade_render_settings)

	self:_register_event("event_cutscene_fade_in")
	self:_register_event("event_cutscene_fade_out")
end

HudElementCutsceneFading.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementCutsceneFading.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local fade_progress = 0

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

	local anim_progress = fade_progress

	if self._fade_easing_function then
		anim_progress = self._fade_easing_function(fade_progress)
	end

	self._fade_ui:update(dt, t, fade_progress ~= nil, anim_progress)
end

HudElementCutsceneFading.event_cutscene_fade_in = function (self, player, duration, easing_function)
	if not self._player or self._player ~= player then
		return
	end

	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = true
end

HudElementCutsceneFading.event_cutscene_fade_out = function (self, player, duration, easing_function)
	if not self._player or self._player ~= player then
		return
	end

	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = false
end

HudElementCutsceneFading.destroy = function (self, ui_renderer)
	self._fade_ui:destroy()

	self._fade_ui = nil

	HudElementCutsceneFading.super.destroy(self, ui_renderer)
end

HudElementCutsceneFading.draw = nil

return HudElementCutsceneFading
