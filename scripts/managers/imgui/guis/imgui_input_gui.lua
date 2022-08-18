local InputDebug = require("scripts/managers/input/input_debug")
local InputDevice = require("scripts/managers/input/input_device")
local ImguiInputGui = class("ImguiInputGui")
ImguiInputGui.RED = {
	255,
	0,
	0,
	255
}
ImguiInputGui.GREEN = {
	0,
	255,
	0,
	255
}
ImguiInputGui.HEADER = {
	100,
	100,
	255,
	255
}

local function _log(str, ...)
	Log.info(ImguiInputGui.DEBUG_TAG, str, ...)
end

ImguiInputGui.init = function (self, ...)
	self._input_manager = Managers.input
end

ImguiInputGui.on_activated = function (self)
	self._input_manager:activate_tracking()
end

ImguiInputGui.on_deactivated = function (self)
	self._input_manager:deactivate_tracking()
end

ImguiInputGui._set_header_texts = function (...)
	local num_columns = select("#", ...)

	for i = 1, num_columns, 1 do
		Imgui.text_colored(select(i, ...), unpack(ImguiInputGui.HEADER))
		Imgui.next_column()
	end
end

ImguiInputGui._set_column_widths = function (...)
	local num_columns = select("#", ...)

	Imgui.columns(num_columns, true)

	for i = 1, num_columns, 1 do
		Imgui.set_column_width(select(i, ...), i - 1)
	end
end

ImguiInputGui._column_entry = function (text, mark, mark_color)
	text = InputDebug.value_or_table_to_string(text)

	if mark then
		Imgui.text_colored(text, unpack(mark_color))
	else
		Imgui.text(text)
	end

	Imgui.next_column()
end

ImguiInputGui._selectable_entry = function (id, text, prev_selected)
	if prev_selected then
		Imgui.push_style_color(Imgui.COLOR_TEXT, 255, 0, 0, 255)
	end

	local selected = Imgui.selectable(text .. "##" .. tostring(id), prev_selected)

	if prev_selected then
		Imgui.pop_style_color(1)
	end

	Imgui.next_column()

	return selected
end

ImguiInputGui._prev_value_text = function (action, t)
	local text = ""

	if action.last_change > t - DevParameters.debug_input_last_action_track_time then
		text = string.format("%s ( t: %.2f )", action.last_value, action.last_change - t)
	end

	return text
end

ImguiInputGui.raw_device = function (self, device_type)
	local devices = self._input_manager:debug_get_input_devices()

	for k, m in pairs(devices) do
		if m.device_type == device_type then
			return k
		end
	end
end

ImguiInputGui.update = function (self, dt, t)
	Imgui.begin_child_window("Devices", 900, 200, true)
	Imgui.columns(1, true)

	if Imgui.collapsing_header("Devices", false) then
		Imgui.indent()
		self._set_column_widths(250, 150, 150, 150)
		self._set_header_texts("Type", "Slot", "Active", "Used")

		local all_devices = self._input_manager:debug_get_all_input_devices()
		local used_devices = self._input_manager:debug_get_all_used_devices()

		for _, device in pairs(all_devices) do
			self._column_entry(device.device_type)
			self._column_entry(device.slot)

			if device:active() then
				self._column_entry("YES", true, ImguiInputGui.GREEN)

				if table.contains(used_devices, device) then
					self._column_entry("YES", true, ImguiInputGui.GREEN)
				else
					self._column_entry("NO", true, ImguiInputGui.RED)
				end
			else
				self._column_entry("NO", true, ImguiInputGui.RED)
				self._column_entry("NO", true, ImguiInputGui.RED)
			end
		end

		Imgui.unindent()
	end

	Imgui.end_child_window()
	Imgui.begin_child_window("Services", 900, 800, true)
	Imgui.columns(1, true)

	if Imgui.collapsing_header("Services", false) then
		Imgui.indent()

		local services = self._input_manager:debug_get_input_services()

		for _, service in pairs(services) do
			local name = service.type

			Imgui.columns(1, true)

			if Imgui.collapsing_header(name, false) then
				self._set_column_widths(250, 250, 150, 250)
				self._set_header_texts("Action", "Mapping", "Current Value", "Previous Value")

				local actions = service:debug_get_all_actions()

				for action_name, action_rule in table.sorted(actions, Managers.frame_table:get_table()) do
					self._column_entry(action_name, action_rule.filter, ImguiInputGui.GREEN)
					self._column_entry(InputDebug.value_or_table_to_string(action_rule.keys, false), false)
					self._column_entry(action_rule.action_value, action_rule.action_value ~= action_rule.default_value, ImguiInputGui.RED)
					self._column_entry(self._prev_value_text(action_rule, t), false)
				end
			end
		end

		Imgui.unindent()
	end

	Imgui.end_child_window()
end

return ImguiInputGui
