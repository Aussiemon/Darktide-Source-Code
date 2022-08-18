local InputDevice = require("scripts/managers/input/input_device")
local InputDebug = class("InputDebug")
InputDebug._debug_devices = {
	keyboard = Keyboard,
	xbox_controller = Pad1,
	mouse = Mouse,
	gamepad = Pad1,
	ps4_controller = PS4Pad1
}
InputDebug.BUTTON_FUNCS = {
	"button",
	"pressed",
	"released",
	"held"
}
InputDebug.AXIS_FUNCS = {
	"axis"
}
InputDebug.DEBUG_TAG = "Input Debug"
InputDebug.DISPLAY_AS = {
	["left shift"] = "LSHIFT",
	["right shift"] = "RSHIFT",
	["left ctrl"] = "LCTRL",
	["right ctrl"] = "RCTRL",
	["left alt"] = "LALT",
	["right alt"] = "RALT"
}

InputDebug.value_or_table_to_string = function (item, uppercase)
	local out = nil

	if type(item) == "table" then
		for n, i in ipairs(item) do
			i = InputDebug.DISPLAY_AS[i] or i

			if uppercase then
				i = string.upper(i)
			end

			if not out then
				out = i
			else
				out = out .. " | " .. i
			end
		end

		if out then
			return out
		end

		for k, v in pairs(item) do
			if type(v) == "table" then
				v = InputDebug.value_or_table_to_string(v, uppercase)
			end

			v = InputDebug.DISPLAY_AS[v] or v

			if uppercase then
				v = string.upper(v)
			end

			if not out then
				out = v
			else
				out = out .. " | " .. v
			end
		end

		out = out or ""

		return out
	end

	item = InputDebug.DISPLAY_AS[item] or item or ""

	if uppercase then
		item = string.upper(item)
	end

	return item
end

local function _debug_print(str, ...)
	Log.debug(InputDebug.DEBUG_TAG, str, ...)
end

InputDebug.active_debug_device_types = function ()
	local device_types = {
		keyboard = DevParameters.debug_show_keyboard_mappings,
		mouse = DevParameters.debug_show_mouse_mappings,
		xbox_controller = DevParameters.debug_show_xbox_mappings,
		ps4_controller = DevParameters.debug_show_ps4_mappings
	}

	return device_types
end

return InputDebug
