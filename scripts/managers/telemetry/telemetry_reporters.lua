local HeartbeatReporter = require("scripts/managers/telemetry/reporters/heartbeat_reporter")
local LoadTimesReporter = require("scripts/managers/telemetry/reporters/load_times_reporter")
local FrameTimeReporter = require("scripts/managers/telemetry/reporters/frame_time_reporter")
local PingReporter = require("scripts/managers/telemetry/reporters/ping_reporter")
local PlayerDealtDamageReporter = require("scripts/managers/telemetry/reporters/player_dealt_damage_reporter")
local PlayerTakenDamageReporter = require("scripts/managers/telemetry/reporters/player_taken_damage_reporter")
local TelemetryReporters = class("TelemetryReporters")
local REPORTER_CLASS_MAP = {
	heartbeat = HeartbeatReporter,
	frame_time = FrameTimeReporter,
	load_times = LoadTimesReporter,
	ping = PingReporter,
	player_dealt_damage = PlayerDealtDamageReporter,
	player_taken_damage = PlayerTakenDamageReporter
}

TelemetryReporters.init = function (self)
	self._reporters = {}

	self:start_reporter("heartbeat")
	self:start_reporter("load_times")
end

TelemetryReporters.start_reporter = function (self, name, params)
	Log.debug("TelemetryReporters", "Starting reporter '%s'", name)

	local reporter_class = REPORTER_CLASS_MAP[name]
	self._reporters[name] = reporter_class:new(params)
end

TelemetryReporters.stop_reporter = function (self, name)
	Log.debug("TelemetryReporters", "Stopping reporter '%s'", name)
	self._reporters[name]:report()
	self._reporters[name]:destroy()

	self._reporters[name] = nil
end

TelemetryReporters.reporter = function (self, name)
	return self._reporters[name]
end

TelemetryReporters.update = function (self, dt, t)
	for _, reporter in pairs(self._reporters) do
		reporter:update(dt, t)
	end
end

TelemetryReporters.destroy = function (self)
	for _, reporter in pairs(self._reporters) do
		reporter:destroy()
	end
end

return TelemetryReporters
