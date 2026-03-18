-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_flow_extension.lua

local MissionObjectiveZoneFlowExtension = class("MissionObjectiveZoneFlowExtension", "MissionObjectiveZoneBaseExtension")

MissionObjectiveZoneFlowExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneFlowExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._zone_type = "flow"
	self._current_progression = 0
	self._use_vo = false
end

MissionObjectiveZoneFlowExtension.setup_from_component = function (self, return_to_skull, max_progress, progress_ui_type)
	self._return_to_skull = return_to_skull
	self._max_progression = max_progress
	self._progress_ui_type = progress_ui_type
end

MissionObjectiveZoneFlowExtension.update = function (self, ...)
	MissionObjectiveZoneFlowExtension.super.update(self, ...)

	if not self._activated then
		return
	end
end

MissionObjectiveZoneFlowExtension.increment_progression = function (self)
	self:set_progression(self._current_progression + 1)
end

MissionObjectiveZoneFlowExtension.set_progression = function (self, value)
	self._current_progression = value

	local progression = self._current_progression

	if self._is_server and progression >= self._max_progression then
		if self._synchronizer_extension:uses_servo_skull() then
			self._start_vo_line_timer = true

			self:_inform_skull_of_completion()
		else
			self:zone_finished()
		end
	end
end

MissionObjectiveZoneFlowExtension.current_progression = function (self)
	return self._current_progression
end

MissionObjectiveZoneFlowExtension.max_progression = function (self)
	return self._max_progression
end

return MissionObjectiveZoneFlowExtension
