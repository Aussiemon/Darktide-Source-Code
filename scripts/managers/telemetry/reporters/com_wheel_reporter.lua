-- chunkname: @scripts/managers/telemetry/reporters/com_wheel_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local ComWheelReporter = class("ComWheelReporter")

ComWheelReporter.init = function (self)
	self._report = {}
end

ComWheelReporter.update = function (self, dt, t)
	return
end

ComWheelReporter.report = function (self)
	if table.is_empty(self._report) then
		return
	end

	Managers.telemetry_events:com_wheel_report(self._report)
end

ComWheelReporter.register_event = function (self, option_name)
	self._report[option_name] = (self._report[option_name] or 0) + 1
end

ComWheelReporter.destroy = function (self)
	return
end

implements(ComWheelReporter, ReporterInterface)

return ComWheelReporter
