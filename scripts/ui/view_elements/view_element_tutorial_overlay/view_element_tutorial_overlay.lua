-- chunkname: @scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTutorialOverlaySettings = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay_settings")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = require("scripts/utilities/world_render")
local DEFAULT_COLOR_INTENSITY_VALUE = ViewElementTutorialOverlaySettings.default_color_intensity_value
local WINDOW_MARGINS_HEIGHT = ViewElementTutorialOverlaySettings.window_margins_height
local WINDOW_MARGINS_WIDTH = ViewElementTutorialOverlaySettings.window_margins_width
local WINDOW_MAX_WIDTH = ViewElementTutorialOverlaySettings.window_max_width
local MASK_PADDING_PIXEL_SIZE = ViewElementTutorialOverlaySettings.mask_padding_pixel_size

local function table_to_address_string(table_value)
	local table_to_string = tostring(table_value)
	local index_start_address = string.find(table_to_string, " ") or 1

	return string.sub(table_to_string, index_start_address)
end

local ViewElementTutorialOverlay = class("ViewElementTutorialOverlay", "ViewElementBase")

ViewElementTutorialOverlay.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementTutorialOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	if optional_menu_settings then
		self._menu_settings = table.merge_recursive(table.clone(ViewElementTutorialOverlaySettings), optional_menu_settings)
	else
		self._menu_settings = ViewElementTutorialOverlaySettings
	end

	self._previous_color_intensities_by_renderer = {}
	self._pivot_offset = {
		0,
		0
	}
	self._highligt_color_intensity = 1
	self._background_color_intensity = 1
	self._tooltip_visibility = true

	self:_setup_default_gui()
	self:_setup_tooltip_grid()

	local pulse_tooltip = true

	self:_set_tooltip_visibility(true, pulse_tooltip)
end

ViewElementTutorialOverlay._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer
	local world_name = class_name .. "_ui_default_world"
	local view_name = self._parent.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

ViewElementTutorialOverlay.activate = function (self, data, start_delay)
	self._start_delay = start_delay or 0
	self._tutorial_data = data
	self._highligt_color_intensity = 1
	self._background_color_intensity = 1
	self._active_next_frame = true
end

ViewElementTutorialOverlay._present_next = function (self)
	local tutorial_data = self._tutorial_data
	local current_index = self._current_index or 0

	if current_index >= #tutorial_data then
		return false
	end

	local next_index = current_index + 1
	local data = tutorial_data[next_index]

	self._current_index = next_index
	self.grow_from_center = data.grow_from_center or false

	local window_width = data.window_width or WINDOW_MAX_WIDTH

	if window_width then
		local grid = self._tooltip_grid
		local menu_settings = grid:menu_settings()
		local grid_size = menu_settings.grid_size
		local mask_size = menu_settings.mask_size

		grid_size[1] = window_width
		mask_size[1] = window_width + MASK_PADDING_PIXEL_SIZE

		self:_set_scenegraph_size("tooltip_grid", window_width + WINDOW_MARGINS_WIDTH)
		self:_set_scenegraph_size("tooltip", window_width + WINDOW_MARGINS_WIDTH)
		grid:force_update_list_size()
	end

	local layout = data.layout

	self:_present_tooltip_grid_layout(layout)

	self._highligt_color_intensity = current_index == 1 and 0 or DEFAULT_COLOR_INTENSITY_VALUE

	if self._tutorial_window_open_animation_id then
		self:_stop_animation(self._tutorial_window_open_animation_id)

		self._tutorial_window_open_animation_id = nil
	end

	self._tutorial_window_open_animation_id = self:_start_animation("tutorial_window_open", self._widgets_by_name, self)

	return true
end

ViewElementTutorialOverlay.draw_begin = function (self, ui_renderer)
	local table_name = table_to_address_string(ui_renderer)

	self._previous_color_intensities_by_renderer[table_name] = ui_renderer.color_intensity_multiplier

	if self._active then
		ui_renderer.color_intensity_multiplier = self._background_color_intensity
	end
end

ViewElementTutorialOverlay.draw_end = function (self, ui_renderer)
	local table_name = table_to_address_string(ui_renderer)

	ui_renderer.color_intensity_multiplier = self._previous_color_intensities_by_renderer[table_name]
	self._previous_color_intensities_by_renderer[table_name] = nil
