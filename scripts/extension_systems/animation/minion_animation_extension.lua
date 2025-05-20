-- chunkname: @scripts/extension_systems/animation/minion_animation_extension.lua

local MinionAnimationExtension = class("MinionAnimationExtension")
local Unit_animation_set_variable = Unit.animation_set_variable
local GameSession_game_object_fields_array = GameSession.game_object_fields_array

MinionAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._unit = unit

	if not is_server then
		self._game_session = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	local breed = extension_init_data.breed

	self._breed = breed

	local state_machine = breed.state_machine

	if state_machine then
		Unit.set_animation_state_machine(unit, state_machine)
	end

	self._animation_variable_bounds = breed.animation_variable_bounds

	local next_seed = extension_init_data.random_seed
	local seeds, num_seeds = Unit.animation_get_seeds(unit)

	for i = 1, num_seeds do
		local seed

		next_seed, seed = math.random_seed(next_seed)
		seeds[i] = seed
	end

	local animation_variables = breed.animation_variables

	if animation_variables then
		local num_anim_variables = #animation_variables
		local variables = Script.new_map(num_anim_variables)
		local index_name_variables = Script.new_map(num_anim_variables)
		local go_var_lookup = Script.new_table(num_anim_variables * 2, num_anim_variables)
		local var_idx = 1

		for i = 1, #animation_variables do
			local variable_name = animation_variables[i]
			local variable_index = Unit.animation_find_variable(unit, variable_name)

			variables[variable_name] = variable_index
			index_name_variables[variable_index] = variable_name

			local anim_var_name_id = Script.id_string_32(variable_name)

			go_var_lookup[var_idx] = anim_var_name_id
			go_var_lookup[var_idx + 1] = 0
			go_var_lookup[anim_var_name_id] = variable_index
			var_idx = var_idx + 2
		end

		self._variables = variables
		self._index_name_variables = index_name_variables
		self._go_var_lookup = go_var_lookup
	end

	Unit.animation_set_seeds(unit, unpack(seeds))
end

MinionAnimationExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_session, self._game_object_id = game_session, game_object_id

	if self._breed.animation_variable_init then
		for name, value in pairs(self._breed.animation_variable_init) do
			self:set_variable(name, value)
		end
	end
end

MinionAnimationExtension.hot_join_sync = function (self, unit, sender, channel)
	local anim_states = Unit.animation_get_state(unit)
	local seeds = Unit.animation_get_seeds(unit)
	local game_object_id = self._game_object_id
	local is_level_unit = false

	RPC.rpc_sync_anim_state(channel, game_object_id, is_level_unit, anim_states, seeds)
end

MinionAnimationExtension.anim_event = function (self, event_name, optional_except_channel_id)
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
	local unit = self._unit
	local game_object_id = self._game_object_id
	local event_index = Unit.animation_event(unit, event_name)
	local variable_index = Unit.animation_find_variable(unit, variable_name)
	local variable_bounds = self._animation_variable_bounds

	if variable_bounds and variable_bounds[variable_name] then
		variable_value = math.clamp(variable_value, variable_bounds[variable_name][1], variable_bounds[variable_name][2])
	end

	Unit_animation_set_variable(unit, variable_index, variable_value)
	Managers.state.game_session:send_rpc_clients("rpc_minion_anim_event_variable_float", game_object_id, event_index, variable_index, variable_value, variable_name)
end

MinionAnimationExtension.has_variable = function (self, name)
	return self._variables and self._variables[name]
end

MinionAnimationExtension.set_variable = function (self, name, value)
	local unit = self._unit
	local game_session, game_object_id = self._game_session, self._game_object_id
	local variables = self._variables
	local index = variables[name]
	local variable_bounds = self._animation_variable_bounds

	if variable_bounds and variable_bounds[name] then
		value = math.clamp(value, variable_bounds[name][1], variable_bounds[name][2])
	end

	Unit_animation_set_variable(unit, index, value)
	GameSession.set_game_object_field(game_session, game_object_id, name, value)
end

MinionAnimationExtension.update = function (self, unit, ...)
	if not self._is_server and self._go_var_lookup then
		local game_session, game_object_id = self._game_session, self._game_object_id
		local go_var_lookup = self._go_var_lookup
		local modified_table_size = GameSession_game_object_fields_array(game_session, game_object_id, go_var_lookup)

		for i = 1, modified_table_size, 2 do
			local index = go_var_lookup[go_var_lookup[i]]
			local variable_name = self._index_name_variables[index]
			local variable_value = go_var_lookup[i + 1]

			if variable_name then
				local variable_bounds = self._animation_variable_bounds

				if variable_bounds and variable_bounds[variable_name] then
					variable_value = math.clamp(variable_value, variable_bounds[variable_name][1], variable_bounds[variable_name][2])
				end
			end

			Unit_animation_set_variable(unit, index, variable_value)
		end
	end
end

return MinionAnimationExtension
