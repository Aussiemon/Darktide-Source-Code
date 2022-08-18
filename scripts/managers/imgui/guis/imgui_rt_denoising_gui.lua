local ImguiDenoising = class("ImguiDenoising")

ImguiDenoising.init = function (self)
	self._input_manager = Managers.input
end

ImguiDenoising._subwindow_count = function (self)
	return 0
end

ImguiDenoising.update = function (self, dt, t)
	Renderer.render_denoiser_imgui()
end

return ImguiDenoising
