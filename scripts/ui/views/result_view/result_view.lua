-- chunkname: @scripts/ui/views/result_view/result_view.lua

local definition_path = "scripts/ui/views/result_view/result_view_definitions"
local ResultViewSettings = require("scripts/ui/views/result_view/result_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ResultView = class("ResultView", "BaseView")

ResultView.init = function (self, settings, context)
	local definitions = require(definition_path)

	ResultView.super.init(self, definitions, settings, context)

	self._pass_draw = false
	self._entry_duration = nil
	self._delay_duration = nil
	self._background_duration = nil
	self._can_exit = context and context.can_exit
	self._end_result = context and context.end_result
end

ResultView.on_enter = function (self)
	ResultView.super.on_enter(self)

	self._entry_duration = ResultViewSettings.entry_duration
	self._background_duration = ResultViewSettings.background_duration

	local end_result = self._end_result
	local victory = end_result and end_result == "won"
	local title_text, sub_title_text = "", ""

	if victory then
		title_text = "loc_victory_title"
		sub_title_text = "loc_victory_sub_title"
	else
		title_text = "loc_defeat_title"
		sub_title_text = "loc_defeat_sub_title"
	end

	self:_set_text(title_text, "title_text", "title_background")
	self:_set_text(sub_title_text, "sub_title_text", "sub_title_background")
end

ResultView.can_exit = function (self)
	return self._can_exit
end

ResultView.on_exit = function (self)
	ResultView.super.on_exit(self)
end

ResultView._set_overlay_opacity = function (self, opacity)
	local widget = self._widgets_by_name.overlay

	widget.alpha_multiplier = opacity
end

ResultView._set_icon_backround_progress = function (self, progress)
	local widget = self._widgets_by_name.background_icon
	local icon_scenegraph = self._ui_scenegraph.background_icon
	local icon_size = icon_scenegraph.size
	local size_progress = math.easeOutCubic(progress)
	local anim_progress = math.easeOutCubic(math.easeCubic(1 - progress))
	local alpha_progress = math.clamp(math.ease_pulse(anim_progress * 0.5), 0, 1)

	widget.alpha_multiplier = alpha_progress

	local background_start_size = ResultViewSettings.background_start_size
	local background_end_size = ResultViewSettings.background_end_size
	local width = background_start_size[1] + (background_end_size[1] - background_start_size[1]) * size_progress
	local height = background_start_size[2] + (background_end_size[2] - background_start_size[2]) * size_progress

	self:_set_scenegraph_size("background_icon", width, height)
end

ResultView.update = function (self, dt, t)
	local background_duration = self._background_duration

	if background_duration then
		background_duration = math.max(background_duration - dt, 0)

		self:_set_icon_backround_progress(1 - background_duration / ResultViewSettings.background_duration)

		if background_duration <= 0 then
			self._background_duration = nil
		else
			self._background_duration = background_duration
		end
	end

	local entry_duration = self._entry_duration

	if entry_duration then
		entry_duration = math.max(entry_duration - dt, 0)

		self:_set_overlay_opacity(math.easeOutCubic(entry_duration / ResultViewSettings.entry_duration))

		if entry_duration <= 0 then
			self._entry_duration = nil
			self._delay_duration = t + ResultViewSettings.duration
		else
			self._entry_duration = entry_duration
		end
	end

	if self._delay_duration then
		if t >= self._delay_duration then
			self._exit_duration = ResultViewSettings.exit_duration
			self._delay_duration = nil
		else
			local delay_duration = self._delay_duration - t

			self._duration_progress = 1 - math.max(delay_duration / ResultViewSettings.duration, 0)
		end
	end

	local exit_duration = self._exit_duration

	if exit_duration then
		exit_duration = math.max(exit_duration - dt, 0)

		local progress = 1 - math.easeInCubic(exit_duration / ResultViewSettings.exit_duration)

		self:_set_overlay_opacity(progress)

		if exit_duration <= 0 then
			self:_continue()
		else
			self._exit_duration = exit_duration
		end
	end

	return ResultView.super.update(self, dt, t)
end

ResultView._continue = function (self)
	local event_name = "event_state_victory_defeat_continue"

	Managers.event:trigger(event_name)
end

ResultView._set_timer_text = function (self, time)
	local floor = math.floor
	local timer_text = string.format("%.2d:%.2d", floor(time / 60) % 60, floor(time) % 60)
	local widget = self._widgets_by_name.timer_text

	widget.content.text = tostring(timer_text)
end

ResultView._set_text = function (self, text, text_id, background_id)
	local widget = self._widgets_by_name[text_id]

	widget.content.text = self:_localize(text)

	if background_id then
		local text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local text_length, text_height = UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, nil, text_options)
		local background_scenegraph = self._ui_scenegraph[background_id]
		local text_background_edge_width = ResultViewSettings.text_background_edge_width
	end
end

return ResultView
