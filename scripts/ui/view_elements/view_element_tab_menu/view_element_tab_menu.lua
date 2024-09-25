﻿-- chunkname: @scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu.lua

local Definitions = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_definitions")
local ViewElementTabMenuSettings = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementTabMenu = class("ViewElementTabMenu", "ViewElementBase")

ViewElementTabMenu.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementTabMenu.super.init(self, parent, draw_layer, start_scale, Definitions)

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementTabMenuSettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementTabMenuSettings
	end

	self._entry_index = 0
	self._entries = {}
	self._is_handling_navigation_input = false
	self._pivot_offset = {
		0,
		0,
	}

	self:_update_input_action_texts()

	if self._menu_settings.grow_vertically then
		self._widgets_by_name.input_text_left.style.text.text_horizontal_alignment = "left"
		self._widgets_by_name.input_text_left.style.text.horizontal_alignment = "left"
		self._widgets_by_name.input_text_left.style.text.text_vertical_alignment = "bottom"
	end
end

ViewElementTabMenu._on_navigation_input_changed = function (self)
	ViewElementTabMenu.super._on_navigation_input_changed(self)
	self:_update_input_action_texts()
end

ViewElementTabMenu.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("entry_pivot", x, y)
end

ViewElementTabMenu.add_entry = function (self, display_name, on_pressed_callback, pass_template, optional_display_icon, optional_update_function, no_localization)
	pass_template = pass_template or ButtonPassTemplates.tab_menu_button

	local id = "entry_" .. self._entry_index
	local scenegraph_id = "entry_pivot"
	local default_size = self._menu_settings.button_size
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, default_size)
	local widget = self:_create_widget(id, widget_definition)
	local entry = {
		widget = widget,
		id = id,
		display_name = display_name,
		icon = optional_display_icon,
		on_pressed_callback = on_pressed_callback,
		update = optional_update_function,
	}
	local display_text = no_localization == true and display_name or display_name and self:_localize(display_name)
	local content = widget.content

	content.hotspot.pressed_callback = on_pressed_callback
	content.text = display_text or ""

	if optional_display_icon then
		content.icon = optional_display_icon
	end

	self._entries[#self._entries + 1] = entry
	self._entry_index = self._entry_index + 1
	self._update_text_lengths = true

	return id
end

ViewElementTabMenu.set_selected_index = function (self, index)
	self._selected_index = index
end

ViewElementTabMenu.selected_index = function (self, index)
	return self._selected_index
end

ViewElementTabMenu._update_widget_size = function (self, widget, ui_renderer)
	local content = widget.content
	local style = widget.style
	local text_style = style.text

	if text_style then
		local text = content.text
		local size = content.size
		local text_options = UIFonts.get_font_options_by_style(text_style)

		size[1] = 1920

		local width, _ = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

		size[1] = width + self._menu_settings.button_text_margin
	end
end

ViewElementTabMenu.set_tab_disabled = function (self, id, is_disabled)
	local widget = self:_widget_by_id(id)

	if widget then
		widget.content.hotspot.disabled = is_disabled
	end
end

ViewElementTabMenu.tab_disabled = function (self, id)
	local widget = self:_widget_by_id(id)

	return widget and widget.content.hotspot.disabled or false
end

ViewElementTabMenu.remove_entry = function (self, id)
	local widget, index = self:_widget_by_id(id)

	if widget then
		self:_unregister_widget_name(widget.name)
		table.remove(self._entries, index)

		return true
	end

	return false
end

ViewElementTabMenu.remove_all_entries = function (self)
	if self._entries then
		for i = 1, #self._entries do
			local entry = self._entries[i]
			local widget = entry.widget

			self:_unregister_widget_name(widget.name)
		end
	end

	self._entries = {}
	self._entry_index = 0
end

ViewElementTabMenu.update = function (self, dt, t, input_service)
	if self._input_disabled then
		input_service = input_service:null_service()
	end

	local entries = self._entries

	if entries then
		local num_entries = #entries

		for i = 1, num_entries do
			local entry = entries[i]
			local entry_update = entry.update

			if entry_update then
				local widget = entry.widget
				local update_text_lengths = entry_update(widget.content, widget.style)

				if update_text_lengths then
					self._update_text_lengths = true
				end
			end
		end
	end

	if self._is_handling_navigation_input and self._selected_index then
		local new_index
		local input_action_right, input_action_left = self._input_action_right, self._input_action_left

		if input_action_right and input_service:get(input_action_right) then
			new_index = self._selected_index + 1
		elseif input_action_left and input_service:get(input_action_left) then
			new_index = self._selected_index - 1
		end

		local menu_settings = self._menu_settings

		if new_index and menu_settings.wrapped_selection then
			new_index = 1 + (new_index - 1) % self._entry_index
		end

		if new_index and new_index >= 1 and new_index <= self._entry_index then
			self._entries[new_index].on_pressed_callback()
		end
	end

	return ViewElementTabMenu.super.update(self, dt, t, input_service)
end

ViewElementTabMenu.disable_input = function (self, disabled)
	self._input_disabled = disabled
end

ViewElementTabMenu.input_disabled = function (self)
	return self._input_disabled
end

ViewElementTabMenu.entries = function (self)
	return self._entries
end

ViewElementTabMenu.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._entries then
		return
	end

	if self._input_disabled then
		input_service = input_service:null_service()
	end

	local old_color_intensity_multiplier = render_settings.color_intensity_multiplier
	local color_intensity_multiplier = self._color_intensity_multiplier or 1

	render_settings.color_intensity_multiplier = (old_color_intensity_multiplier or 1) * color_intensity_multiplier

	ViewElementTabMenu.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.color_intensity_multiplier = old_color_intensity_multiplier
end

ViewElementTabMenu._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local menu_settings = self._menu_settings
	local update_text_lengths = self._update_text_lengths and not menu_settings.fixed_button_size

	self._update_text_lengths = nil

	local grow_vertically = menu_settings.grow_vertically
	local widgets_by_name = self._widgets_by_name
	local entries = self._entries

	if entries then
		local button_spacing = menu_settings.button_spacing
		local input_label_offset = menu_settings.input_label_offset
		local input_label_offset_x = input_label_offset and input_label_offset[1] or 0
		local input_label_offset_y = input_label_offset and input_label_offset[2] or 0
		local pivot_offset = self._pivot_offset
		local pivot_offset_x = pivot_offset[1]
		local pivot_offset_y = pivot_offset[2]
		local total_width = 0
		local total_height = 0
		local num_entries = #entries

		for i = 1, num_entries do
			local entry = entries[i]
			local widget = entry.widget

			if update_text_lengths then
				self:_update_widget_size(widget, ui_renderer)
			end

			local size = widget.content.size

			total_width = total_width + (size[1] + button_spacing)
			total_height = total_height + (size[2] + button_spacing)
		end

		local left_size_offset = 0
		local top_size_offset = 0
		local horizontal_alignment = menu_settings.horizontal_alignment

		if horizontal_alignment then
			if horizontal_alignment == "center" then
				left_size_offset = -(total_width - button_spacing) * 0.5
			elseif horizontal_alignment == "right" then
				left_size_offset = -total_width + button_spacing
			end
		end

		local vertical_alignment = menu_settings.vertical_alignment

		if vertical_alignment then
			if vertical_alignment == "center" then
				top_size_offset = -(total_height - button_spacing) * 0.5
			elseif vertical_alignment == "right" then
				top_size_offset = -total_height + button_spacing
			end
		end

		if grow_vertically then
			local button_size = ViewElementTabMenuSettings.button_size

			widgets_by_name.input_text_left.offset[1] = input_label_offset_x
			widgets_by_name.input_text_left.offset[2] = top_size_offset - (button_size[2] + input_label_offset_y)
		else
			widgets_by_name.input_text_left.offset[1] = left_size_offset - input_label_offset_x
			widgets_by_name.input_text_left.offset[2] = input_label_offset_y
		end

		for i = 1, num_entries do
			local entry = entries[i]
			local widget = entry.widget

			widget.content.hotspot.is_focused = i == self._selected_index

			local offset = widget.offset
			local size = widget.content.size

			if grow_vertically then
				offset[1] = 0
				offset[2] = 0 + top_size_offset
			else
				offset[1] = 0 + left_size_offset
				offset[2] = 0
			end

			left_size_offset = left_size_offset + size[1]
			top_size_offset = top_size_offset + size[2]

			if i < num_entries then
				left_size_offset = left_size_offset + button_spacing
				top_size_offset = top_size_offset + button_spacing
			end

			UIWidget.draw(widget, ui_renderer)
		end

		if grow_vertically then
			widgets_by_name.input_text_right.offset[1] = input_label_offset_x
			widgets_by_name.input_text_right.offset[2] = top_size_offset + input_label_offset_y
		else
			widgets_by_name.input_text_right.offset[1] = left_size_offset + input_label_offset_x
			widgets_by_name.input_text_right.offset[2] = input_label_offset_y
		end

		self._total_width = total_width
	end

	ViewElementTabMenu.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementTabMenu.get_total_width = function (self)
	return self._total_width or 0
end

ViewElementTabMenu._get_input_text = function (self, input_action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(input_action)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	return tostring(input_text)
end

ViewElementTabMenu.set_input_actions = function (self, input_action_left, input_action_right)
	self._input_action_left = input_action_left
	self._input_action_right = input_action_right

	self:_update_input_action_texts()
end

ViewElementTabMenu.set_is_handling_navigation_input = function (self, is_enabled)
	self._is_handling_navigation_input = is_enabled
end

ViewElementTabMenu._update_input_action_texts = function (self)
	local using_cursor_navigation = self._using_cursor_navigation
	local input_action_left = self._input_action_left
	local input_action_right = self._input_action_right
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.input_text_left.content.text = not using_cursor_navigation and input_action_left and self:_get_input_text(input_action_left) or ""
	widgets_by_name.input_text_right.content.text = not using_cursor_navigation and input_action_right and self:_get_input_text(input_action_right) or ""
end

ViewElementTabMenu.content_by_id = function (self, id)
	local widget = self:_widget_by_id(id)

	return widget.content
end

ViewElementTabMenu._widget_by_id = function (self, id)
	local entries = self._entries

	if entries then
		for i = 1, #entries do
			local entry = entries[i]

			if entry.id == id then
				return entry.widget, i
			end
		end
	end
end

ViewElementTabMenu.set_color_intensity_multiplier = function (self, color_intensity_multiplier)
	self._color_intensity_multiplier = color_intensity_multiplier or 1
end

return ViewElementTabMenu
