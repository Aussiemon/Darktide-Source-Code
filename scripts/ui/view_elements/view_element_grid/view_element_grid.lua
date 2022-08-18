local create_definitions_function = require("scripts/ui/view_elements/view_element_grid/view_element_grid_definitions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementGridSettings = require("scripts/ui/view_elements/view_element_grid/view_element_grid_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Text = require("scripts/utilities/ui/text")
local ViewElementGrid = class("ViewElementGrid", "ViewElementBase")

ViewElementGrid.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementGridSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementGridSettings
	end

	self._loaded_item_icons_info = {}
	self._pivot_offset = {
		0,
		0
	}
	local definitions = create_definitions_function(self._menu_settings)

	ViewElementGrid.super.init(self, parent, draw_layer, start_scale, definitions)
	self:_setup_grid_gui()

	self._widgets_by_name.sort_button.content.visible = false
	self._widgets_by_name.timer_text.content.visible = false
	self._input_disabled = false
end

local _timer_params = {}

ViewElementGrid.set_expire_time = function (self, time)
	local timer_text = (time and Text.format_time_span_long_form_localized(time)) or ""
	local timer_loc_string = self._menu_settings.timer_loc_string

	if timer_loc_string then
		local timer_params = _timer_params
		timer_params.timer_text = timer_text
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

	self:_cb_on_sort_button_pressed(start_index)
end

ViewElementGrid.trigger_sort_index = function (self, index)
	self:_cb_on_sort_button_pressed(index)
end

ViewElementGrid._cb_on_sort_button_pressed = function (self, start_index)
	local options = self._sort_options
	local next_index = start_index or (self._active_sort_index and math.index_wrapper(self._active_sort_index + 1, #options)) or 1
	local next_option = options[next_index]
	local input_action = next_option.input_action
	local sort_display_name = next_option.display_name
	local text = Localize("loc_inventory_item_grid_sort_format_key", true, {
		name = Localize(sort_display_name)
	})
	local widget = self._widgets_by_name.sort_button
	widget.content.text = text
	self._active_sort_index = next_index

	self._sort_callback(next_option)
end

ViewElementGrid.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementGrid.disable_input = function (self, disabled)
	self._input_disabled = disabled
end

ViewElementGrid._setup_grid_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 101
	local world_name = self._unique_id .. "_ui_grid_world"
	local parent = self._parent
	local view_name = parent.view_name
	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = self._unique_id .. "_ui_grid_world_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1
	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	local renderer_name = self._unique_id .. "_grid_renderer"
	self._ui_grid_renderer = ui_manager:create_renderer(renderer_name, self._world)
	local gui = self._ui_grid_renderer.gui
	local gui_retained = self._ui_grid_renderer.gui_retained
	local resource_renderer_name = self._unique_id .. "_grid_renderer_resource"
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"
	self._ui_resource_renderer = ui_manager:create_renderer(resource_renderer_name, self._world, true, gui, gui_retained, material_name)
end

ViewElementGrid._destroy_grid_gui = function (self)
	if self._ui_resource_renderer then
		local renderer_name = self._unique_id .. "_grid_renderer_resource"
		self._ui_resource_renderer = nil

		Managers.ui:destroy_renderer(renderer_name)
	end

	if self._ui_grid_renderer then
		self._ui_grid_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_grid_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

ViewElementGrid.update = function (self, dt, t, input_service)
	if self._grid then
		if self._input_disabled then
			input_service = input_service:null_service()
		end

		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)

		local current_scrollbar_progress = self._grid:scrollbar_progress()

		if self._current_scrollbar_progress ~= current_scrollbar_progress then
			self._current_scrollbar_progress = current_scrollbar_progress

			self:_update_grid_widgets_visibility()
		end
	end

	return ViewElementGrid.super.update(self, dt, t, input_service)
end

ViewElementGrid.widgets = function (self)
	return self._grid_widgets
end

ViewElementGrid.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._grid then
		return
	end

	if self._input_disabled then
		input_service = input_service:null_service()
	end

	ViewElementGrid.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	self:_draw_grid(dt, t, input_service)
	self:_draw_render_target()
end

ViewElementGrid._draw_render_target = function (self)
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
	local size = {
		width,
		height
	}
	local gui_position = Vector3(position[1] * scale, position[2] * scale, position[3] or 0)
	local gui_size = Vector3(size[1] * scale, size[2] * scale, size[3] or 0)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size, color)
end

ViewElementGrid._draw_grid = function (self, dt, t, input_service)
	local grid = self._grid

	if not grid then
		return
	end

	local widgets = self._grid_widgets
	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	is_grid_hovered = is_grid_hovered and not self._input_disabled
	local render_settings = self._render_settings
	local ui_renderer = self._ui_grid_renderer
	local ui_resource_renderer = self._ui_resource_renderer
	local ui_scenegraph = self._ui_scenegraph
	local gui = ui_renderer.gui
	local base_render_pass = ui_resource_renderer.base_render_pass
	local render_target = ui_resource_renderer.render_target

	Gui.render_pass(gui, 0, base_render_pass, true, render_target)
	Gui.render_pass(gui, 1, "to_screen", false)
	UIRenderer.begin_pass(ui_resource_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets, 1 do
		local widget = widgets[i]

		if widget and grid:is_widget_visible(widget) then
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end

			UIWidget.draw(widget, ui_resource_renderer)
		end
	end

	UIRenderer.end_pass(ui_resource_renderer)
end

ViewElementGrid._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets
	local content_blueprints = self._content_blueprints

	if widgets then
		local grid = self._grid
		local ui_renderer = self._ui_resource_renderer
		local num_widgets = #widgets

		for i = 1, num_widgets, 1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]
			local update = template and template.update
			local content = widget.content
			local visible = grid:is_widget_visible(widget)
			content.visible = visible

			if update then
				update(self, widget, input_service, dt, t, ui_renderer)
			end
		end
	end
end

ViewElementGrid._destroy_grid_widgets = function (self)
	local widgets = self._grid_widgets
	local content_blueprints = self._content_blueprints

	if widgets then
		local ui_renderer = self._ui_resource_renderer
		local num_widgets = #widgets

		for i = 1, num_widgets, 1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]
			local destroy = template and template.destroy
			local content = widget.content
			local element = content.element

			if destroy then
				destroy(self, widget, element, ui_renderer)
			end
		end
	end

	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	self._current_scrollbar_progress = nil
