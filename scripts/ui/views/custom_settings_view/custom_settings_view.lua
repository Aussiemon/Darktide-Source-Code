-- chunkname: @scripts/ui/views/custom_settings_view/custom_settings_view.lua

local Definitions = require("scripts/ui/views/custom_settings_view/custom_settings_view_definitions")
local ContentBlueprints = require("scripts/ui/views/options_view/options_view_content_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local OptionsViewSettings = require("scripts/ui/views/options_view/options_view_settings")
local custom_settings_view_settings = require("scripts/ui/views/custom_settings_view/custom_settings_view_settings")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local settings_grid_width = custom_settings_view_settings.settings_grid_width
local scrollbar_width = custom_settings_view_settings.scrollbar_width
local grid_height_max = custom_settings_view_settings.grid_height
local grid_blur_edge_size = custom_settings_view_settings.grid_blur_edge_size
local CustomSettingsView = class("CustomSettingsView", "BaseView")

CustomSettingsView.init = function (self, settings, context)
	self._current_settings_widgets = {}
	self._current_settings_alignment = {}
	self._current_index = 1
	self._pages = context.pages
	self._can_exit_view = context and context.can_exit

	CustomSettingsView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = false
	self._grid = nil
	self._offscreen_world = nil
	self._offscreen_viewport = nil
	self._offscreen_viewport_name = nil
	self._awaiting_input_release = false

	self:_setup_offscreen_gui()
end

CustomSettingsView.on_enter = function (self)
	if not self._pages then
		return Managers.ui:close_view("custom_settings_view", true)
	end

	CustomSettingsView.super.on_enter(self)

	self._awaiting_input_release = true
	self._open_input_released = nil

	self:_enable_settings_overlay(false)
	self:_setup_buttons_interactions()
	self:_setup_input_legend()
	self:_change_settings_page(1)
end

CustomSettingsView.on_exit = function (self)
	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_offscreen_renderer")

		local offscreen_world = self._offscreen_world
		local offscreen_viewport_name = self._offscreen_viewport_name

		ScriptWorld.destroy_viewport(offscreen_world, offscreen_viewport_name)
		Managers.ui:destroy_world(offscreen_world)

		self._offscreen_viewport = nil
		self._offscreen_viewport_name = nil
		self._offscreen_world = nil
	end

	CustomSettingsView.super.on_exit(self)
end

CustomSettingsView.on_resolution_modified = function (self)
	CustomSettingsView.super.on_resolution_modified(self)

	local grid = self._grid

	if grid then
		grid:on_resolution_modified(self._render_scale)
	end
end

CustomSettingsView.settings_grid_length = function (self)
	local grid = self._grid

	if grid then
		local scroll_length = grid:scroll_length()
		local total_length = grid:length()
		local area_length = grid:area_length()

		return math.max(total_length - scroll_length, area_length)
	end

	return 0
end

CustomSettingsView.settings_scroll_amount = function (self)
	local grid = self._grid

	if grid then
		local scroll_progress = grid:scrollbar_progress()
		local scroll_length = grid:scroll_length()

		return scroll_length * scroll_progress
	end

	return 0
end

CustomSettingsView._setup_buttons_interactions = function (self)
	self._widgets_by_name.next_button.content.hotspot.pressed_callback = callback(self, "_on_forward_pressed")
end

CustomSettingsView._setup_input_legend = function (self)
	local legend_inputs = self._definitions.legend_inputs

	if not legend_inputs then
		return
	end

	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback

		if legend_input.on_pressed_callback then
			on_pressed_callback = callback(self, legend_input.on_pressed_callback)
		end

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

CustomSettingsView.should_show_close_legend = function (self)
	if not self._can_exit_view then
		return false
	end

	return true
end

CustomSettingsView.cb_on_back_pressed = function (self)
	if self._selected_settings_widget then
		self._close_selected_setting = true

		return
	end

	if not self._can_exit_view then
		return
	end

	Managers.ui:close_view(self.view_name)
end

CustomSettingsView._consume_held_open_input = function (self, input_service)
	if not self._awaiting_input_release then
		return input_service
	end

	if not input_service:get("confirm_hold") and not input_service:get("left_hold") then
		self._open_input_released = true
	end

	return input_service:null_service()
end

CustomSettingsView._sync_grid_hotspot_focus = function (self)
	local widgets = self._current_settings_widgets

	if not widgets then
		return
	end

	local selected_index = self._grid and self._grid:selected_grid_index()

	if Managers.ui:using_cursor_navigation() then
		selected_index = nil
	end

	for i = 1, #widgets do
		local hotspot = widgets[i].content.hotspot

		if hotspot then
			local selected = i == selected_index

			hotspot.is_selected = selected
			hotspot.is_focused = selected
		end
	end
end

CustomSettingsView._change_settings_page = function (self, next_index)
	if next_index > #self._pages then
		Managers.ui:close_view(self.view_name)
		Managers.event:trigger("event_custom_settings_closed")

		return
	end

	if self._pages[self._current_index] and self._pages[self._current_index].on_leave then
		self._pages[self._current_index].on_leave(self)
	end

	local settings_title = self._pages[next_index].title
	local title_widget = self._widgets_by_name.title_settings
	local page_number_widget = self._widgets_by_name.page_number
	local next_button_widget = self._widgets_by_name.next_button

	if self._pages[next_index] and self._pages[next_index].on_enter then
		self._pages[next_index].on_enter(self)
	end

	self._current_index = next_index
	title_widget.content.text = settings_title or ""
	next_button_widget.content.original_text = self._current_index < #self._pages and Utf8.upper(Localize("loc_next")) or Utf8.upper(Localize("loc_confirm"))
	page_number_widget.content.text = self._current_index .. " / " .. #self._pages
	page_number_widget.content.visible = #self._pages > 3

	self:_setup_page_grid(self._pages[next_index].widgets)

	self._ui_scenegraph.next_button.horizontal_alignment = self._pages[next_index].next_button_alignment or "center"
end

CustomSettingsView.cb_on_settings_pressed = function (self, widget, entry)
	if not self._can_close or self._selected_settings_widget or self._navigation_column_changed_this_frame then
		return
	end

	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end

	if self._selected_settings_widget then
		local selected_widget = self._selected_settings_widget

		selected_widget.offset[3] = 0

		local dependent_focus_ids = selected_widget.content and selected_widget.content.entry and selected_widget.content.entry.dependent_focus_ids

		if dependent_focus_ids then
			for i = 1, #dependent_focus_ids do
				local id = dependent_focus_ids[i]

				self._current_settings_widgets_by_id[id].offset[3] = 0
			end
		end
	end

	if not entry.ignore_focus then
		local widget_name = widget.name
		local selected_widget = self:_set_exclusive_focus_on_grid_widget(widget_name)

		if selected_widget then
			selected_widget.offset[3] = 90

			local dependent_focus_ids = selected_widget.content.entry and selected_widget.content.entry.dependent_focus_ids

			if dependent_focus_ids then
				for i = 1, #dependent_focus_ids do
					local id = dependent_focus_ids[i]

					self._current_settings_widgets_by_id[id].offset[3] = 90
				end
			end
		end
	end
end

CustomSettingsView._update_settings_widgets = function (self, dt, t, input_service)
	local settings = self._current_settings_widgets

	if not settings then
		return
	end

	local grid = self._grid
	local selected_settings_widget = self._selected_settings_widget
	local blur_margin = grid_blur_edge_size[2]

	for i = 1, #settings do
		local widget = settings[i]

		if widget then
			local visible = not grid or grid:is_widget_visible(widget, blur_margin)

			if visible or widget == selected_settings_widget then
				local widget_type = widget.type
				local template = ContentBlueprints[widget_type]
				local update = template and template.update

				if update then
					update(self, widget, input_service, dt, t)
				end
			end
		end
	end

	if selected_settings_widget and self._close_selected_setting then
		self:_set_exclusive_focus_on_grid_widget(nil)

		self._close_selected_setting = nil
	end
end

CustomSettingsView._on_forward_pressed = function (self)
	local index = self._current_index + 1

	self:_change_settings_page(index)
end

CustomSettingsView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name

	self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen_2"
	local viewport_layer = 1
	local shading_environment = OptionsViewSettings.shading_environment

	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._offscreen_world)
