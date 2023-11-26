-- chunkname: @scripts/managers/input/input_service.lua

local InputFilters = require("scripts/managers/input/input_filters")
local InputUtils = require("scripts/managers/input/input_utils")
local NullInputService = require("scripts/managers/input/null_input_service")
local InputService = class("InputService")

InputService.DEBUG_TAG = "Input Service"

local function _default_boolean()
	return false
end

local function _default_vector3()
	return Vector3(0, 0, 0)
end

local function _default_float()
	return 0
end

local function _boolean_combine(value_one, value_two)
	return value_one or value_two
end

local function _vector3_combine(value_one, value_two)
	if Vector3.length(value_one) > Vector3.length(value_two) then
		return value_one
	else
		return value_two
	end
end

local function _float_combine(value_one, value_two)
	return math.max(value_one, value_two)
end

InputService.ACTION_TYPES = InputService.ACTION_TYPES or {
	pressed = {
		device_func = "pressed",
		type = "boolean",
		default_device_func = _default_boolean,
		combine_func = _boolean_combine
	},
	held = {
		device_func = "held",
		type = "boolean",
		default_device_func = _default_boolean,
		combine_func = _boolean_combine
	},
	released = {
		device_func = "released",
		type = "boolean",
		default_device_func = _default_boolean,
		combine_func = _boolean_combine
	},
	axis = {
		device_func = "axis",
		type = "vector3",
		default_device_func = _default_vector3,
		combine_func = _vector3_combine
	},
	button = {
		device_func = "button",
		type = "float",
		default_device_func = _default_float,
		combine_func = _float_combine
	}
}

InputService.init = function (self, type, mappings, filter_mappings, aliases)
	self.get = self._get
	self.type = type
	self._connected_devices = {}
	self._actions = {}
	self._active_keys_and_axes = {}
	self._mappings = mappings
	self._aliases = aliases or {}
	self._filter_mappings = filter_mappings or {}
	self._null_service = NullInputService:new(self)
	self._last_time = 0
	self._simulated_actions = {}

	self:_rework_actions()
end

InputService.set_aliases = function (self, new_aliases)
	self._aliases = new_aliases or {}

	self:_rework_actions()
end

InputService.get_mapping = function (self)
	return self._mappings
end

InputService.is_null_service = function (self)
	return false
end

InputService._rework_actions = function (self)
	self._actions = {}

	self:_rework_active_keys_axes()
	self:_rework_action_rules()
	self:_rework_filters()
end

InputService._rework_active_keys_axes = function (self)
	self._active_keys_and_axes = {}

	if self._aliases then
		for alias, alias_definition in pairs(self._aliases) do
			for _, name in ipairs(alias_definition) do
				self._active_keys_and_axes[name] = self:_key_info(name)
			end
		end
	end

	for action_name, action_definition in pairs(self._mappings) do
		local raw_keys = action_definition.raw

		if raw_keys then
			if type(raw_keys) == "table" then
				for _, name in ipairs(raw_keys) do
					self._active_keys_and_axes[name] = self:_key_info(name)
				end
			else
				self._active_keys_and_axes[raw_keys] = self:_key_info(raw_keys)
			end
		end
	end
end

InputService._rework_action_rules = function (self)
	for action_name, action_definition in pairs(self._mappings) do
		self._actions[action_name] = self:_rework_action_rule(action_definition)
	end
end