end

ViewElementGrid._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets, 1 do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

ViewElementGrid._create_entry_widget_from_config = function (self, config, suffix, callback_name, secondary_callback_name)
	local scenegraph_id = "grid_content_pivot"
	local widget_type = config.widget_type
	local parent = self._parent
	local ui_renderer = parent._ui_renderer
	local widget = nil
	local template = self._content_blueprints[widget_type]

	fassert(template, "[ViewElementGrid] - Could not find content blueprint for type: %s", widget_type)

	local size = (template.size_function and template.size_function(self, config)) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = (pass_template_function and pass_template_function(self, config)) or template.pass_template
	local optional_style = template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

	if widget_definition then
		local name = "widget_" .. suffix
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type
		local init = template.init

		if init then
			init(self, widget, config, callback_name, secondary_callback_name, ui_renderer)
		end
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size
		}
	end
end

ViewElementGrid._update_window_size = function (self)
	local menu_settings = self._menu_settings
	local using_title = self._display_name_key ~= nil
	local bottom_divider_height_offset = 16
	local title_top_divider_height_offset = 15
	local grid_height_divider_deduction = bottom_divider_height_offset + title_top_divider_height_offset
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local title_height = menu_settings.title_height - bottom_divider_height_offset
	local scrollbar_vertical_margin = menu_settings.scrollbar_vertical_margin or 0

	if not using_title or not {
		[2] = grid_size[2] - title_height - grid_height_divider_deduction
	} then
		local active_grid_size = {
			grid_size[1],
			grid_size[2] - grid_height_divider_deduction
		}
	end

	if not using_title or not {
		[2] = mask_size[2] - title_height - grid_height_divider_deduction
	} then
		local active_mask_size = {
			mask_size[1],
			mask_size[2] - grid_height_divider_deduction
		}
	end

	self:_set_scenegraph_size("grid_title_background", nil, (using_title and title_height) or 0)
	self:_set_scenegraph_size("grid_background", nil, active_grid_size[2])
	self:_set_scenegraph_size("grid_mask", nil, active_mask_size[2])
	self:_set_scenegraph_size("grid_interaction", nil, active_mask_size[2])
	self:_set_scenegraph_size("grid_scrollbar", nil, active_mask_size[2] - 20 - scrollbar_vertical_margin)
	self:_set_scenegraph_position("grid_background", nil, (using_title and title_height) or 0)
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

	self:_update_window_size()
