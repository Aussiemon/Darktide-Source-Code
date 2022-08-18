local InputAliases = require("scripts/managers/input/input_aliases")
local InputDevice = require("scripts/managers/input/input_device")
local InputLocaleNameOverrides = require("scripts/settings/input/input_locale_name_overrides")
local InputManagerTestify = GameParameters.testify and require("scripts/managers/input/input_manager_testify")
local InputService = require("scripts/managers/input/input_service")
local InputUtils = require("scripts/managers/input/input_utils")
local DefaultSettings = {}

table.insert(DefaultSettings, require("scripts/settings/input/default_debug_input_settings"))
table.insert(DefaultSettings, require("scripts/settings/input/default_free_flight_input_settings"))
table.insert(DefaultSettings, require("scripts/settings/input/default_ingame_input_settings"))
table.insert(DefaultSettings, require("scripts/settings/input/default_imgui_input_settings"))
table.insert(DefaultSettings, require("scripts/settings/input/default_view_input_settings"))

local AdvancedSettings = {}

table.insert(AdvancedSettings, require("scripts/settings/input/default_debug_input_settings"))
table.insert(AdvancedSettings, require("scripts/settings/input/default_free_flight_input_settings"))
table.insert(AdvancedSettings, require("scripts/settings/input/advanced_ingame_input_settings"))
table.insert(AdvancedSettings, require("scripts/settings/input/default_imgui_input_settings"))
table.insert(AdvancedSettings, require("scripts/settings/input/default_view_input_settings"))

local InputManager = class("InputManager")
InputManager.DEBUG_TAG = "Input Manager"
InputManager.SELECTION_LOGIC = table.enum("fixed", "latest", "combined")

local function _log(str, ...)
	Log.info(InputManager.DEBUG_TAG, str, ...)
end

InputManager.init = function (self)
	self._all_input_devices = {}
	self._active_input_devices = {}
	self._used_input_devices = {}
	self._available_layouts = {
		default = {
			display_name = "loc_setting_controller_layout_default",
			settings = DefaultSettings
		},
		advanced = {
			display_name = "loc_setting_controller_layout_advanced",
			settings = AdvancedSettings
		}
	}
	self._input_services = {}
	self._input_settings = {}
	self._aliases = {}
	self._key_watch_result = nil
	self._key_watch_devices = {}
	self._key_watch = false
	self._selection = {
		logic = InputManager.SELECTION_LOGIC.latest,
		controller_type = "keyboard",
		slot = 1
	}
	local event_manager = Managers.event

	event_manager:register(self, "device_activated", "_cb_device_activated")
	event_manager:register(self, "device_deactivated", "_cb_device_deactivated")

	self._use_last_pressed = true

	for _, default_setting in ipairs(DefaultSettings) do
		self:add_setting(default_setting.service_type, default_setting.aliases, default_setting.settings, default_setting.filters, default_setting.default_devices)
	end

	if not DEDICATED_SERVER and PLATFORM == "win32" then
		self._cursor_stack_data = {
			stack_depth = 0,
			stack_references = {}
		}
		local allow_cursor_rendering = true

		self:_set_allow_cursor_rendering(allow_cursor_rendering)
		self:_update_clip_cursor()
	end
end

InputManager.load_settings = function (self)
	for service_type, alias in pairs(self._aliases) do
		alias:load(service_type)
		self:apply_alias_changes(service_type)
	end
end

InputManager.init_all_devices = function (self)
	if DEDICATED_SERVER then
		return
	end

	for category, device_list in pairs(InputUtils.input_device_list) do
		for i, device in ipairs(device_list) do
			self:init_device(category, device, i)
		end
	end

	self:_update_selection()
end

InputManager.set_selection_logic = function (self, logic, controller_type, slot)
	self._selection.logic = logic or self._selection.logic
	self._selection.controller_type = controller_type or self._selection.controller_type
	self._selection.slot = slot

	self:_update_selection()
end

InputManager._update_selection = function (self)
	if self._selection.logic == self.SELECTION_LOGIC.fixed then
		self:_select_fixed()
	elseif self._selection.logic == self.SELECTION_LOGIC.latest then
		self:_select_latest()
	else
		self:_select_combined()
	end
end

