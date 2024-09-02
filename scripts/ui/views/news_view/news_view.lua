-- chunkname: @scripts/ui/views/news_view/news_view.lua

local Promise = require("scripts/foundation/utilities/promise")
local Definitions = require("scripts/ui/views/news_view/news_view_definitions")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WidgetSlideBlueprints = require("scripts/ui/views/news_view/news_view_blueprints")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local NewsViewSettings = require("scripts/ui/views/news_view/news_view_settings")
local NewsView = class("NewsView", "BaseView")

NewsView.init = function (self, settings, context)
	self._slide_position = {}
	self._initialized = false
	self._url_textures = {}

	local slide_data = context and context.slide_data
	local content_package = context and context.content_package

	self._should_save = context == nil or context.should_save ~= false

	if not slide_data then
		self:_load_slides()
	else
		self:_initialize_slides(slide_data)
	end

	self._view_triggered_by_user = not context or not context.on_startup
	self._grid = nil
	self._offscreen_renderer = nil
	self._slide_page_circles = {}
	self._slide_left_image = nil
	self._content_alpha_multiplier = 0
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	NewsView.super.init(self, Definitions, settings, context, content_package)

	self._allow_close_hotkey = false
	self._pass_draw = false
	self._telemetry_view_name = string.format("news_view_%s", self._view_triggered_by_user and "widget" or "startup")
	self._telemetry_id = context.telemetry_id
end

local function to_news_view(news_item)
	local content = news_item.content or {}
	local backend_contents = news_item.contents
	local image_url

	if backend_contents then
		for _, content_item in ipairs(backend_contents) do
			local presentation = content_item.presentation
			local is_default = not presentation or table.array_contains(presentation, "default")

			if not is_default then
				-- Nothing
			elseif content_item.type == "title" then
				table.insert(content, {
					widget_type = "header",
					text = content_item.data or "",
				})
			elseif content_item.type == "subtitle" then
				table.insert(content, {
					widget_type = "sub_header",
					text = content_item.data or "",
				})
			elseif content_item.type == "body" then
				table.insert(content, {
					widget_type = "body",
					text = content_item.data or "",
				})
			elseif content_item.type == "br" then
				table.insert(content, {
					widget_type = "dynamic_spacing",
					size = {
						500,
						20,
					},
				})
			elseif content_item.type == "image" then
				image_url = content_item.data
			end
		end
	end

	return {
		id = news_item.id,
		content = content,
		image_url = image_url,
		backend_news = news_item,
		local_image = news_item.local_image,
		local_image_material = news_item.local_image_material,
		local_slide = news_item.local_slide,
	}
end

NewsView._initialize_slides = function (self, slide_data)
	local slides = {}
	local raw_news = slide_data.slides

	for i = 1, #raw_news do
		table.insert(slides, to_news_view(raw_news[i]))
	end

	self._starting_slide_index = slide_data.starting_slide_index
	self._slides = slides
	self._initialized = true
end

NewsView._load_slides = function (self)
	self._initialized = false

	Managers.data_service.news:get_news():next(function (raw_news)
		local slide_data = {
			starting_slide_index = 1,
			slides = raw_news,
		}

		self:_initialize_slides(slide_data)
	end)
end

NewsView._add_viewed_slide = function (self, slide_to_add)
	local backend_news = slide_to_add.backend_news

	if self._should_save then
		backend_news:mark_read()
	end
end

NewsView.on_enter = function (self)
	NewsView.super.on_enter(self)

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.previous_button.content.visible = false
	widgets_by_name.next_button.content.visible = false

	self:_setup_grid()
	Managers.telemetry_events:open_view(self._telemetry_view_name, false, self._telemetry_id)
	Promise.until_value_is_true(function ()
		return self._initialized
	end):next(function ()
		local slides = self._slides

		if slides and #slides > 0 then
			self._started = true
			self._window_open_anim_id = self:_start_animation("on_enter", widgets_by_name)

			self:_create_slide_page_circles()
			self:_setup_buttons_interactions()

			local ignore_animation = true

			self:_change_slide(self._starting_slide_index, ignore_animation)
		else
			Managers.ui:close_view(self.view_name)
		end
	end)
