-- chunkname: @scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup.lua

local definition_path = "scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup_definitions"
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WorldRenderUtils = require("scripts/utilities/world_render")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local BLUR_TIME = 0.3
local ViewElementKeybindPopup = class("ViewElementKeybindPopup", "ViewElementBase")

ViewElementKeybindPopup.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	ViewElementKeybindPopup.super.init(self, parent, draw_layer, start_scale, definitions)
	self:_setup_default_gui()
	self:_setup_background_gui()

	local background_widget_definition = self._definitions.background_widget_definition

	self._background_widget = self:_create_widget("background_widget", background_widget_definition)
	self._blur_duration = BLUR_TIME
end

ViewElementKeybindPopup.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ViewElementKeybindPopup._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer + 10
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

ViewElementKeybindPopup._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = self._draw_layer + 9
	local world_name = class_name .. "_ui_background_world"
	local view_name = self._parent.view_name

	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_popup_background_renderer = ui_manager:create_renderer(class_name .. "_ui_popup_background_renderer", self._background_world)
end

ViewElementKeybindPopup.destroy = function (self, ui_renderer)
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

	if self._ui_popup_background_renderer then
		self._ui_popup_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_popup_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end

	ViewElementKeybindPopup.super.destroy(self, ui_renderer)
end

ViewElementKeybindPopup._set_background_blur = function (self, fraction)
	local max_value = 0.55
	local class_name = self.__class_name
	local world_name = class_name .. "_ui_background_world"
	local viewport_name = class_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

ViewElementKeybindPopup.update = function (self, dt, t, input_service)
	if self._blur_duration then
		if self._blur_duration < 0 then
			self._blur_duration = nil
		else
			local progress = 1 - self._blur_duration / BLUR_TIME
			local anim_progress = math.easeOutCubic(progress)

			self:_set_background_blur(anim_progress)

			self._blur_duration = self._blur_duration - dt
			self._alpha_multiplier = anim_progress
		end
	end

	self:_pulse_action_text()

	return ViewElementKeybindPopup.super.update(self, dt, t, input_service)
end

ViewElementKeybindPopup.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	ui_renderer = self._ui_default_renderer

	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	ViewElementKeybindPopup.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = previous_alpha_multiplier

	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	local ui_scenegraph = self._ui_scenegraph
	local ui_popup_background_renderer = self._ui_popup_background_renderer

	UIRenderer.begin_pass(ui_popup_background_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._background_widget, ui_popup_background_renderer)
	UIRenderer.end_pass(ui_popup_background_renderer)

	render_settings.start_layer = previous_layer
end

ViewElementKeybindPopup._pulse_action_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local value_text = widgets_by_name.value_text
	local speed = 4
	local anim_progress = 0.5 + math.sin(Application.time_since_launch() * speed) * 0.5

	value_text.alpha_multiplier = 0.4 + 0.6 * anim_progress
end

ViewElementKeybindPopup._get_color_string_by_color = function (self, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}"
end

ViewElementKeybindPopup.set_value_text = function (self, value)
	local widgets_by_name = self._widgets_by_name
	local value_text = widgets_by_name.value_text

	value_text.content.text = value
end

ViewElementKeybindPopup.set_action_text = function (self, action)
	local widgets_by_name = self._widgets_by_name
	local action_text = widgets_by_name.action_text

	action_text.content.text = action
end

ViewElementKeybindPopup.set_description_text = function (self, description)
	local widgets_by_name = self._widgets_by_name
	local description_text = widgets_by_name.description_text

	description_text.content.text = description
end

return ViewElementKeybindPopup
