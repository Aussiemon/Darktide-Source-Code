local ImguiEnvironmentGui = class("ImguiEnvironmentGui")
ImguiEnvironmentGui.HEADER = {
	100,
	100,
	255,
	255
}

ImguiEnvironmentGui.init = function (self)
	return
end

ImguiEnvironmentGui._set_header_texts = function (...)
	local num_columns = select("#", ...)

	for i = 1, num_columns do
		Imgui.text_colored(select(i, ...), unpack(ImguiEnvironmentGui.HEADER))
		Imgui.next_column()
	end
end

ImguiEnvironmentGui._set_column_widths = function (...)
	local num_columns = select("#", ...)

	Imgui.columns(num_columns, true)

	for i = 1, num_columns do
		Imgui.set_column_width(select(i, ...), i - 1)
	end
end

ImguiEnvironmentGui.update = function (self, dt, t)
	Imgui.set_window_size(975, 400, "once")

	local blends = Managers.shading_environment_blend_debug:blends()

	if blends then
		self._set_column_widths(600, 100, 100, 75, 100)
		self._set_header_texts("Shading Environment Resource", "Percentage", "Blend Mask", "Layer", "Source")

		for i = 1, #blends do
			local blend = blends[i]

			Imgui.text(tostring(blend.resource_name))
			Imgui.next_column()

			local percentage = string.format("%.2f", blend.weight * 100)

			Imgui.text(percentage)
			Imgui.next_column()
			Imgui.text(tostring(blend.blend_mask))
			Imgui.next_column()
			Imgui.text(tostring(blend.layer))
			Imgui.next_column()
			Imgui.text(tostring(blend.source))
			Imgui.next_column()
		end
	end
end

return ImguiEnvironmentGui
