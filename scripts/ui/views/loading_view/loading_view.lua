-- chunkname: @scripts/ui/views/loading_view/loading_view.lua

local definition_path = "scripts/ui/views/loading_view/loading_view_definitions"
local InputUtils = require("scripts/managers/input/input_utils")
local LoadingViewSettings = require("scripts/ui/views/loading_view/loading_view_settings")
local TaskbarFlash = require("scripts/utilities/taskbar_flash")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local LoadingView = class("LoadingView", "BaseView")
local Views = require("scripts/ui/views/views")
local UIWidget = require("scripts/managers/ui/ui_widget")

LoadingView.select_background = function (self)
	local backgrounds = Views.loading_view.backgrounds
	local background = backgrounds[1]
	local background_package = Views.loading_view.dynamic_package_folder .. background

	return background, background_package
end

LoadingView.init = function (self, settings, context)
	self._entry_duration = nil
	self._text_cycle_duration = nil
	self._update_hint_text = nil

	local background, background_package = self:select_background()
	local definitions = require(definition_path)

	definitions.widget_definitions.background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/" .. background,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}
		}
	}, "loading_image")

	LoadingView.super.init(self, definitions, settings, context, background_package)

	self._can_exit = context and context.can_exit
	self._pass_draw = false
	self._no_cursor = true
end

LoadingView.on_enter = function (self)
	LoadingView.super.on_enter(self)
	Managers.event:trigger("event_start_waiting")

	self._entry_duration = LoadingViewSettings.entry_duration

	self:_cycle_next_hint()
	self:_update_input_display()
	self:_register_event("event_on_active_input_changed", "event_on_input_changed")
end

LoadingView.draw = function (self, dt, t, input_service, layer)
	LoadingView.super.draw(self, dt, t, input_service, layer)
	Managers.ui:render_loading_info()
end

LoadingView.can_exit = function (self)
	return self._can_exit
end

LoadingView.on_exit = function (self)
	LoadingView.super.on_exit(self)
	Managers.event:trigger("event_stop_waiting")
	TaskbarFlash.flash_window()
end

LoadingView.event_on_input_changed = function (self)
	self:_update_input_display()
end

LoadingView._update_input_display = function (self)
	local text = "loc_next"
	local widgets_by_name = self._widgets_by_name
	local text_widget = widgets_by_name.hint_input_description
	local localized_text = self:_localize(text)
	local service_type = "View"
	local alias_name = "next_hint"
	local color_tint_text = true
	local input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)

	text_widget.content.text = input_key .. " " .. localized_text
end

LoadingView._widget_text_length = function (self, widget_id)
	local widget = self._widgets_by_name[widget_id]
	local scenegraph_id = widget.scenegraph_id
	local widget_width, widget_height = self:_scenegraph_size(scenegraph_id)
	local text = widget.content.text
	local text_style = widget.style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_length, _ = UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, {
		widget_width,
		widget_height
	}, text_options)

	return text_length
end

LoadingView._handle_input = function (self, input_service)
	if input_service:get("next_hint") then
		self:_cycle_next_hint()
	end
end

LoadingView._cycle_next_hint = function (self)
	if self._text_cycle_duration then
		return
	end

	self._text_cycle_duration = LoadingViewSettings.hint_text_update_duration
	self._update_hint_text = true
end

LoadingView._set_hint_text_opacity = function (self, opacity)
	local widget = self._widgets_by_name.hint_text

	widget.alpha_multiplier = opacity
end

LoadingView._update_next_hint = function (self)
	local loading_hints = LoadingViewSettings.loading_hints
	local num_hints = #loading_hints

	self._hint_index = self._hint_index and self._hint_index % num_hints + 1 or math.random(1, num_hints)

	local next_hint = loading_hints[self._hint_index]

	self:_set_hint_text(next_hint)

	self._update_hint_text = nil
end

LoadingView._set_hint_text = function (self, text)
	local widget = self._widgets_by_name.hint_text

	widget.content.text = self:_localize(text)
end

LoadingView._set_overlay_opacity = function (self, opacity)
	local widget = self._widgets_by_name.overlay

	widget.alpha_multiplier = opacity
end

LoadingView.update = function (self, dt, t, input_service)
	local entry_duration = self._entry_duration

	if entry_duration then
		entry_duration = math.max(entry_duration - dt, 0)

		self:_set_overlay_opacity(math.easeOutCubic(entry_duration / LoadingViewSettings.entry_duration))

		if entry_duration <= 0 then
			self._entry_duration = nil
		else
			self._entry_duration = entry_duration
		end
	end

	if self._text_cycle_duration and self._text_cycle_duration then
		local text_cycle_duration = self._text_cycle_duration - dt
		local progress = 1 - math.max(text_cycle_duration / LoadingViewSettings.hint_text_update_duration, 0)
		local cycle_progress = (progress * 2 - 1)^2

		if self._update_hint_text and progress > 0.48 then
			self:_update_next_hint()
		end

		self._text_cycle_duration = progress ~= 1 and text_cycle_duration or nil

		self:_set_hint_text_opacity(cycle_progress)
	end

	return LoadingView.super.update(self, dt, t, input_service)
end

return LoadingView
