local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PacingReporter = class("PacingReporter")
local SAMPLE_INTERVAL = 10

PacingReporter.init = function (self, params)
	self._last_sample_time = 0
	self._last_tension_sample = 0
end

PacingReporter.destroy = function (self)
	return
end

PacingReporter.update = function (self, dt, t)
	if not Managers.state or not Managers.state.pacing then
		return
	end

	local tension = Managers.state.pacing:tension()

	if SAMPLE_INTERVAL < t - self._last_sample_time and tension ~= self._last_tension_sample then
		Managers.telemetry_events:pacing(tension)

		self._last_tension_sample = tension
		self._last_sample_time = math.floor(t)
	end
end

PacingReporter.report = function (self)
	return
end

implements(PacingReporter, ReporterInterface)

return PacingReporter
