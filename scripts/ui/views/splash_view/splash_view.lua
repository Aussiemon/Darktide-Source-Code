local Definitions = require("scripts/ui/views/splash_view/splash_view_definitions")
local SplashViewSettings = require("scripts/ui/views/splash_view/splash_view_settings")
local SplashPageDefinitions = require("scripts/ui/views/splash_view/splash_view_page_definitions")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local device_list = {
	Keyboard,
	Mouse,
	Pad1
}
local SplashView = class("SplashView", "BaseView")

SplashView.init = function (self, settings, context)
	SplashView.super.init(self, Definitions, settings, context)

	self._current_time = 0
	self._time_between_pages = SplashPageDefinitions.time_between_pages
	self._show_skip = false
	self._skip_pressed = false
	self._legend_active = 0
	self._hold_timer = 0
	self._total_duration = SplashPageDefinitions.duration
	self._page_definitions = table.clone(SplashPageDefinitions.pages)
	self._pass_draw = false
	self._pass_input = false
	self._done = false
end

SplashView.on_enter = function (self)
	SplashView.super.on_enter(self)
end

SplashView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 100)
	local legend_inputs = SplashPageDefinitions.legend_inputs
	local input_legends_by_key = {}

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)
		local id = self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
		local key = legend_input.key

		if key then
			input_legends_by_key[key] = {
				id = id,
				settings = legend_input
			}
		end
	end

	self._input_legends_by_key = input_legends_by_key

	if self._hold_to_skip then
		local id = self._input_legends_by_key.hold_skip.id
		local entry = self._input_legend_element:_get_entry_by_id(id)
		local entry_widget = entry.widget
		local widget_definition = UIWidget.create_definition({
			{
				style_id = "background",
				pass_type = "rect",
				style = {
					color = Color.ui_grey_medium(255, true)
				}
			},
			{
				style_id = "fill",
				pass_type = "rect",
				style = {
					color = Color.ui_terminal(255, true),
					size = {
						0
					}
				}
			}
		}, entry_widget.scenegraph_id)
		self._skip_bar_widget = self:_create_widget("skip", widget_definition)
	end
end

SplashView.is_done = function (self)
	return self._done and not Managers.ui:is_view_closing("splash_video_view")
end

local function _handle_alignment(position, data, width, height, parent_size_x, parent_size_y)
	local horizontal_alignment = data.horizontal_alignment

	if horizontal_alignment then
		if horizontal_alignment == "center" then
			position[1] = position[1] + parent_size_x / 2 - width / 2
		elseif horizontal_alignment == "right" then
			position[1] = position[1] + parent_size_x - width
		end
	end

	local vertical_alignment = data.vertical_alignment

	if vertical_alignment then
		if vertical_alignment == "center" then
			position[2] = position[2] + parent_size_y / 2 - height / 2
		elseif vertical_alignment == "bottom" then
			position[2] = position[2] + parent_size_y - height
		end
	end
end

local temp_color = {
	255,
	255,
	255,
	255
}

local function _get_entry_color(entry, alpha_multiplier)
	local color = entry.color or entry.style and (entry.style.color or entry.style.text_color)

	if color then
		temp_color[1] = color[1] * alpha_multiplier
		temp_color[2] = color[2]
		temp_color[3] = color[3]
		temp_color[4] = color[4]
	else
		temp_color[1] = 255 * alpha_multiplier
		temp_color[2] = 255
		temp_color[3] = 255
		temp_color[4] = 255
	end

	return temp_color
end

