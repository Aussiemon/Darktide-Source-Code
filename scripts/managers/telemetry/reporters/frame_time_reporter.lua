local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local FrameTimeReporter = class("FrameTimeReporter")
local SAMPLE_INTERVAL = 1

FrameTimeReporter.init = function (self, params)
	self._measures = {}
	self._last_sample_time = 0
	self._mission_name = params.mission_name
end

FrameTimeReporter.destroy = function (self)
	return
end

FrameTimeReporter.update = function (self, dt, t)
	if SAMPLE_INTERVAL < t - self._last_sample_time then
		self:_take_measure(dt)

		self._last_sample_time = math.floor(t)
	end
end

FrameTimeReporter._take_measure = function (self, dt)
	local dt_ms = dt * 1000
	self._measures[#self._measures + 1] = dt_ms
end

FrameTimeReporter.report = function (self)
	if #self._measures == 0 then
		return
	end

	table.sort(self._measures)

	local avg = table.average(self._measures)
	local variance = table.variance(self._measures)
	local std_dev = math.sqrt(variance)
	local p99_9 = table.percentile(self._measures, 99.9)
	local p99 = table.percentile(self._measures, 99)
	local p95 = table.percentile(self._measures, 95)
	local p90 = table.percentile(self._measures, 90)
	local p75 = table.percentile(self._measures, 75)
	local p50 = table.percentile(self._measures, 50)
	local p25 = table.percentile(self._measures, 25)
	local observations = #self._measures
	local map_name = self._mission_name

	Managers.telemetry_events:performance_frame_time(avg, std_dev, p99_9, p99, p95, p90, p75, p50, p25, observations, map_name)
end

implements(FrameTimeReporter, ReporterInterface)

return FrameTimeReporter
