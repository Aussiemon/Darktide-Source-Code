-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_decode.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveDecode = class("MissionObjectiveDecode", "MissionObjectiveBase")

MissionObjectiveDecode.update_progression = function (self, objective_data)
	MissionObjectiveDecode.super.update_progression(self)

	local timer_extension = ScriptUnit.extension(self._synchronizer_unit, "networked_timer_system")
	local progress = timer_extension:progression()
	local mission_objective_decode_synchronizer_extension = self:synchronizer_extension()
	local finished = mission_objective_decode_synchronizer_extension:setup_only_finished()
	local stuck = mission_objective_decode_synchronizer_extension:is_stuck()

	if stuck then
		self._ui_state = "alert"
	else
		self._ui_state = "default"
	end

	if finished then
		progress = 1
	end

	self:set_progression(progress)

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

return MissionObjectiveDecode
