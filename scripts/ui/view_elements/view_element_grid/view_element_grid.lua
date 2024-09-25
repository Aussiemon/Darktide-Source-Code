﻿-- chunkname: @scripts/ui/view_elements/view_element_grid/view_element_grid.lua

local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Text = require("scripts/utilities/ui/text")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementGridSettings = require("scripts/ui/view_elements/view_element_grid/view_element_grid_settings")
local _create_definitions_function = require("scripts/ui/view_elements/view_element_grid/view_element_grid_definitions")
local ViewElementGrid = class("ViewElementGrid", "ViewElementBase")

ViewElementGrid.init = function (self, parent, draw_layer, start_scale, optional_menu_settings, optional_definitions)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	local owner = parent and (parent.view_name or parent.__class_name) or Managers.ui:active_top_view()

	self._element_view_id = string.format("%s_%s", owner, optional_menu_settings.reference_name or "1")

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementGridSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementGridSettings
	end

	self._loaded_item_icons_info = {}
	self._pivot_offset = {
		0,
		0,
	}
	self._loaded_icon_id_cache = {}
	self._cache_loaded_icons = self._menu_settings.cache_loaded_icons or false
	self._use_horizontal_scrollbar = self._menu_settings.use_horizontal_scrollbar
	self._widget_visual_margin = self._menu_settings.widget_visual_margin or 0
	self._widget_icon_load_margin = self._menu_settings.widget_icon_load_margin or 0
	self._resource_renderer_background = self._menu_settings.resource_renderer_background or false

	local definitions = _create_definitions_function(self._menu_settings)

	if optional_definitions then
		table.merge_recursive(definitions, optional_definitions)
	end

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()
	self._reset_selection_on_navigation_change = self._menu_settings.reset_selection_on_navigation_change

	ViewElementGrid.super.init(self, parent, draw_layer, start_scale, definitions)

	self._no_resource_rendering = self._menu_settings.no_resource_rendering

	if not self._no_resource_rendering then
		if self._menu_settings.use_parent_ui_renderer then
			local ui_renderer = self._parent:ui_renderer()
			local world = ui_renderer.world

			self._ui_grid_renderer = ui_renderer
			self._ui_grid_renderer_is_external = true

			local gui = self._ui_grid_renderer.gui
			local gui_retained = self._ui_grid_renderer.gui_retained
			local resource_renderer_name = self._unique_id
			local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"

			self._ui_resource_renderer = Managers.ui:create_renderer(resource_renderer_name, world, true, gui, gui_retained, material_name)
		else
			local optional_world

			if self._menu_settings.use_parent_world then
				local ui_renderer = self._parent:ui_renderer()

				optional_world = ui_renderer.world
			end

			self:_setup_grid_gui(optional_world)
		end
	else
		self._ui_grid_renderer_is_external = true
	end

	self._widgets_by_name.sort_button.content.visible = false
	self._widgets_by_name.timer_text.content.visible = false
	self._input_disabled = false
	self._widgets_by_name.grid_loading.content.is_loading = self._menu_settings.show_loading_overlay
end

local _timer_params = {}

ViewElementGrid.set_expire_time = function (self, time)
	local timer_text = time and Text.format_time_span_long_form_localized(time) or ""
	local timer_loc_string = self._menu_settings.timer_loc_string

	if timer_loc_string then
		local timer_params = _timer_params
		local timer_color = Color.terminal_text_body_sub_header(255, true)

		timer_params.timer_text = timer_text
		timer_params.timer_color_r = timer_color[2]
		timer_params.timer_color_g = timer_color[3]
		timer_params.timer_color_b = timer_color[4]
		timer_text = Localize(timer_loc_string, true, timer_params)
	end

	self._widgets_by_name.timer_text.content.text = timer_text
	self._widgets_by_name.timer_text.content.visible = time ~= nil
end

ViewElementGrid.setup_sort_button = function (self, options, sort_callback, start_index)
	self._sort_options = options
	self._sort_callback = sort_callback

	local widget = self._widgets_by_name.sort_button

	widget.content.visible = true
	widget.content.hotspot.pressed_callback = callback(self, "_cb_on_sort_button_pressed")
	self._sort_button_input = "hotkey_item_sort"

	if not start_index then
		start_index = 1

		local player = Managers.player:local_player(1)
		local save_manager = Managers.save

		if player and save_manager then
			local account_data = save_manager:account_data()
			local element_view_id = self._element_view_id

			start_index = account_data.selected_sort_options[element_view_id] or 1
		end
	end

	self:_cb_on_sort_button_pressed(start_index)
