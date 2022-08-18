require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveGoal = class("MissionObjectiveGoal", "MissionObjectiveBase")

MissionObjectiveGoal.init = function (self)
	MissionObjectiveGoal.super.init(self)
	self:set_updated_externally(true)
end

return MissionObjectiveGoal
