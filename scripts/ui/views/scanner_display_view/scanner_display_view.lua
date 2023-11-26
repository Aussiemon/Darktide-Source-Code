-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view.lua

local MinigameDecodeSymbolsView = require("scripts/ui/views/scanner_display_view/minigame_decode_symbols_view")
local MinigameNoneView = require("scripts/ui/views/scanner_display_view/minigame_none_view")
local MinigameScanView = require("scripts/ui/views/scanner_display_view/minigame_scan_view")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewDefinitions = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local DEBUG_RENDERING = false
local ScannerDisplayView = class("ScannerDisplayView", "BaseView")

ScannerDisplayView.MINIGAMES = {
	[MinigameSettings.types.none] = MinigameNoneView,
	[MinigameSettings.types.scan] = MinigameScanView,
	[MinigameSettings.types.decode_symbols] = MinigameDecodeSymbolsView
}

ScannerDisplayView.init = function (self, settings, context)
	local class_name = self.__class_name

	self._viewport_name = class_name .. "_ui_offscreen_world_viewport"
	self._viewport_type = "overlay_offscreen_3"
	self._viewport_layer = 1
	self._viewport = nil
	self._offscreen_ui_renderer = nil
	self._no_cursor = true
	self._minigame = ScannerDisplayView.MINIGAMES[context.minigame_type]:new(context)

	local definitions = ScannerDisplayViewDefinitions[context.minigame_type]

	ScannerDisplayView.super.init(self, definitions, settings)

	if self._minigame.set_local_player then
		local player = self:_player()

		self._minigame:set_local_player(player)
	end
end

local system_name = "dialogue_system"

ScannerDisplayView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

ScannerDisplayView.on_enter = function (self)
	ScannerDisplayView.super.on_enter(self)
	self:_setup_offscreen_gui()
end

ScannerDisplayView.is_using_input = function (self)
	return false
end

ScannerDisplayView.on_exit = function (self)
	local offscreen_ui_renderer = self._offscreen_ui_renderer

	if offscreen_ui_renderer then
		local ui_manager = Managers.ui
		local world = self._world
		local class_name = self.__class_name
		local renderer_name = class_name .. "_offscreen_ui_renderer"
		local viewport_name = self._viewport_name

		ui_manager:destroy_renderer(renderer_name)
		ScriptWorld.destroy_viewport(world, viewport_name)

		self._viewport = nil
		self._offscreen_ui_renderer = nil

		ui_manager:destroy_world(self._world)

		self._world_name = nil
		self._world = nil
	end

	ScannerDisplayView.super.on_exit(self)
end

ScannerDisplayView._setup_offscreen_gui = function (self)
	self:_create_offscreen_world()

	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local world = self._world
	local viewport_name = self._viewport_name
	local viewport_type = self._viewport_type
	local viewport_layer = self._viewport_layer
	local renderer_name = class_name .. "_offscreen_ui_renderer"

	self._viewport = ui_manager:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	self._offscreen_ui_renderer = ui_manager:create_renderer(renderer_name, world)
end

ScannerDisplayView._create_offscreen_world = function (self)
	local world_layer = 500
	local timer_name = "ui"
	local class_name = self.__class_name
	local world_name = class_name .. "_offscreen_world"

	self._world_name = world_name
	self._world = Managers.ui:create_world(world_name, world_layer, timer_name)
end

ScannerDisplayView.update = function (self, dt, t)
	self._minigame:update(dt, t, self._widgets_by_name)

	return ScannerDisplayView.super.update(self, dt, t)
end

ScannerDisplayView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	ScannerDisplayView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
	self._minigame:draw_widgets(dt, t, input_service, ui_renderer)
end

ScannerDisplayView.draw = function (self, dt, t, input_service, layer)
	if DEBUG_RENDERING then
		ScannerDisplayView.super.draw(self, dt, t, input_service, layer)
	else
		local render_scale = self._render_scale
		local render_settings = self._render_settings
		local ui_renderer = self._offscreen_ui_renderer
		local ui_scenegraph = self._ui_scenegraph

		render_settings.start_layer = layer
		render_settings.scale = render_scale
		render_settings.inverse_scale = render_scale and 1 / render_scale

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
		self:_draw_widgets(dt, t, input_service, ui_renderer)
		UIRenderer.end_pass(ui_renderer)
		self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
	end
end

return ScannerDisplayView