end

ViewElementGrid.trigger_sort_index = function (self, index)
	self:_cb_on_sort_button_pressed(index)
end

ViewElementGrid._cb_on_sort_button_pressed = function (self, start_index)
	local options = self._sort_options
	local next_index = start_index or self._active_sort_index and math.index_wrapper(self._active_sort_index + 1, #options) or 1
	local next_option = options[next_index] or options[1]
	local sort_display_name = next_option.display_name
	local sort_color = Color.terminal_text_body_sub_header(255, true)
	local text = Localize("loc_inventory_item_grid_sort_format_key", true, {
		sort_color_r = sort_color[2],
		sort_color_g = sort_color[3],
		sort_color_b = sort_color[4],
		name = sort_display_name,
	})

	self._sort_button_text = text

	self:_apply_sort_button_text()

	local player = Managers.player:local_player(1)
	local save_manager = Managers.save

	if player and save_manager then
		local account_data = save_manager:account_data()
		local element_view_id = self._element_view_id

		account_data.selected_sort_options[element_view_id] = next_index

		save_manager:queue_save()
	end

	self._active_sort_index = next_index

	self._sort_callback(next_option)
end

ViewElementGrid._apply_sort_button_text = function (self)
	local text = self._sort_button_text
	local input_action = self._sort_button_input

	if text and input_action then
		if InputDevice.gamepad_active then
			local service_type = "View"
			local color_tint_text = true
			local input_key = InputUtils.input_text_for_current_input_device(service_type, input_action, color_tint_text)

			text = input_key .. " " .. text
		end

		local widget = self._widgets_by_name.sort_button

		widget.content.text = text
		self._update_sort_button_length = true
	end
end

ViewElementGrid.set_sort_button_offset = function (self, x, y)
	local widget = self._widgets_by_name.sort_button
	local scenegraph_id = widget.scenegraph_id

	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position(scenegraph_id, x, y)
end

ViewElementGrid.set_timer_text_offset = function (self, x, y)
	local widget = self._widgets_by_name.timer_text
	local scenegraph_id = widget.scenegraph_id

	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position(scenegraph_id, x, y)
end

ViewElementGrid.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementGrid.set_grid_interaction_offset = function (self, x, y)
	self:_set_scenegraph_position("grid_interaction", x, y)
end

ViewElementGrid.disable_input = function (self, disabled)
	self._input_disabled = disabled
end

ViewElementGrid.input_disabled = function (self)
	return self._input_disabled
end

ViewElementGrid.set_draw_layer = function (self, draw_layer)
	if self._world then
		local world_name = self._unique_id .. "_ui_grid_world"
		local world_layer = 101 + draw_layer

		Managers.world:set_world_layer(world_name, world_layer)
	end

	ViewElementGrid.super.set_draw_layer(self, draw_layer)
end

ViewElementGrid._setup_grid_gui = function (self, optional_world)
	local ui_manager = Managers.ui

	if not optional_world then
		local timer_name = "ui"
		local world_layer = 101 + self._draw_layer
		local world_name = self._unique_id .. "_ui_grid_world"
		local parent = self._parent
		local view_name = parent.view_name

		self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

		local viewport_name = self._unique_id .. "_ui_grid_world_viewport"
		local viewport_type = "overlay"
		local viewport_layer = 1

		self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
		self._viewport_name = viewport_name
	end

	local world = optional_world or self._world
	local renderer_name = self._unique_id .. "_grid_renderer"

	self._ui_grid_renderer = ui_manager:create_renderer(renderer_name, world)

	local gui = self._ui_grid_renderer.gui
	local gui_retained = self._ui_grid_renderer.gui_retained
	local resource_renderer_name = self._unique_id
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"

	self._ui_resource_renderer = ui_manager:create_renderer(resource_renderer_name, world, true, gui, gui_retained, material_name)
end

ViewElementGrid._destroy_grid_gui = function (self)
	if self._ui_resource_renderer then
		local renderer_name = self._unique_id

		self._ui_resource_renderer = nil

		Managers.ui:destroy_renderer(renderer_name)
	end

	if self._ui_grid_renderer then
		self._ui_grid_renderer = nil

		if not self._ui_grid_renderer_is_external then
			Managers.ui:destroy_renderer(self._unique_id .. "_grid_renderer")
		end
	end

	local world = self._world

	if self._world then
		local viewport_name = self._viewport_name

		if viewport_name then
			ScriptWorld.destroy_viewport(world, viewport_name)

			self._viewport_name = nil
		end

		Managers.ui:destroy_world(world)

		self._world = nil
	end
end

ViewElementGrid.update = function (self, dt, t, input_service)
	self._drawn = false

	if self._present_grid_layout then
		self._present_grid_layout()

		self._present_grid_layout = nil
	end

	if self._grid then
		if self._input_disabled then
			input_service = input_service:null_service()
		end

		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)

		local current_scrollbar_progress = self._grid:scrollbar_progress()

		if self._current_scrollbar_progress ~= current_scrollbar_progress then
			self._current_scrollbar_progress = current_scrollbar_progress

			self:update_grid_widgets_visibility()
		end
	end

	return ViewElementGrid.super.update(self, dt, t, input_service)
