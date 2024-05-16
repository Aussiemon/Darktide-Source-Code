-- chunkname: @scripts/ui/views/credits_view/credits_view.lua

local Definitions = require("scripts/ui/views/credits_view/credits_view_definitions")
local Credits = require("scripts/ui/views/credits_view/credits")
local CreditsViewSettings = require("scripts/ui/views/credits_view/credits_view_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local CreditsView = class("CreditsView", "BaseView")
local credits_settigns = Credits.settings
local view_settings = CreditsViewSettings

CreditsView.init = function (self, settings, context)
	CreditsView.super.init(self, Definitions, settings, context)

	self._pass_draw = false
	self._should_stop = false
	self._carousel_start_index = 1
	self._carousel_start_time = nil
end

CreditsView.on_enter = function (self)
	CreditsView.super.on_enter(self)

	self._current_offset = 0
	self._speed_multiplier = credits_settigns.speed
	self._num_credits = #credits_settigns.entries

	self:_setup_input_legend()
	self:_create_widget("credits_text", Definitions.text_widgets_definitions.credits_text)
	self:_create_widget("credits_image", Definitions.text_widgets_definitions.credits_image)
end

CreditsView.cb_on_close_pressed = function (self)
	Managers.ui:close_view(self.view_name)
end

CreditsView.update = function (self, dt, t, input_service)
	if not input_service:get("next_hold") and not input_service:get("credits_pause") and not input_service:get("left_hold") and self._triggered_action then
		self._speed_multiplier = credits_settigns.speed
		self._should_stop = false
		self._triggered_action = false
	end

	CreditsView.super.update(self, dt, t, input_service)
end

CreditsView.cb_credits_speed = function (self)
	self._speed_multiplier = credits_settigns.ffw_speed
	self._triggered_action = true
end

CreditsView.cb_credits_pause = function (self)
	self._should_stop = true
	self._triggered_action = true
end

CreditsView.draw = function (self, dt, t, input_service, layer)
	CreditsView.super.draw(self, dt, t, input_service, layer)
	self:_handle_credits(dt, t, input_service, layer)
end

CreditsView._handle_credits = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local current_offset = self._should_stop and self._current_offset or math.min(0, self._current_offset - self._speed_multiplier * dt)

	self._current_offset = current_offset

	local ui_scenegraph = self._ui_scenegraph
	local h = RESOLUTION_LOOKUP.height

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local credit_entries = credits_settigns.entries
	local style_settings = view_settings.style_settings
	local widget, content, style

	for i = 1, self._num_credits do
		local entry = credit_entries[i]

		if entry.type == "image" then
			widget = self._widgets_by_name.credits_image
			content = widget.content
			style = widget.style
			content.credits_image = entry.texture
			style.credits_image.size = entry.size
			current_offset = current_offset + entry.size[1] + 5
		else
			widget = self._widgets_by_name.credits_text
			content = widget.content
			style = widget.style
			content.credits_text = entry.localized_str or entry.localized and Localize(entry.text) or entry.text
			entry.localized_str = content.text_field

			if entry.type == "header" then
				style.credits_text.text_color = style_settings.header.color
				style.credits_text.font_type = style_settings.header.font_type
				style.credits_text.font_size = style_settings.header.font_size
				style.credits_text.material = style_settings.header.material
				current_offset = current_offset + 84 + 5
			elseif entry.type == "title" then
				style.credits_text.text_color = style_settings.title.color
				style.credits_text.font_type = style_settings.normal.font_type
				style.credits_text.font_size = style_settings.title.font_size
				style.credits_text.material = nil
				current_offset = current_offset + 64 + 5
			else
				style.credits_text.text_color = style_settings.normal.color
				style.credits_text.font_type = style_settings.normal.font_type
				style.credits_text.font_size = style_settings.normal.font_size
				style.credits_text.material = nil
				current_offset = current_offset + 30 + 5
			end
		end

		if current_offset > 600 then
			break
		elseif current_offset > -h then
			widget.offset[2] = current_offset

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if current_offset < -1200 then
		self._current_offset = 0
	end

	UIRenderer.end_pass(ui_renderer)
	self:_handle_carousel(dt, t)
end

CreditsView._handle_carousel = function (self, dt, t)
	if not self._carousel_start_time then
		self._carousel_start_time = t
	end

	if t > self._carousel_start_time + credits_settigns.carousel_interval then
		local bg_widget = self._widgets_by_name.background
		local img_index = self._carousel_start_index + 1 <= #view_settings.carousel and self._carousel_start_index + 1 or 1

		self:_start_animation("backgorund_transition", bg_widget, {
			new_image = view_settings.carousel[img_index],
		})

		self._carousel_start_index = img_index
		self._carousel_start_time = t
	end
end

CreditsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 60)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
	end
end

return CreditsView
