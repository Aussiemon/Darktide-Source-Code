local ImguiResourceEventsGui = class("ImguiResourceEventsGui")

ImguiResourceEventsGui.init = function (self, ...)
	self._input_manager = Managers.input
end

ImguiResourceEventsGui._subwindow_count = function (self)
	return 0
end

ImguiResourceEventsGui.update = function (self, dt, t)
	return
end

return ImguiResourceEventsGui