end

ViewElementGrid.set_color_intensity_multiplier = function (self, color_intensity_multiplier)
	self._color_intensity_multiplier = color_intensity_multiplier or 1
end

ViewElementGrid.set_alpha_multiplier = function (self, alpha_multiplier)
	self._alpha_multiplier = alpha_multiplier or 1
end

ViewElementGrid.alpha_multiplier = function (self)
	return self._alpha_multiplier
end

ViewElementGrid.widgets = function (self)
	return self._grid_widgets
end

ViewElementGrid.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._grid then
		return
	end

	if not self._visible then
		return
	end

	if self._update_sort_button_length then
		self._update_sort_button_length = false

		local widget = self._widgets_by_name.sort_button
		local style = widget.style
		local text_style = style.text
		local text_width, _, _, _ = UIRenderer.text_size(ui_renderer, widget.content.text, text_style.font_type, text_style.font_size)

		self:_set_scenegraph_size("sort_button", text_width + 10)
	end

	if self._input_disabled then
		input_service = input_service:null_service()
	end

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	local ui_scenegraph = self._ui_scenegraph
	local ui_grid_renderer = self._ui_grid_renderer
	local no_resource_rendering = self._no_resource_rendering

	if no_resource_rendering then
		ui_grid_renderer = ui_renderer
	end

	local old_color_intensity_multiplier = render_settings.color_intensity_multiplier
	local color_intensity_multiplier = self._color_intensity_multiplier or 1

	render_settings.color_intensity_multiplier = (old_color_intensity_multiplier or 1) * color_intensity_multiplier

	local old_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = self._alpha_multiplier or 1

	render_settings.alpha_multiplier = (old_alpha_multiplier or 1) * alpha_multiplier

	if not self._ui_grid_renderer_is_external then
		UIRenderer.clear_render_pass_queue(ui_grid_renderer)
	end

	UIRenderer.begin_pass(ui_grid_renderer, ui_scenegraph, input_service, dt, render_settings)

	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]
		local widget_name = widget.name

		if widget_name ~= "grid_background" then
			UIWidget.draw(widget, ui_grid_renderer)
		end
	end

	self:_draw_widgets(dt, t, input_service, ui_grid_renderer, render_settings)
	UIRenderer.end_pass(ui_grid_renderer)

	if not self._resource_renderer_background then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
		UIWidget.draw(self._widgets_by_name.grid_background, ui_renderer)
		UIRenderer.end_pass(ui_renderer)
	end

	self:_draw_grid(dt, t, ui_renderer, input_service, render_settings)

	render_settings.start_layer = previous_layer

	if not no_resource_rendering then
		self:_draw_render_target(render_settings)
	end

	self._drawn = true

	if self._grid then
		local sort_button_input = self._sort_button_input
		local active_sort_index = self._active_sort_index

		if sort_button_input and active_sort_index and input_service:get(sort_button_input) then
			local options = self._sort_options
			local num_options = #options
			local next_index = math.index_wrapper(active_sort_index + 1, num_options)

			self:_cb_on_sort_button_pressed(next_index)
		end
	end

	render_settings.color_intensity_multiplier = old_color_intensity_multiplier
	render_settings.alpha_multiplier = old_alpha_multiplier
end

ViewElementGrid._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	return
end

ViewElementGrid._draw_render_target = function (self, render_settings)
	local ui_grid_renderer = self._ui_grid_renderer
	local resolution_width = RESOLUTION_LOOKUP.width
	local resolution_height = RESOLUTION_LOOKUP.height
	local gui = ui_grid_renderer.gui
	local color = Color(255, 255, 255, 255)
	local ui_resource_renderer = self._ui_resource_renderer
	local material = ui_resource_renderer.render_target_material
	local base_render_pass = ui_resource_renderer.base_render_pass
	local scale = self._render_scale or 1
	local width, height = self:_scenegraph_size("grid_mask")
	local position = self:scenegraph_world_position("grid_mask")
	local start_layer = (render_settings.start_layer or 0) + self._draw_layer
	local gui_position = Vector3(position[1] * scale, position[2] * scale, (position[3] or 0) + start_layer)
	local gui_size = Vector3(width * scale, height * scale, 0)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size, color)