end

CustomSettingsView.draw = function (self, dt, t, input_service, layer)
	input_service = self:_consume_held_open_input(input_service)

	if self._current_settings_widgets then
		self:_draw_grid(dt, t, input_service)
	end

	local pass_input, pass_draw = CustomSettingsView.super.draw(self, dt, t, input_service, layer)

	return pass_input, pass_draw
end

CustomSettingsView._draw_grid = function (self, dt, t, input_service)
	local widgets = self._current_settings_widgets
	local grid = self._grid
	local ui_renderer = self._ui_offscreen_renderer

	if not widgets or not grid or not ui_renderer then
		return
	end

	local interaction_widget = self._widgets_by_name.options_grid_interaction
	local is_grid_hovered = not Managers.ui:using_cursor_navigation() or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
	local ui_scenegraph = self._ui_scenegraph
	local null_input_service = input_service:null_service()
	local blur_margin = grid_blur_edge_size[2]

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for j = 1, #widgets do
		local widget = widgets[j]

		if widget then
			ui_renderer.input_service = self._selected_settings_widget and self._selected_settings_widget ~= widget and null_input_service or input_service

			if grid:is_widget_visible(widget, blur_margin) then
				local hotspot = widget.content.hotspot

				if hotspot then
					hotspot.force_disabled = not is_grid_hovered

					local is_active = hotspot.is_focused or hotspot.is_hover

					if is_active and widget.content.entry and (widget.content.entry.tooltip_text or widget.content.entry.disabled_by and not table.is_empty(widget.content.entry.disabled_by)) then
						self:_set_tooltip_data(widget)
					end
				end

				UIWidget.draw(widget, ui_renderer)
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