end

NewsView.on_exit = function (self)
	NewsView.super.on_exit(self)
	Managers.telemetry_events:close_view(self._telemetry_view_name)
	self:_unload_url_textures()
end

NewsView._create_slide_page_circles = function (self)
	local circle_widget_definition = Definitions.slide_circle_widget_definition
	local circles = {}
	local circle_size_width = NewsViewSettings.slide_thumb_size[1]
	local circle_offset = 10
	local total_width = 0
	local circle_count = self:_circle_count()
	local offset_x = -(circle_count * circle_size_width + (circle_count - 1) * circle_offset - circle_size_width) * 0.5
	local view_triggered_by_user = self._view_triggered_by_user

	for i = 1, circle_count do
		circles[i] = self:_create_widget("slide_circ_" .. i, circle_widget_definition)
		circles[i].offset[1] = offset_x
		offset_x = offset_x + circle_size_width + circle_offset

		if view_triggered_by_user then
			circles[i].content.hotspot.pressed_callback = callback(self, "_animate_slide_out", i)
		end

		total_width = total_width + circle_size_width

		if i < circle_count then
			total_width = total_width + circle_offset
		end
	end

	self._slide_page_circles = circles

	self:_set_scenegraph_size("slide_page_indicator", total_width)
end

NewsView._change_slide = function (self, slide_index, ignore_animation)
	local widgets_by_name = self._widgets_by_name
	local num_slides = #self._slides

	if num_slides < slide_index or slide_index < 1 then
		local prev_button_content = widgets_by_name.previous_button.content

		prev_button_content.visible = true
		prev_button_content.original_text = Localize("loc_news_view_close")

		return
	end

	local slide = self._slides[slide_index]

	if not slide.local_slide then
		self:_add_viewed_slide(slide)
	end

	local slide_content = slide.content
	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}

	for index, entry in ipairs(slide_content) do
		layout[#layout + 1] = entry
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}

	if slide.local_image_material then
		local image_element = widgets_by_name.window_image

		image_element.content.texture = slide.local_image_material
		image_element.style.texture.force_view = true
	end

	if slide.image_url then
		local image_element = widgets_by_name.window_image

		self:load_texture(slide.image_url, image_element)
	elseif slide.local_image then
		local image_element = widgets_by_name.window_image

		image_element.style.texture.material_values.texture = slide.local_image
	else
		local image_element = widgets_by_name.window_image

		image_element.style.texture.material_values.texture = nil
	end

	local grid = self._grid

	grid:present_grid_layout(layout, WidgetSlideBlueprints)
	grid:set_handle_grid_navigation(true)

	self._slide_position.previous = self._slide_position.current
	self._slide_position.current = slide_index

	if slide_index == 1 then
		local target_position_width, target_position_height

		if num_slides == 1 then
			target_position_width, target_position_height = self:_scenegraph_position("center_button")
		else
			target_position_width, target_position_height = self:_scenegraph_position("next_button")
		end

		self:_set_scenegraph_position("next_button", target_position_width, target_position_height)
		self:_force_update_scenegraph()

		if self._view_triggered_by_user and num_slides > 1 then
			widgets_by_name.previous_button.content.visible = true
		else
			widgets_by_name.previous_button.content.visible = false

			if not self._using_cursor_navigation then
				widgets_by_name.previous_button.content.hotspot.is_selected = false
				widgets_by_name.next_button.content.hotspot.is_selected = true
			end
		end
	else
		widgets_by_name.previous_button.content.visible = true
	end

	widgets_by_name.next_button.content.visible = true

	if slide_index == num_slides then
		widgets_by_name.next_button.content.original_text = Localize("loc_news_view_close")
		widgets_by_name.previous_button.content.original_text = Localize("loc_news_view_previous")
	else
		if slide_index > 1 then
			widgets_by_name.previous_button.content.original_text = Localize("loc_news_view_previous")
		else
			widgets_by_name.previous_button.content.original_text = Localize("loc_news_view_close")
		end

		widgets_by_name.next_button.content.original_text = Localize("loc_news_view_next")
	end

	self:_on_navigation_input_changed()

	if self._using_cursor_navigation then
		widgets_by_name.previous_button.content.hotspot.is_selected = false
		widgets_by_name.next_button.content.hotspot.is_selected = false
	elseif not widgets_by_name.previous_button.content.hotspot.is_selected or widgets_by_name.next_button.content.hotspot.is_selected then
		widgets_by_name.previous_button.content.hotspot.is_selected = false
		widgets_by_name.next_button.content.hotspot.is_selected = true
	end

	self:_set_slide_indicator_focus(slide_index)

	if not ignore_animation then
		self:_animate_slide_in()
	end