end

ViewElementGrid._draw_grid = function (self, dt, t, ui_renderer, input_service, render_settings)
	local grid = self._grid

	if not grid then
		return
	end

	local widgets = self._grid_widgets
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false

	is_grid_hovered = is_grid_hovered and not self._input_disabled

	local ui_resource_renderer = self._ui_resource_renderer
	local ui_scenegraph = self._ui_scenegraph
	local ui_grid_renderer = self._ui_grid_renderer
	local widget_renderer = ui_resource_renderer
	local no_resource_rendering = self._no_resource_rendering

	if no_resource_rendering then
		ui_grid_renderer = ui_renderer
		widget_renderer = ui_renderer
	end

	if not no_resource_rendering then
		local base_render_pass = ui_resource_renderer.base_render_pass
		local render_target = ui_resource_renderer.render_target

		UIRenderer.add_render_pass(ui_grid_renderer, 0, base_render_pass, true, render_target)
		UIRenderer.add_render_pass(ui_grid_renderer, 1, "to_screen", false)
	end

	local widget_visual_margin = self._widget_visual_margin

	UIRenderer.begin_pass(widget_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._resource_renderer_background then
		UIWidget.draw(self._widgets_by_name.grid_background, widget_renderer)
	end

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget and grid:is_widget_visible(widget, widget.content.extra_margin or widget_visual_margin) then
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end

			UIWidget.draw(widget, widget_renderer)
		end
	end

	UIRenderer.end_pass(widget_renderer)
end

ViewElementGrid._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets
	local content_blueprints = self._content_blueprints

	if widgets then
		local grid = self._grid
		local ui_renderer = self._ui_resource_renderer
		local num_widgets = #widgets
		local widget_visual_margin = self._widget_visual_margin
		local widget_icon_load_margin = self._widget_icon_load_margin

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]
			local content = widget.content
			local previous_visibility_state = content.visible
			local visible = grid:is_widget_visible(widget, content.extra_margin or widget_visual_margin)
			local render_icon = grid:is_widget_visible(widget, widget_icon_load_margin)

			content.visible_last_frame = content.visible
			content.visible = visible
			content.render_icon = render_icon or visible

			if visible or previous_visibility_state ~= visible then
				local update = template and template.update

				if update then
					update(self, widget, input_service, dt, t, ui_renderer, template)
				end
			end
		end
	end
end

ViewElementGrid._destroy_grid = function (self)
	if self._grid then
		self._grid:destroy()

		self._grid = nil
	end
end

ViewElementGrid._destroy_grid_widgets = function (self)
	local widgets = self._grid_widgets
	local content_blueprints = self._content_blueprints

	if widgets then
		local ui_renderer = self._ui_resource_renderer
		local no_resource_rendering = self._no_resource_rendering

		if no_resource_rendering then
			ui_renderer = self._parent:ui_renderer()
		end

		local num_widgets = #widgets

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]
			local destroy = template and template.destroy
			local content = widget.content
			local element = content.element

			if destroy then
				destroy(self, widget, element, ui_renderer)
			end

			UIWidget.destroy(ui_renderer, widget)
		end
	end

	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	self._current_scrollbar_progress = nil
end

ViewElementGrid._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

ViewElementGrid._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name, double_click_callback_name)
	local scenegraph_id = "grid_content_pivot"
	local widget_type = config.widget_type
	local ui_renderer = self._ui_resource_renderer
	local no_resource_rendering = self._no_resource_rendering

	if no_resource_rendering then
		ui_renderer = self._parent:ui_renderer()
	end

	local widget
	local template = self._content_blueprints[widget_type]
	local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, config, ui_renderer) or template.pass_template
	local optional_style_function = template.style_function
	local optional_style = optional_style_function and optional_style_function(self, config, size) or template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

	if widget_definition then
		local name = "widget_" .. suffix

		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, config, callback_name, secondary_callback_name, ui_renderer, double_click_callback_name, template)
		end
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size,
		}
	end
end

ViewElementGrid.update_grid_height = function (self, grid_height, mask_height)
	local menu_settings = self._menu_settings

	menu_settings.grid_size[2] = grid_height or menu_settings.grid_size[2]
	menu_settings.mask_size[2] = mask_height or menu_settings.mask_size[2]

	self:_update_window_size()
