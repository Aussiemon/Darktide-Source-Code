-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_zone.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveZone = class("MissionObjectiveZone", "MissionObjectiveBase")

MissionObjectiveZone.ZONE_TYPES = table.enum("none", "capture", "scan")

MissionObjectiveZone.init = function (self, peer_id)
	MissionObjectiveZone.super.init(self, peer_id)

	self._current_zone_progression = 0
	self._start_counter = false
	self._override_marked_units = nil
end

MissionObjectiveZone.start_objective = function (self, mission_objective_data, group_id, registered_units, synchronizer_unit)
	MissionObjectiveZone.super.start_objective(self, mission_objective_data, group_id, registered_units, synchronizer_unit)

	local zone_synchronizer_extension = self:synchronizer_extension()
	local stages = zone_synchronizer_extension:num_zones_in_mission_objective()

	self:set_stage_count(stages)
end

MissionObjectiveZone.start_stage = function (self, stage)
	MissionObjectiveZone.super.start_stage(self, stage)

	local mission_objective_zone_synchronizer_extension = self:synchronizer_extension()

	if mission_objective_zone_synchronizer_extension:has_current_active_zone() then
		local start_num_active_units = self:max_incremented_progression()

		if start_num_active_units == 0 then
			start_num_active_units = mission_objective_zone_synchronizer_extension:start_num_active_units()

			self:set_max_increment(start_num_active_units)
		end
	end
end

MissionObjectiveZone.update_progression = function (self)
	MissionObjectiveZone.super.update_progression(self)

	local mission_objective_zone_synchronizer_extension = self:synchronizer_extension()
	local start_num_active_units = self:max_incremented_progression()

	if mission_objective_zone_synchronizer_extension:has_current_active_zone() and start_num_active_units == 0 then
		start_num_active_units = mission_objective_zone_synchronizer_extension:start_num_active_units()

		self:set_max_increment(start_num_active_units)
		self:propagate_objective_increment()
	end

	local current_progression = self:incremented_progression()
	local progression = mission_objective_zone_synchronizer_extension:zone_progression()

	if current_progression < progression then
		local progression_percent = progression / start_num_active_units

		self:set_increment(progression)
		self:set_progression(progression_percent)
		self:propagate_objective_increment()

		if self:max_progression_achieved() then
			self:stage_done()
		end
	end
end

MissionObjectiveZone.max_progression_achieved = function (self)
	local mission_objective_zone_synchronizer_extension = self:synchronizer_extension()

	if mission_objective_zone_synchronizer_extension:uses_servo_skull() then
		return false
	end

	return MissionObjectiveZone.super.max_progression_achieved(self)
end

MissionObjectiveZone.set_go_to_marker = function (self, unit)
	if unit then
		if not self._override_marked_units or not self._override_marked_units[unit] then
			self._override_marked_units = {
				unit,
			}
			self._override_marked_units[unit] = true
		end
	else
		self._override_marked_units = nil
	end
end

MissionObjectiveZone.marked_units = function (self)
	if self._override_marked_units then
		return self._override_marked_units
	end

	return MissionObjectiveZone.super.marked_units(self)
end

MissionObjectiveZone.propagate_objective_increment = function (self)
	local mission_objective_system = self._mission_objective_system

	mission_objective_system:propagate_objective_increment(self)
end

return MissionObjectiveZone
