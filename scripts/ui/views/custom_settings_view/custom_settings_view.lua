local Definitions = require("scripts/ui/views/custom_settings_view/custom_settings_view_definitions")
local ContentBlueprints = require("scripts/ui/views/custom_settings_view/custom_settings_view_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local CustomSettingsView = class("CustomSettingsView", "BaseView")

CustomSettingsView.init = function (self, settings, context)
	local settings = settings or {}
	self.pages = (context and context.pages) or {}

	CustomSettingsView.super.init(self, Definitions, settings)

	self._allow_close_hotkey = false
end

CustomSettingsView.on_enter = function (self)
	CustomSettingsView.super.on_enter(self)

	self._grid = nil
	self._offscreen_world = nil
	self._offscreen_viewport = nil
	self._offscreen_viewport_name = nil
	self._grid_widgets = {}
	self._current_index = 1

	self:_setup_buttons_interactions()
	self:_setup_offscreen_renderer()
	self:_change_settings_page(self._current_index)
end

CustomSettingsView.on_exit = function (self)
	self:_destroy_offscreen_renderer()
	Application.save_user_settings()
	CustomSettingsView.super.on_exit(self)
end

CustomSettingsView._setup_offscreen_renderer = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name
	self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._offscreen_world)
end

CustomSettingsView._destroy_offscreen_renderer = function (self)
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

CustomSettingsView._setup_buttons_interactions = function (self)
	self._widgets_by_name.next_button.content.hotspot.pressed_callback = callback(self, "_on_forward_pressed")
end

CustomSettingsView._change_settings_page = function (self, next_index)
	if next_index > #self.pages then
		return Managers.ui:close_view(self.view_name)
	end

	local page_title = self.pages[next_index].display_name
	local current_widgets = self._grid_widgets
	local title_widget = self._widgets_by_name.title_settings
	local page_number_widget = self._widgets_by_name.page_number

	if current_widgets then
		for i = 1, #current_widgets, 1 do
			local widget = current_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	local widgets = {}
	local alignments = {}
	local grid_scenegraph_id = "grid_start"
	local scenegraph_id = "grid_content_pivot"
	local widget_focus_index = nil

	for i = 1, #self.pages[next_index].entries, 1 do
		local entry = self.pages[next_index].entries[i]
		local name = "widget_" .. i

		if entry.pass_template then
			local pass_template = entry.pass_template
			local size = entry.size
			local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
			local widget = self:_create_widget(name, widget_definition)
			widget.entry = entry
			widgets[#widgets + 1] = widget
			alignments[#alignments + 1] = widget

			if entry.focusable and not widget_focus_index then
				widget_focus_index = i
			end
		elseif entry.widget_type then
			local widget_type = entry.widget_type
			local template = ContentBlueprints[widget_type]
			local size = entry.size or template.size
			local pass_template = template.pass_template
			local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
			local widget = self:_create_widget(name, widget_definition)
			widget.type = widget_type
			widget.id = entry.id
			widget.entry = entry
			local init = template.init

			if init then
				init(self, widget, entry, "cb_on_settings_pressed")
			end

			widgets[#widgets + 1] = widget
			alignments[#alignments + 1] = widget

			if entry.focusable then
				widget_focus_index = widget_focus_index or i
			end
		end
	end

	local direction = "down"
	local grid = UIWidgetGrid:new(widgets, alignments, self._ui_scenegraph, grid_scenegraph_id, direction, {
		0,
		10
	})
	self._grid = grid
	self._grid_widgets = widgets
	self._current_index = next_index
	title_widget.content.text = Localize(page_title)
	page_number_widget.content.text = self._current_index .. " / " .. #self.pages
	self._focused_widget_index = widget_focus_index

	self:_focus_selected_widget()
end

CustomSettingsView.cb_on_settings_pressed = function (self, widget, entry)
	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end
end

CustomSettingsView._on_forward_pressed = function (self)
	local index = self._current_index + 1

	self:_change_settings_page(index)
end

CustomSettingsView.draw = function (self, dt, t, input_service, layer)
	if self._grid then
		self:_draw_grid(dt, t, input_service)
	end

	return CustomSettingsView.super.draw(self, dt, t, input_service, layer)
end

CustomSettingsView._draw_grid = function (self, dt, t, input_service)
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local widgets = self._grid_widgets
	local grid = self._grid

	if grid then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		for i = 1, #widgets, 1 do
			local widget = widgets[i]

			if grid:is_widget_visible(widget) then
				local widget_type = widget.type
				local template = ContentBlueprints[widget_type]
				local update = template and template.update

				if update then
					update(self, widget, input_service, dt, t)
				end

				UIWidget.draw(widget, ui_renderer)
			end
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

CustomSettingsView._handle_input = function (self, input_service)
	local is_gamepad = not self:using_cursor_navigation()

	if is_gamepad and input_service:get("confirm_pressed") then
		self:_on_forward_pressed()
	end
end

CustomSettingsView._on_navigation_input_changed = function (self)
	self:_focus_selected_widget()
end

CustomSettingsView._focus_selected_widget = function (self)
	local is_gamepad = not self:using_cursor_navigation()
	local index = self._focused_widget_index

	self._grid:focus_grid_index()

	for i = 1, #self._grid_widgets, 1 do
		local widget = self._grid_widgets[i]
		local content = widget.content

		if content.hotspot then
			content.hotspot.is_selected = false
		end

		content.exclusive_focus = false
	end

	if is_gamepad and index then
		self._grid:focus_grid_index(index)

		local widget = self._grid_widgets[index]
		local content = widget.content

		if content.hotspot then
			content.hotspot.is_selected = true
		end

		content.exclusive_focus = true
	end
end

return CustomSettingsView
