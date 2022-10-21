require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveCaptureZone = class("MissionObjectiveCaptureZone", "MissionObjectiveBase")

MissionObjectiveCaptureZone.start_stage = function (self, stage)
	MissionObjectiveCaptureZone.super.start_stage(self, stage)

	local capture_zone_synchronizer_extension = self:synchronizer_extension()

	self:set_max_increment(capture_zone_synchronizer_extension:start_num_active_units())
end

MissionObjectiveCaptureZone.update_progression = function (self)
	MissionObjectiveCaptureZone.super.update_progression(self)

	local capture_zone_synchronizer_extension = self:synchronizer_extension()
	local capture_zone_progression = capture_zone_synchronizer_extension:progression()
	local start_num_active_units = self:max_incremented_progression()
	local current_progression = self:incremented_progression()

	if capture_zone_progression ~= current_progression then
		local increment = 1

		self:update_increment(increment)

		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:propagate_objective_increment(self)
	end

	local progression_percent = capture_zone_progression / start_num_active_units

	self:set_progression(progression_percent)

	if self:has_second_progression() then
		local current_capture_zone_unit = self:get_current_capture_zone()

		if current_capture_zone_unit then
			local capture_zone_extension = ScriptUnit.extension(current_capture_zone_unit, "capture_zone_system")
			local time_progress = capture_zone_extension:get_time_progress()

			self:set_second_progression(time_progress)
		end
	end

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

MissionObjectiveCaptureZone.get_current_capture_zone = function (self)
	local synchronizer_extension = self:synchronizer_extension()

	return synchronizer_extension:get_current_capture_zone()
end

return MissionObjectiveCaptureZone
