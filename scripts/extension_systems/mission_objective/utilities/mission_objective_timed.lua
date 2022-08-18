require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveTimed = class("MissionObjectiveTimed", "MissionObjectiveBase")

MissionObjectiveTimed.init = function (self)
	MissionObjectiveTimed.super.init(self)

	self._duration = 0
	self._time_left = 0
	self._time_elapsed = 0
end

MissionObjectiveTimed.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit)
	MissionObjectiveTimed.super.start_objective(self, mission_objective_data, registered_units, synchronizer_unit)

	self._duration = mission_objective_data.duration
	self._time_left = mission_objective_data.duration
	self._time_elapsed = 0
end

MissionObjectiveTimed.update = function (self, dt)
	MissionObjectiveTimed.super.update(self, dt)

	self._time_elapsed = self._time_elapsed + dt
	self._time_elapsed = math.min(self._time_elapsed, self._duration)
	self._time_left = self._duration - self._time_elapsed
	self._time_left = math.max(self._time_left, 0)
end

MissionObjectiveTimed.update_progression = function (self)
	MissionObjectiveTimed.super.update_progression(self)

	if self._duration > 0 then
		local progression = self._time_elapsed / self._duration
		progression = math.clamp(progression, 0, 1)

		self:set_progression(progression)
	end

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

return MissionObjectiveTimed
