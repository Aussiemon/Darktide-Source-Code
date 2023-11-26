-- chunkname: @scripts/managers/telemetry/reporters/pacing_reporter.lua

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
	local travel_progress = Managers.state.main_path:furthest_travel_percentage(1)

	if t - self._last_sample_time > SAMPLE_INTERVAL and tension ~= self._last_tension_sample then
		Managers.telemetry_events:pacing(tension, travel_progress)

		self._last_tension_sample = tension
		self._last_sample_time = math.floor(t)
	end
end

PacingReporter.report = function (self)
	return
end

implements(PacingReporter, ReporterInterface)

return PacingReporter
