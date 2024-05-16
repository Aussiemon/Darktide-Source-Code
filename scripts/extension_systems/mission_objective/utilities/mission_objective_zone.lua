-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_zone.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveZone = class("MissionObjectiveZone", "MissionObjectiveBase")

MissionObjectiveZone.ZONE_TYPES = table.enum("none", "capture", "scan")

local ZONE_TYPES = MissionObjectiveZone.ZONE_TYPES

MissionObjectiveZone.init = function (self, peer_id)
	MissionObjectiveZone.super.init(self, peer_id)

	self._current_zone_progression = 0
	self._start_counter = false
	self._zone_type = ZONE_TYPES.none
	self._override_marked_units = nil
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

	local progression = 0
	local current_progression = self:incremented_progression()
	local progression_percent = 0
	local zone_type = self._zone_type

	if zone_type == ZONE_TYPES.none then
		zone_type = mission_objective_zone_synchronizer_extension:zone_type()

		if zone_type then
			self._zone_type = zone_type
		end
	end

	if zone_type == ZONE_TYPES.capture then
		progression = mission_objective_zone_synchronizer_extension:progression(ZONE_TYPES.capture)
		progression_percent = progression / start_num_active_units
	elseif zone_type == ZONE_TYPES.scan then
		local zone_progression = mission_objective_zone_synchronizer_extension:zone_progression()
		local num_zones_in_mission_objective = mission_objective_zone_synchronizer_extension:num_zones_in_mission_objective()

		if self._current_zone_progression ~= zone_progression then
			self._current_zone_progression = zone_progression

			local new_progression = -current_progression

			self:update_increment(new_progression)

			current_progression = self:incremented_progression()

			self:set_max_increment(0)
			self:propagate_objective_increment()
		end

		progression = mission_objective_zone_synchronizer_extension:progression(ZONE_TYPES.scan)
		progression_percent = zone_progression / num_zones_in_mission_objective
	end

	if current_progression < progression then
		local increment = progression - current_progression

		self:update_increment(increment)
		self:propagate_objective_increment()
	end

	if self:has_second_progression() then
		local second_progression = mission_objective_zone_synchronizer_extension:second_progression()

		self:set_second_progression(second_progression)
	end

	self:set_progression(progression_percent)

	if self:max_progression_achieved() then
		self:stage_done()
	end
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
