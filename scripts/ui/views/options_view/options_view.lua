local definition_path = "scripts/ui/views/options_view/options_view_definitions"
local ViewElementKeybindPopup = require("scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ContentBlueprints = require("scripts/ui/views/options_view/options_view_content_blueprints")
local OptionsTemplates = require("scripts/settings/options/options_templates")
local OptionsViewSettings = require("scripts/ui/views/options_view/options_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local OptionsUtilities = require("scripts/utilities/ui/options")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputUtils = require("scripts/managers/input/input_utils")
local OptionsView = class("OptionsView", "BaseView")

OptionsView.init = function (self, settings)
	local definitions = require(definition_path)

	OptionsView.super.init(self, definitions, settings)

	self._pass_draw = false

	self:_setup_offscreen_gui()
end

OptionsView.on_enter = function (self)
	OptionsView.super.on_enter(self)

	self._using_cursor_navigation = true

	self:_setup_settings_config(OptionsTemplates)
	self:_setup_category_config(OptionsTemplates)
	self:_setup_input_legend()
	self:_enable_settings_overlay(false)
end

OptionsView.on_exit = function (self)
	Managers.event:trigger("event_on_input_settings_changed")

	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	OptionsView.super.on_exit(self)

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
end

OptionsView.cb_on_close_pressed = function (self)
	local view_name = "options_view"

	Managers.ui:close_view(view_name)
end

OptionsView.cb_reset_category_to_default = function (self)
	local selected_category = self._selected_category
	local reset_functions_by_category = self._reset_functions_by_category
	local reset_function = reset_functions_by_category[selected_category]

	if reset_function then
		reset_function()
	else
		local settings_category_default_values = self._settings_category_default_values
		local settings_default_values = selected_category and settings_category_default_values[selected_category]

		if settings_default_values then
			for setting, default_value in pairs(settings_default_values) do
				local on_activated = setting.on_activated

				if on_activated then
					on_activated(default_value)
				end
			end
		end
	end
end

OptionsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs, 1 do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

OptionsView._setup_content_grid_scrollbar = function (self, grid, widget_id, grid_scenegraph_id, grid_pivot_scenegraph_id)
	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name[widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
end

OptionsView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name
	self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local shading_environment = OptionsViewSettings.shading_environment
	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._offscreen_world)
end

OptionsView._setup_content_widgets = function (self, content, scenegraph_id, callback_name)
	local definitions = self._definitions
	local widget_definitions = {}
	local widgets = {}
	local alignment_list = {}
	local amount = #content

	for i = 1, amount, 1 do
		local entry = content[i]
		local verified = true

		if verified then
			local widget_type = entry.widget_type
			local widget = nil
			local template = ContentBlueprints[widget_type]

			fassert(template, "[OptionsView] - Could not find content blueprint for type: %s", widget_type)

			local size = template.size
			local pass_template = template.pass_template

			if pass_template and not widget_definitions[widget_type] then
				local scenegraph_definition = definitions.scenegraph_definition
				widget_definitions[widget_type] = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
			end

			local widget_definition = widget_definitions[widget_type]

			if widget_definition then
				local name = scenegraph_id .. "_widget_" .. i
				widget = self:_create_widget(name, widget_definition)
				local init = template.init

				if init then
					init(self, widget, entry, callback_name)
				end

				local focus_group = entry.focus_group

				if focus_group then
					widget.content.focus_group = focus_group
				end

				widgets[#widgets + 1] = widget
			end

			alignment_list[#alignment_list + 1] = widget or {
				size = size
			}
		end
	end

	return widgets, alignment_list
end

OptionsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name.scrollbar
	scrollbar_widget.content.visible = self._category_content_grid:can_scroll()

	if self._selected_settings_widget then
		UIWidget.draw(self._selected_settings_widget, ui_renderer)

		input_service = input_service:null_service()
		ui_renderer.input_service = input_service
	end

	OptionsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

OptionsView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self:_handling_keybinding() or self._selected_settings_widget then
		input_service = input_service:null_service()
		ui_renderer.input_service = input_service
	end

	OptionsView.super._draw_elements(self, dt, t, ui_renderer, render_settings, input_service)
end

OptionsView.draw = function (self, dt, t, input_service, layer)
	if self:_handling_keybinding() then
		input_service = input_service:null_service()
	end

	local widgets_by_name = self._widgets_by_name
	local grid_interaction_widget = widgets_by_name.grid_interaction

	self:_draw_grid(self._category_content_grid, self._category_content_widgets, grid_interaction_widget, dt, t, input_service)

	if self._settings_content_grid then
		local grid_interaction_widget = widgets_by_name.settings_grid_interaction

		self:_draw_grid(self._settings_content_grid, self._settings_content_widgets, grid_interaction_widget, dt, t, input_service)
	end

	OptionsView.super.draw(self, dt, t, input_service, layer)
end

OptionsView._draw_grid = function (self, grid, widgets, interaction_widget, dt, t, input_service)
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local null_input_service = input_service:null_service()
	local render_settings = self._render_settings
	local ui_renderer = self._ui_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for j = 1, #widgets, 1 do
		local widget = widgets[j]
		local draw = widget ~= self._selected_settings_widget

		if draw then
			if self._selected_settings_widget then
				ui_renderer.input_service = null_input_service
			end

			if grid:is_widget_visible(widget) then
				local hotspot = widget.content.hotspot

				if hotspot then
					hotspot.force_disabled = not is_grid_hovered
				end

				UIWidget.draw(widget, ui_renderer)
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

OptionsView._setup_grid = function (self, widgets, alignment_list, grid_scenegraph_id, spacing, use_is_focused)
	local ui_scenegraph = self._ui_scenegraph
	local direction = "down"
	local grid = UIWidgetGrid:new(widgets, alignment_list, ui_scenegraph, grid_scenegraph_id, direction, spacing, nil, use_is_focused)
	local render_scale = self._render_scale

	grid:set_render_scale(render_scale)

	return grid
end

OptionsView.set_render_scale = function (self, scale)
	OptionsView.super.set_render_scale(self, scale)
	self._category_content_grid:set_render_scale(self._render_scale)

	if self._settings_content_grid then
		self._settings_content_grid:set_render_scale(self._render_scale)
	end
end

OptionsView.update = function (self, dt, t, input_service, view_data)
	local drawing_view = view_data.drawing_view

	if self:_handling_keybinding() then
		input_service = input_service:null_service()

		if not drawing_view then
			self:close_keybind_popup(true)
		end
	end

	self:_handle_keybind_rebind(dt, t, input_service)

	local close_keybind_popup_duration = self._close_keybind_popup_duration

	if close_keybind_popup_duration then
		if close_keybind_popup_duration < 0 then
			self._close_keybind_popup_duration = nil

			self:close_keybind_popup(true)
		else
			self._close_keybind_popup_duration = close_keybind_popup_duration - dt
		end
	end

	local grid_length = self._category_content_grid:length()

	if grid_length ~= self._grid_length then
		self._grid_length = grid_length
	end

	local grid_input_service = input_service

	if self:_handling_keybinding() or self._selected_settings_widget then
		grid_input_service = input_service:null_service()
	end

	self._category_content_grid:update(dt, t, grid_input_service)
	self:_update_category_content_widgets(dt, t)

	local settings_content_grid = self._settings_content_grid

	if settings_content_grid then
		settings_content_grid:update(dt, t, grid_input_service)
		self:_update_settings_content_widgets(dt, t, input_service)
	end

	return OptionsView.super.update(self, dt, t, input_service)
end

OptionsView.on_resolution_modified = function (self)
	OptionsView.super.on_resolution_modified(self)

	local scale = self._render_scale

	self._category_content_grid:on_resolution_modified(scale)

	if self._settings_content_grid then
		self._settings_content_grid:on_resolution_modified(scale)
	end

	self._grid_length = nil
end

OptionsView._on_navigation_input_changed = function (self)
	OptionsView.super._on_navigation_input_changed(self)
	self:_update_grid_navigation_selection()
end

OptionsView.settings_grid_length = function (self)
	local grid = self._settings_content_grid

	if grid then
		local scroll_length = grid:scroll_length()
		local total_length = grid:length()
		local area_length = grid:area_length()

		return math.max(total_length - scroll_length, area_length)
	end

	return 0
end

OptionsView.settings_scroll_amount = function (self)
	local grid = self._settings_content_grid

	if grid then
		local scroll_progress = grid:scrollbar_progress()
		local scroll_length = grid:scroll_length()

		return scroll_length * scroll_progress
	end

	return 0
end

OptionsView.set_exlusive_focus_on_grid_widget = function (self, widget_name)
	local force_disabled = not widget_name

	self:_set_exlusive_focus_on_grid_widget(widget_name, force_disabled)
end

OptionsView._handle_input = function (self, input_service)
	local selected_settings_widget = self._selected_settings_widget

	if selected_settings_widget then
		local close_selected_setting = false

		if input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back") then
			close_selected_setting = true

			self:_update_grid_navigation_selection()
		end

		self._close_selected_setting = close_selected_setting
	else
		local selected_navigation_row = self._selected_navigation_row_index
		local selected_navigation_column = self._selected_navigation_column_index

		if selected_navigation_row and selected_navigation_column then
			if input_service:get("navigate_left_continuous") then
				self:_change_navigation_column(selected_navigation_column - 1)
			elseif input_service:get("navigate_right_continuous") then
				self:_change_navigation_column(selected_navigation_column + 1)
			end
		end
	end
end

OptionsView._update_grid_navigation_selection = function (self)
	if self._using_cursor_navigation then
		if self._selected_navigation_row_index or self._selected_navigation_column_index then
			self:_set_selected_navigation_widget(nil)
		end
	elseif not self._selected_navigation_row_index and not self._selected_navigation_column_index then
		if not self._selected_settings_widget then
			self:_set_default_navigation_widget()
		else
			self:_set_selected_navigation_widget(self._selected_settings_widget)
		end
	end
end

OptionsView.present_category_widgets = function (self, category)
	self._selected_category = category
	local settings_category_widgets = self._settings_category_widgets
	local widgets = settings_category_widgets[category]

	if widgets then
		self._settings_content_widgets = widgets
		self._settings_alignment_list = widgets
		local scrollbar_widget_id = "settings_scrollbar"
		local grid_scenegraph_id = "settings_grid_background"
		local grid_pivot_scenegraph_id = "settings_grid_content_pivot"
		local grid_spacing = OptionsViewSettings.grid_spacing
		self._settings_content_grid = self:_setup_grid(self._settings_content_widgets, self._settings_alignment_list, grid_scenegraph_id, grid_spacing, false)

		self:_setup_content_grid_scrollbar(self._settings_content_grid, scrollbar_widget_id, grid_scenegraph_id, grid_pivot_scenegraph_id)

		self._navigation_widgets = {
			self._category_content_widgets,
			self._settings_content_widgets
		}
		self._navigation_grids = {
			self._category_content_grid,
			self._settings_content_grid
		}

		self:_update_grid_navigation_selection()
	end
end

OptionsView._setup_category_config = function (self, config)
	local config_categories = config.categories
	local entries = {}
	local reset_functions_by_category = {}

	for i = 1, #config_categories, 1 do
		local category_config = config_categories[i]
		local category_display_name = category_config.display_name
		local category_icon = category_config.icon
		local category_reset_function = category_config.reset_function
		entries[#entries + 1] = {
			widget_type = "settings_button",
			display_name = category_display_name,
			icon = category_icon,
			pressed_function = function (parent, widget, entry)
				self._category_content_grid:select_widget(widget)

				local widget_name = widget.name

				self:present_category_widgets(category_display_name)
			end,
			select_function = function (parent, widget, entry)
				local widget_name = widget.name

				self:present_category_widgets(category_display_name)
			end
		}
		reset_functions_by_category[category_display_name] = category_reset_function
	end

	local scenegraph_id = "grid_content_pivot"
	local callback_name = "cb_on_category_pressed"
	self._category_content_widgets, self._category_alignment_list = self:_setup_content_widgets(entries, scenegraph_id, callback_name)
	local scrollbar_widget_id = "scrollbar"
	local grid_scenegraph_id = "background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = OptionsViewSettings.grid_spacing
	self._category_content_grid = self:_setup_grid(self._category_content_widgets, self._category_alignment_list, grid_scenegraph_id, grid_spacing, true)

	self:_setup_content_grid_scrollbar(self._category_content_grid, scrollbar_widget_id, grid_scenegraph_id, grid_pivot_scenegraph_id)

	self._reset_functions_by_category = reset_functions_by_category
	self._navigation_widgets = {
		self._category_content_widgets
	}
	self._navigation_grids = {
		self._category_content_grid
	}
end

OptionsView._setup_settings_config = function (self, config)
	local config_settings = config.settings
	local category_widgets = {}
	local settings_default_values = {}
	local callback_name = "cb_on_settings_pressed"

	for setting_index, setting in ipairs(config_settings) do
		local valid = not setting.validation_function or setting.validation_function()

		if valid and not setting.hidden then
			local category = setting.category or "Uncategorized"
			local widgets = category_widgets[category]

			if not category_widgets[category] then
				category_widgets[category] = {}
				widgets = category_widgets[category]
			end

			if not settings_default_values[category] then
				settings_default_values[category] = {}
			end

			if setting.get_function then
				settings_default_values[category][setting] = setting.default_value
			end

			local widget_suffix = "setting_" .. tostring(setting_index)
			local widget, alignment_widget = self:_create_settings_widget_from_config(setting, category, widget_suffix, callback_name)
			category_widgets[category][#widgets + 1] = widget
		end
	end

	self._settings_category_default_values = settings_default_values
	self._settings_category_widgets = category_widgets
end

OptionsView._update_category_content_widgets = function (self, dt, t)
	local category_content_widgets = self._category_content_widgets

	if category_content_widgets then
		local selected_category_widget = self._selected_category_widget

		for i = 1, #category_content_widgets, 1 do
			local widget = category_content_widgets[i]

			if widget.content.hotspot.is_focused then
				if widget ~= selected_category_widget then
					self._selected_category_widget = widget
					local entry = widget.content.entry

					if entry and entry.select_function then
						entry.select_function(self, widget, entry)
					end
				end

				break
			end
		end
	end
end

OptionsView._update_settings_content_widgets = function (self, dt, t, input_service)
	local settings_content_widgets = self._settings_content_widgets

	if settings_content_widgets then
		local focused_widget_index = self._settings_content_grid:selected_grid_index()
		local focused_widget = focused_widget_index and settings_content_widgets[focused_widget_index]

		if focused_widget then
			self:_set_selected_navigation_widget(focused_widget)
		end

		local handle_input = false

		for i = 1, #settings_content_widgets, 1 do
			local widget = settings_content_widgets[i]
			local widget_type = widget.type
			local template = ContentBlueprints[widget_type]
			local update = template and template.update

			if update then
				local allowing_other_input = update(self, widget, input_service, dt, t)
				local is_selected_widget = widget == self._selected_settings_widget

				if is_selected_widget then
					handle_input = allowing_other_input
				end
			end
		end

		if handle_input and self._selected_settings_widget and self._close_selected_setting then
			self._selected_settings_widget.offset[3] = 0

			self:_set_selected_grid_widget(self._settings_content_widgets, nil)
			self:_set_exlusive_focus_on_grid_widget(nil)

			self._close_selected_setting = nil

			self:_enable_settings_overlay(false)
			self:set_can_exit(true, true)
		end
	end
end

OptionsView._create_settings_widget_from_config = function (self, config, category, suffix, callback_name)
	local scenegraph_id = "settings_grid_content_pivot"
	local default_value = config.default_value
	local default_value_type = type(default_value)
	local options = config.options or (config.options_function and config.options_function())
	local widget_type = config.widget_type

	if not widget_type then
		if options then
			widget_type = "dropdown"
		else
			local get_function = config.get_function

			if get_function then
				local value = get_function()
				local value_type = (value ~= nil and type(value)) or default_value_type

				if value_type == "boolean" then
					widget_type = "checkbox"
				elseif value_type == "number" then
					widget_type = "value_slider"
				elseif value_type == "string" then
					widget_type = "settings_button"
				else
					widget_type = "settings_button"
				end
			end
		end
	end

	if widget_type == "button" then
		config.ignore_focus = true
	end

	local widget = nil
	local template = ContentBlueprints[widget_type]

	fassert(template, "[OptionsView] - Could not find content blueprint for type: %s", widget_type)

	local size = (template.size_function and template.size_function(self, config)) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = (pass_template_function and pass_template_function(self, config)) or template.pass_template
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size)

	if widget_definition then
		local name = "widget_" .. suffix
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type
		local init = template.init

		if init then
			init(self, widget, config, callback_name)
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

OptionsView._handle_keybind_rebind = function (self, dt, t, input_service)
	if self._handling_keybind then
		local input_manager = Managers.input
		local results = input_manager:key_watch_result()

		if results then
			local entry = self._active_keybind_entry
			local widget = self._active_keybind_widget
			local presentation_string = InputUtils.localized_string_from_key_info(results)
			local service_type = entry.service_type
			local alias_name = entry.alias_name
			local value = entry.value

			entry.on_activated(results, value)
			self:close_keybind_popup()
		end
	end
end

OptionsView._handling_keybinding = function (self)
	return self._handling_keybind or self._close_keybind_popup_duration ~= nil
end

OptionsView.show_keybind_popup = function (self, widget, entry)
	if not self:_handling_keybinding() then
		self._active_keybind_entry = entry
		self._active_keybind_widget = widget
		local layer = 100
		local reference_name = "keybind_popup"
		self._keybind_popup = self:_add_element(ViewElementKeybindPopup, reference_name, layer)
		local display_name = self:_localize(entry.display_name or "n/a")

		self._keybind_popup:set_action_text(display_name)

		local value = entry.get_function()
		local devices = entry.devices
		local value_text = (value and InputUtils.localized_string_from_key_info(value)) or self:_localize("loc_keybind_unassigned")

		self._keybind_popup:set_value_text(value_text)
		Managers.input:start_key_watch(devices)

		self._handling_keybind = true

		self:set_can_exit(false)
	end
end

OptionsView.close_keybind_popup = function (self, force_close)
	if force_close then
		Managers.input:stop_key_watch()

		local reference_name = "keybind_popup"
		self._keybind_popup = nil

		self:_remove_element(reference_name)
		self:set_can_exit(true, true)
	else
		self._close_keybind_popup_duration = 0.2
	end

	self._handling_keybind = false
	self._active_keybind_entry = nil
	self._active_keybind_widget = nil
end

OptionsView._set_warning_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local warning_text = widgets_by_name.warning_text
	local action = "TEST"
	local color_1 = self:_get_color_string_by_color(Color.ui_brown_light(255, true))
	local color_2 = self:_get_color_string_by_color(Color.red(255, true))
	warning_text.content.text = string.format("Warning! Input for action %s%s%s has been unassigned.", color_1, action, color_2)
end

OptionsView.cb_on_category_pressed = function (self, widget, entry)
	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end
end

OptionsView.cb_on_settings_pressed = function (self, widget, entry)
	if not self._can_close or self._selected_settings_widget then
		return
	end

	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end

	if not entry.ignore_focus then
		local widget_name = widget.name
		local selected_widget = self:_set_exlusive_focus_on_grid_widget(widget_name)

		self:_enable_settings_overlay(true)

		if selected_widget then
			selected_widget.offset[3] = 90
		end
	end
end

OptionsView._enable_settings_overlay = function (self, enable)
	local widgets_by_name = self._widgets_by_name
	local settings_overlay_widget = widgets_by_name.settings_overlay
	settings_overlay_widget.content.visible = enable
end

OptionsView._set_exlusive_focus_on_grid_widget = function (self, widget_name, force_disabled)
	local widgets = self._settings_content_widgets
	local selected_widget = nil

	for i = 1, #widgets, 1 do
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

	return selected_widget
end

OptionsView._change_navigation_column = function (self, column_index)
	local navigation_widgets = self._navigation_widgets
	local num_columns = #navigation_widgets
	local success = false

	if column_index < 1 or num_columns < column_index then
		return success
	else
		success = true
	end

	local widgets = navigation_widgets[column_index]

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot and hotspot.is_selected then
			self:_set_selected_navigation_widget(widget)

			return success
		end
	end

	local widgets = navigation_widgets[column_index]

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot then
			self:_set_selected_navigation_widget(widget)

			return success
		end
	end
end

OptionsView._set_default_navigation_widget = function (self)
	local navigation_widgets = self._navigation_widgets

	for i = 1, #navigation_widgets, 1 do
		if self:_change_navigation_column(i) then
			return
		end
	end
end

OptionsView._set_selected_navigation_widget = function (self, widget)
	local widget_name = widget and widget.name
	local selected_row, selected_column = nil
	local navigation_widgets = self._navigation_widgets

	for column_index = 1, #navigation_widgets, 1 do
		local widgets = navigation_widgets[column_index]
		local _, focused_grid_index = self:_set_focused_grid_widget(widgets, widget_name)

		if focused_grid_index then
			self:_set_selected_grid_widget(widgets, widget_name)

			selected_row = focused_grid_index
			selected_column = column_index
		end
	end

	local navigation_grids = self._navigation_grids

	for column_index = 1, #navigation_grids, 1 do
		local selected_grid = column_index == selected_column
		local navigation_grid = navigation_grids[column_index]

		navigation_grid:select_grid_index((selected_grid and selected_row) or nil, nil, nil, column_index == 1)
	end

	self._selected_navigation_row_index = selected_row
	self._selected_navigation_column_index = selected_column
end

OptionsView._set_focused_grid_widget = function (self, widgets, widget_name)
	local selected_widget, selected_widget_index = nil

	for i = 1, #widgets, 1 do
		local widget = widgets[i]
		local is_focused = widget.name == widget_name
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot then
			hotspot.is_focused = is_focused

			if is_focused then
				selected_widget = widget
				selected_widget_index = i
			end
		end
	end

	return selected_widget, selected_widget_index
end

OptionsView._set_selected_grid_widget = function (self, widgets, widget_name)
	local selected_widget, selected_widget_index = nil

	for i = 1, #widgets, 1 do
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

return OptionsView
