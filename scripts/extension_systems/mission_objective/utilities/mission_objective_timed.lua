-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_timed.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveTimed = class("MissionObjectiveTimed", "MissionObjectiveBase")

MissionObjectiveTimed.init = function (self)
	MissionObjectiveTimed.super.init(self)

	self._duration = 0
	self._time_left = 0
	self._time_elapsed = 0
end

MissionObjectiveTimed._get_duration = function (self, mission_objective_data)
	if mission_objective_data.duration then
		return mission_objective_data.duration
	end

	if mission_objective_data.duration_by_difficulty then
		local difficulty = Managers.state.difficulty:get_difficulty()

		if difficulty > #mission_objective_data.duration_by_difficulty then
			Log.error("MissionObjectiveTimed", "duration_by_difficulty misses a duration corresponding to difficulty '%d', falling back to the duration on the highest index instead (duration will be '%d')", difficulty, mission_objective_data.duration_by_difficulty[#mission_objective_data.duration_by_difficulty])

			return mission_objective_data.duration_by_difficulty[#mission_objective_data.duration_by_difficulty]
		end

		return mission_objective_data.duration_by_difficulty[difficulty]
	end

	return nil
end

MissionObjectiveTimed.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit)
	MissionObjectiveTimed.super.start_objective(self, mission_objective_data, registered_units, synchronizer_unit)

	self._use_counter = false
	self._duration = self:_get_duration(mission_objective_data)
	self._time_left = mission_objective_data.duration
	self._time_elapsed = 0

	self:set_max_increment(self._duration)
end

MissionObjectiveTimed.start_stage = function (self, stage)
	MissionObjectiveTimed.super.start_stage(self, stage)
	self:set_max_increment(self._duration)
end

MissionObjectiveTimed.update = function (self, dt)
	MissionObjectiveTimed.super.update(self, dt)

	local timed_synchronizer_extension = self:synchronizer_extension()

	if timed_synchronizer_extension then
		dt = timed_synchronizer_extension:rubberband_time(dt)
	end

	self._time_elapsed = self._time_elapsed + dt
	self._time_elapsed = math.min(self._time_elapsed, self._duration)
	self._time_left = self._duration - self._time_elapsed
end

MissionObjectiveTimed.add_time = function (self, time)
	self._time_elapsed = math.clamp(self._time_elapsed + time, 0, self._duration)
	self._time_left = self._duration - self._time_elapsed
end

MissionObjectiveTimed.update_progression = function (self)
	MissionObjectiveTimed.super.update_progression(self)

	if self._duration > 0 then
		local progression = self._time_elapsed / self._duration
		local timed_synchronizer_extension = self:synchronizer_extension()

		if timed_synchronizer_extension then
			progression = timed_synchronizer_extension:progression_displayed(progression)
		end

		progression = math.clamp(progression, 0, 1)

		self:set_progression(progression)
	end

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

MissionObjectiveTimed.progression_to_flow = function (self)
	local synchronizer_unit = self._synchronizer_unit

	if synchronizer_unit and ALIVE[synchronizer_unit] then
		Unit.set_flow_variable(synchronizer_unit, "lua_var_objective_time_remaining", self._duration * (1 - self._progression))
	end

	MissionObjectiveTimed.super.progression_to_flow(self)
end

return MissionObjectiveTimed
