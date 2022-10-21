local PerformanceReporter = class("PerformanceReporter")

PerformanceReporter.init = function (self)
	self._min_ms_per_frame = math.huge
	self._max_ms_per_frame = 0
	self._avg_ms_per_frame = 0
	self._mspf = {}
	self._min_batchcount = math.huge
	self._max_batchcount = 0
	self._avg_batchcount = 0
	self._batchcounts = {}
	self._min_primitives_count = math.huge
	self._max_primitives_count = 0
	self._avg_primitives_count = 0
	self._primitives_count = {}
end

PerformanceReporter.update = function (self, dt, t)
	local ms_per_frame = dt * 1000
	self._mspf[#self._mspf + 1] = ms_per_frame
	local batchcount = Application.get_batchcount_stats()
	self._batchcounts[#self._batchcounts + 1] = batchcount
	local primitives_count = Application.get_primitives_count()
	self._primitives_count[#self._primitives_count + 1] = primitives_count

	self:_update_min_values(ms_per_frame, batchcount, primitives_count)
	self:_update_max_values(ms_per_frame, batchcount, primitives_count)
	self:_update_avg_values(ms_per_frame, batchcount, primitives_count)
end

PerformanceReporter._update_min_values = function (self, ms_per_frame, batchcount, primitives_count)
	self._min_ms_per_frame = ms_per_frame < self._min_ms_per_frame and ms_per_frame or self._min_ms_per_frame
	self._min_batchcount = batchcount < self._min_batchcount and batchcount or self._min_batchcount
	self._min_primitives_count = primitives_count < self._min_primitives_count and primitives_count or self._min_primitives_count
end

PerformanceReporter._update_max_values = function (self, ms_per_frame, batchcount, primitives_count)
	self._max_ms_per_frame = self._max_ms_per_frame < ms_per_frame and ms_per_frame or self._max_ms_per_frame
	self._max_batchcount = self._max_batchcount < batchcount and batchcount or self._max_batchcount
	self._max_primitives_count = self._max_primitives_count < primitives_count and primitives_count or self._max_primitives_count
end

PerformanceReporter._update_avg_values = function (self, ms_per_frame, batchcount, primitives_count)
	self._avg_ms_per_frame = (ms_per_frame + self._avg_ms_per_frame * (#self._mspf - 1)) / #self._mspf
	self._avg_batchcount = (batchcount + self._avg_batchcount * (#self._batchcounts - 1)) / #self._batchcounts
	self._avg_primitives_count = (primitives_count + self._avg_primitives_count * (#self._primitives_count - 1)) / #self._primitives_count
end

PerformanceReporter.min_ms_per_frame = function (self)
	return self._min_ms_per_frame
end

PerformanceReporter.max_ms_per_frame = function (self)
	return self._max_ms_per_frame
end

PerformanceReporter.avg_ms_per_frame = function (self)
	return self._avg_ms_per_frame
end

PerformanceReporter.median_ms_per_frame = function (self)
	local median_ms_per_frame = math.get_median_value(self._mspf)

	return median_ms_per_frame
end

PerformanceReporter.min_batchcount = function (self)
	return self._min_batchcount
end

PerformanceReporter.max_batchcount = function (self)
	return self._max_batchcount
end

PerformanceReporter.avg_batchcount = function (self)
	return self._avg_batchcount
end

PerformanceReporter.median_batchcount = function (self)
	local median_batchcount = math.get_median_value(self._batchcounts)

	return median_batchcount
end

PerformanceReporter.min_primitives_count = function (self)
	return self._min_primitives_count
end

PerformanceReporter.max_primitives_count = function (self)
	return self._max_primitives_count
end

PerformanceReporter.avg_primitives_count = function (self)
	return self._avg_primitives_count
end

PerformanceReporter.median_primitives_count = function (self)
	local median_primitives_count = math.get_median_value(self._primitives_count)

	return median_primitives_count
end

return PerformanceReporter