InputManager._select_fixed = function (self)
	local used_devices = self._used_input_devices
	local device = self:_find_active_device(self._selection.controller_type, self._selection.slot)

	if device then
		table.clear(used_devices)

		local extra_device = nil

		if device.device_type == "keyboard" then
			extra_device = self:_find_active_device("mouse")
		elseif device.device_type == "mouse" then
			extra_device = self:_find_active_device("keyboard")
		end

		table.insert(used_devices, device)

		if extra_device then
			table.insert(used_devices, extra_device)
		end
	end

	self:_update_devices_for_services()
end

InputManager._select_latest = function (self)
	local latest = InputDevice.last_pressed_device

	if latest then
		local used_devices = self._used_input_devices

		if table.array_contains(used_devices, latest) then
			return
		end

		table.clear(used_devices)
		_log("Using input from: %s, it being the latest having a button pressed", latest:debug_name())
		table.insert(used_devices, latest)

		if latest.device_type == "mouse" then
			local last_keyboard = InputDevice.last_pressed_of_type.keyboard

			if last_keyboard then
				_log("Using input from: %s", last_keyboard:debug_name())
				table.insert(used_devices, last_keyboard)
			end
		elseif latest.device_type == "keyboard" then
			local last_mouse = InputDevice.last_pressed_of_type.mouse

			if last_mouse then
				_log("Using input from: %s", last_mouse:debug_name())
				table.insert(used_devices, last_mouse)
			end
		end

		self:_update_devices_for_services()
	end
end

InputManager._select_combined = function (self)
	local used_devices = self._used_input_devices

	table.clear(used_devices)

	for device, type in pairs(self._active_input_devices) do
		table.insert(used_devices, device)
	end

	self:_update_devices_for_services()
end

InputManager._update_devices_for_services = function (self)
	for _, service in pairs(self._input_services) do
		service:set_devices(self._used_input_devices)
	end
end

InputManager.init_device = function (self, generic_device_type, raw_device, device_slot)
	if generic_device_type ~= "mouse" then
		self:set_dead_zones(raw_device)
	end

	if InputLocaleNameOverrides[generic_device_type] then
		self:_locale_override(raw_device, InputLocaleNameOverrides[generic_device_type])
	end

	_log("Init device: %s, %s", generic_device_type, device_slot)

	local new_device = InputDevice:new(raw_device, generic_device_type, device_slot)

	table.insert(self._all_input_devices, new_device)

	if new_device:active() then
		self._active_input_devices[new_device] = new_device.device_type
	end
end

InputManager._locale_override = function (self, raw_device, overrides)
	for name, locale_name in pairs(overrides) do
		local key_num = raw_device.button_id(name)

		if key_num then
			raw_device.set_button_locale_name(key_num, locale_name)
		else
			local axis_num = raw_device.axis_id(name)

			if axis_num then
				raw_device.set_axis_locale_name(axis_num, locale_name)
			end
		end
	end
end

InputManager.device_in_use = function (self, device_name)
	if device_name == "gamepad" then
		return InputDevice.gamepad_active
	else
		return not InputDevice.gamepad_active
	end
end

InputManager.last_pressed_device = function (self)
	return InputDevice.last_pressed_device
end

InputManager.set_dead_zones = function (self, raw_device)
	local num_axes = raw_device.num_axes()

	for i = 1, num_axes do
		raw_device.set_dead_zone(i, raw_device.CIRCULAR, 0.1)
	end
end

InputManager.get_input_service = function (self, service_type)
	if not self._input_services[service_type] then
		local settings = self._input_settings[service_type]

		fassert(settings, "No defined settings for service type [%s]", service_type)

		local alias_table = nil

		if self._aliases[service_type] then
			alias_table = self._aliases[service_type]:alias_table()
		end

		local new_service = InputService:new(service_type, settings.raw, settings.filters, alias_table)

		new_service:set_devices(self._used_input_devices)

		self._input_services[service_type] = new_service

		_log("Created a InputService of type [%s]", service_type)
	end

	return self._input_services[service_type]
end

InputManager.destroy_input_service = function (self, service_type)
	local service = self._input_services[service_type]

	fassert(service, "There is no InputService of type [%s] to destroy", service_type)

	self._input_services[service_type] = nil

	_log("Destroyed InputService of type [%s]", service_type)
