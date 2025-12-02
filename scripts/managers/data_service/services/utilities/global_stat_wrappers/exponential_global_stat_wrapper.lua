-- chunkname: @scripts/managers/data_service/services/utilities/global_stat_wrappers/exponential_global_stat_wrapper.lua

require("scripts/managers/data_service/services/utilities/global_stat_wrappers/global_stat_wrapper")

local ExponentialGlobalStatWrapper = class("ExponentialGlobalStatWrapper", "GlobalStatWrapper")

ExponentialGlobalStatWrapper.init = function (self, obj, func_name, category, stat_name, options)
	options = table.add_missing(options or {}, {
		step_factor = 0.1,
	})

	return ExponentialGlobalStatWrapper.super.init(self, obj, func_name, category, stat_name, options)
end

ExponentialGlobalStatWrapper._interpolate = function (self)
	local diff = self._target - self._current
	local step = math.round(self._options.step_factor * diff)

	if step == 0 then
		return self._target
	end

	return self._current + step
end

return ExponentialGlobalStatWrapper
