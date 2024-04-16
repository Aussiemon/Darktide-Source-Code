local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local TacticalOverlayReporter = class("TacticalOverlayReporter")

TacticalOverlayReporter.init = function (self)
	self._report = {
		times_opened = 0
	}
end

TacticalOverlayReporter.update = function (self, dt, t)
	return
end

TacticalOverlayReporter.report = function (self)
	if table.is_empty(self._report) then
		return
	end

	Managers.telemetry_events:tactical_overlay_report(self._report)
end

TacticalOverlayReporter.register_event = function (self, penance_count)
	self._report.times_opened = self._report.times_opened + 1
	self._report.tracked_penances = penance_count
end

TacticalOverlayReporter.destroy = function (self)
	return
end

implements(TacticalOverlayReporter, ReporterInterface)

return TacticalOverlayReporter