SplashView.draw = function (self, dt, t, input_service, layer)
	SplashView.super.draw(self, dt, t, input_service, layer)

	if self._input_legend_element then
		local render_scale = self._render_scale
		local render_settings = self._render_settings
		local id = self._input_legends_by_key.hold_skip.id
		local entry = self._input_legend_element:_get_entry_by_id(id)
		local entry_widget = entry.widget
		local ui_renderer = self._ui_renderer
		local ui_scenegraph = self._input_legend_element._ui_scenegraph
		local bar_margin = 10
		local position = self._input_legend_element:scenegraph_position(entry_widget.scenegraph_id)
		local width = 100
		local z_offset = render_settings.draw_layer or 0
		z_offset = z_offset + self._input_legend_element._draw_layer + 1
		self._skip_bar_widget.offset = {
			position[1] + entry_widget.offset[1] + (entry_widget.content.size[1] - width) * 0.5,
			position[2] + entry_widget.offset[2] + entry_widget.content.size[2] - bar_margin,
			z_offset
		}
		self._skip_bar_widget.content.size = {
			width,
			5
		}
		local progress = UISettings.cutscenes_skip.hold_time and math.min(self._hold_timer / UISettings.cutscenes_skip.hold_time, 1) or 1
		self._skip_bar_widget.style.fill.size[1] = width * progress

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		if self._skip_bar_widget then
			UIWidget.draw(self._skip_bar_widget, ui_renderer)
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

local temp_position = {
	0,
	0,
	0
}

SplashView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	SplashView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local screen_width = RESOLUTION_LOOKUP.width
	local screen_height = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	local current_time = self._current_time

	if current_time then
		if Managers.ui:is_view_closing("splash_video_view") then
			return
		end

		local time_between_pages = self._time_between_pages
		local page_definitions = self._page_definitions
		local total_page_duration = 0

		for i = 1, #page_definitions do
			local page = page_definitions[i]
			local page_duration = page.duration
			local alpha_multiplier = 1
			local local_time = current_time - total_page_duration
			local draw = page_duration >= local_time

			if draw then
				if not page.initialized then
					page.initialized = true

					if page.visibility_function and page.visibility_function() ~= true then
						self:_on_skip_pressed()

						return
					end

					self._two_step_skip = page.two_step_skip or false
					self._hold_to_skip = page.hold_to_skip or false
					self._show_skip = false
					self._legend_active = 0
					self._hold_timer = 0
				end

				if local_time < time_between_pages then
					local pause_progress = math.clamp(local_time / time_between_pages, 0, 1)
					alpha_multiplier = math.easeInCubic(pause_progress)
				elseif local_time > local_time - time_between_pages then
					local pause_progress = math.clamp((page_duration - local_time) / time_between_pages, 0, 1)
					alpha_multiplier = math.easeOutCubic(pause_progress)
				end

				for j = 1, #page do
					local entry = page[j]
					local entry_type = entry.type
					local position = entry.position
					local size = entry.size
					local value = entry.value

					if not entry.initialized then
						entry.initialized = true
					end

					if entry_type ~= "video" then
						if position then
							temp_position[1] = position[1]
							temp_position[2] = position[2]
							temp_position[3] = position[3]
						end

						_handle_alignment(temp_position, entry, size[1], size[2], screen_width * inverse_scale, screen_height * inverse_scale)
					end

					local color = _get_entry_color(entry, alpha_multiplier)

					if entry_type == "text" then
						local style = entry.style
						local text_options = UIFonts.get_font_options_by_style(style)
						local text = self:_localize(value)
						local font_size = UIFonts.scaled_size(style.font_size, scale)

						UIRenderer.draw_text(ui_renderer, text, font_size, style.font_type, temp_position, size, color, text_options)
					elseif entry_type == "rect" then
						UIRenderer.draw_rect(ui_renderer, Vector3(temp_position[1], temp_position[2], temp_position[3]), Vector2(size[1], size[2]), color)
					elseif entry_type == "texture" then
						UIRenderer.draw_texture(ui_renderer, value, temp_position, size, color)
					elseif entry_type == "video" and not self._splash_video_view_opened and not Managers.ui:is_view_closing("splash_video_view") then
						local context = {
							pass_draw = true,
							pass_input = true,
							debug_preview = true,
							can_exit = false,
							video_name = entry.video_name,
							sound_name = entry.sound_name,
							exit_sound_name = entry.exit_sound_name,
							size = entry.size,
							position = entry.position
						}
						local view_name = "splash_video_view"

						Managers.ui:open_view(view_name, nil, nil, nil, nil, context)

						self._splash_video_view_opened = true
					end
				end

				break
			else
				total_page_duration = total_page_duration + page_duration

				for k = 1, i do
					local page = page_definitions[k]

					for j = 1, #page do
						local entry = page[j]
						local entry_type = entry.type

						if entry.initialized then
							entry.initialized = nil

							if entry_type == "video" and self._splash_video_view_opened then
								local view_name = "splash_video_view"

								Managers.ui:close_view(view_name)

								self._splash_video_view_opened = nil
							end
						end

						if page.initialized then
							self._two_step_skip = false
							self._show_skip = false
							self._hold_to_skip = false
							self._legend_active = 0
							self._hold_timer = 0
							page.initialized = nil
						end
					end
				end
			end
		end
	end