end

InputManager.start_key_watch = function (self, device_types)
	self._key_watch = true
	self._key_watch_result = nil
	self._key_watch_devices = device_types
end

InputManager.stop_key_watch = function (self)
	self._key_watch = false
	self._key_watch_result = nil
	self._key_watch_devices = nil
end

InputManager.key_watch_result = function (self)
	return self._key_watch_result
end

InputManager.add_setting = function (self, service_type, aliases, raw_key_table, filter_table, default_devices)
	fassert(not self._input_settings[service_type], "There is already a default setting defined for serivce type [%s], service_type")
	_log("Adding a default setting for input service type [%s]", service_type)

	self._input_settings[service_type] = {
		raw = raw_key_table,
		aliases = aliases,
		filters = filter_table,
		default_devices = default_devices
	}

	if aliases then
		self._aliases[service_type] = InputAliases:new(aliases)
	end
end

InputManager.setting_service_types = function (self)
	local service_types = {}

	for service_type, settings in pairs(self._input_settings) do
		table.insert(service_types, service_type)
	end

	return service_types
end

InputManager.alias_object = function (self, service_type)
	return self._aliases[service_type]
end

InputManager.apply_alias_changes = function (self, service_type)
	local service = self:get_input_service(service_type)

	fassert(service, "No input service of the type")

	if self._aliases[service_type] then
		local alias_table = self._aliases[service_type]:alias_table()

		service:set_aliases(alias_table)
	end
end

InputManager.save_key_mappings = function (self, service_type)
	if self._aliases[service_type] then
		self._aliases[service_type]:save(service_type)
	end
end

InputManager.restore_default_aliases = function (self, service_type)
	local aliases = self._aliases[service_type]

	if aliases then
		aliases:restore_default()
	else
		_log("No aliases for input service type [%s]", service_type)
	end

	self:apply_alias_changes(service_type)
end

InputManager.update = function (self, dt, t)
	self:_update_selection()
	self:_update_devices(dt, t)
	self:_update_services(dt, t)

	if RESOLUTION_LOOKUP.modified then
		self:_update_clip_cursor()
	end

	self:_update_key_watch()

	if GameParameters.testify then
		Testify:poll_requests_through_handler(InputManagerTestify, self)
	end
end

InputManager.on_reload = function (self, refreshed_resources)
	for _, service in pairs(self._input_services) do
		service:on_reload()
	end
end

InputManager._update_devices = function (self, dt, t)
	Profiler.start("Update Devices")

	for _, device in pairs(self._all_input_devices) do
		device:update(dt, t)
	end

	Profiler.stop("Update Devices")
end

InputManager._update_services = function (self, dt, t)
	Profiler.start("Update Services")

	for _, service in pairs(self._input_services) do
		service:update(dt, t)
	end

	Profiler.stop("Update Services")
end

InputManager._update_key_watch = function (self)
	Profiler.start("Update Key Watch")

	if self._key_watch then
		local held = {}
		local released = {}

		for _, d in ipairs(self._key_watch_devices) do
			local device = InputDevice.last_pressed_of_type[d]

			if device then
				held = table.append(held, device:buttons_held())
				released = table.append(released, device:buttons_released())
			end
		end

		if #released > 0 then
			self._key_watch_result = {
				enablers = held,
				main = released[1],
				disablers = {}
			}
			self._key_watch = false
		end
	end

	Profiler.stop("Update Key Watch")
end

InputManager._cb_device_activated = function (self, device)
	_log("Device activated, type = %s, slot = %s", device.device_type, device.slot)

	self._active_input_devices[device] = device.device_type

	self:_update_selection()
end

InputManager._find_active_device = function (self, device_type, slot)
	for device, type in pairs(self._active_input_devices) do
		if device_type then
			if device_type == device.device_type then
				if slot then
					if slot == device.slot then
						return device
					end
				else
					return device
				end
			end
		else
			return device
		end
	end
end

