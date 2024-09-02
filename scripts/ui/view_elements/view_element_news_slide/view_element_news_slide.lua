-- chunkname: @scripts/ui/view_elements/view_element_news_slide/view_element_news_slide.lua

local Definitions = require("scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_definitions")
local Settings = require("scripts/ui/view_elements/view_element_news_slide/view_element_news_slide_settings")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementNewsSlide = class("ViewElementNewsSlide", "ViewElementBase")

ViewElementNewsSlide.init = function (self, parent, draw_layer, start_scale)
	ViewElementNewsSlide.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._slide_data = nil
	self._textures = {}
	self._old_index = nil
	self._current_index = nil
	self._slide_time = 0
	self._progress_widgets = nil

	local news_button = self._widgets_by_name.news_button

	news_button.visible = false
	news_button.content.hotspot.pressed_callback = callback(self, "view_requested")
	self._backend_promise = Managers.data_service.news:get_events():next(function (backend_data)
		self._backend_promise = nil

		self:_initialize_slides(backend_data)
	end):catch(function (error)
		self._backend_promise = nil

		Log.warning("ViewElementNewsSlide", "Failed to load news with error: %s", table.tostring(error, 5))
	end)
end

ViewElementNewsSlide.destroy = function (self)
	if self._backend_promise then
		self._backend_promise:cancel()
	end

	self:_delete_progress_bar()

	for url, _ in pairs(self._textures) do
		Managers.url_loader:unload_texture(url)
	end

	ViewElementNewsSlide.super.destroy(self)
end

local function _compare_slides(a, b)
	local a_index = a.sort_index or 0
	local a_index, b_index = a_index, b.sort_index or 0

	return b_index < a_index
end

ViewElementNewsSlide._initialize_slides = function (self, backend_data)
	if #backend_data == 0 then
		return
	end

	local slides = {}

	for i = 1, #backend_data do
		local raw_data = backend_data[i]
		local contents = raw_data.contents
		local content_count = contents and #contents or 0
		local title, image_url, body_text, body_number

		for j = 1, content_count do
			local content = contents[j]
			local type = content.type
			local presentation = content.presentation
			local is_preview = presentation and table.array_contains(presentation, "preview")

			if not is_preview then
				-- Nothing
			elseif type == "title" then
				title = content.data
			elseif type == "image" then
				image_url = content.data
				self._textures[image_url] = false
			elseif type == "body" then
				body_text = content.data
			elseif type == "timer_countdown" then
				local server_time = Managers.backend:get_server_time(Managers.time:time("main"))
				local time_left = math.max(tonumber(content.data) - server_time, 0) / 1000

				body_number = TextUtils.format_time_span_localized(time_left, true)
			end
		end

		if title and image_url then
			slides[#slides + 1] = {
				id = raw_data.id,
				title = title or "",
				body_text = body_text or "",
				body_number = body_number or "",
				image_url = image_url,
				backend_index = i,
				sort_index = raw_data.displayPriority and tonumber(raw_data.displayPriority) or 0,
			}
		end
	end

	table.sort(slides, _compare_slides)

	for url, _ in pairs(self._textures) do
		Managers.url_loader:load_texture(url):next(function (data)
			self._textures[url] = data
		end)
	end

	if #slides == 0 then
		return
	end

	self._slide_data = slides
	self._backend_data = backend_data
	self._widgets_by_name.news_button.visible = true

	self:_change_slide(1, Settings.transition_time)

	if self:_has_progress_bar() then
		self:_create_progress_bar()
	end
end

ViewElementNewsSlide._slide_count = function (self)
	local slides = self._slide_data

	return slides and #slides or 0
end

ViewElementNewsSlide._has_progress_bar = function (self)
	return self:_slide_count() > 1
end

