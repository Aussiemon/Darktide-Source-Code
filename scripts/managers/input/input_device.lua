local InputUtils = require("scripts/managers/input/input_utils")
local InputDevice = class("InputDevice")
InputDevice.DEFAULT_HELD_THRESHOLD = InputDevice.DEFAULT_HELD_THRESHOLD or 0.5
InputDevice.last_pressed_of_type = {}
InputDevice.last_pressed_device = nil
InputDevice.default_device_id = InputDevice.default_device_id or {}
InputDevice.gamepad_active = nil

InputDevice.init = function (self, raw_device, device_type, slot)
	self.device_type = device_type
	self.slot = slot
	self._raw_device = raw_device
	self._default_held_threshold = InputDevice.DEFAULT_HELD_THRESHOLD
	self._active = raw_device:active()
	self._last_press_event = 0
	self._is_gamepad = InputUtils.is_gamepad(device_type)
	InputDevice.last_pressed_device = InputDevice.last_pressed_device or self
	InputDevice.last_pressed_of_type[device_type] = InputDevice.last_pressed_of_type[device_type] or self

	if raw_device.device_id then
		self._device_id = raw_device.device_id()
	end
end

INPUT_BUFFER = {}

InputDevice.update = function (self, dt, t)
	local old_state = self._active
	self._active = self._raw_device:active()

	if self._active and (self._raw_device.any_pressed() or self:_any_analog_input()) and self:_verify_device() then
		self._last_press_event = t
		InputDevice.last_pressed_device = self
		InputDevice.last_pressed_of_type[self.device_type] = self
		InputDevice.gamepad_active = self._is_gamepad
	end

	if not old_state and self._active then
		Managers.event:trigger("device_activated", self)
	elseif old_state and not self._active then
		Managers.event:trigger("device_deactivated", self)
	end
end

local VALID_AXES = {
	left = true,
	right = true
}

InputDevice._any_analog_input = function (self)
	local input_device = self._raw_device
	local num_axes = input_device.num_axes()

	for key = 0, num_axes - 1 do
		local button_name = input_device.axis_name(key)

		if VALID_AXES[button_name] then
			local value = input_device.axis(key)

			if Vector3.length_squared(value) > 0 then
				return true
			end
		end
	end
end

InputDevice._verify_device = function (self)
	if not IS_XBS then
		return true
	end

	local default_device_id = InputDevice.default_device_id[self.device_type]

	if not default_device_id then
		return true
	else
		return default_device_id == self._device_id
	end
end

InputDevice.last_pressed = function (self)
	return self._last_press_event
end

InputDevice.active = function (self)
	return self._active
end

InputDevice.slot = function (self)
	return self.slot
end

InputDevice.held = function (self, id)
	return self._raw_device.button(id) > 0
end

InputDevice.type = function (self)
	return self.device_type
end

InputDevice.debug_name = function (self)
	if self.slot then
		return self.device_type .. "(" .. self.slot .. ")"
	end

	return self.device_type
end

InputDevice.button_index = function (self, name)
	return InputUtils.button_index(name, self._raw_device, self.device_type)
end

InputDevice.axis_index = function (self, name)
	return InputUtils.axis_index(name, self._raw_device, self.device_type)
end

InputDevice.local_key_name = function (self, key)
	return InputUtils.local_key_name(key, self.device_type)
end

InputDevice.local_to_global_name = function (self, local_name)
	return InputUtils.local_to_global_name(local_name, self.device_type)
end

InputDevice.raw_device = function (self)
	return self._raw_device
end

InputDevice.set_default_held_threshold = function (self, threshold)
	self._default_held_threshold = threshold
end

InputDevice.buttons_held = function (self)
	local raw_device = self._raw_device
	local num = math.min(raw_device.num_buttons(), 255)
	local button_list = {}

	for i = 0, num - 1 do
		if raw_device.button(i) > 0 then
			local raw_name = raw_device.button_name(i)
			local global_name = self:local_to_global_name(raw_name)

			table.insert(button_list, global_name)
		end
	end

	return button_list
end

InputDevice.buttons_released = function (self)
	local raw_device = self._raw_device
	local num = math.min(raw_device.num_buttons(), 255)
	local button_list = {}

	for i = 0, num - 1 do
		if raw_device.released(i) then
			local raw_name = raw_device.button_name(i)
			local global_name = self:local_to_global_name(raw_name)

			table.insert(button_list, global_name)
		end
	end

	return button_list
end

return InputDevice
