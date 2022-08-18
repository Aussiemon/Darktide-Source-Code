local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local HeartbeatReporter = class("HeartbeatReporter")
local SAMPLE_INTERVAL = 300

HeartbeatReporter.init = function (self)
	self._last_sample_time = 0
end

HeartbeatReporter.destroy = function (self)
	return
end

HeartbeatReporter.update = function (self, dt, t)
	if SAMPLE_INTERVAL < t - self._last_sample_time then
		Managers.telemetry_events:heartbeat()

		self._last_sample_time = math.floor(t)
	end
end

HeartbeatReporter.report = function (self)
	return
end

implements(HeartbeatReporter, ReporterInterface)

return HeartbeatReporter
