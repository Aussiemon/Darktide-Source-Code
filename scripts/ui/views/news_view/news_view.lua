-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local Definitions = require("scripts/ui/views/news_view/news_view_definitions")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WidgetSlideBlueprints = require("scripts/ui/views/news_view/news_view_blueprints")
local NewsView = class("NewsView", "BaseView")
local dummy_data = {
	{
		id = "id_1",
		content = {
			{
				text = "slide 1",
				type = "header"
			},
			{
				type = "spacing_vertical"
			},
			{
				type = "body",
				text = Localize("loc_news_view_text_long")
			},
			{
				texture = "content/ui/materials/title_screen_background",
				type = "left_image"
			}
		}
	},
	{
		id = "id_2",
		content = {
			{
				text = "slide 2",
				type = "header"
			},
			{
				type = "spacing_vertical"
			},
			{
				type = "body",
				text = Localize("loc_news_view_text_short")
			},
			{
				texture = "content/ui/materials/backgrounds/class_background_zealot",
				type = "left_image"
			}
		}
	},
	{
		id = "id_3",
		content = {
			{
				text = "slide 3",
				type = "header"
			},
			{
				type = "spacing_vertical"
			},
			{
				text = "this is but a test",
				type = "body"
			},
			{
				texture = "content/ui/materials/title_screen_background",
				type = "left_image"
			}
		}
	},
	{
		id = "id_4",
		content = {
			{
				text = "slide 4",
				type = "header"
			},
			{
				type = "spacing_vertical"
			},
			{
				type = "body",
				text = Localize("loc_news_view_text_short")
			},
			{
				texture = "content/ui/materials/backgrounds/class_background_zealot",
				type = "left_image"
			}
		}
	}
}

NewsView.init = function (self, settings, context)
	self._slide_position = {}
	local slide_data = context and context.slide_data
	self._view_triggered_by_user = false

	fassert(slide_data, "[News View] - No slide_data provided in context")

	self._viewed_slides_id = slide_data.viewed_slides_id
	self._starting_slide_index = slide_data.starting_slide_index
	self._slides = slide_data.slides
	self._offscreen_renderer = nil
	self._grid_widgets = {}
	self._grid = nil
	self._slide_page_circles = {}
	self._slide_left_image = nil

	NewsView.super.init(self, Definitions, settings)

	self._allow_close_hotkey = false
	self._pass_draw = false
end

