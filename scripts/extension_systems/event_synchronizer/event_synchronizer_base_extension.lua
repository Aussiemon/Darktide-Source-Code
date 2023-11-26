-- chunkname: @scripts/extension_systems/event_synchronizer/event_synchronizer_base_extension.lua

local EventSynchronizerBaseExtension = class("EventSynchronizerBaseExtension")

EventSynchronizerBaseExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._objective_name = "default"
	self._auto_start = false
	self._mission_active = false
	self._finished = false
	self._setup_seed = 0
	self._seed = 0
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if self._is_server then
		self._setup_seed = math.random_seed()
		self._seed = math.random_seed()
	end
end

EventSynchronizerBaseExtension.setup_from_component = function (self)
	return
end

EventSynchronizerBaseExtension.register_connected_units = function (self, stage_units, registered_units)
	return stage_units
end

EventSynchronizerBaseExtension.start_event = function (self)
	if not self._mission_active then
		self._mission_active = true

		Unit.flow_event(self._unit, "lua_event_started")
	end
end

EventSynchronizerBaseExtension.start_stage = function (self, stage)
	return
end

EventSynchronizerBaseExtension.finished_stage = function (self)
	return
end

EventSynchronizerBaseExtension.finished_event = function (self)
	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_finished", unit_id)
	end

	self._mission_active = false
	self._finished = true

	Unit.flow_event(self._unit, "lua_event_finished")
end

EventSynchronizerBaseExtension.auto_start = function (self)
	return self._auto_start
end

EventSynchronizerBaseExtension.seeds = function (self)
	return self._setup_seed, self._seed
end

EventSynchronizerBaseExtension.distribute_seeds = function (self, setup_seed, seed)
	self._setup_seed = setup_seed
	self._seed = seed
end

EventSynchronizerBaseExtension.finished = function (self)
	return self._finished
end

return EventSynchronizerBaseExtension
