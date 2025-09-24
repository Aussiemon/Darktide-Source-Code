-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_kill.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveKill = class("MissionObjectiveKill", "MissionObjectiveBase")

MissionObjectiveKill.start_stage = function (self, stage)
	MissionObjectiveKill.super.start_stage(self, stage)
	self:set_max_increment(0)
end

MissionObjectiveKill.register_unit = function (self, unit)
	MissionObjectiveKill.super.register_unit(self, unit)

	local kill_synchronizer_extension = self:synchronizer_extension()

	kill_synchronizer_extension:register_minion_unit(unit)
end

MissionObjectiveKill.update_progression = function (self)
	MissionObjectiveKill.super.update_progression(self)

	local kill_synchronizer_extension = self:synchronizer_extension()
	local progression = kill_synchronizer_extension:progression()

	self:set_progression(progression)

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

MissionObjectiveKill._init_objective_unit = function (self, unit)
	local mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension then
		MissionObjectiveKill.super._init_objective_unit(self, unit)
	else
		Managers.state.extension:system("mission_objective_system"):add_marker(self._name, nil, unit)
		self:register_unit(unit)
	end
end

return MissionObjectiveKill