end

NewsView._circle_count = function (self)
	local slide_count = #self._slides

	return slide_count > 1 and slide_count or 0
end

NewsView.load_texture = function (self, image_url, image_element)
	if image_url then
		local style = image_element.style

		style.texture.material_values.texture = nil

		local url_textures = self._url_textures

		url_textures[#url_textures + 1] = image_url

		Managers.url_loader:load_texture(image_url):next(function (data)
			style.texture.material_values.texture = data.texture
			url_textures[image_url] = data
		end):catch(function (error)
			local error_string = tostring(error)

			Log.error("NewsService", "Error fetching news images", error_string)
		end)
	end
end

NewsView.draw = function (self, dt, t, input_service, layer)
	if not self._started then
		return
	end

	local content_alpha_multiplier = self._content_alpha_multiplier
	local grid_widgets = self._grid:widgets()

	if grid_widgets then
		for _, widget in ipairs(grid_widgets) do
			widget.alpha_multiplier = content_alpha_multiplier
		end
	end

	return NewsView.super.draw(self, dt, t, input_service, layer)
end

NewsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local slide_page_circles = self._slide_page_circles

	if slide_page_circles then
		for i = 1, #slide_page_circles do
			UIWidget.draw(slide_page_circles[i], self._ui_renderer)
		end
	end

	return NewsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

NewsView.update = function (self, dt, t, input_service, layer)
	if self._current_anim_id and self:_is_animation_completed(self._current_anim_id) then
		self:_stop_animation(self._current_anim_id)

		self._current_anim_id = nil
	end

	if self._window_open_anim_id and self:_is_animation_completed(self._window_open_anim_id) then
		self:_stop_animation(self._window_open_anim_id)

		self._window_open_anim_id = nil
	end

	if self._grid then
		self._grid:update(dt, t, input_service)
	end

	self._pass_draw = not self._started

	return NewsView.super.update(self, dt, t, input_service, layer)
end

NewsView._setup_buttons_interactions = function (self)
	self._widgets_by_name.previous_button.content.hotspot.pressed_callback = callback(self, "_on_back_pressed")
	self._widgets_by_name.next_button.content.hotspot.pressed_callback = callback(self, "_on_forward_pressed")
end

NewsView._on_back_pressed = function (self)
	if self._current_anim_id or self._window_open_anim_id or self._window_exit_anim_id then
		return
	end

	local current_slide = self._slide_position.current

	if self._view_triggered_by_user and (current_slide == nil or current_slide == 1) then
		self._window_exit_anim_id = self:_start_animation("on_exit", self._widgets_by_name, nil, callback(function ()
			Managers.ui:close_view(self.view_name)
		end))

		self:_play_sound(UISoundEvents.news_popup_exit)

		return
	else
		self:_play_sound(UISoundEvents.news_popup_slide_previous)

		local previous_slide = current_slide - 1

		self:_animate_slide_out(previous_slide)
	end
end

NewsView._on_forward_pressed = function (self)
	if self._current_anim_id or self._window_open_anim_id or self._window_exit_anim_id then
		return
	end

	local current_slide = self._slide_position.current

	if current_slide == #self._slides then
		self._window_exit_anim_id = self:_start_animation("on_exit", self._widgets_by_name, nil, callback(function ()
			Managers.ui:close_view(self.view_name)
		end))

		self:_play_sound(UISoundEvents.news_popup_exit)

		return
	end

	self:_play_sound(UISoundEvents.news_popup_slide_next)

	local next_slide = self._slide_position.current + 1

	self:_animate_slide_out(next_slide)
end

NewsView._get_animation_widgets = function (self)
	local window_image_widget = self._widgets_by_name.window_image
	local widgets = {
		[window_image_widget.name] = window_image_widget,
	}

	return widgets
end

NewsView._animate_slide_out = function (self, next_slide)
	local widgets = self:_get_animation_widgets()

	if self._current_anim_id then
		self:_stop_animation(self._current_anim_id)

		self._current_anim_id = nil
	end

	self._current_anim_id = self:_start_animation("change_content_out", widgets, nil, callback(self, "_change_slide", next_slide))
end

NewsView._animate_slide_in = function (self)
	local widgets = self:_get_animation_widgets()

	if self._current_anim_id then
		self:_stop_animation(self._current_anim_id)

		self._current_anim_id = nil
	end

	self._current_anim_id = self:_start_animation("change_content_in", widgets, nil)
end

NewsView._set_slide_indicator_focus = function (self, index)
	local slide_page_circles = self._slide_page_circles

	for i = 1, #slide_page_circles do
		local widget = slide_page_circles[i]

		widget.content.active = i == index
	end
end

NewsView._on_navigation_input_changed = function (self)
	NewsView.super._on_navigation_input_changed(self)

	local widgets_by_name = self._widgets_by_name

	if self._using_cursor_navigation then
		widgets_by_name.previous_button.content.hotspot.is_selected = false
		widgets_by_name.next_button.content.hotspot.is_selected = false
	elseif not widgets_by_name.previous_button.content.hotspot.is_selected or widgets_by_name.next_button.content.hotspot.is_selected then
		widgets_by_name.previous_button.content.hotspot.is_selected = false
		widgets_by_name.next_button.content.hotspot.is_selected = true
	end
end

NewsView._handle_button_gamepad_navigation = function (self, input_service)
	local widgets_by_name = self._widgets_by_name

	if input_service:get("navigate_left_continuous") then
		if not widgets_by_name.previous_button.content.hotspot.is_selected and widgets_by_name.previous_button.content.visible then
			widgets_by_name.previous_button.content.hotspot.is_selected = true
			widgets_by_name.next_button.content.hotspot.is_selected = false

			self:_play_sound(UISoundEvents.default_mouse_hover)
		end
	elseif input_service:get("navigate_right_continuous") and not widgets_by_name.next_button.content.hotspot.is_selected and widgets_by_name.next_button.content.visible then
		widgets_by_name.previous_button.content.hotspot.is_selected = false
		widgets_by_name.next_button.content.hotspot.is_selected = true

		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

NewsView._handle_input = function (self, input_service, dt, t)
	local widgets_by_name = self._widgets_by_name

	if not self._tutorial_window_open_animation_id then
		self:_handle_button_gamepad_navigation(input_service)

		if input_service:get("back") then
			local current_slide = self._slide_position.current

			if self._view_triggered_by_user or current_slide ~= 1 then
				self:_on_back_pressed()
			end
		elseif input_service:get("gamepad_confirm_pressed") then
			if widgets_by_name.next_button.content.hotspot.is_selected then
				self:_on_forward_pressed()
			elseif widgets_by_name.previous_button.content.hotspot.is_selected then
				self:_on_back_pressed()
			end
		end
	end

	if self._tutorial_window_open_animation_id and self:_is_animation_completed(self._tutorial_window_open_animation_id) then
		self._tutorial_window_open_animation_id = nil
	end
end

NewsView._setup_grid = function (self)
	local definitions = self._definitions

	if not self._grid then
		local grid_scenegraph_id = "slide_content_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 18,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._grid = self:_add_element(ViewElementGrid, "slide_content_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("slide_content_grid", self._grid)
		self._grid:set_empty_message("")
	end

	self:_play_sound(UISoundEvents.news_popup_enter)
end

NewsView._unload_url_textures = function (self)
	local url_textures = self._url_textures
	local url_texture_count = url_textures and #url_textures or 0

	for i = 1, url_texture_count do
		Managers.url_loader:unload_texture(url_textures[i])
	end

	self._url_textures = {}
end

return NewsView
