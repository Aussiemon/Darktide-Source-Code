local Definitions = require("scripts/ui/views/system_view/system_view_definitions")
local ContentList = require("scripts/ui/views/system_view/system_view_content_list")
local ContentBlueprints = require("scripts/ui/views/system_view/system_view_content_blueprints")
local SystemViewSettings = require("scripts/ui/views/system_view/system_view_settings")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local SystemView = class("SystemView", "BaseView")

SystemView.init = function (self, settings)
	SystemView.super.init(self, Definitions, settings)
end

SystemView.on_enter = function (self)
	SystemView.super.on_enter(self)

	local scenegraph_id = "grid_content_pivot"
	local callback_name = "_on_entry_pressed_cb"
	self._content_widgets, self._alignment_list = self:_setup_content_widgets(ContentList, scenegraph_id, callback_name)
	self._content_grid = self:_setup_grid(self._content_widgets, self._alignment_list)

	self:_setup_content_grid_scrollbar()
	self:_setup_input_legend()
	self:_setup_default_gui()
	self:_setup_background_gui()
end

SystemView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

SystemView.cb_on_close_pressed = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
end

SystemView._setup_content_grid_scrollbar = function (self)
	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name.scrollbar
	local pivot_scenegraph_id = "grid_content_pivot"
	local interaction_scenegraph_id = "background"

	self._content_grid:assign_scrollbar(scrollbar_widget, pivot_scenegraph_id, interaction_scenegraph_id)
end

SystemView._on_entry_pressed_cb = function (self, widget, entry)
	local trigger_function = entry.trigger_function

	if trigger_function then
		trigger_function()
	end
end

SystemView._setup_content_widgets = function (self, content, scenegraph_id, callback_name)
	local definitions = self._definitions
	local widget_definitions = {}
	local widgets = {}
	local alignment_list = {}
	local current_state_name = Managers.ui:get_current_state_name()
	local list = content.default

	for name, value in pairs(content) do
		if name == current_state_name then
			list = value

			break
		end
	end

	local amount = #list

	for i = 1, amount do
		local entry = list[i]
		local verified = true
		local disabled = false
		local validation_function = entry.validation_function

		if validation_function and verified then
			verified, disabled = validation_function()
		end

		if verified then
			local type = entry.type
			local widget = nil
			local template = ContentBlueprints[type]
			local size = template.size
			local pass_template = template.pass_template

			if pass_template and not widget_definitions[type] then
				local scenegraph_definition = definitions.scenegraph_definition
				widget_definitions[type] = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
			end

			local widget_definition = widget_definitions[type]

			if widget_definition then
				local name = scenegraph_id .. "_widget_" .. i
				widget = self:_create_widget(name, widget_definition)
				local init = template.init

				if init then
					init(self, widget, entry, callback_name, disabled)
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

SystemView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_default_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

SystemView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local widgets_by_name = self._widgets_by_name
	local scrollbar_widget = widgets_by_name.scrollbar
	scrollbar_widget.content.visible = self._content_grid:can_scroll()

	SystemView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local content_widgets = self._content_widgets
	local num_content_widgets = #content_widgets

	for i = 1, num_content_widgets do
		local widget = content_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

SystemView._setup_grid = function (self, widgets, alignment_list)
	local ui_scenegraph = self._ui_scenegraph
	local grid_scenegraph_id = "background"
	local direction = "down"
	local spacing = ContentBlueprints.vertical_spacing

	return UIWidgetGrid:new(widgets, alignment_list, ui_scenegraph, grid_scenegraph_id, direction, spacing, nil, true)
end

SystemView.set_render_scale = function (self, scale)
	SystemView.super.set_render_scale(self, scale)
	self._content_grid:set_render_scale(self._render_scale)
end

SystemView.update = function (self, dt, t, input_service)
	local grid_length = self._content_grid:length()

	if grid_length ~= self._grid_length then
		self._grid_length = grid_length
	end

	self._content_grid:update(dt, t, input_service)

	return SystemView.super.update(self, dt, t, input_service)
end

SystemView.on_resolution_modified = function (self)
	SystemView.super.on_resolution_modified(self)
	self._content_grid:on_resolution_modified()

	self._grid_length = nil
end

SystemView._on_navigation_input_changed = function (self)
	SystemView.super._on_navigation_input_changed(self)

	local grid = self._content_grid

	if not self._using_cursor_navigation then
		if not grid:selected_grid_index() then
			grid:select_first_index()
		end
	elseif grid:selected_grid_index() then
		grid:select_grid_index(nil)
	end
end

SystemView._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 121
	local world_name = class_name .. "_ui_background_world"
	local view_name = self.view_name
	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._background_world_name = world_name
	self._background_world_draw_layer = world_layer
	self._background_world_default_layer = world_layer
	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_background_renderer = ui_manager:create_renderer(class_name .. "_ui_background_renderer", self._background_world)
	local max_value = 0.75

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value)
end

SystemView._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 122
	local world_name = class_name .. "_ui_default_world"
	local view_name = self.view_name
	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._world_name = world_name
	self._world_draw_layer = world_layer
	self._world_default_layer = world_layer
	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1
	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

SystemView.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

SystemView._destroy_background = function (self)
	if self._ui_background_renderer then
		self._ui_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end
end

SystemView._destroy_default_gui = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

SystemView.on_exit = function (self)
	self:_destroy_background()
	self:_destroy_default_gui()
	SystemView.super.on_exit(self)
end

return SystemView
