-- chunkname: @scripts/extension_systems/event_synchronizer/timed_synchronizer_extension.lua

local TimedSynchronizerExtension = class("TimedSynchronizerExtension", "EventSynchronizerBaseExtension")

TimedSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	TimedSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._objective_name = "default"
	self._paused = false
end

TimedSynchronizerExtension.setup_from_component = function (self, objective_name, auto_start, curve_power)
	self._objective_name = objective_name
	self._auto_start = auto_start
	self._curve_power = curve_power

	self._mission_objective_system:register_objective_synchronizer(objective_name, self._unit)
end

TimedSynchronizerExtension.objective_started = function (self)
	TimedSynchronizerExtension.super.objective_started(self)

	if self._is_server then
		local mission_objective = self._mission_objective_system:active_objective(self._objective_name)

		if self._paused then
			mission_objective:pause()
		end
	end
end

TimedSynchronizerExtension.hot_join_sync = function (self, sender, channel)
	if self._paused then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_paused", level_unit_id)
	end
end

TimedSynchronizerExtension.start_event = function (self)
	if self._paused then
		self._paused = false

		local mission_objective = self._mission_objective_system:active_objective(self._objective_name)

		mission_objective:resume()
		Unit.flow_event(self._unit, "lua_event_resumed")
	else
		TimedSynchronizerExtension.super.start_event(self)
	end
end

TimedSynchronizerExtension.finished_event = function (self)
	TimedSynchronizerExtension.super.finished_event(self)

	self._paused = false
end

TimedSynchronizerExtension.add_time = function (self, time)
	if self._is_server then
		local mission_objective = self._mission_objective_system:active_objective(self._objective_name)

		mission_objective:add_time(time)
	end
end

TimedSynchronizerExtension.pause_event = function (self)
	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_paused", unit_id)
	end

	local mission_objective = self._mission_objective_system:active_objective(self._objective_name)

	if mission_objective then
		mission_objective:pause()
	end

	self._paused = true

	Unit.flow_event(self._unit, "lua_event_paused")
end

TimedSynchronizerExtension.resume_event = function (self)
	if self._is_server then
		self:start_event()

		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_started", unit_id)
	end
end

TimedSynchronizerExtension.progression_displayed = function (self, progression)
	if self._curve_power == 1 or progression > 1 then
		return progression
	end

	return 1 - math.pow(1 - progression, self._curve_power)
end

return TimedSynchronizerExtension