end

ViewElementTutorialOverlay.draw_external_widget = function (self, widget, ui_renderer, render_settings)
	local table_name = table_to_address_string(ui_renderer)
	local widgets_name = self:active_tutorial_widgets_name()

	if self._active and widgets_name then
		for i = 1, #widgets_name do
			local widget_name = widgets_name[i]

			if widget.name == widget_name then
				local previous_color_intensity_multiplier = self._previous_color_intensities_by_renderer[table_name] or 1

				ui_renderer.color_intensity_multiplier = math.max(self._background_color_intensity, self._highligt_color_intensity) * previous_color_intensity_multiplier

				break
			end
		end
	end

	UIWidget.draw(widget, ui_renderer)

	if self._active then
		ui_renderer.color_intensity_multiplier = self._background_color_intensity
	end
end

ViewElementTutorialOverlay.draw_external_element = function (self, element, dt, t, ui_renderer, render_settings, input_service)
	local table_name = table_to_address_string(ui_renderer)
	local elements = self:active_tutorial_elements()
	local element_color_intensity = self._background_color_intensity

	if self._active and elements then
		for i = 1, #elements do
			local element_name = elements[i].__class_name

			if element_name == element.__class_name then
				local previous_color_intensity_multiplier = self._previous_color_intensities_by_renderer[table_name] or 1

				ui_renderer.color_intensity_multiplier = math.max(self._background_color_intensity, self._highligt_color_intensity) * previous_color_intensity_multiplier
				element_color_intensity = nil

				break
			end
		end
	end

	if element_color_intensity and element.set_tutorial_color_intensity_multiplier then
		element:set_tutorial_color_intensity_multiplier(element_color_intensity)
	end

	element:draw(dt, t, ui_renderer, render_settings, input_service)

	if element_color_intensity and element.set_tutorial_color_intensity_multiplier then
		element:set_tutorial_color_intensity_multiplier(nil)
	end

	if self._active then
		ui_renderer.color_intensity_multiplier = self._background_color_intensity
	end
end

ViewElementTutorialOverlay.active_tutorial_index = function (self)
	return self._current_index
end

ViewElementTutorialOverlay._active_tutorial_data = function (self)
	local current_index = self._current_index or 0
	local tutorial_data = self._tutorial_data
	local data = tutorial_data[current_index]

	return data
end

ViewElementTutorialOverlay.active_tutorial_widgets_name = function (self)
	local data = self:_active_tutorial_data()

	return data and data.widgets_name
end

ViewElementTutorialOverlay.active_tutorial_elements = function (self)
	local data = self:_active_tutorial_data()

	return data and data.elements
end

ViewElementTutorialOverlay.active_tutorial_position_data = function (self)
	local data = self:_active_tutorial_data()

	return data and data.position_data
end

ViewElementTutorialOverlay.active_tutorial_clamping_data = function (self)
	local data = self:_active_tutorial_data()

	return data and data.clamping_data
end

ViewElementTutorialOverlay.ui_renderer = function (self)
	return self._ui_default_renderer
end

ViewElementTutorialOverlay.is_active = function (self)
	return self._active
end

ViewElementTutorialOverlay._setup_tooltip_grid = function (self)
	local grid_scenegraph_id = "tooltip_grid"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size
	local grid_settings = {
		scrollbar_width = 7,
		widget_icon_load_margin = 0,
		use_select_on_focused = false,
		edge_padding = 0,
		hide_dividers = true,
		use_is_focused_for_navigation = false,
		use_terminal_background = false,
		no_resource_rendering = true,
		title_height = 0,
		hide_background = true,
		grid_spacing = {
			0,
			0
		},
		grid_size = grid_size,
		mask_size = {
			grid_size[1] + MASK_PADDING_PIXEL_SIZE,
			grid_size[2] + MASK_PADDING_PIXEL_SIZE
		}
	}

	self._grid_settings = grid_settings

	local reference_name = "tooltip_grid"
	local layer = self._draw_layer + 10
	local scale = self._render_scale or RESOLUTION_LOOKUP.scale
	local grid = ViewElementGrid:new(self, layer, scale, grid_settings)

	self._tooltip_grid = grid
end