InputService._key_info = function (self, name)
	local main, e, d = InputUtils.split_key(name)
	local info = self:_corresponding_device(main)

	if info then
		if #e > 0 then
			local enablers = {}

			for _, key in ipairs(e) do
				local enabler = self:_corresponding_device(key)

				if enabler then
					enablers[#enablers + 1] = enabler
				end
			end

			info.enablers = enablers
		end

		if #d > 0 then
			local disablers = {}

			for _, key in ipairs(d) do
				local disabler = self:_corresponding_device(key)

				if disabler then
					disablers[#disablers + 1] = disabler
				end
			end

			info.disablers = disablers
		end
	end

	return info
end

InputService._corresponding_device = function (self, name)
	for _, device in pairs(self._connected_devices) do
		local index = device:button_index(name)

		if index then
			return {
				device = device,
				index = index
			}
		end

		index = device:axis_index(name)

		if index then
			return {
				device = device,
				index = index
			}
		end
	end
end

InputService.update = function (self, dt, t)
	self:_evaluate_filters(dt, t)

	self._last_time = t
end

InputService.on_reload = function (self)
	self:_rework_actions()
end

InputService._evaluate_filters = function (self, dt, t)
	for action_name, action_rule in pairs(self._actions) do
		if action_rule.filter then
			action_rule.eval_obj.current_value = nil
		end
	end
end

InputService.action_rule = function (self, action_name)
	local action_rule = self._actions[action_name]

	return action_rule
end

InputService.reverse_lookup = function (self, action_name)
	local action_rule = self._actions[action_name]

	return action_rule.debug_info
end

InputService._rework_action_rule = function (self, action_definition)
	local action_rule = {}

	action_rule.callbacks = {}
	action_rule.debug_info = {}
	action_rule.type = action_definition.type
	action_rule.key_alias = action_definition.key_alias

	local key_alias = action_definition.key_alias

	if key_alias then
		local aliases = self._aliases[key_alias]

		for _, name in ipairs(aliases) do
			self:_add_callback_to_action_rule(action_rule, name)
		end
	end

	local raw_keys = action_definition.raw

	if raw_keys then
		if type(raw_keys) == "table" then
			for _, name in ipairs(raw_keys) do
				self:_add_callback_to_action_rule(action_rule, name)
			end
		else
			self:_add_callback_to_action_rule(action_rule, raw_keys)
		end
	end

	action_rule.default_func = InputService.ACTION_TYPES[action_definition.type].default_device_func
	action_rule.filter = false

	return action_rule
end

local function _enabler_func(cb, action_type, enablers)
	for _, enabler in ipairs(enablers) do
		if not enabler.device:held(enabler.index) then
			return InputService.ACTION_TYPES[action_type].default_device_func()
		end
	end

	return cb()
end

local function _disabler_func(cb, action_type, disablers)
	for _, disabler in ipairs(disablers) do
		if disabler.device:held(disabler.index) then
			return InputService.ACTION_TYPES[action_type].default_device_func()
		end
	end

	return cb()
end

InputService._add_callback_to_action_rule = function (self, action_rule, name)
	local info = self._active_keys_and_axes[name]

	if info then
		table.insert(action_rule.debug_info, name)

		local cb

		if action_rule.type == "held" then
			cb = callback(info.device, action_rule.type, info.index)
		else
			local function func(device, type, index)
				return device[type](index)
			end

			cb = callback(func, info.device:raw_device(), action_rule.type, info.index)
		end

		if info.enablers then
			cb = callback(_enabler_func, cb, action_rule.type, info.enablers)
		end

		if info.disablers then
			cb = callback(_disabler_func, cb, action_rule.type, info.disablers)
		end

		table.insert(action_rule.callbacks, cb)
	end
end

InputService._rework_filters = function (self)
	for action_name, _ in pairs(self._filter_mappings) do
		if not self._actions[action_name] then
			self:_rework_filter(action_name)
		end
	end
end

InputService._rework_filter = function (self, action_name)
	if not self._actions[action_name] and self._filter_mappings then
		local filter_data = self._filter_mappings[action_name]
		local source_actions = filter_data.input_mappings

		if type(source_actions) == "table" then
			for _, source_action_name in pairs(source_actions) do
				self:_rework_filter(source_action_name)
			end
		else
			self:_rework_filter(source_actions)
		end

		local filter_type = filter_data.filter_type
		local eval_obj = InputFilters[filter_type].init(filter_data)
		local default_func = InputFilters.default
		local default_value = InputFilters[filter_type].update(eval_obj, self._null_service)

		if type(default_value) == "userdata" then
			default_value = Vector3Box(default_value)
			default_func = InputFilters.vector3_default
		end

		local function filter_eval_func(filter_data_parameter, input_service_parameter)
			if filter_data_parameter.current_value == nil then
				filter_data_parameter.current_value = InputFilters[filter_type].update(filter_data_parameter, input_service_parameter)
			end

			return filter_data_parameter.current_value
		end

		local action_rule = {
			filter = true,
			eval_func = filter_eval_func,
			eval_obj = eval_obj,
			eval_param = self,
			default_value = default_value,
			default_func = default_func
		}

		self._actions[action_name] = action_rule
	end
end

InputService.device = function (self, device_type)
	for _, d in pairs(self._connected_devices) do
		if d.device_type == device_type then
			return d
		end
	end
end

InputService.devices = function (self)
	return self._connected_devices
end

InputService.null_service = function (self)
	return self._null_service
end

InputService.connect_device = function (self, device)
	self._connected_devices[#self._connected_devices + 1] = device

	self:_rework_actions()
end

InputService.disconnect_device = function (self, device)
	local index = table.find(self._connected_devices, device)

	if index then
		table.remove(self._connected_devices, index)
		self:_rework_actions()
	end
end

InputService.set_devices = function (self, devices)
	self._connected_devices = devices

	self:_rework_actions()
end

InputService.has = function (self, action_name)
	return self._actions[action_name] ~= nil
end

InputService._get = function (self, action_name)
	local action_rule = self._actions[action_name]

	if action_rule.filter then
		return action_rule.eval_func(action_rule.eval_obj, action_rule.eval_param)
	else
		local out = action_rule.default_func()
		local action_type = action_rule.type
		local combiner = InputService.ACTION_TYPES[action_type].combine_func

		for _, cb in ipairs(action_rule.callbacks) do
			out = combiner(out, cb())
		end

		return out
	end
end

InputService._get_simulate = function (self, action_name)
	local value = self._simulated_actions[action_name]

	if value ~= nil then
		return value
	else
		return self:_get(action_name)
	end
end

InputService.start_simulate_action = function (self, action_name, value)
	self._simulated_actions[action_name] = value
	self.get = self._get_simulate
end

InputService.stop_simulate_action = function (self, action_name)
	local simulated_actions = self._simulated_actions

	simulated_actions[action_name] = nil

	if table.is_empty(simulated_actions) then
		self.get = self._get
	end
end

InputService.actions = function (self)
	return self._actions
end

InputService.get_default = function (self, action_name)
	local action = self._actions[action_name]

	return action.default_func(action.default_value)
end

InputService.get_alias_key = function (self, action_name)
	local action = self._actions[action_name]
	local key_alias = action.key_alias

	return key_alias
end

InputService.get_action_type = function (self, action_name)
	local action = self._actions[action_name]
	local action_type = action.type

	return action_type
end

return InputService