end

ViewElementGrid.grid_height = function (self)
	return self._menu_settings.grid_size[2]
end

ViewElementGrid._update_window_size = function (self)
	local menu_settings = self._menu_settings
	local using_title = self._display_name_key ~= nil
	local hide_dividers = menu_settings.hide_dividers
	local ignore_divider_height = menu_settings.ignore_divider_height
	local bottom_divider_height_offset = 16
	local title_top_divider_height_offset = 15
	local grid_height_divider_deduction = (hide_dividers or ignore_divider_height) and 0 or bottom_divider_height_offset + title_top_divider_height_offset
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local edge_padding = menu_settings.edge_padding or 0
	local title_height = menu_settings.title_height - bottom_divider_height_offset
	local scrollbar_vertical_margin = menu_settings.scrollbar_vertical_margin or 0
	local scrollbar_vertical_offset = menu_settings.scrollbar_vertical_offset or 0
	local scrollbar_horizontal_offset = menu_settings.scrollbar_horizontal_offset or 0
	local top_padding = menu_settings.top_padding or 0
	local active_grid_size = using_title and {
		grid_size[1],
		grid_size[2] - title_height - grid_height_divider_deduction,
	} or {
		grid_size[1],
		grid_size[2] - grid_height_divider_deduction,
	}
	local active_mask_size = using_title and {
		mask_size[1],
		mask_size[2] - title_height - grid_height_divider_deduction,
	} or {
		mask_size[1],
		mask_size[2] - grid_height_divider_deduction,
	}

	self:_set_scenegraph_size("grid_title_background", active_grid_size[1] + edge_padding, using_title and title_height or 0)
	self:_set_scenegraph_size("grid_background", active_grid_size[1] + edge_padding, active_grid_size[2])
	self:_set_scenegraph_size("grid_mask", active_mask_size[1], active_mask_size[2] - top_padding)
	self:_set_scenegraph_size("grid_interaction", active_mask_size[1], active_mask_size[2] - top_padding)

	if self._use_horizontal_scrollbar then
		self:_set_scenegraph_size("grid_scrollbar", active_mask_size[1] - 20 - scrollbar_vertical_margin, nil)
	else
		self:_set_scenegraph_size("grid_scrollbar", nil, active_mask_size[2] - 40 - scrollbar_vertical_margin)
	end

	self:_set_scenegraph_position("grid_scrollbar", scrollbar_horizontal_offset or 0, scrollbar_vertical_offset or 0)
	self:_set_scenegraph_position("grid_mask", nil, top_padding and top_padding * 0.5 or 0)
	self:_set_scenegraph_position("grid_background", nil, using_title and title_height or 0)

	if self._grid then
		self._grid:force_update_list_size()
	end
end

ViewElementGrid._assign_display_name = function (self, display_name)
	local use_title = display_name ~= nil
	local widgets_by_name = self._widgets_by_name
	local title_text = ""

	self._display_name_key = display_name

	if use_title then
		local title_formatting = self._menu_settings.title_formatting

		if title_formatting == "title_case" then
			title_text = Text.localize_to_title_case(display_name)
		elseif title_formatting == "upper_case" then
			title_text = Text.localize_to_upper(display_name)
		else
			title_text = Localize(display_name)
		end
	end

	widgets_by_name.title_text.content.text = title_text
	widgets_by_name.title_text.content.visible = use_title
	widgets_by_name.grid_title_background.content.visible = use_title
	widgets_by_name.grid_divider_title.content.visible = use_title
end

ViewElementGrid.present_grid_layout = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction, optional_on_present_callback, optional_left_double_click_callback)
	if self._drawn and self._grid then
		self._present_grid_layout = callback(function ()
			if not self._destroyed then
				self:_on_present_grid_layout_changed(layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction, optional_left_double_click_callback)

				if optional_on_present_callback then
					optional_on_present_callback()
				end
			end
		end)

		return
	else
		self:_on_present_grid_layout_changed(layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction, optional_left_double_click_callback)

		if optional_on_present_callback then
			optional_on_present_callback()
		end
	end
end

