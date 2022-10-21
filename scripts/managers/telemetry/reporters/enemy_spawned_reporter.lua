local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local EnemySpawnedReporter = class("EnemySpawnedReporter")

EnemySpawnedReporter.init = function (self)
	self._report = {}
end

EnemySpawnedReporter.update = function (self, dt, t)
	return
end

EnemySpawnedReporter.report = function (self)
	if table.is_empty(self._report) then
		return
	end

	Managers.telemetry_events:enemies_spawned_report(self._report)
end

EnemySpawnedReporter.register_event = function (self, enemy)
	self._report[enemy.name] = (self._report[enemy.name] or 0) + 1
end

EnemySpawnedReporter.destroy = function (self)
	return
end

implements(EnemySpawnedReporter, ReporterInterface)

return EnemySpawnedReporter
