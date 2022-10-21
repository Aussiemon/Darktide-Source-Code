local ImguiPackages = class("ImguiPackages")
ImguiPackages.RED = {
	255,
	0,
	0,
	255
}
ImguiPackages.GREEN = {
	0,
	255,
	0,
	255
}
ImguiPackages.HEADER = {
	100,
	100,
	255,
	255
}

ImguiPackages.init = function (self)
	self._show_only_loaded = true
end

ImguiPackages._set_header_texts = function (...)
	local num_columns = select("#", ...)

	for i = 1, num_columns do
		Imgui.text_colored(select(i, ...), unpack(ImguiPackages.HEADER))
		Imgui.next_column()
	end
end

ImguiPackages._set_column_widths = function (...)
	local num_columns = select("#", ...)

	Imgui.columns(num_columns, true)

	for i = 1, num_columns do
		Imgui.set_column_width(select(i, ...), i - 1)
	end
end

ImguiPackages.update = function (self, dt, t)
	Imgui.set_window_size(1200, 400, "once")

	local pm = Managers.package
	self._show_only_loaded = Imgui.checkbox("Show only currently loaded packages", self._show_only_loaded)
	local references = pm:references(self._show_only_loaded)

	for key, value in pairs(references) do
		if Imgui.collapsing_header(key .. "    " .. "(" .. #value .. " item(s))", false) then
			self._set_column_widths(50, 650, 100, 100)

			if self._show_only_loaded then
				self._set_header_texts("ID", "Package name", "Load time", "")
			else
				self._set_header_texts("ID", "Package name", "Load time", "Unload time")
			end

			for i = 1, #value do
				local item = value[i]

				Imgui.text(item.id)
				Imgui.next_column()
				Imgui.text(item.package_name)
				Imgui.next_column()
				Imgui.text(string.format("%4f", item.load_call_time))
				Imgui.next_column()

				if not self._show_only_loaded then
					Imgui.text(string.format("%4f", item.unload_time))
				end

				Imgui.next_column()
			end

			Imgui.columns(1, false)
		end
	end
end

return ImguiPackages
