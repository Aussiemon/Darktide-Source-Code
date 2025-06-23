-- chunkname: @scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading.lua

local Definitions = require("scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading_definitions")
local HudElementCutsceneFading = class("HudElementCutsceneFading", "HudElementBase")

HudElementCutsceneFading.init = function (self, parent, draw_layer, start_scale)
	HudElementCutsceneFading.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._player = parent:player()
	self._fade_color = {
		z = 0,
		x = 0,
		y = 0
	}

	self:_register_event("event_cutscene_fade_in")
	self:_register_event("event_cutscene_fade_out")
	self:_register_event("event_cutscene_fade_out_at")
end

HudElementCutsceneFading.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementCutsceneFading.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local widgets_by_name = self._widgets_by_name
	local fade_widget = widgets_by_name.fade
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

	local fade_color = self._fade_color

	fade_widget.style.rect.color[1] = 255 * anim_progress
	fade_widget.style.rect.color[2] = fade_color.x
	fade_widget.style.rect.color[3] = fade_color.y
	fade_widget.style.rect.color[4] = fade_color.z

	local fade_out = self._fade_out_data

	if fade_out and t >= fade_out.fade_out_at then
		self:event_cutscene_fade_out(fade_out.player, fade_out.duration, fade_out.easing_function, fade_out.fade_color)

		self._fade_out_data = nil
	end
end

local function _is_valid_color_channel_value(value)
	return type(value) == "number" and value >= 0 and value <= 255
end

local function _check_for_valid_color(color)
	if color == nil or type(color) ~= "table" and type(color) ~= "userdata" then
		return {
			z = 0,
			x = 0,
			y = 0
		}
	end

	local is_valid_vector_color = _is_valid_color_channel_value(color.x) and _is_valid_color_channel_value(color.y) and _is_valid_color_channel_value(color.z)

	if is_valid_vector_color then
		return {
			x = color.x,
			y = color.y,
			z = color.z
		}
	end

	local is_valid_color = _is_valid_color_channel_value(color[2]) and _is_valid_color_channel_value(color[3]) and _is_valid_color_channel_value(color[4])

	if is_valid_color then
		return {
			x = color[2],
			y = color[3],
			z = color[4]
		}
	end

	return {
		z = 0,
		x = 0,
		y = 0
	}
end

HudElementCutsceneFading.event_cutscene_fade_in = function (self, player, duration, easing_function, fade_color)
	if not self._player or self._player ~= player then
		return
	end

	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = true

	local color = _check_for_valid_color(fade_color)

	self._fade_color = color
end

HudElementCutsceneFading.event_cutscene_fade_out = function (self, player, duration, easing_function, fade_color)
	if not self._player or self._player ~= player then
		return
	end

	self._fade_duration = duration
	self._fade_time = duration
	self._fade_easing_function = easing_function
	self._fading_in = false

	local color = _check_for_valid_color(fade_color)

	self._fade_color = color
	self._fade_out_data = nil
end

HudElementCutsceneFading.event_cutscene_fade_out_at = function (self, player, duration, easing_function, fade_out_at, fade_color)
	self._fade_out_data = {
		player = player,
		duration = duration,
		easing_function = easing_function,
		fade_out_at = fade_out_at,
		fade_color = _check_for_valid_color(fade_color)
	}
end

return HudElementCutsceneFading
