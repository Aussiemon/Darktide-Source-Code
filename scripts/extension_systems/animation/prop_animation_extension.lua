local PropAnimationExtension = class("PropAnimationExtension")

PropAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	local level_id = Managers.state.unit_spawner:level_index(unit)

	if level_id then
		self._unit_id = level_id
		self._is_level_unit = true
	else
		self._unit_id = nil
		self._is_level_unit = nil
	end

	self._game_session = nil
	self._variables = {}
	local next_seed = math.random_seed()
	local seeds, num_seeds = Unit.animation_get_seeds(unit)

	for i = 1, num_seeds do
		local seed = nil
		next_seed, seed = math.random_seed(next_seed)
		seeds[i] = seed
	end

	Unit.animation_set_seeds(unit, unpack(seeds))
end

PropAnimationExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._unit_id = game_object_id
	self._is_level_unit = false
	self._game_session = game_session
end

PropAnimationExtension.setup_from_component = function (self, animation_variables, optional_state_machine_override)
	local unit = self._unit

	if optional_state_machine_override ~= "" then
		Unit.set_animation_state_machine(unit, optional_state_machine_override)
	end

	local variables = self._variables

	for i = 1, #animation_variables do
		local variable_name = animation_variables[i]
		local variable_index = Unit.animation_find_variable(unit, variable_name)
		variables[variable_name] = variable_index
	end
end

PropAnimationExtension.hot_join_sync = function (self, unit, sender, channel)
	local anim_states = Unit.animation_get_state(unit)
	local seeds = Unit.animation_get_seeds(unit)
	local unit_id = self._unit_id
	local is_level_unit = self._is_level_unit

	RPC.rpc_sync_anim_state(channel, unit_id, is_level_unit, anim_states, seeds)
end

PropAnimationExtension.anim_event = function (self, event_name)
	local unit = self._unit
	local unit_id = self._unit_id
	local is_level_unit = self._is_level_unit
	local event_index = Unit.animation_event(unit, event_name)

	Managers.state.game_session:send_rpc_clients("rpc_prop_anim_event", unit_id, is_level_unit, event_index)
end

PropAnimationExtension.anim_event_with_variable_float = function (self, event_name, variable_name, variable_value)
	local unit = self._unit
	local unit_id = self._unit_id
	local is_level_unit = self._is_level_unit
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)

	local event_index = Unit.animation_event(unit, event_name)

	Managers.state.game_session:send_rpc_clients("rpc_prop_anim_event_variable_float", unit_id, is_level_unit, event_index, variable_index, variable_value)
end

PropAnimationExtension.set_variable = function (self, name, value)
	local unit = self._unit
	local unit_id = self._unit_id
	local is_level_unit = self._is_level_unit
	local variables = self._variables
	local variable_index = variables[name]

	Unit.animation_set_variable(unit, variable_index, value)
	Managers.state.game_session:send_rpc_clients("rpc_prop_anim_set_variable", unit_id, is_level_unit, variable_index, value)
end

return PropAnimationExtension
