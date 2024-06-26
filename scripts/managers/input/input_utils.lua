﻿-- chunkname: @scripts/managers/input/input_utils.lua

local InputUtils = {}

InputUtils.input_device_list = {
	xbox_controller = {
		rawget(_G, "Pad1"),
		rawget(_G, "Pad2"),
		rawget(_G, "Pad3"),
		rawget(_G, "Pad4"),
		rawget(_G, "Pad5"),
		rawget(_G, "Pad6"),
		rawget(_G, "Pad7"),
		rawget(_G, "Pad8"),
	},
	ps4_controller = {
		rawget(_G, "PS5Pad1"),
		rawget(_G, "PS5Pad2"),
		rawget(_G, "PS5Pad3"),
		rawget(_G, "PS5Pad4"),
		rawget(_G, "PS5Pad5"),
		rawget(_G, "PS5Pad6"),
		rawget(_G, "PS5Pad7"),
		rawget(_G, "PS5Pad8"),
	},
	mouse = {
		rawget(_G, "Mouse"),
	},
	keyboard = {
		rawget(_G, "Keyboard"),
	},
}
InputUtils.replaced_strings = {}
InputUtils.replaced_strings.oem_period = "oem_period (> .)"
InputUtils.replaced_strings.oem_minus = "oem_minus (_ -)"
InputUtils.replaced_strings["numpad plus"] = "numpad +"
InputUtils.replaced_strings["num minus"] = "num -"
InputUtils.replaced_strings.oem_comma = "oem_comma (< ,)"
InputUtils.replaced_strings.oem_colon = "oem_1 (: ;)"
InputUtils.replaced_strings.oem_plus = "oem_plus (+ =)"
InputUtils.replaced_strings.oem_2 = "oem_2 (? /)"
InputUtils.replaced_strings.oem_3 = "oem_3 (~ `)"
InputUtils.replaced_strings.oem_4 = "oem_4 ({ [)"
InputUtils.replaced_strings.oem_5 = "oem_5 (| )"
InputUtils.replaced_strings.oem_6 = "oem_6 (} ])"
InputUtils.replaced_strings.oem_7 = "oem_7 (\" ')"
InputUtils.replaced_strings.oem_8 = "oem_8 (?!)"
InputUtils.replaced_strings.oem_102 = "oem_102 (> <)"

InputUtils.axis_index = function (global_name, raw_device, device_type)
	local k = InputUtils.local_key_name(global_name, device_type)

	if k then
		return raw_device.axis_index(k)
	end

	return nil
end

InputUtils.button_index = function (global_name, raw_device, device_type)
	local k = InputUtils.local_key_name(global_name, device_type)

	if k then
		return raw_device.button_index(k)
	end

	return nil
end

InputUtils.local_key_name = function (global_name, device_type)
	local i, j = string.find(global_name, device_type .. "_")

	if i then
		local k = string.sub(global_name, j + 1)

		k = InputUtils.replaced_strings[k] or k

		return k
	end
end

InputUtils.local_to_global_name = function (local_name, device_type)
	local_name = table.find(InputUtils.replaced_strings, local_name) or local_name

	return device_type .. "_" .. local_name
end

