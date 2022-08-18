local ImguiMeshStreamerGui = class("ImguiMeshStreamerGui")

ImguiMeshStreamerGui.init = function (self, ...)
	self._input_manager = Managers.input
end

ImguiMeshStreamerGui._subwindow_count = function (self)
	return 0
end

ImguiMeshStreamerGui.update = function (self, dt, t)
	Renderer.render_mesh_streamer_imgui()
end

return ImguiMeshStreamerGui
