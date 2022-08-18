local MinionAnimationExtension = class("MinionAnimationExtension")

MinionAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._unit = unit

	if not is_server then
		self._game_session = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	local breed = extension_init_data.breed
	local state_machine = breed.state_machine

	if state_machine then
		Unit.set_animation_state_machine(unit, state_machine)
	end

	local next_seed = extension_init_data.random_seed
	local num_seeds, seeds = Unit.animation_get_seeds(unit)

	for i = 1, num_seeds, 1 do
		local seed = nil
		next_seed, seed = math.random_seed(next_seed)
		seeds[i] = seed
	end

	local animation_variables = breed.animation_variables

	if animation_variables then
		local variables = {}

		for i = 1, #animation_variables, 1 do
			local variable_name = animation_variables[i]
			local variable_index = Unit.animation_find_variable(unit, variable_name)
			variables[variable_name] = variable_index
		end

		self._variables = variables
	end

	Unit.animation_set_seeds(unit, unpack(seeds))
end

MinionAnimationExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

MinionAnimationExtension.hot_join_sync = function (self, unit, sender, channel)
	local _, anim_states = Unit.animation_get_state(unit)
	local _, seeds = Unit.animation_get_seeds(unit)
	local game_object_id = self._game_object_id
	local is_level_unit = false

	RPC.rpc_sync_anim_state(channel, game_object_id, is_level_unit, anim_states, seeds)
end

MinionAnimationExtension.anim_event = function (self, event_name, optional_except_channel_id)
	fassert(self._is_server, "[MinionAnimationExtension] Only server should trigger \"anim_event\"!")

	local unit = self._unit
	local game_object_id = self._game_object_id
	local event_index = Unit.animation_event(unit, event_name)

	if optional_except_channel_id then
		Managers.state.game_session:send_rpc_clients_except("rpc_minion_anim_event", optional_except_channel_id, game_object_id, event_index)
	else
		Managers.state.game_session:send_rpc_clients("rpc_minion_anim_event", game_object_id, event_index)
	end
end

MinionAnimationExtension.anim_event_with_variable_float = function (self, event_name, variable_name, variable_value)
	fassert(self._is_server, "[MinionAnimationExtension] Only server should trigger \"anim_event_with_variable_float\"!")

	local unit = self._unit
	local game_object_id = self._game_object_id
	local event_index = Unit.animation_event(unit, event_name)
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Managers.state.game_session:send_rpc_clients("rpc_minion_anim_event_variable_float", game_object_id, event_index, variable_index, variable_value)
end

MinionAnimationExtension.set_variable = function (self, name, value)
	fassert(self._is_server, "[MinionAnimationExtension] Only server should trigger \"set_variable\"!")

	local unit = self._unit
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local variables = self._variables
	local index = variables[name]

	Unit.animation_set_variable(unit, index, value)
	GameSession.set_game_object_field(game_session, game_object_id, name, value)
end

MinionAnimationExtension.update = function (self, unit, ...)
	if not self._is_server and self._variables then
		local game_session = self._game_session
		local game_object_id = self._game_object_id
		local variables = self._variables
		local GameSession_game_object_field = GameSession.game_object_field
		local Unit_animation_set_variable = Unit.animation_set_variable

		for name, index in pairs(variables) do
			local variable_value = GameSession_game_object_field(game_session, game_object_id, name)

			Unit_animation_set_variable(unit, index, variable_value)
		end
	end
end

return MinionAnimationExtension