ViewElementGrid._on_present_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction, optional_left_double_click_callback)
	self:_destroy_grid_widgets()
	self:_assign_display_name(display_name)
	self:_hide_empty_message()

	self._visible_grid_layout = layout
	self._content_blueprints = content_blueprints
	self._left_click_callback = left_click_callback
	self._right_click_callback = right_click_callback
	self._left_double_click_callback = optional_left_double_click_callback

	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_left_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"
	local double_click_callback_name = optional_left_double_click_callback and "cb_on_grid_entry_double_click_pressed"
	local previous_group_header_name
	local group_header_index = 0

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local widget, alignment_widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name, double_click_callback_name)

		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget

		if widget then
			if entry.widget_type == "group_header" then
				group_header_index = group_header_index + 1
				previous_group_header_name = "group_header_" .. group_header_index
			end

			widget.content.group_header = previous_group_header_name
			widget.content.entry = entry
		end
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets

	local menu_settings = self._menu_settings
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = menu_settings.grid_spacing
	local grid_direction = optional_grow_direction or "down"
	local use_select_on_focused = menu_settings.use_select_on_focused
	local use_is_focused_for_navigation = menu_settings.use_is_focused_for_navigation
	local bottom_chin = menu_settings.bottom_chin or 0
	local top_padding = menu_settings.top_padding or 0
	local scroll_start_margin = menu_settings.scroll_start_margin or 0
	local grid = UIWidgetGrid:new(self._grid_widgets, self._grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation, use_select_on_focused, bottom_chin, top_padding, scroll_start_margin)

	self._grid = grid

	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_enable_gamepad_scrolling(menu_settings.enable_gamepad_scrolling)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(100)
	self:_update_window_size()
	self:_on_navigation_input_changed()

	if #self._grid_widgets == 0 then
		self:_show_empty_message()
	end
end

ViewElementGrid.set_enable_gamepad_scrolling = function (self, enable_gamepad_scrolling)
	local menu_settings = self._menu_settings

	menu_settings.enable_gamepad_scrolling = enable_gamepad_scrolling

	self._grid:set_enable_gamepad_scrolling(enable_gamepad_scrolling)
end

ViewElementGrid.is_gamepad_scrolling_enabled = function (self)
	local menu_settings = self._menu_settings

	return menu_settings.enable_gamepad_scrolling
end

ViewElementGrid.grid_scrollbar = function (self)
	return self._widgets_by_name.grid_scrollbar
end

ViewElementGrid._show_empty_message = function (self)
	self._widgets_by_name.grid_empty.content.visible = true
end

ViewElementGrid._hide_empty_message = function (self)
	self._widgets_by_name.grid_empty.content.visible = false
end

ViewElementGrid.set_empty_message = function (self, text)
	if text then
		self._widgets_by_name.grid_empty.content.text = text
	end
end

ViewElementGrid.set_handle_grid_navigation = function (self, allow)
	local grid = self._grid

	grid:set_handle_grid_navigation(allow)
end

ViewElementGrid.set_loading_state = function (self, is_loading)
	self._widgets_by_name.grid_loading.content.is_loading = is_loading

	if is_loading then
		self:_hide_empty_message()
	end
end

ViewElementGrid.update_dividers_alpha = function (self, top_alpha, bottom_alpha)
	self._widgets_by_name.grid_divider_top.alpha_multiplier = top_alpha
	self._widgets_by_name.grid_divider_bottom.alpha_multiplier = bottom_alpha
end

ViewElementGrid.update_dividers = function (self, top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)
	if top_divider_material then
		self._widgets_by_name.grid_divider_top.content.texture = top_divider_material
	end

	if top_divider_size then
		self._widgets_by_name.grid_divider_top.style.texture.size = top_divider_size
	end

	if top_divider_position then
		self._widgets_by_name.grid_divider_top.style.texture.offset = top_divider_position
	end

	if bottom_divider_material then
		self._widgets_by_name.grid_divider_bottom.content.texture = bottom_divider_material
	end

	if bottom_divider_size then
		self._widgets_by_name.grid_divider_bottom.style.texture.size = bottom_divider_size
	end

	if bottom_divider_position then
		self._widgets_by_name.grid_divider_bottom.style.texture.offset = bottom_divider_position
	end
end

ViewElementGrid.widget_by_name = function (self, widget_name)
	return self._widgets_by_name[widget_name]
end

ViewElementGrid.focus_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	local grid = self._grid

	grid:focus_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ViewElementGrid.focused_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:focused_grid_index()
	end
end

ViewElementGrid.focused_grid_widget = function (self)
	local grid = self._grid

	if grid then
		local focused_index = grid:focused_grid_index()
		local widgets = self._grid_widgets
		local widget = widgets[focused_index]

		return widget
	end
end

ViewElementGrid.select_grid_widget = function (self, widget, scrollbar_animation_progress, instant_scroll)
	local grid = self._grid
	local index = grid:index_by_widget(widget)

	grid:select_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ViewElementGrid.select_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	local grid = self._grid

	grid:select_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ViewElementGrid.select_first_index = function (self)
	local grid = self._grid
	local selected_grid_index = grid:select_first_index()

	return selected_grid_index
