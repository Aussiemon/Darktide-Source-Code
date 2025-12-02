-- chunkname: @scripts/managers/data_service/services/utilities/global_stat_wrappers/global_stat_wrapper.lua

local Promise = require("scripts/foundation/utilities/promise")
local GlobalStatWrapper = class("GlobalStatWrapper")

GlobalStatWrapper.init = function (self, obj, func_name, category, stat_name, options)
	self._options = table.add_missing(options or {}, {
		delay = 1,
		delay_jitter = 0,
	})
	self._category, self._stat_name = category, stat_name
	self._object, self._func_name = obj, func_name
	self._target = Managers.data_service.global_stats:subscribe(self, "_update_value", category, stat_name)
	self._current = self._target

	return self._target
end

GlobalStatWrapper._update_object = function (self)
	self._current = self:_interpolate()

	self._object[self._func_name](self._object, self._stat_name, self._current)
end

GlobalStatWrapper._add_delayed = function (self, time)
	self._promise = Promise.delay(time)

	self._promise:next(function ()
		self:_update_object()

		self._promise = nil

		if self._target ~= self._current then
			local delay_timer = self._options.delay + math.random() * self._options.delay_jitter

			self:_add_delayed(delay_timer)
		end
	end)
end

GlobalStatWrapper._update_value = function (self, _, new_value)
	self._target = new_value

	if not self._promise and self._target ~= self._current then
		self:_add_delayed(0)
	end
end

GlobalStatWrapper.destroy = function (self)
	Managers.data_service.global_stats:unsubscribe(self, self._category, self._stat_name)

	if self._promise and self._promise:is_pending() then
		self._promise:cancel()

		self._promise = nil
	end
end

return GlobalStatWrapper