end

ViewElementGrid.present_grid_layout = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name)
	self:_destroy_grid_widgets()
	self:_assign_display_name(display_name)

	self._visible_grid_layout = layout
	self._content_blueprints = content_blueprints
	self._left_click_callback = left_click_callback
	self._right_click_callback = right_click_callback
	local widgets = {}
	local alignment_widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_left_pressed"
	local right_click_callback_name = "cb_on_grid_entry_right_pressed"
	local previous_group_header_name = nil
	local group_header_index = 0
	local widget_index = 1

	for index, entry in ipairs(layout) do
		local widget_suffix = "entry_" .. tostring(index)
		local widget, alignment_widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name, right_click_callback_name)
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget

		if widget then
			if entry.widget_type == "group_header" then
				group_header_index = group_header_index + 1
				previous_group_header_name = "group_header_" .. group_header_index
			end

			widget.content.group_header = previous_group_header_name
			entry.widget_index = widget_index
			widget_index = widget_index + 1
		end
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local menu_settings = self._menu_settings
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = menu_settings.grid_spacing
	local grid_direction = "down"
	local use_is_focused_for_navigation = menu_settings.use_is_focused_for_navigation
	local grid = UIWidgetGrid:new(self._grid_widgets, self._grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation)
	self._grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(100)
end

ViewElementGrid.focus_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	local grid = self._grid

	grid:focus_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ViewElementGrid.select_grid_index = function (self, index, scrollbar_animation_progress, instant_scroll)
	local grid = self._grid

	grid:select_grid_index(index, scrollbar_animation_progress, instant_scroll)
end

ViewElementGrid.select_first_index = function (self)
	local grid = self._grid

	grid:select_first_index()
end

ViewElementGrid.selected_grid_index = function (self)
	local grid = self._grid

	if grid then
		return grid:selected_grid_index()
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
	local grid = self._grid

	grid:force_update_list_size()

	local selected_index = grid:selected_grid_index()

	if selected_index then
		self:scroll_to_grid_index(selected_index)
	end
end

ViewElementGrid.get_scrollbar_percentage_by_index = function (self, index)
	return self._grid:get_scrollbar_percentage_by_index(index)
end

ViewElementGrid.scroll_to_grid_index = function (self, index, instant_scroll)
	local grid = self._grid
	local scroll_progress = grid:get_scrollbar_percentage_by_index(index)

	grid:set_scrollbar_progress(scroll_progress, not instant_scroll)
end

ViewElementGrid._on_navigation_input_changed = function (self)
	ViewElementGrid.super._on_navigation_input_changed(self)

	local grid = self._grid

	if grid then
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

ViewElementGrid._update_grid_widgets_visibility = function (self)
	local widgets = self._grid_widgets

	if widgets then
		local num_widgets = #widgets
		local ui_renderer = self._ui_resource_renderer
		local content_blueprints = self._content_blueprints

		for i = 1, num_widgets, 1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if not visible and template.unload_icon then
					template.unload_icon(self, widget, element, ui_renderer)
				end
			end
		end

		for i = 1, num_widgets, 1 do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if visible and template.load_icon then
					template.load_icon(self, widget, element, ui_renderer)
				end
			end
		end
	end
end

ViewElementGrid.remove_widget = function (self, widget)
	self._grid:remove_widget(widget)
end

ViewElementGrid.destroy = function (self)
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

return ViewElementGrid
