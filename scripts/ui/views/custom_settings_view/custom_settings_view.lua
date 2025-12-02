-- chunkname: @scripts/ui/views/custom_settings_view/custom_settings_view.lua

local Definitions = require("scripts/ui/views/custom_settings_view/custom_settings_view_definitions")
local ContentBlueprints = require("scripts/ui/views/options_view/options_view_content_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local OptionsViewSettings = require("scripts/ui/views/options_view/options_view_settings")
local custom_settings_view_settings = require("scripts/ui/views/custom_settings_view/custom_settings_view_settings")
local settings_grid_width = custom_settings_view_settings.settings_grid_width
local CustomSettingsView = class("CustomSettingsView", "BaseView")

CustomSettingsView.init = function (self, settings, context)
	self._current_settings_widgets = {}
	self._current_settings_alignment = {}
	self._current_index = 1
	self._pages = context.pages

	CustomSettingsView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = false
	self._grid = nil
	self._offscreen_world = nil
	self._offscreen_viewport = nil
	self._offscreen_viewport_name = nil
end

CustomSettingsView.on_enter = function (self)
	if not self._pages then
		return Managers.ui:close_view("custom_settings_view", true)
	end

	CustomSettingsView.super.on_enter(self)
	self:_enable_settings_overlay(false)
	self:_setup_buttons_interactions()
	self:_change_settings_page(1)
end

CustomSettingsView.on_exit = function (self)
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
	self._ui_scenegraph.grid_start.horizontal_alignment = self._pages[next_index].grid_alignment or "center"
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

	for i = 1, #settings do
		local widget = settings[i]
		local widget_type = widget.type
		local template = ContentBlueprints[widget_type]
		local update = template and template.update

		if update then
			update(self, widget, input_service, dt, t)
		end
	end

	local selected_settings_widget = self._selected_settings_widget

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

	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._offscreen_world)
end

CustomSettingsView.draw = function (self, dt, t, input_service, layer)
	if self._current_settings_widgets then
		self:_draw_grid(dt, t, input_service)
	end

	return CustomSettingsView.super.draw(self, dt, t, input_service, layer)
end

CustomSettingsView._draw_grid = function (self, dt, t, input_service)
	local interaction_widget = self._widgets_by_name.options_grid_interaction
	local is_grid_hovered = not Managers.ui:using_cursor_navigation() or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local widgets = self._current_settings_widgets
	local grid = self._grid
	local null_input_service = input_service:null_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for j = 1, #widgets do
		local widget = widgets[j]

		ui_renderer.input_service = self._selected_settings_widget and self._selected_settings_widget ~= widget and null_input_service or input_service

		if grid:is_widget_visible(widget) then
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

	UIRenderer.end_pass(ui_renderer)
end

CustomSettingsView._set_tooltip_data = function (self, widget)
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

	local starting_point = self:_scenegraph_world_position("settings_grid_start")
	local current_y = self._widgets_by_name.tooltip.offset[2]
	local scroll_addition = self._settings_content_grid:length_scrolled()
	local new_y = starting_point[2] + widget.offset[2] - scroll_addition

	if current_widget ~= widget or current_widget == widget and new_y ~= current_y then
		self._tooltip_data = {
			widget = widget,
			text = localized_text,
		}
		self._widgets_by_name.tooltip.content.text = localized_text

		local text_style = self._widgets_by_name.tooltip.style.text
		local x_pos = starting_point[1] + widget.offset[1]
		local width = widget.content.size[1] * 0.5
		local _, text_height = self:_text_size(localized_text, text_style, {
			width,
			0,
		})
		local height = text_height

		self._widgets_by_name.tooltip.content.size = {
			width,
			height,
		}
		self._widgets_by_name.tooltip.offset[1] = x_pos - width * 0.8
		self._widgets_by_name.tooltip.offset[2] = math.max(new_y - height, 20)
	end
end

CustomSettingsView.update = function (self, dt, t, input_service, layer)
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
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
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

		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = alignment_widget

		if setting.id then
			widgets_by_id[setting.id] = widget
		end
	end

	local ui_scenegraph = self._ui_scenegraph
	local direction = "down"
	local grid_scenegraph_id = "grid_start"
	local grid_content_pivot = "grid_content_pivot"
	local grid_spacing = {
		0,
		10,
	}

	self._grid = UIWidgetGrid:new(widgets, alignment_widgets, ui_scenegraph, grid_scenegraph_id, direction, grid_spacing)

	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name.grid_content_scrollbar

	self._grid:assign_scrollbar(scrollbar_widget, grid_content_pivot, grid_scenegraph_id)
	self._grid:set_scrollbar_progress(0)

	local grid_height = math.min(self._grid:length(), 800)
	local grid_width = settings_grid_width

	self:_set_scenegraph_size("grid_start", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_pivot", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_mask", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_scrollbar", grid_width, grid_height)
	self:_set_scenegraph_size("grid_content_interaction", grid_width, grid_height)
	self._grid:force_update_list_size()

	self._current_settings_widgets = widgets
	self._current_settings_widgets_by_id = widgets_by_id

	self:_on_navigation_input_changed()
end

CustomSettingsView._create_settings_widget_from_config = function (self, config, suffix, callback_name, changed_callback_name)
	local scenegraph_id = "grid_content_pivot"
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
	elseif not Managers.ui:using_cursor_navigation() then
		local selected_widget = self._selected_index or self._grid:first_interactable_grid_index()

		if input_service:get("navigate_down_continuous") and selected_widget < #self._current_settings_widgets then
			self._selected_index = selected_widget + 1

			local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

			self._grid:select_grid_index(self._selected_index, true, scroll_progress, true)
		elseif input_service:get("navigate_up_continuous") and selected_widget > 1 then
			self._selected_index = selected_widget - 1

			local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

			self._grid:select_grid_index(self._selected_index, true, scroll_progress, true)
		elseif input_service:get("next") then
			self:_on_forward_pressed()
		end
	end
end

CustomSettingsView._on_navigation_input_changed = function (self)
	self._selected_index = self._grid:selected_grid_index() or self._grid:first_interactable_grid_index()

	if not Managers.ui:using_cursor_navigation() then
		local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

		self._grid:select_grid_index(self._selected_index, scroll_progress, true, true)
	else
		local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

		self._grid:select_grid_index(nil, scroll_progress, true, true)
	end
end

CustomSettingsView._set_exclusive_focus_on_grid_widget = function (self, widget_name)
	local widgets = self._current_settings_widgets
	local selected_widget

	for i = 1, #widgets do
		local widget = widgets[i]
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
