-- chunkname: @scripts/extension_systems/event_synchronizer/timed_synchronizer_extension.lua

local TimedSynchronizerExtension = class("TimedSynchronizerExtension", "EventSynchronizerBaseExtension")

TimedSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	TimedSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._objective_name = "default"
end

TimedSynchronizerExtension.setup_from_component = function (self, objective_name, automatic_start)
	self._objective_name = objective_name
	self._auto_start = automatic_start

	self._mission_objective_system:register_objective_synchronizer(objective_name, self._unit)
end

TimedSynchronizerExtension.add_time = function (self, time)
	local mission_objective = self._mission_objective_system:active_objective(self._objective_name)

	mission_objective:add_time(time)
end

return TimedSynchronizerExtension