ViewElementTutorialOverlay._present_tooltip_grid_layout = function (self, layout)
	local definitions = self._definitions
	local grid_blueprints = definitions.grid_blueprints
	local grid = self._tooltip_grid

	grid:present_grid_layout(layout, grid_blueprints, nil, nil, nil, nil, callback(self, "cb_on_grid_layout_changed"), nil)
end

ViewElementTutorialOverlay.cb_on_grid_layout_changed = function (self, layout, content_blueprints, left_click_callback, right_click_callback, display_name, optional_grow_direction)
	local grid = self._tooltip_grid
	local grid_length = grid:grid_length()
	local clamping_data = self:active_tutorial_clamping_data()
	local menu_settings = grid:menu_settings()
	local grid_size = menu_settings.grid_size
	local mask_size = menu_settings.mask_size
	local new_grid_height = math.clamp(grid_length + 10, 0, 1900)

	grid_size[2] = new_grid_height
	mask_size[2] = new_grid_height

	self:_set_scenegraph_size("tooltip_grid", nil, new_grid_height + WINDOW_MARGINS_HEIGHT)
	self:_set_scenegraph_size("tooltip", nil, new_grid_height + WINDOW_MARGINS_HEIGHT)
	grid:force_update_list_size()
	self:_update_active_tooltip_entry_position()
end

ViewElementTutorialOverlay._update_active_tooltip_entry_position = function (self)
	if not self._active then
		return
	end

	local position_data = self:active_tutorial_position_data()

	if position_data then
		local x = position_data.x
		local y = position_data.y
		local z = position_data.z
		local clamping_data = self:active_tutorial_clamping_data()

		if clamping_data then
			local clamping_vertical_alignment = clamping_data.vertical_alignment or "top"
			local clamping_horizontal_alignment = clamping_data.horizontal_alignment or "top"
			local grid = self._tooltip_grid
			local menu_settings = grid:menu_settings()
			local grid_size = menu_settings.grid_size

			if clamping_vertical_alignment == "bottom" then
				y = y - (grid_size[2] + WINDOW_MARGINS_HEIGHT)
			elseif clamping_vertical_alignment == "center" then
				y = y - (grid_size[2] + WINDOW_MARGINS_HEIGHT) * 0.5
			end

			if clamping_horizontal_alignment == "right" then
				x = x - (grid_size[1] + WINDOW_MARGINS_WIDTH)
			elseif clamping_horizontal_alignment == "center" then
				x = x - (grid_size[1] + WINDOW_MARGINS_WIDTH) * 0.5
			end
		end

		self:_set_scenegraph_position("entry_pivot", x, y, z)

		local horizontal_alignment = position_data.horizontal_alignment
		local vertical_alignment = position_data.vertical_alignment

		self:_set_scenegraph_position("tooltip", nil, nil, nil, horizontal_alignment, vertical_alignment)
	end

	self:_update_tooltip_grid_position()
end

ViewElementTutorialOverlay._update_tooltip_grid_position = function (self)
	if not self._tooltip_grid then
		return
	end

	self:_force_update_scenegraph()

	local position = self:scenegraph_world_position("tooltip_grid")

	self._tooltip_grid:set_pivot_offset(position[1], position[2])
end

ViewElementTutorialOverlay._set_tooltip_visibility = function (self, visible, pulse_tooltip)
	self._tooltip_visibility = visible

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.tooltip.content.visible = visible
	widgets_by_name.tooltip.content.pulse = visible and pulse_tooltip

	local grid = self._tooltip_grid

	grid:set_visibility(visible)
end

ViewElementTutorialOverlay._on_navigation_input_changed = function (self)
	ViewElementTutorialOverlay.super._on_navigation_input_changed(self)
end

ViewElementTutorialOverlay.on_resolution_modified = function (self, scale)
	ViewElementTutorialOverlay.super.on_resolution_modified(self, scale)
	self:_update_active_tooltip_entry_position()
	self._tooltip_grid:set_render_scale(scale)
end

ViewElementTutorialOverlay.background_color_intensity = function (self)
	return self._background_color_intensity
end

ViewElementTutorialOverlay.highligt_color_intensity = function (self)
	return self._highligt_color_intensity
end

local _device_list = {
	Pad1,
	Keyboard,
	Mouse
}