end

SplashView._on_skip_pressed = function (self)
	local current_time = self._current_time

	if current_time then
		local page_definitions = self._page_definitions
		local total_page_duration = 0

		for i = 1, #page_definitions do
			local page = page_definitions[i]
			local page_duration = page.duration
			total_page_duration = total_page_duration + page_duration

			if current_time < total_page_duration then
				self._current_time = total_page_duration

				break
			end
		end
	end
end

SplashView.on_hold_skip_pressed = function (self)
	self._skip_pressed = true
end

SplashView.on_skip_pressed = function (self)
	self:_on_skip_pressed()
end

SplashView.update = function (self, dt, t, input_service)
	if self._show_skip and not self._input_legend_element then
		self:_setup_input_legend()
	elseif not self._show_skip and self._input_legend_element then
		self:_remove_input_legend()
	end

	if self._input_legend_element then
		if input_service:get("skip_cinematic_hold") or input_service:get("left_hold") and self._skip_pressed == true and self._hold_to_skip == true then
			self._hold_timer = self._hold_timer + dt
			self._legend_active = 0
		elseif self._skip_pressed == true and self._hold_to_skip == true then
			self._skip_pressed = false
			self._legend_active = 0
			self._hold_timer = 0
		elseif self._show_skip and self._hold_to_skip == true then
			self._legend_active = self._legend_active + dt
		end
	end

	if UISettings.cutscenes_skip.hold_time < self._hold_timer then
		self._legend_active = 0
		self._hold_timer = 0
		self._show_skip = false

		self:_on_skip_pressed()
	elseif UISettings.cutscenes_skip.fade_inactivity_time < self._legend_active then
		self._show_skip = false
		self._legend_active = 0
		self._hold_timer = 0
	end

	if IS_XBS then
		local input_device_list = InputUtils.input_device_list
		local xbox_controllers = input_device_list.xbox_controller

		for i = 1, #xbox_controllers do
			local xbox_controller = xbox_controllers[i]

			if self._two_step_skip then
				if xbox_controller.active() and xbox_controller.any_pressed() and not self._show_skip then
					self._show_skip = true
				end
			elseif xbox_controller.active() and xbox_controller.any_pressed() then
				self:_on_skip_pressed()
			end
		end
	else
		for i = 1, #device_list do
			local device = device_list[i]

			if self._two_step_skip then
				if device and device.active and device.any_pressed() and not self._show_skip then
					self._show_skip = true
				end
			elseif device and device.active and device.any_pressed() then
				self:_on_skip_pressed()
			end
		end
	end

	if not self._done then
		self._current_time = self._current_time + dt

		if self._total_duration <= self._current_time then
			self._done = true
		end
	end

	SplashView.super.update(self, dt, t, input_service)
end

SplashView.on_exit = function (self)
	if self._splash_video_view_opened then
		local view_name = "splash_video_view"

		Managers.ui:close_view(view_name)

		self._splash_video_view_opened = false
	end

	self:_remove_input_legend()
	SplashView.super.on_exit(self)
end

SplashView._remove_input_legend = function (self)
	if self._input_legend_element then
		self:_remove_element("input_legend")

		self._input_legend_element = nil
	end

	if self._skip_bar_widget then
		self:_unregister_widget_name(self._skip_bar_widget.name)

		self._skip_bar_widget = nil
	end
end

return SplashView
