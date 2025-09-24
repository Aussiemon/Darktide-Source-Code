-- chunkname: @scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay.lua

require("scripts/ui/view_elements/view_element_base")

local Definitions = require("scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Settings = require("scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay_settings")
local ViewElementLoadingOverlay = class("ViewElementLoadingOverlay", "ViewElementBase")

ViewElementLoadingOverlay.init = function (self, parent, draw_layer, start_scale, settings)
	ViewElementLoadingOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._settings = table.merge(settings, Settings)
	self._unique_id = string.format("table:%s", table.tostring(self))
	self._loading = false
	self._opacity = 0

	if not self._settings.use_parent_renderer then
		self:_setup_world()
	end
end

ViewElementLoadingOverlay._setup_world = function (self)
	do
		local world_name = self._unique_id .. "_world"
		local world_layer = 101 + (self._draw_layer or 0)
		local timer_name = "ui"
		local view_name = self._parent.view_name

		self._world = Managers.ui:create_world(world_name, world_layer, timer_name, view_name)
	end

	do
		local viewport_name = self._unique_id .. "_viewport"
		local viewport_type = "overlay"
		local viewport_layer = 1

		self._viewport = Managers.ui:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
		self._viewport_name = viewport_name
	end

	local world = self._world
	local renderer_name = self._unique_id .. "_renderer"

	self._renderer = Managers.ui:create_renderer(renderer_name, world)
end

ViewElementLoadingOverlay.destroy = function (self)
	self:_destroy_world()
	ViewElementLoadingOverlay.super.destroy(self)
end

ViewElementLoadingOverlay._destroy_world = function (self)
	if self._renderer then
		Managers.ui:destroy_renderer(self._unique_id .. "_renderer")

		self._renderer = nil
	end

	if self._world and self._viewport_name then
		ScriptWorld.destroy_viewport(self._world, self._viewport_name)

		self._viewport_name = nil
	end

	if self._world then
		Managers.ui:destroy_world(self._world)

		self._world = nil
	end
end

ViewElementLoadingOverlay.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local loading_widget = self._widgets_by_name.loading
	local wait_reason, _, max_opacity = Managers.ui:current_wait_info()

	if wait_reason ~= nil then
		self._opacity = math.clamp(self._opacity + dt / self._settings.fade_in_time, 0, 1)
	else
		self._opacity = math.clamp(self._opacity - dt / self._settings.fade_out_time, 0, 1)
	end

	local should_show = wait_reason ~= nil or self._opacity > 0

	loading_widget.visible = should_show

	if should_show then
		loading_widget.alpha_multiplier = self._opacity * (max_opacity or 255) / 255
		loading_widget.content.text = self._settings.wait_reason or wait_reason or ""
	end

	ui_renderer = self._settings.use_parent_renderer and ui_renderer or self._renderer

	ViewElementLoadingOverlay.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return ViewElementLoadingOverlay
