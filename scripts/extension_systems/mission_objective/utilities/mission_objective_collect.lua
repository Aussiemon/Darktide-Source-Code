-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_collect.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveCollect = class("MissionObjectiveCollect", "MissionObjectiveBase")

MissionObjectiveCollect.init = function (self)
	MissionObjectiveCollect.super.init(self)

	self._collect_amount = 0

	self:set_updated_externally(true)
end

MissionObjectiveCollect.start_objective = function (self, mission_objective_data, units, synchronizer_unit)
	MissionObjectiveCollect.super.start_objective(self, mission_objective_data, units, synchronizer_unit)

	self._collect_amount = mission_objective_data.collect_amount
end

MissionObjectiveCollect.start_stage = function (self, stage)
	MissionObjectiveCollect.super.start_stage(self, stage)
	self:set_max_increment(self._collect_amount)
end

MissionObjectiveCollect.update_progression = function (self)
	MissionObjectiveCollect.super.update_progression(self)

	local amount_to_collect = self:max_incremented_progression()

	if amount_to_collect > 0 then
		local current_amount = self:incremented_progression()
		local progression = current_amount / amount_to_collect

		progression = math.clamp(progression, 0, 1)

		self:set_progression(progression)
	end
end

return MissionObjectiveCollect