CustomSettingsView._set_tooltip_data = function (self, widget)
	local tooltip_widget = self._widgets_by_name.tooltip

	if not tooltip_widget then
		return
	end

	local current_widget = self._tooltip_data and self._tooltip_data.widget
	local localized_text
	local tooltip_text = widget.content.entry.tooltip_text
	local disabled_by_list = widget.content.entry.disabled_by

	if tooltip_text then
		if type(tooltip_text) == "function" then
			localized_text = tooltip_text()
		else
			localized_text = Localize(tooltip_text)
		end
	end

	if disabled_by_list then
		localized_text = localized_text and string.format("%s\n", localized_text)

		for _, text in pairs(disabled_by_list) do
			localized_text = localized_text and string.format("%s\n%s", localized_text, Localize(text)) or Localize(text)
		end
	end

	local starting_point = self:_scenegraph_world_position("grid_start")
	local current_y = tooltip_widget.offset[2]
	local scroll_addition = self._grid and self._grid:length_scrolled() or 0
	local new_y = starting_point[2] + widget.offset[2] - scroll_addition

	if current_widget ~= widget or current_widget == widget and new_y ~= current_y then
		self._tooltip_data = {
			widget = widget,
			text = localized_text,
		}
		tooltip_widget.content.text = localized_text

		local text_style = tooltip_widget.style.text
		local x_pos = starting_point[1] + widget.offset[1]
		local width = widget.content.size[1] * 0.5
		local _, text_height = self:_text_size(localized_text, text_style, {
			width,
			0,
		})
		local height = text_height

		tooltip_widget.content.size = {
			width,
			height,
		}
		tooltip_widget.offset[1] = x_pos - width * 0.8
		tooltip_widget.offset[2] = math.max(new_y - height, 20)
	end
end

