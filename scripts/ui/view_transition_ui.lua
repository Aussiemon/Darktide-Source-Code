-- chunkname: @scripts/ui/view_transition_ui.lua

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ViewTransitionUI = class("ViewTransitionUI", "ConstantElementBase")

ViewTransitionUI.init = function (self, render_settings)
	render_settings = render_settings or {
		viewport_type = "overlay",
		viewport_layer = 1,
		world_layer = 990,
		timer_name = "ui"
	}
	self._render_settings = render_settings
	self._fade_color = {
		z = 0,
		x = 0,
		y = 0
	}
end

ViewTransitionUI._setup_renderer = function (self)
	local class_name = self.__class_name
	local name_prefix = tostring(self) .. "_" .. class_name
	local render_settings = self._render_settings
	local ui_manager = Managers.ui
	local timer_name = render_settings.timer_name
	local world_layer = render_settings.world_layer
	local world_name = name_prefix .. "_ui_world"

	self._world = ui_manager:create_world(world_name, world_layer, timer_name)
	self._world_name = world_name
	self._world_draw_layer = world_layer
	self._world_default_layer = world_layer

	local viewport_name = name_prefix .. "_ui_world_viewport"
	local viewport_type = render_settings.viewport_type
	local viewport_layer = render_settings.viewport_layer

	self._background_viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name

	local renderer_name = name_prefix .. "_ui_renderer"

	self._ui_renderer = ui_manager:create_renderer(renderer_name, self._world)
	self._renderer_name = renderer_name
end

ViewTransitionUI._destroy_renderer = function (self)
	if self._ui_renderer then
		self._ui_renderer = nil

		Managers.ui:destroy_renderer(self._renderer_name)

		self._renderer_name = nil

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport = nil
		self._viewport_name = nil
		self._world = nil
	end
end

ViewTransitionUI.set_fade_color_rgb = function (self, r, g, b)
	self._fade_color.x = r or 0
	self._fade_color.y = g or 0
	self._fade_color.z = b or 0
end

ViewTransitionUI.progress = function (self)
	return self._progress or 0
end

ViewTransitionUI.destroy = function (self)
	if self._active then
		self:_destroy_renderer()

		self._active = nil
	end

	ViewTransitionUI.super.destroy(self)
end

ViewTransitionUI.active = function (self)
	return self._active
end

ViewTransitionUI.update = function (self, dt, t, should_transition, transition_progress)
	if not self._active and should_transition then
		self:_setup_renderer()

		self._active = true
	elseif self._active and not should_transition then
		self:_destroy_renderer()

		self._active = false
		self._progress = nil
	end

	self._progress = transition_progress

	if self._active then
		local anim_progress = transition_progress
		local ui_renderer = self._ui_renderer
		local gui = ui_renderer.gui
		local screen_width = RESOLUTION_LOOKUP.width
		local screen_height = RESOLUTION_LOOKUP.height
		local position = Vector3(0, 0, 999)
		local size = Vector2(screen_width, screen_height)
		local color = Color(255 * anim_progress, self._fade_color.x, self._fade_color.y, self._fade_color.z)

		Gui.rect(gui, position, size, color)
	end
end

return ViewTransitionUI
