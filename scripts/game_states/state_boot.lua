-- chunkname: @scripts/game_states/state_boot.lua

local PackageManager = require("scripts/foundation/managers/package/package_manager")

require("scripts/foundation/managers/package/package_manager_editor")

local UIStartupScreen = require("scripts/ui/ui_startup_screen")
local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local StateBoot = class("StateBoot")

local function _grab_mouse()
	if PLATFORM == "win32" then
		Window.set_focus()
		Window.set_mouse_focus(true)
		Window.set_clip_cursor(true)
		Window.set_cursor("content/ui/textures/cursors/mouse_cursor_idle")
	end
end

StateBoot.on_enter = function (self, parent, params)
	Script.set_index_offset(params.index_offset)

	local sub_state_params = {
		sub_state_index = 1,
		states = params.states,
	}

	self._done = false

	self:_create_startup_world()

	self._sm = GameStateMachine:new(self, params.states[1][1], sub_state_params, nil, nil, "Main", "Boot", true)
	self._next_state = params.next_state
	self._package_manager = params.package_manager
	self._localization_manager = params.localization_manager

	_grab_mouse()
end

StateBoot._create_startup_world = function (self)
	local world = Application.new_world("boot_world", Application.DISABLE_PHYSICS)

	self._world = world

	local shading_environment_name = GameParameters.default_ui_shading_environment

	self._shading_environment = World.create_shading_environment(world, shading_environment_name)
	self._viewport = Application.create_viewport(world, "overlay")

	local camera_unit = World.spawn_unit_ex(world, "core/units/camera")
	local camera = Unit.camera(camera_unit, "camera")

	self._camera_unit = camera_unit

	Camera.set_data(camera, "unit", camera_unit)
	Viewport.set_data(self._viewport, "camera", camera)

	self._gui = World.create_screen_gui(world, "immediate")
end

StateBoot.update = function (self, dt)
	self._sm:update(dt)
	self:_update_world(dt)

	if self._done then
		return CLASSES[self._next_state], {
			package_manager = self._package_manager,
			dt = dt,
			localization_manager = self._localization_manager,
		}
	end
end

StateBoot._update_world = function (self, dt)
	local dt = 0.03333333333333333

	World.update_timer(self._world, dt)
end

StateBoot.render = function (self)
	UIStartupScreen.render(self._gui)

	local viewport = self._viewport
	local camera = Viewport.get_data(viewport, "camera")
	local shading_environment = self._shading_environment

	Application.render_world(self._world, camera, viewport, shading_environment)
end

StateBoot.gui = function (self)
	return self._gui
end

StateBoot.sub_states_done = function (self)
	self._done = true
end

StateBoot.on_exit = function (self)
	self._sm:destroy()

	local world = self._world
	local gui = self._gui

	World.destroy_gui(world, gui)

	local shading_environment = self._shading_environment

	World.destroy_shading_environment(world, shading_environment)

	local camera_unit = self._camera_unit

	World.destroy_unit(world, camera_unit)

	local viewport = self._viewport

	Application.destroy_viewport(world, viewport)
	Application.release_world(world)
end

return StateBoot
