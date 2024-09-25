-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_decode.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveDecode = class("MissionObjectiveDecode", "MissionObjectiveBase")

MissionObjectiveDecode.update_progression = function (self)
	MissionObjectiveDecode.super.update_progression(self)

	local timer_extension = ScriptUnit.extension(self._synchronizer_unit, "networked_timer_system")
	local progress = timer_extension:progression()
	local decode_synchronizer_extension = self:synchronizer_extension()
	local finished = decode_synchronizer_extension:setup_only_finished()

	if finished then
		progress = 1
	end

	self:set_progression(progress)

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

return MissionObjectiveDecode