end

ViewElementGrid.selected_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:selected_grid_index()
	end
end

ViewElementGrid.widget_index = function (self, widget)
	local grid = self._grid

	if grid then
		return grid:index_by_widget(widget)
	end
end

ViewElementGrid.widget_by_index = function (self, index)
	local grid = self._grid

	if grid then
		return grid:widget_by_index(index)
	end
end

ViewElementGrid.first_interactable_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:first_interactable_grid_index()
	end
end

ViewElementGrid.last_interactable_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:last_interactable_grid_index()
	end
end

ViewElementGrid.selected_grid_widget = function (self)
	local grid = self._grid

	if grid then
		local selected_index = grid:selected_grid_index()
		local widgets = self._grid_widgets
		local widget = widgets[selected_index]

		return widget
	end
end

ViewElementGrid.force_update_list_size = function (self)
	self:_update_window_size()

	local grid = self._grid

	if grid then
		grid:force_update_list_size()

		local selected_index = grid:selected_grid_index()

		if selected_index then
			grid:clear_scroll_progress()
			self:scroll_to_grid_index(selected_index)
		end
	end
end

ViewElementGrid.get_scrollbar_percentage_by_index = function (self, index, start_from_bottom)
	return self._grid:get_scrollbar_percentage_by_index(index, start_from_bottom)
end

ViewElementGrid.scroll_to_grid_index = function (self, index, instant_scroll, start_from_bottom)
	local grid = self._grid
	local scroll_progress = grid:get_scrollbar_percentage_by_index(index, start_from_bottom)

	grid:set_scrollbar_progress(scroll_progress, not instant_scroll)
end

ViewElementGrid.scroll_to_grid_widget = function (self, widget, instant_scroll, start_from_bottom)
	local grid = self._grid
	local index = grid:index_by_widget(widget)
	local scroll_progress = grid:get_scrollbar_percentage_by_index(index, start_from_bottom)

	grid:set_scrollbar_progress(scroll_progress, not instant_scroll)
end

ViewElementGrid.scrollbar_progress = function (self)
	local grid = self._grid

	return grid:scrollbar_progress()
end

ViewElementGrid.set_scrollbar_progress = function (self, scroll_progress, instant_scroll)
	local grid = self._grid

	return grid:set_scrollbar_progress(scroll_progress, not instant_scroll)
end

ViewElementGrid._on_navigation_input_changed = function (self)
	ViewElementGrid.super._on_navigation_input_changed(self)
	self:_apply_sort_button_text()

	local grid = self._grid

	if grid and self._reset_selection_on_navigation_change then
		if not self._using_cursor_navigation then
			if not grid:selected_grid_index() then
				grid:select_first_index()
			end
		elseif grid:selected_grid_index() then
			grid:select_grid_index(nil)
		end
	end
end

ViewElementGrid.cb_on_grid_entry_right_pressed = function (self, widget, element)
	if self._right_click_callback then
		self._right_click_callback(widget, element)
	end
end

ViewElementGrid.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if self._left_click_callback then
		self._left_click_callback(widget, element)
	end
end

ViewElementGrid.cb_on_grid_entry_double_click_pressed = function (self, widget, element)
	if self._left_double_click_callback then
		self._left_double_click_callback(widget, element)
	end
end

ViewElementGrid.update_grid_widgets_visibility = function (self)
	local widgets = self._grid_widgets

	if widgets then
		local ui_renderer = self._ui_resource_renderer
		local no_resource_rendering = self._no_resource_rendering

		if no_resource_rendering then
			ui_renderer = self._parent:ui_renderer()
		end

		local content_blueprints = self._content_blueprints
		local num_widgets = #widgets
		local update_visible_icon_prioritization_load = false

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible
				local render_icon = content.render_icon or visible

				if not render_icon and template.unload_icon then
					template.unload_icon(self, widget, element, ui_renderer)
				end
			end
		end

		for i = num_widgets, 1, -1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible
				local visible_last_frame = content.visible_last_frame
				local render_icon = content.render_icon or visible

				if render_icon and template.load_icon then
					local prioritize = visible

					if content.icon_load_id and visible and not visible_last_frame then
						update_visible_icon_prioritization_load = true
					end

					local profile = self._item_icon_profile

					template.load_icon(self, widget, element, ui_renderer, profile, prioritize)

					local icon_load_id = content.icon_load_id

					if icon_load_id and self._cache_loaded_icons and not self._loaded_icon_id_cache[icon_load_id] then
						self._loaded_icon_id_cache[icon_load_id] = Managers.ui:increment_item_icon_load_by_existing_id(icon_load_id)
					end
				end
			end
		end

		if update_visible_icon_prioritization_load then
			for j = #widgets, 1, -1 do
				local widget = widgets[j]
				local widget_type = widget.type
				local template = content_blueprints[widget_type]
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if visible and template.update_item_icon_priority then
					template.update_item_icon_priority(self, widget, element, ui_renderer)
				end
			end
		end
	end