ViewElementTutorialOverlay.update = function (self, dt, t, input_service)
	if self._start_delay then
		if self._start_delay <= 0 then
			self._start_delay = nil
			self._active = self:_present_next()
		else
			self._start_delay = self._start_delay - dt
		end
	elseif self._active then
		self._background_color_intensity = math.clamp(math.max(self._background_color_intensity - dt * 3, DEFAULT_COLOR_INTENSITY_VALUE), 0, 1)
		self._highligt_color_intensity = math.clamp(math.max(self._highligt_color_intensity + dt, self._background_color_intensity), 0, 1)
	end

	if self._close_intro_popup then
		self:_set_tooltip_visibility(true, true)

		self._active = nil
		self._close_intro_popup = nil
		self._current_index = 0
	end

	if self._active and not self._close_intro_popup then
		local any_input_pressed = false
		local input_device_list = InputUtils.platform_device_list()

		for i = 1, #input_device_list do
			local device = input_device_list[i]

			if device.active() and device.any_pressed() then
				any_input_pressed = true

				break
			end
		end

		if any_input_pressed and not self:_present_next() then
			self._close_intro_popup = true
		end
	end

	local grid = self._tooltip_grid

	if grid then
		grid:update(dt, t, input_service)

		if self._active_customize_preset_index then
			local equipped_grid_index
			local grid_widgets = grid:widgets()

			for i = 1, #grid_widgets do
				local grid_widget = grid_widgets[i]
				local content = grid_widget.content

				if content.equipped then
					equipped_grid_index = i

					break
				end
			end

			local gamepad_active = InputDevice.gamepad_active

			if not grid:selected_grid_index() then
				if gamepad_active and equipped_grid_index then
					grid:select_grid_index(equipped_grid_index)
				end
			elseif not gamepad_active then
				grid:select_grid_widget(nil)
			end

			local selected_grid_index = grid:selected_grid_index()

			if selected_grid_index and equipped_grid_index and selected_grid_index ~= equipped_grid_index then
				local grid_widget = grid_widgets[selected_grid_index]

				if grid_widget then
					-- Nothing
				end

				::label_28_0::

				local grid_widget_element = grid_widget.content.element
			end

			::label_28_1::

			input_service = input_service:null_service()
		end
	end

	if self._active_next_frame then
		self._active = true
		self._active_next_frame = nil
	end

	return ViewElementTutorialOverlay.super.update(self, dt, t, input_service)
end

ViewElementTutorialOverlay.force_close = function (self)
	if self._active then
		self._close_intro_popup = true
	end
end

ViewElementTutorialOverlay.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active or self._start_delay then
		return
	end

	local ui_renderer = self._ui_default_renderer
	local previous_color_intensity_multiplier = ui_renderer.color_intensity_multiplier

	ui_renderer.color_intensity_multiplier = 1

	local grid = self._tooltip_grid

	if grid then
		grid:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	ViewElementTutorialOverlay.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	ui_renderer.color_intensity_multiplier = previous_color_intensity_multiplier
end

ViewElementTutorialOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementTutorialOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementTutorialOverlay._get_input_text = function (self, input_action)
	local service_type = "View"
	local alias_key = Managers.ui:get_input_alias_key(input_action)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

	return tostring(input_text)
end

ViewElementTutorialOverlay.set_input_actions = function (self, input_action_left, input_action_right)
	self._input_action_left = input_action_left
	self._input_action_right = input_action_right

	self:_update_input_action_texts()
end

ViewElementTutorialOverlay._update_input_action_texts = function (self)
	local using_cursor_navigation = self._using_cursor_navigation
	local input_action_left = self._input_action_left
	local input_action_right = self._input_action_right
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.input_text_left.content.text = not using_cursor_navigation and input_action_left and self:_get_input_text(input_action_left) or ""
	widgets_by_name.input_text_right.content.text = not using_cursor_navigation and input_action_right and self:_get_input_text(input_action_right) or ""
end

ViewElementTutorialOverlay.destroy = function (self, ui_renderer)
	self._tooltip_grid:destroy(self._ui_default_renderer)

	self._tooltip_grid = nil

	ViewElementTutorialOverlay.super.destroy(self, self._ui_default_renderer)

	self._ui_default_renderer = nil

	Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

	local world = self._world
	local viewport_name = self._viewport_name

	ScriptWorld.destroy_viewport(world, viewport_name)
	Managers.ui:destroy_world(world)

	self._viewport_name = nil
	self._world = nil
end

return ViewElementTutorialOverlay
