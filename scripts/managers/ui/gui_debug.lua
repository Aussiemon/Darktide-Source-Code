local GuiDebug = {
	named_guis = {},
	material_names = {},
	start_frame_caputure = false,
	log_enabled = false
}

local function innergui(function_name, ...)
	if GuiDebug.log_enabled then
		local num_args = select("#", ...)
		local args = {}
		local gui = select(1, ...)
		local str = "[%s][%s]"

		for i = 2, num_args, 1 do
			args[i - 1] = tostring(select(i, ...))

			if type(select(i, ...)) == "string" then
				args[i - 1] = "\"" .. args[i - 1] .. "\""
			end

			if args[i - 1] == "[Material]" and GuiDebug.material_names[gui] and GuiDebug.material_names[gui][select(i, ...)] then
				args[i - 1] = "[material = " .. GuiDebug.material_names[gui][select(i, ...)] .. "]"
			end

			str = str .. " %s "
		end

		local world_name = GuiDebug.named_guis[gui] or "??"

		Log.info("GUIDebug", str, function_name, world_name, unpack(args))
	end

	return GuiDebug[function_name](...)
end

for key, value in pairs(Gui) do
	if type(value) == "function" then
		GuiDebug[key] = value
		Gui[key] = callback(innergui, key)
	end
end

return GuiDebug