ViewElementNewsSlide._create_progress_bar = function (self)
	local progress_widgets = {}
	local item_count = self:_slide_count()
	local definition = Definitions.blueprints.loading_bar

	for i = 1, item_count do
		local widget = self:_create_widget("progress_widget_" .. i, definition)

		widget.content.hotspot.pressed_callback = callback(self, "_request_slide_change", i)
		progress_widgets[i] = widget
	end

	self._progress_widgets = progress_widgets

	self:_position_progress_bar()
end

ViewElementNewsSlide._delete_progress_bar = function (self)
	local widgets = self._progress_widgets
	local item_count = widgets and #widgets or 0

	for i = 1, item_count do
		self:_unregister_widget_name("progress_widget_" .. i)
	end

	self._progress_widgets = nil
end

ViewElementNewsSlide._position_progress_bar = function (self)
	local widgets = self._progress_widgets
	local item_count = widgets and #widgets or 0
	local buffer = Settings.buffer

	if item_count == 2 then
		buffer = 0
	end

	local available_width = Settings.bar_size[1] - buffer * (item_count - 1)
	local weights = item_count + Settings.selected_factor - 1
	local small_width = available_width / weights
	local large_width = small_width * Settings.selected_factor

	if item_count == 2 then
		small_width, large_width = 0, available_width
	end

	local time = self._slide_time
	local transition_progress = math.ease_exp(math.clamp(time / Settings.transition_time, 0, 1))
	local total_progress = math.clamp((time - Settings.transition_time) / (Settings.total_time - Settings.transition_time), 0, 1)
	local width = 0
	local old_index, current_index = self._old_index, self._current_index

	for i = 1, item_count do
		local is_old = i == old_index
		local is_current = i == current_index
		local size

		if is_old then
			size = small_width + (1 - transition_progress) * (large_width - small_width)
		elseif is_current then
			size = small_width + transition_progress * (large_width - small_width)
		else
			size = small_width
		end

		local widget = widgets[i]
		local content, style = widget.content, widget.style

		content.size[1] = size
		style.background.size[1] = size
		style.hotspot.size[1] = size

		if is_current then
			local current_progress = time < Settings.transition_time and 1 - transition_progress or total_progress
			local progress_size = size * current_progress

			style.foreground.offset[1] = progress_size
			style.foreground.size[1] = size - progress_size
			style.glow.offset[1] = progress_size - 12
			style.glow.size[1] = math.min(Settings.bar_size[2], size - progress_size)
		end

		widget.offset[1] = width
		content.active = is_current
		width = width + size + buffer
		widget.visible = item_count ~= 2 or is_current
	end
end

ViewElementNewsSlide._request_slide_change = function (self, target)
	local too_early = self._slide_time < Settings.transition_time
	local is_current = target == self._current_index
	local slide_count = self:_slide_count()

	if is_current and slide_count == 2 then
		self:_change_slide(target == 1 and 2 or 1)

		return
	end

	if too_early or is_current then
		self._slide_time = math.min(self._slide_time, Settings.transition_time)

		return
	end

	return self:_change_slide(target)
end

ViewElementNewsSlide._default_transition_time = function (self)
	return self:_slide_count() == 2 and Settings.transition_time or 0
end

ViewElementNewsSlide._change_slide = function (self, target, optional_start_time)
	self._old_index = self._current_index
	self._current_index = target
	self._slide_time = optional_start_time or self:_default_transition_time()

	local news_button = self._widgets_by_name.news_button
	local slide_data = self._slide_data[self._current_index]

	news_button.content.title = slide_data.title
	news_button.content.body_text = slide_data.body_text
	news_button.content.body_number = slide_data.body_number

	Managers.telemetry_events:update_news_widget(target, slide_data.id)

	news_button.style.online_image.material_values.texture = nil

	self:_update_slide_image()
end

local function _top_center_aspect_uvs(target_x, target_y, real_x, real_y)
	local x_ratio = target_x / real_x
	local y_ratio = target_y / real_y
	local ratio = math.max(x_ratio, y_ratio)

	x_ratio, y_ratio = x_ratio / ratio, y_ratio / ratio

	local x_diff = (1 - x_ratio) / 2

	return x_diff, 0, 1 - x_diff, y_ratio
