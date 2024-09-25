-- chunkname: @scripts/managers/telemetry/reporters/mispredict_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local MispredictReporter = class("MispredictReporter")

MispredictReporter.init = function (self)
	self._entries = {}
	self._count = 0
end

MispredictReporter.update = function (self, dt, t)
	return
end

MispredictReporter.report = function (self)
	Managers.telemetry_events:mispredict_report(self._entries, self._count)
end

MispredictReporter.register_frame = function (self)
	self._count = self._count + 1
end

MispredictReporter.register_event = function (self, tsm, component_name, field_name)
	local component_data = self._entries[component_name] or {}
	local field_data = component_data[field_name] or {
		average_t = 0,
		count = 0,
		component = component_name,
		field = field_name,
	}

	component_data[field_name] = field_data
	self._entries[component_name] = component_data
	field_data.count = field_data.count + 1
	field_data.average_t = field_data.average_t + (tsm - field_data.average_t) / field_data.count
end

MispredictReporter.destroy = function (self)
	return
end

implements(MispredictReporter, ReporterInterface)

return MispredictReporter
