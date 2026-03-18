-- chunkname: @scripts/managers/telemetry/reporters/pacing_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PacingReporter = class("PacingReporter")
local SAMPLE_INTERVAL = 10

PacingReporter.init = function (self, params)
	self._last_sample_time = 0
	self._entry_count = 0
	self._entries = {
		timestamp = {},
		tension = {},
		progress = {},
	}
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

	if t - self._last_sample_time < SAMPLE_INTERVAL then
		return
	end

	self._last_sample_time = t

	local index = self._entry_count + 1

	self._entry_count = index
	self._entries.timestamp[index] = tostring(Managers.backend:get_server_time(t) / 1000)
	self._entries.tension[index] = tension
	self._entries.progress[index] = travel_progress
end

PacingReporter.report = function (self)
	if self._entry_count == 0 then
		return
	end

	Managers.telemetry_events:pacing_report(self._entry_count, self._entries.timestamp, self._entries.tension, self._entries.progress)
end

implements(PacingReporter, ReporterInterface)

return PacingReporter
