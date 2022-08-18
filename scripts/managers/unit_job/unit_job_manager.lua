local JobInterface = require("scripts/managers/unit_job/job_interface")
local unit_alive = Unit.alive
local UnitJobManager = class("UnitJobManager")

UnitJobManager.init = function (self, unit_spawner_manager)
	self._unit_spawner_manager = unit_spawner_manager
	self._units = {}
end

UnitJobManager.destroy = function (self)
	self._unit_spawner_manager = nil
	self._units = nil
end

UnitJobManager.delete_units = function (self)
	local unit_spawner_manager = self._unit_spawner_manager
	local units = self._units

	for unit, _ in pairs(units) do
		unit_spawner_manager:mark_for_deletion(unit)

		units[unit] = nil
	end
end

UnitJobManager.register = function (self, unit, job_class)
	assert(self._units[unit] == nil, "Already registered unit %q to UnitJobManager", unit)

	self._units[unit] = job_class
end

UnitJobManager.update = function (self, dt, t)
	local unit_spawner_manager = self._unit_spawner_manager
	local units = self._units

	for unit, job_class in pairs(units) do
		if job_class:job_completed() then
			unit_spawner_manager:mark_for_deletion(unit)

			units[unit] = nil
		end
	end
end

return UnitJobManager
