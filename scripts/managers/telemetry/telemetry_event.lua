local TelemetryEvent = class("TelemetryEvent")

TelemetryEvent.init = function (self, source, subject, type, session)
	self._event = {
		specversion = "1.2",
		source = source,
		subject = subject,
		type = type,
		session = session
	}
end

TelemetryEvent.set_revision = function (self, revision)
	self._event.revision = revision
end

TelemetryEvent.set_data = function (self, data)
	self._event.data = data
end

TelemetryEvent.raw = function (self)
	return self._event
end

TelemetryEvent.__tostring = function (self)
	return table.tostring(self._event, math.huge)
end

return TelemetryEvent
