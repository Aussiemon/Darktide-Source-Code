-- chunkname: @scripts/managers/data_service/services/utilities/global_stat_wrappers/linear_global_stat_wrapper.lua

require("scripts/managers/data_service/services/utilities/global_stat_wrappers/global_stat_wrapper")

local LinearGlobalStatWrapper = class("LinearGlobalStatWrapper", "GlobalStatWrapper")

LinearGlobalStatWrapper.init = function (self, obj, func_name, category, stat_name, options)
	options = table.add_missing(options or {}, {
		delay = 0.09,
		delay_jitter = 0.02,
		step_factor = 0.04,
		step_jitter = 0.01,
	})

	return LinearGlobalStatWrapper.super.init(self, obj, func_name, category, stat_name, options)
end

LinearGlobalStatWrapper._interpolate = function (self)
	local step_size = math.random(self._min_step, self._max_step)
	local current, target = self._current, self._target

	if step_size >= math.abs(current - target) then
		return target
	elseif current < target then
		return math.min(current + step_size, target)
	elseif target < current then
		return math.max(current - step_size, target)
	else
		return target
	end
end

LinearGlobalStatWrapper._update_value = function (self, ...)
	LinearGlobalStatWrapper.super._update_value(self, ...)

	local diff = math.abs(self._target - self._current)

	self._min_step = math.max(math.round(diff * self._options.step_factor), 1)
	self._max_step = self._min_step + math.round(diff * self._options.step_jitter)
end

return LinearGlobalStatWrapper
