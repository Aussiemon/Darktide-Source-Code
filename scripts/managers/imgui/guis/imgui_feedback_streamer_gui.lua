local ImguiFeedbackStreamerGui = class("ImguiFeedbackStreamerGui")

ImguiFeedbackStreamerGui.init = function (self, ...)
	self._input_manager = Managers.input
end

ImguiFeedbackStreamerGui._subwindow_count = function (self)
	return 0
end

ImguiFeedbackStreamerGui.update = function (self, dt, t)
	Renderer.render_streamer_imgui()
end

return ImguiFeedbackStreamerGui
