-- chunkname: @scripts/utilities/performance_reporter.lua

local PerformanceReporter = class("PerformanceReporter")
local application_get_frame_times = Application.get_frame_times
local application_get_batchcount_stats = Application.get_batchcount_stats
local application_get_primitives_count = Application.get_primitives_count
local table = table

PerformanceReporter.init = function (self, values_to_measure)
	self._measurements = {}
	self._frame_count = 0
	self._measure_thread_frame_time = values_to_measure.thread_frame_time
	self._measure_batchcount = values_to_measure.batchcount
	self._measure_primitives_count = values_to_measure.primitives_count

	self:_initialize_tables()
end

PerformanceReporter._initialize_tables = function (self)
	local measurements = self._measurements

	measurements.frame_time_main = {}

	if self._measure_thread_frame_time then
		measurements.frame_time_render = {}
		measurements.frame_time_gpu = {}

		Renderer.set_gpu_profiling(true)
	end

	if self._measure_batchcount then
		measurements.batchcount = {}
	end

	if self._measure_primitives_count then
		measurements.primitives_count = {}
	end
end

PerformanceReporter.update = function (self, dt, t)
	local has_gpu_measurements_started = self:_measure_frame_time(dt)

	if self._measure_thread_frame_time and not has_gpu_measurements_started then
		return
	end

	self:_measure_frame_statistics()
end

PerformanceReporter._measure_frame_time = function (self, dt)
	local frame_time_render, frame_time_gpu

	if self._measure_thread_frame_time then
		frame_time_render, frame_time_gpu = application_get_frame_times()
	end

	if self._measure_thread_frame_time and frame_time_gpu == 0 then
		return false
	end

	local measurements = self._measurements
	local frame_count = self._frame_count + 1

	self._frame_count = frame_count
	measurements.frame_time_main[frame_count] = dt * 1000

	if self._measure_thread_frame_time then
		measurements.frame_time_render[frame_count] = frame_time_render
		measurements.frame_time_gpu[frame_count] = frame_time_gpu

		return true
	end
end

PerformanceReporter._measure_frame_statistics = function (self)
	local measurements = self._measurements
	local frame_count = self._frame_count

	if self._measure_batchcount then
		measurements.batchcount[frame_count] = application_get_batchcount_stats()
	end

	if self._measure_primitives_count then
		measurements.primitives_count[frame_count] = application_get_primitives_count()
	end
end

PerformanceReporter.performance_measurements = function (self)
	local measurements = self._measurements
	local performance_measurements = {}

	for t_name, t in pairs(measurements) do
		performance_measurements[t_name] = self:_format_table(t)
	end

	return performance_measurements
end

PerformanceReporter._format_table = function (self, t)
	local result = {}

	table.sort(t)

	t = self:_exclude_negative_values(t)
	result.avg = table.average(t)
	result.variance = table.variance(t)
	result.std_dev = math.sqrt(result.variance)
	result.p99_9 = table.percentile(t, 99.9)
	result.p99 = table.percentile(t, 99)
	result.p95 = table.percentile(t, 95)
	result.p90 = table.percentile(t, 90)
	result.p75 = table.percentile(t, 75)
	result.p50 = table.percentile(t, 50)
	result.p25 = table.percentile(t, 25)
	result.observations = self._frame_count

	return result
end

PerformanceReporter._exclude_negative_values = function (self, t)
	table.array_remove_if(t, function (number)
		return type(number) ~= "number" or number < 0
	end)

	return t
end

return PerformanceReporter