InputUtils.split_key = function (inputstr)
	local t = {}

	for str in string.gmatch(inputstr, "([^(%+)]+)") do
		table.insert(t, str)
	end

	local k = t[#t]

	t[#t] = nil

	local d = {}
	local m

	for str in string.gmatch(k, "([^(%-)]+)") do
		if not m then
			m = str
		else
			table.insert(d, str)
		end
	end

	return m, t, d
end

InputUtils.make_string = function (key_info)
	local keystring = key_info.main

	if key_info.enablers then
		for _, key in ipairs(key_info.enablers) do
			keystring = key .. "+" .. keystring
		end
	end

	if key_info.disablers then
		for _, key in ipairs(key_info.disablers) do
			keystring = keystring .. "-" .. key
		end
	end

	return keystring
end

InputUtils.get_first_device_of_type = function (device_type)
	return InputUtils.input_device_list[device_type][1]
end

InputUtils.key_device_type = function (global_name)
	for device_type, _ in pairs(InputUtils.input_device_list) do
		if string.find(global_name, device_type) then
			return device_type
		end
	end
end

InputUtils.localized_button_name = function (index, device)
	local device_category = device.category()
	local keystring = device.button_locale_name(index) or string.upper(device.button_name(index))

	if device_category == "keyboard" then
		keystring = string.upper(keystring)
		keystring = string.format("[%s]", keystring)
	end

	return keystring
end

InputUtils.localized_axis_name = function (index, device)
	local device_category = device.category()
	local keystring = device.axis_locale_name(index) or string.format("AXIS_%s", string.upper(device.axis_name(index)))

	if device_category == "keyboard" then
		keystring = string.upper(keystring)
		keystring = string.format("[%s]", keystring)
	end

	return keystring
end

InputUtils.key_axis_locale = function (global_name)
	local device_type = InputUtils.key_device_type(global_name)
	local dummy_device = InputUtils.get_first_device_of_type(device_type)

	if not dummy_device then
		return "[]"
	end

	local index = InputUtils.button_index(global_name, dummy_device, device_type)

	if index then
		return InputUtils.localized_button_name(index, dummy_device), device_type
	end

	index = InputUtils.axis_index(global_name, dummy_device, device_type)

	if index then
		return InputUtils.localized_axis_name(index, dummy_device), device_type
	end

	return "[]"
end

InputUtils.localized_string_from_key_info = function (key_info, color_tint_text)
	local keystring = InputUtils.key_axis_locale(key_info.main)

	if key_info.enablers then
		for _, key in ipairs(key_info.enablers) do
			keystring = InputUtils.key_axis_locale(key) .. "+" .. keystring
		end
	end

	if key_info.disablers then
		for _, key in ipairs(key_info.disablers) do
			keystring = keystring .. "-" .. InputUtils.key_axis_locale(key)
		end
	end

	if color_tint_text then
		local ui_input_color = Color.ui_input_color(255, true)

		keystring = InputUtils.apply_color_to_input_text(keystring, ui_input_color)
	end

	return keystring
end

InputUtils.apply_color_to_input_text = function (text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
end

local _keyboard_devices = {
	"keyboard",
	"mouse",
}
local _gamepad_devices = {
	xbox_controller = {
		"xbox_controller",
	},
	ps4_controller = {
		"ps4_controller",
	},
}

InputUtils.input_text_for_current_input_device = function (service_type, alias_key, color_tint_text)
	local input_manager = Managers.input
	local alias_array_index = 1
	local device_types = _keyboard_devices

	if input_manager:device_in_use("gamepad") then
		if IS_XBS then
			device_types = _gamepad_devices.xbox_controller
		elseif IS_PLAYSTATION then
			device_types = _gamepad_devices.ps4_controller
		else
			local device = input_manager:last_pressed_device()
			local type = device:type()

			device_types = _gamepad_devices[type] or _keyboard_devices
		end
	end

	local alias = input_manager:alias_object(service_type)
	local key_info = alias:get_keys_for_alias(alias_key, device_types)
	local input_key = key_info and InputUtils.localized_string_from_key_info(key_info, color_tint_text) or ""

	return input_key
end

InputUtils.is_gamepad = function (device_type)
	return _gamepad_devices[device_type] ~= nil
end

InputUtils.start_simulate_action = function (input_service_name, action_name, value)
	local input_service = Managers.input:get_input_service(input_service_name)

	input_service:start_simulate_action(action_name, value)
end

InputUtils.stop_simulate_action = function (input_service_name, action_name)
	local input_service = Managers.input:get_input_service(input_service_name)

	input_service:stop_simulate_action(action_name)
end

local _temp_device_list = {}

InputUtils.platform_device_list = function ()
	table.clear(_temp_device_list)

	local input_device_list = InputUtils.input_device_list

	if IS_XBS then
		table.append(_temp_device_list, input_device_list.xbox_controller)
	elseif IS_PLAYSTATION then
		table.append(_temp_device_list, input_device_list.ps4_controller)
	else
		table.append(_temp_device_list, input_device_list.mouse)
		table.append(_temp_device_list, input_device_list.keyboard)

		_temp_device_list[#_temp_device_list + 1] = Pad1
	end

	return _temp_device_list
end

return InputUtils
