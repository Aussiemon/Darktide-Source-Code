-- chunkname: @scripts/ui/boot_ui.lua

local BootUI = class("BootUI")

BootUI.init = function (self)
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
	self._show_texts = false
	self._boot_texts = {}
end

BootUI.destroy = function (self)
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

BootUI.update = function (self, dt, optional_boot_texts)
	local fixed_dt = 0.03333333333333333

	World.update_timer(self._world, fixed_dt)
	self:_draw(optional_boot_texts)
end

BootUI._draw = function (self, optional_boot_texts)
	local gui = self._gui
	local screen_size = Vector2(Application.back_buffer_size())
	local canvas_size = Vector2(1920, 1080)
	local scale = math.min(screen_size.x / canvas_size.x, screen_size.y / canvas_size.y)

	Gui.rect(gui, Vector3.zero(), screen_size, Color(0, 0, 0))

	local icon_size = Vector2(256 * scale, 256 * scale)
	local icon_offset = Vector2(-25 * scale, -25 * scale, 999)
	local icon_position = icon_offset + (screen_size - icon_size)

	Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", icon_position, icon_size)

	if optional_boot_texts and DevParameters.boot_show_text then
		local font_name = "content/ui/fonts/mono_tide_regular"
		local font_size = 20 * scale
		local line_height = 1.3 * font_size
		local color = Color(235, 235, 235)

		for i = 1, #optional_boot_texts do
			local text = optional_boot_texts[i]
			local y = 10 + i * line_height

			Gui.slug_text(gui, text, font_name, font_size, Vector3(10, y, 999), nil, color)
		end
	end
end

BootUI.render = function (self)
	local viewport = self._viewport
	local camera = Viewport.get_data(viewport, "camera")
	local shading_environment = self._shading_environment

	Application.render_world(self._world, camera, viewport, shading_environment)
end

return BootUI