end

ViewElementNewsSlide._update_slide_image = function (self)
	local style = self._widgets_by_name.news_button.style.online_image
	local material_values = style.material_values
	local current_slide_data = self._slide_data[self._current_index]
	local url = current_slide_data and current_slide_data.image_url
	local texture_data = self._textures[url]

	if not material_values.texture and texture_data then
		local uvs = style.uvs
		local target_size = Settings.image_size

		uvs[1][1], uvs[1][2], uvs[2][1], uvs[2][2] = _top_center_aspect_uvs(target_size[1], target_size[2], texture_data.width, texture_data.height)
		material_values.texture = texture_data.texture
	end
end

ViewElementNewsSlide.update = function (self, dt, t, input_service)
	if self:_has_progress_bar() then
		self._slide_time = self._slide_time + dt
	end

	if self._slide_time >= Settings.total_time then
		local target = self._current_index + 1

		if target > self:_slide_count() then
			target = 1
		end

		self:_change_slide(target)
	end

	if self:_has_progress_bar() then
		self:_position_progress_bar()
	end

	if self:_slide_count() > 0 then
		self:_update_slide_image()
	end

	return ViewElementNewsSlide.super.update(self, dt, t, input_service)
end

ViewElementNewsSlide._get_text_dimensions = function (self, pass_name, ui_renderer)
	local news_button = self._widgets_by_name.news_button
	local style = news_button.style[pass_name]
	local title_text_options = UIFonts.get_font_options_by_style(style)

	return UIRenderer.text_size(ui_renderer, news_button.content[pass_name], style.font_type, style.font_size, style.size, title_text_options)
end

ViewElementNewsSlide._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local news_button = self._widgets_by_name.news_button
	local _, title_height = self:_get_text_dimensions("title", ui_renderer)

	news_button.style.title_background.size[2] = title_height + 2 * Settings.buffer

	local text_width, text_height = self:_get_text_dimensions("body_text", ui_renderer)
	local number_width, number_height = self:_get_text_dimensions("body_number", ui_renderer)
	local line_count = 0

	if text_width > 0 then
		news_button.style.body_number.offset[2] = text_height + Settings.buffer
		text_width = text_width + 2 * Settings.buffer
		line_count = line_count + 1
	else
		news_button.style.body_number.offset[2] = 0
	end

	if number_width > 0 then
		line_count = line_count + 1
		number_width = number_width + 2 * Settings.buffer
	end

	local background_width = math.max(number_width, text_width)
	local background_height = text_height + number_height + (1 + line_count) * Settings.buffer

	news_button.style.body_gradient.offset[1] = -background_width / 2
	news_button.style.body_background.size[1] = background_width / 2
	news_button.style.body_gradient.size[1] = background_width / 2
	news_button.style.body_background.size[2] = background_height
	news_button.style.body_gradient.size[2] = background_height

	local progress_widgets = self._progress_widgets
	local progress_count = progress_widgets and #progress_widgets or 0

	for i = 1, progress_count do
		UIWidget.draw(progress_widgets[i], ui_renderer)
	end

	ViewElementNewsSlide.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementNewsSlide.view_requested = function (self)
	local current_index = self._current_index
	local slide_data = self._slide_data and self._slide_data[current_index]
	local backend_index = slide_data and slide_data.backend_index
	local backend_data = self._backend_data and self._backend_data[backend_index]

	if backend_data then
		Managers.ui:open_view("news_view", nil, nil, nil, nil, {
			should_save = false,
			telemetry_id = slide_data.id,
			slide_data = {
				starting_slide_index = 1,
				slides = {
					backend_data,
				},
			},
		})
	end
end

ViewElementNewsSlide.can_open_view = function (self)
	local current_index = self._current_index
	local slide_data = self._slide_data and self._slide_data[current_index]
	local backend_index = slide_data and slide_data.backend_index
	local backend_data = self._backend_data and self._backend_data[backend_index]

	return backend_data ~= nil
end

return ViewElementNewsSlide
