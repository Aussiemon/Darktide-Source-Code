-- chunkname: @scripts/managers/telemetry/reporters/voice_over_event_triggered_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local VoiceOverEventTriggeredReporter = class("VoiceOverEventTriggeredReporter")

VoiceOverEventTriggeredReporter.init = function (self)
	self._report = {}
	self._vo_name_to_index = {}
end

VoiceOverEventTriggeredReporter.update = function (self, dt, t)
	return
end

VoiceOverEventTriggeredReporter.report = function (self)
	if table.is_empty(self._report) then
		return
	end

	Managers.telemetry_events:voice_over_event_triggered_report(self._report)
end

VoiceOverEventTriggeredReporter.register_event = function (self, rule_name)
	local index = self._vo_name_to_index[rule_name]

	if not index then
		index = #self._report + 1
		self._report[index] = {
			observations = 1,
			vo_name = rule_name,
		}
		self._vo_name_to_index[rule_name] = index
	else
		self._report[index].observations = self._report[index].observations + 1
	end
end

VoiceOverEventTriggeredReporter.destroy = function (self)
	return
end

implements(VoiceOverEventTriggeredReporter, ReporterInterface)

return VoiceOverEventTriggeredReporter