InputManager._cb_device_deactivated = function (self, device)
	_log("Device deactivated, type = %s, slot = %s", device.device_type, device.slot)

	self._active_input_devices[device] = nil

	if InputDevice.default_device_id[device.device_type] then
		return
	end

	if InputDevice.last_pressed_of_type[device.device_type] == device then
		InputDevice.last_pressed_of_type[device.device_type] = self:_find_active_device(device.device_type)

		if InputDevice.last_pressed_device == device then
			InputDevice.last_pressed_device = InputDevice.last_pressed_of_type[device.device_type] or self:_find_active_device()
		end
	end

	self:_update_selection()
end

InputManager.debug_get_input_services = function (self)
	return self._input_services
end

InputManager.debug_get_all_input_devices = function (self)
	return self._all_input_devices
end

InputManager.debug_get_all_used_devices = function (self)
	return self._used_input_devices
end

InputManager._set_allow_cursor_rendering = function (self, allow_cursor_rendering)
	local cursor_stack_data = self._cursor_stack_data
	cursor_stack_data.allow_cursor_rendering = allow_cursor_rendering

	if cursor_stack_data.stack_depth > 0 then
		Window.set_show_cursor(allow_cursor_rendering)
	end
end

InputManager.set_cursor_position = function (self, reference, position)
	if PLATFORM == "win32" then
		local cursor_stack_data = self._cursor_stack_data
		local stack_references = cursor_stack_data.stack_references

		assert(stack_references[reference], "Trying to change cursor position without having pushed the cursor first.")
		Window.set_cursor_position(position)
	end
end

InputManager.push_cursor = function (self, reference)
	if PLATFORM == "win32" then
		local cursor_stack_data = self._cursor_stack_data
		local stack_references = cursor_stack_data.stack_references

		assert(not stack_references[reference], "Trying to push cursor. Reference name already exist.")

		if cursor_stack_data.stack_depth == 0 and cursor_stack_data.allow_cursor_rendering then
			local is_fullscreen = RESOLUTION_LOOKUP.fullscreen

			Window.set_show_cursor(true)
			Window.set_clip_cursor(is_fullscreen or false)
		end

		cursor_stack_data.stack_depth = cursor_stack_data.stack_depth + 1
		stack_references[reference] = true
	end
end

InputManager.pop_cursor = function (self, reference)
	if PLATFORM == "win32" then
		local cursor_stack_data = self._cursor_stack_data
		local stack_references = cursor_stack_data.stack_references

		assert(stack_references[reference], "Trying to pop cursor with an unregistered reference name.")

		stack_references[reference] = nil

		assert(cursor_stack_data.stack_depth > 0, "Trying to pop a cursor stack that doesn't exist.")

		cursor_stack_data.stack_depth = cursor_stack_data.stack_depth - 1

		if cursor_stack_data.stack_depth == 0 then
			Window.set_show_cursor(false)
			Window.set_clip_cursor(true)
		end
	end
end

InputManager.cursor_active = function (self)
	if PLATFORM == "win32" then
		local cursor_stack_data = self._cursor_stack_data
		local stack_depth = cursor_stack_data.stack_depth

		return stack_depth > 0
	end

	return false
end

InputManager._update_clip_cursor = function (self)
	if PLATFORM == "win32" then
		local cursor_stack_data = self._cursor_stack_data
		local is_fullscreen = RESOLUTION_LOOKUP.fullscreen

		if cursor_stack_data.stack_depth == 0 then
			Window.set_clip_cursor(true)
		elseif cursor_stack_data.stack_depth > 0 then
			Window.set_clip_cursor(is_fullscreen)
		end
	end
end

InputManager.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "device_activated")
	event_manager:unregister(self, "device_deactivated")
end

InputManager.change_input_layout = function (self, layout_name)
	local layout_settings = self._available_layouts[layout_name]

	if not layout_settings then
		return
	end

	self._input_settings = {}
	self._aliases = {}

	for _, settings in ipairs(layout_settings.settings) do
		self:add_setting(settings.service_type, settings.aliases, settings.settings, settings.filters, settings.default_devices)
		self:apply_alias_changes(settings.service_type)
	end
end

InputManager.get_input_layout_names = function (self)
	local layout_names = {}

	for name, values in pairs(self._available_layouts) do
		layout_names[#layout_names + 1] = {
			name = name,
			display_name = values.display_name
		}
	end

	return layout_names
end

return InputManager
