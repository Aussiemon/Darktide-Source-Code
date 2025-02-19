-- chunkname: @scripts/managers/telemetry/reporters/ping_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PingReporter = class("PingReporter")
local SAMPLE_INTERVAL = 1

PingReporter.init = function (self, params)
	self._measures = {}
	self._last_sample_time = 0
	self._mission_name = params.mission_name
	self._region = Managers.connection:region() or "unknown"
end

PingReporter.destroy = function (self)
	return
end

PingReporter.update = function (self, dt, t)
	if t - self._last_sample_time > SAMPLE_INTERVAL then
		self:_take_measure(dt)

		self._last_sample_time = math.floor(t)
	end
end

PingReporter._take_measure = function (self, dt)
	local is_client = Managers.connection:is_client()

	if not is_client then
		return
	end

	local host_peer_id = Managers.connection:host()

	if not host_peer_id then
		return
	end

	local ping = Network.ping(host_peer_id)
	local ping_ms = ping * 1000

	self._measures[#self._measures + 1] = ping_ms
end

PingReporter.report = function (self)
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
	local region = Managers.connection:region() or self._region
	local map_name = self._mission_name

	Managers.telemetry_events:performance_ping(avg, std_dev, p99_9, p99, p95, p90, p75, p50, p25, observations, region, map_name)
end

implements(PingReporter, ReporterInterface)

return PingReporter