NewsView._add_viewed_slide = function (self, slide_to_add)
	for i = 1, #self._viewed_slides_id, 1 do
		local viewed_slide = self._viewed_slides_id[i]

		if viewed_slide == slide_to_add.id then
			return
		end
	end

	self._viewed_slides_id[#self._viewed_slides_id + 1] = slide_to_add.id
end

NewsView._save_viewed_slides = function (self)
	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	save_data.viewed_news_slides = self._viewed_slides_id

	save_manager:queue_save()
end

NewsView.on_enter = function (self)
	NewsView.super.on_enter(self)
	self:_create_offscreen_renderer()
	self:_create_slide_page_circles()
	self:_setup_buttons_interactions()
	self:_change_slide(self._starting_slide_index)
end

NewsView.on_exit = function (self)
	self:_save_viewed_slides()
	self:_destroy_renderer()
	NewsView.super.on_exit(self)
end

NewsView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

NewsView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"
	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

NewsView._create_grid_widgets = function (self, content)
	local grid_widgets = {}
	local slide_left_image_widget = nil
	local alignment_list = {}
	local widget_content_scenegraph_id = "slide_content_grid_content"
	local widget_background_scenegraph_id = "slide_content_left"

	for i = 1, #content, 1 do
		local entry = content[i]
		local entry_type = entry.type

		if entry_type == "left_image" then
			local widget_blueprint = WidgetSlideBlueprints[entry_type]
			local pass_template = widget_blueprint.pass_template
			local widget_definition = UIWidget.create_definition(pass_template, widget_background_scenegraph_id)
			slide_left_image_widget = self:_create_widget("entry_" .. i, widget_definition)

			widget_blueprint.init(self, slide_left_image_widget, entry)
		else
			local widget_blueprint = WidgetSlideBlueprints[entry_type]
			local size = widget_blueprint.size
			local pass_template = widget_blueprint.pass_template

			if pass_template then
				local widget_definition = UIWidget.create_definition(pass_template, widget_content_scenegraph_id, nil, size)
				local widget = self:_create_widget("entry_" .. i, widget_definition)

				widget_blueprint.init(self, widget, entry)

				grid_widgets[#grid_widgets + 1] = widget
				alignment_list[#alignment_list + 1] = widget
			else
				alignment_list[#alignment_list + 1] = {
					size = size
				}
			end
		end
	end

	return grid_widgets, alignment_list, slide_left_image_widget
end

NewsView._create_slide_page_circles = function (self)
	local circle_widget_definition = Definitions.slide_circle_widget_definition
	local circles = {}
	local circle_size_width = circle_widget_definition.style.circ.size[1]
	local circle_offset = 20

	for i = 1, #self._slides, 1 do
		circles[i] = self:_create_widget("slide_circ_" .. i, circle_widget_definition)
		circles[i].offset[1] = (i - 1) * circle_offset
		circles[i].content.hotspot.pressed_callback = callback(self, "_animate_slide_out", i)
	end

	self._slide_page_circles = circles
	local page_indicator_width = circles[#circles].offset[1] + circle_size_width
	self._ui_scenegraph.slide_page_indicator.size = {
		page_indicator_width,
		0
	}
end

NewsView._setup_grid = function (self, widgets, alignment_list)
	local grid_direction = "down"
	local grid_scenegraph_id = "slide_content_grid"
	local grid = UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, grid_direction)

	return grid
end

NewsView._clean_current_slide = function (self)
	local grid_widgets = self._grid_widgets
	local slide_left_image = self._slide_left_image

	if grid_widgets then
		for i = 1, #grid_widgets, 1 do
			local widget = grid_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	if slide_left_image then
		local widget_name = slide_left_image.name

		self:_unregister_widget_name(widget_name)
	end

	self._grid = nil
end

NewsView._change_slide = function (self, new_value)

	-- Decompilation error in this vicinity:
	if new_value > #self._slides or new_value < 1 then
		return
	end

	local slide = self._slides[new_value]

	self:_add_viewed_slide(slide)
	self:_clean_current_slide()

	local widgets, alignment_list, slide_left_image_widget = self:_create_grid_widgets(slide.content)
	local slide_grid = self:_setup_grid(widgets, alignment_list)
	self._grid_widgets = widgets
	self._grid = slide_grid
	self._slide_left_image = slide_left_image_widget
	self._slide_position.previous = self._slide_position.current
	self._slide_position.current = new_value

	if new_value == 1 then
		self._widgets_by_name.previous_button.content.visible = false
	else
		self._widgets_by_name.previous_button.content.visible = true
	end

	if new_value == #self._slides then
		self._widgets_by_name.next_button.content.text = Localize("loc_news_view_close")
	else
		self._widgets_by_name.next_button.content.text = Localize("loc_news_view_next")
	end

	local scrollbar_widget = self._widgets_by_name.slide_scrollbar
	local grid_content_scenegraph_id = "slide_content_grid_content"
	local interaction_scenegraph_id = "slide_content_grid_interaction"

	slide_grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph_id, interaction_scenegraph_id)
	slide_grid:set_scrollbar_progress(0)
	self:_on_navigation_input_changed()
	self:_set_slide_indicator_focus(new_value)
	self:_animate_slide_in()
end

NewsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local slide_left_image = self._slide_left_image
	local slide_page_circles = self._slide_page_circles

	if slide_left_image then
		UIWidget.draw(slide_left_image, self._ui_renderer)
	end

	if slide_page_circles then
		for i = 1, #slide_page_circles, 1 do
			local slide_page_circles = slide_page_circles[i]

			UIWidget.draw(slide_page_circles, self._ui_renderer)
		end
	end

	return NewsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

NewsView.draw = function (self, dt, t, input_service, layer)
	local offscreen_renderer = self._offscreen_renderer
	local render_settings = self._render_settings

	if offscreen_renderer then
		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)

		local grid_widgets = self._grid_widgets
		local grid = self._grid

		for i = 1, #grid_widgets, 1 do
			local widget = grid_widgets[i]

			if grid:is_widget_visible(widget) then
				UIWidget.draw(widget, offscreen_renderer)
			end
		end

		UIRenderer.end_pass(offscreen_renderer)
	end

	return NewsView.super.draw(self, dt, t, input_service, layer)
end

NewsView.update = function (self, dt, t, input_service, layer)
	self._grid:update(dt, t, input_service)

	return NewsView.super.update(self, dt, t, input_service, layer)
end

NewsView._setup_buttons_interactions = function (self)
	self._widgets_by_name.previous_button.content.hotspot.pressed_callback = callback(self, "_on_back_pressed")
	self._widgets_by_name.next_button.content.hotspot.pressed_callback = callback(self, "_on_forward_pressed")
end

NewsView._on_back_pressed = function (self)
	local previous_slide = self._slide_position.current - 1

	self:_animate_slide_out(previous_slide)
end

NewsView._on_forward_pressed = function (self)
	local current_slide = self._slide_position.current

	if current_slide == #self._slides then
		Managers.ui:close_view(self.view_name)

		return
	end

	local next_slide = self._slide_position.current + 1

	self:_animate_slide_out(next_slide)
end

NewsView._get_animation_widgets = function (self)
	local widgets = {
		scrollbar = self._widgets_by_name.slide_scrollbar
	}

	for i = 1, #self._grid_widgets, 1 do
		widgets[self._grid_widgets[i].name] = self._grid_widgets[i]
	end

	if self._slide_left_image then
		widgets[#widgets + 1] = self._slide_left_image
	end

	return widgets
end

NewsView._animate_slide_out = function (self, next_slide)
	local widgets = self:_get_animation_widgets()

	self:_enable_interactions(true)
	self:_start_animation("on_exit", widgets, nil, callback(self, "_change_slide", next_slide))
end

NewsView._animate_slide_in = function (self)
	local widgets = self:_get_animation_widgets()

	self:_start_animation("on_enter", widgets, nil, callback(self, "_enable_interactions", false))
end

NewsView._set_slide_indicator_focus = function (self, index)
	local slide_page_circles = self._slide_page_circles

	for i = 1, #slide_page_circles, 1 do
		local widget = slide_page_circles[i]
		widget.content.active = i == index
	end
end

NewsView._enable_interactions = function (self, is_disabled)
	self._widgets_by_name.previous_button.content.hotspot.disabled = is_disabled
	self._widgets_by_name.next_button.content.hotspot.disabled = is_disabled
	local slide_page_circles = self._slide_page_circles

	for i = 1, #slide_page_circles, 1 do
		local widget = slide_page_circles[i]
		widget.content.hotspot.disabled = is_disabled
	end
end

NewsView._on_navigation_input_changed = function (self)
	NewsView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if not grid then
		return
	end

	if not self._using_cursor_navigation then
		if not grid:selected_grid_index() then
			local focused_index = 1

			if focused_index then
				local scrollbar_progress = grid:get_scrollbar_percentage_by_index(focused_index)

				grid:select_grid_index(focused_index, scrollbar_progress, true)
			else
				grid:select_first_index()
			end
		end
	elseif grid:selected_grid_index() then
		grid:select_grid_index(nil)
	end
end

NewsView._handle_input = function (self, input_service, dt, t)
	if input_service:get("close_view") and self._view_triggered_by_user then
		Managers.ui:close_view(self.view_name)
	elseif input_service:get("back") or input_service:get("navigate_secondary_left_pressed") then
		if self._slide_position.current > 1 then
			self:_on_back_pressed()
		end
	elseif input_service:get("confirm_pressed") or input_service:get("navigate_secondary_right_pressed") then
		self:_on_forward_pressed()
	end
end

return NewsView
