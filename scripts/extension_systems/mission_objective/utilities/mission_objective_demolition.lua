-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_demolition.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveDemolition = class("MissionObjectiveDemolition", "MissionObjectiveBase")

MissionObjectiveDemolition.init = function (self)
	MissionObjectiveDemolition.super.init(self)

	self._resume_timer_active = false
	self._resume_timer = 0
end

MissionObjectiveDemolition.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit)
	MissionObjectiveDemolition.super.start_objective(self, mission_objective_data, registered_units, synchronizer_unit)

	local demolition_synchronizer_extension = self:synchronizer_extension()
	local stages = demolition_synchronizer_extension:setup_stages(registered_units)

	self:set_stage_count(stages)
end

MissionObjectiveDemolition.start_stage = function (self, stage)
	MissionObjectiveDemolition.super.start_stage(self, stage)

	self._resume_timer_active = false

	local demolition_synchronizer_extension = self:synchronizer_extension()

	self:set_max_increment(demolition_synchronizer_extension:active_stage_unit_num())
end

MissionObjectiveDemolition.stage_done = function (self)
	for target_unit, _ in pairs(self._objective_units) do
		if self:has_marker(target_unit) then
			local objective_target_extension = ScriptUnit.extension(target_unit, "mission_objective_target_system")

			objective_target_extension:remove_unit_marker()
		end
	end

	MissionObjectiveDemolition.super.stage_done(self)
end

MissionObjectiveDemolition.update = function (self, dt)
	MissionObjectiveDemolition.super.update(self, dt)

	if self._resume_timer_active then
		self._resume_timer = self._resume_timer - dt

		if self._resume_timer <= 0 then
			self._resume_timer = 0

			self:resume()
			self:stage_done()
		end
	end
end

MissionObjectiveDemolition.update_progression = function (self)
	MissionObjectiveDemolition.super.update_progression(self)

	local num_active_units = self:max_incremented_progression()
	local total_destroyed = 0

	for target_unit, _ in pairs(self._objective_units) do
		local health_extension = ScriptUnit.has_extension(target_unit, "health_system")
		local corruptor_arm_extension = ScriptUnit.has_extension(target_unit, "corruptor_arm_system")

		if health_extension then
			if not health_extension:is_alive() then
				total_destroyed = total_destroyed + 1

				if self:has_marker(target_unit) then
					local objective_target_extension = ScriptUnit.extension(target_unit, "mission_objective_target_system")

					objective_target_extension:remove_unit_marker()
				end
			end
		elseif corruptor_arm_extension then
			if corruptor_arm_extension:has_lost_pustules() then
				total_destroyed = total_destroyed + 1
			end
		elseif not self:has_marker(target_unit) then
			total_destroyed = total_destroyed + 1
		end
	end

	local current_progression = self:incremented_progression()

	if total_destroyed ~= current_progression then
		local increment = total_destroyed - current_progression

		self:update_increment(increment)

		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:propagate_objective_increment(self)
	end

	local progression_percent = total_destroyed / num_active_units

	self:set_progression(progression_percent)

	if progression_percent >= 1 and not self._resume_timer_active then
		local demolition_synchronizer_extension = self:synchronizer_extension()

		self._resume_timer = demolition_synchronizer_extension:stage_end_delay(self._stage)

		if self._resume_timer > 0 then
			self._resume_timer_active = true

			Unit.flow_event(self._synchronizer_unit, "lua_event_timer_started")
			self:pause()
		else
			self:stage_done()
		end
	end
end

MissionObjectiveDemolition.marked_units = function (self)
	local demolition_synchronizer_extension = self:synchronizer_extension()
	local override_markers = demolition_synchronizer_extension:override_objective_markers()

	if override_markers then
		return override_markers
	end

	return MissionObjectiveDemolition.super.marked_units(self)
end

return MissionObjectiveDemolition