end

ViewElementGrid.set_default_item_icon_profile = function (self, profile)
	self._item_icon_profile = profile
end

ViewElementGrid.remove_widget = function (self, widget)
	self._grid:remove_widget(widget)

	if widget.name then
		self:_unregister_widget_name(widget.name)
	end
end

ViewElementGrid.grid = function (self)
	return self._grid
end

ViewElementGrid.destroy = function (self, ui_renderer)
	if self._present_grid_layout then
		self._present_grid_layout = nil
	end

	for _, icon_reference_id in pairs(self._loaded_icon_id_cache) do
		Managers.ui:unload_item_icon(icon_reference_id)
	end

	self._loaded_icon_id_cache = nil

	local ui_grid_renderer = self._ui_grid_renderer

	if ui_grid_renderer then
		local widgets = self._widgets
		local num_widgets = #widgets

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if widget_name ~= "grid_background" then
				UIWidget.destroy(ui_grid_renderer, widget)
			end
		end
	end

	self:_destroy_grid_widgets()
	self:_destroy_grid_gui()
	ViewElementGrid.super.destroy(self)
end

ViewElementGrid.element_by_index = function (self, index)
	local widgets = self._grid_widgets

	if widgets then
		local widget = widgets[index]

		if widget then
			local content = widget.content
			local element = content.element

			return element
		end
	end
end

ViewElementGrid.index_by_element = function (self, element)
	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local content = widget.content

			if content.element == element then
				return i
			end
		end
	end
end

ViewElementGrid.grid_length = function (self)
	local grid = self._grid

	if grid then
		return grid:length()
	end
end

ViewElementGrid.menu_settings = function (self)
	return self._menu_settings
end

ViewElementGrid.sort_button_widget = function (self)
	return self._widgets_by_name.sort_button
end

ViewElementGrid.sort_button_scenegpraph = function (self)
	return self._ui_scenegraph.sort_button
end

ViewElementGrid.get_sort_button_world_position = function (self)
	local widget = self._widgets_by_name.sort_button
	local scenegraph_id = widget.scenegraph_id

	return self:scenegraph_world_position(scenegraph_id)
end

ViewElementGrid.force_update_list_size_keeping_scroll = function (self)
	local grid = self._grid
	local current_scroll = grid:length_scrolled()

	self:force_update_list_size()
	self:set_scrollbar_progress(current_scroll / grid:scroll_length(), true)
end

ViewElementGrid.hovered_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:hovered_grid_index()
	end
end

ViewElementGrid.hovered_widget = function (self)
	local grid = self._grid

	if grid then
		local hovered_index = grid:hovered_grid_index()
		local widgets = self._grid_widgets
		local widget = widgets[hovered_index]

		return widget
	end
end

ViewElementGrid.set_background_hovered = function (self, hovered)
	local grid_background = self._widgets_by_name.grid_background

	if grid_background then
		grid_background.content.hovered = hovered
	end
end

ViewElementGrid.hovered = function (self)
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = self._using_cursor_navigation and (interaction_widget.content.hotspot.is_hover or false)

	is_grid_hovered = is_grid_hovered and not self._input_disabled

	return is_grid_hovered
end

ViewElementGrid.pressed = function (self)
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local on_pressed = interaction_widget.content.hotspot.on_pressed or false
	local on_right_pressed = interaction_widget.content.hotspot.on_right_pressed or false

	on_pressed = on_pressed and not self._input_disabled
	on_right_pressed = on_right_pressed and not self._input_disabled

	return on_pressed, on_right_pressed
end

ViewElementGrid.select = function (self)
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction

	interaction_widget.content.hotspot.is_selected = true
end

ViewElementGrid.unselect = function (self)
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction

	interaction_widget.content.hotspot.is_selected = false
end

ViewElementGrid.selected = function (self)
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction

	if interaction_widget.content.hotspot.is_selected == nil then
		return false
	end

	return interaction_widget.content.hotspot.is_selected
end

return ViewElementGrid
