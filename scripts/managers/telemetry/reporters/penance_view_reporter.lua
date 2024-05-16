-- chunkname: @scripts/managers/telemetry/reporters/penance_view_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PenanceViewReporter = class("PenanceViewReporter")

PenanceViewReporter.init = function (self)
	self._tracking_report = {}
	self._claim_penance_report = {}
	self._claim_track_report = {}
end

PenanceViewReporter.update = function (self, dt, t)
	return
end

PenanceViewReporter.report = function (self)
	if not table.is_empty(self._tracking_report) then
		Managers.telemetry_events:penances_tracked_report(self._tracking_report)
	end

	if not table.is_empty(self._claim_penance_report) then
		Managers.telemetry_events:penance_claimed_report(self._claim_penance_report)
	end

	if not table.is_empty(self._claim_track_report) then
		Managers.telemetry_events:track_claimed_report(self._claim_track_report)
	end
end

PenanceViewReporter.register_tracking_event = function (self, penance_id, tracked)
	local recorded_tracking = self._tracking_report[penance_id]

	if recorded_tracking == nil then
		self._tracking_report[penance_id] = tracked
	elseif recorded_tracking ~= tracked then
		self._tracking_report[penance_id] = nil
	end
end

PenanceViewReporter.register_penance_claim_event = function (self, penance_id)
	self._claim_penance_report[penance_id] = (self._claim_penance_report[penance_id] or 0) + 1
end

PenanceViewReporter.register_track_claim_event = function (self, track_index)
	self._claim_track_report[track_index] = (self._claim_track_report[track_index] or 0) + 1
end

PenanceViewReporter.destroy = function (self)
	return
end

implements(PenanceViewReporter, ReporterInterface)

return PenanceViewReporter
