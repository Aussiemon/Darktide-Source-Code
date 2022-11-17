local ImguiParticleWorldGui = class("ImguiParticleWorldGui")

ImguiParticleWorldGui.init = function (self, world, ...)
	self._input_manager = Managers.input
	self._world = world
end

ImguiParticleWorldGui._subwindow_count = function (self)
	return 0
end

ImguiParticleWorldGui.update = function (self, dt, t)
	local world = self._world

	World.particles_draw_imgui_debug(world)
end

return ImguiParticleWorldGui