CustomSettingsView.update = function (self, dt, t, input_service, layer)
	if self._awaiting_input_release and self._open_input_released then
		self._awaiting_input_release = false
		self._open_input_released = nil
	end

	input_service = self:_consume_held_open_input(input_service)

	local grid = self._grid

	if grid then
		local grid_input_service = input_service

		if self._selected_settings_widget then
			grid_input_service = input_service:null_service()
		end

		grid:update(dt, t, grid_input_service)

		self._selected_index = grid:selected_grid_index() or self._selected_index

		self:_sync_grid_hotspot_focus()

		local scrollbar_widget = self._widgets_by_name.grid_content_scrollbar

		if scrollbar_widget then
			scrollbar_widget.content.visible = grid:can_scroll()
		end
	end

	self:_update_settings_widgets(dt, t, input_service)

	if self._tooltip_data and self._tooltip_data.widget then
		if self._tooltip_data and self._tooltip_data.widget and (self._using_cursor_navigation and not self._tooltip_data.widget.content.hotspot.is_hover or not self._using_cursor_navigation and not self._tooltip_data.widget.content.hotspot.is_focused) then
			self._tooltip_data = {
				text = nil,
				widget = nil,
			}
			self._widgets_by_name.tooltip.content.visible = false
		end

		local active_views = Managers.ui:active_views()
		local active_view = active_views and active_views[#active_views]

		if self._tooltip_data and self._tooltip_data.widget and active_view then
			if active_view ~= self.view_name and self._widgets_by_name.tooltip.content.visible then
				self._widgets_by_name.tooltip.content.visible = false
			elseif active_view == self.view_name and self._tooltip_data.widget and not self._widgets_by_name.tooltip.content.visible then
				self._widgets_by_name.tooltip.content.visible = true
			end
		end
	end

	return CustomSettingsView.super.update(self, dt, t, input_service, layer)
end

CustomSettingsView._setup_page_grid = function (self, config)
	local current_widgets = self._current_settings_widgets

	if current_widgets then
		for i = 1, #current_widgets do
			local widget = current_widgets[i]

			if widget then
				self:_unregister_widget_name(widget.name)
			end
		end
	end

	local widgets = {}
	local widgets_by_id = {}
	local alignment_widgets = {}
	local callback_name = "cb_on_settings_pressed"
	local changed_callback_name = "cb_on_settings_changed"

	for setting_index, setting in ipairs(config) do
		local widget_suffix = "setting_" .. tostring(setting_index)
		local widget, alignment_widget = self:_create_settings_widget_from_config(setting, widget_suffix, callback_name, changed_callback_name)

		if widget then
			widgets[#widgets + 1] = widget
			alignment_widgets[#alignment_widgets + 1] = alignment_widget

			if setting.id then
				widgets_by_id[setting.id] = widget
			end
		elseif alignment_widget then
			alignment_widgets[#alignment_widgets + 1] = alignment_widget
		end
	end

	local grid_width = settings_grid_width
	local page = self._pages[self._current_index]

	self._ui_scenegraph.grid_start.horizontal_alignment = page and page.grid_alignment or "center"

	local ui_scenegraph = self._ui_scenegraph
	local direction = "down"
	local grid_scenegraph_id = "grid_start"
	local grid_content_pivot = "grid_content_pivot"
	local grid_spacing = {
		0,
		10,
	}

	self._grid = UIWidgetGrid:new(widgets, alignment_widgets, ui_scenegraph, grid_scenegraph_id, direction, grid_spacing, nil, true)

	self._grid:set_render_scale(self._render_scale)

	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name.grid_content_scrollbar

	self._grid:assign_scrollbar(scrollbar_widget, grid_content_pivot, "grid_content_interaction")

	local grid_height = math.min(self._grid:length(), grid_height_max)

	self:_set_scenegraph_size("grid_start", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_pivot", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_mask", grid_width + grid_blur_edge_size[1] * 2, grid_height + grid_blur_edge_size[2] * 2)
	self:_set_scenegraph_size("grid_content_scrollbar", scrollbar_width, grid_height)
	self:_set_scenegraph_size("grid_content_interaction", grid_width + scrollbar_width * 2, grid_height)
	self._grid:force_update_list_size()
	self._grid:set_scrollbar_progress(0)

	scrollbar_widget.content.visible = self._grid:can_scroll()
	scrollbar_widget.content.using_custom_gamepad_navigation = true
	self._current_settings_widgets = widgets
	self._current_settings_widgets_by_id = widgets_by_id

	self:_on_navigation_input_changed()
end

CustomSettingsView._create_settings_widget_from_config = function (self, config, suffix, callback_name, changed_callback_name, optional_scenegraph_id)
	local scenegraph_id = optional_scenegraph_id or "grid_content_pivot"
	local default_value = config.default_value
	local default_value_type = type(default_value)
	local options = config.options or config.options_function and config.options_function()
	local widget_type = config.widget_type

	if widget_type == "group_header" then
		return nil
	elseif widget_type == "spacing" then
		return nil, {
			size = {
				settings_grid_width,
				20,
			},
		}
	elseif widget_type == "large_spacing" then
		return nil, {
			size = {
				settings_grid_width,
				50,
			},
		}
	elseif widget_type == "extra_large_spacing" then
		return nil, {
			size = {
				settings_grid_width,
				100,
			},
		}
	elseif not widget_type then
		if options then
			widget_type = "dropdown"
		else
			local get_function = config.get_function

			if get_function then
				local value = get_function(config)
				local value_type = value ~= nil and type(value) or default_value_type

				widget_type = value_type == "boolean" and "checkbox" or value_type == "number" and "value_slider" or value_type == "string" and "settings_button" or "settings_button"
			end
		end
	end

	if widget_type == "button" then
		config.ignore_focus = true
	end

	local widget
	local template = ContentBlueprints[widget_type]
	local size = template.size_function and template.size_function(self, config) or template.size

	config.size = size

	local indentation_level = config.indentation_level or 0
	local indentation_spacing = OptionsViewSettings.indentation_spacing * indentation_level
	local new_size = {
		size[1] - indentation_spacing,
		size[2],
	}
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, config, new_size) or template.pass_template
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, new_size)
	local name = "widget_" .. suffix

	if widget_definition then
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, config, callback_name, changed_callback_name)
		end
	end

	if config.shrink_to_fit then
		size[2] = math.min(size[2], widget.content.size[2])
	end

	if widget then
		return widget, {
			size = {
				size[1] + (config.alignment and config.alignment.size and config.alignment.size[1] or 0),
				size[2] + (config.alignment and config.alignment.size and config.alignment.size[2] or 0),
			},
			name = name,
			horizontal_alignment = config.alignment and config.alignment.horizontal_alignment or "right",
		}
	else
		return nil, {
			size = size,
		}
	end
end

CustomSettingsView._handle_input = function (self, input_service, dt, t)
	local selected_settings_widget = self._selected_settings_widget

	if selected_settings_widget then
		local close_selected_setting = false

		if input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back") then
			close_selected_setting = true
		end

		self._close_selected_setting = close_selected_setting
	elseif not Managers.ui:using_cursor_navigation() and input_service:get("next") then
		self:_on_forward_pressed()
	end
end

CustomSettingsView._on_navigation_input_changed = function (self)
	CustomSettingsView.super._on_navigation_input_changed(self)

	local grid = self._grid

	if not grid then
		return
	end

	self._selected_index = grid:selected_grid_index() or grid:first_interactable_grid_index()

	local scroll_progress = grid:get_scrollbar_percentage_by_index(self._selected_index)

	if not Managers.ui:using_cursor_navigation() then
		grid:select_grid_index(self._selected_index, scroll_progress, true, true)
	else
		grid:select_grid_index(nil, scroll_progress, true, true)
	end

	self:_sync_grid_hotspot_focus()
end

CustomSettingsView._set_exclusive_focus_on_grid_widget = function (self, widget_name)
	local widgets = self._current_settings_widgets
	local selected_widget

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget then
			local selected = widget.name == widget_name
			local content = widget.content

			content.exclusive_focus = selected

			local hotspot = content.hotspot or content.button_hotspot

			if hotspot then
				hotspot.is_selected = selected

				if selected then
					selected_widget = widget
				end
			end
		end
	end

	self._selected_settings_widget = selected_widget

	local has_exclusive_focus = selected_widget ~= nil and not self._using_cursor_navigation

	self:_enable_settings_overlay(has_exclusive_focus)
	self:set_can_exit(not has_exclusive_focus, not has_exclusive_focus)

	return selected_widget
end

CustomSettingsView._enable_settings_overlay = function (self, enable)
	local widgets_by_name = self._widgets_by_name
	local settings_overlay_widget = widgets_by_name.settings_overlay

	settings_overlay_widget.content.visible = enable

	local grid_mask_widget = widgets_by_name.grid_content_mask

	if grid_mask_widget then
		grid_mask_widget.offset[3] = enable and 90 or 0
	end
end

CustomSettingsView.set_exclusive_focus_on_grid_widget = function (self, widget_name)
	self:_set_exclusive_focus_on_grid_widget(widget_name)
end

CustomSettingsView._set_selected_grid_widget = function (self, widgets, widget_name)
	local selected_widget, selected_widget_index

	for i = 1, #widgets do
		local widget = widgets[i]
		local is_selected = widget.name == widget_name
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot then
			hotspot.is_selected = is_selected

			if is_selected then
				selected_widget = widget
				selected_widget_index = i
			end
		end
	end

	return selected_widget, selected_widget_index
end

return CustomSettingsView
