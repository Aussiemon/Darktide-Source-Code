local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local MinigameExtension = class("MinigameExtension")
MinigameExtension.UPDATE_DISABLED_BY_DEFAULT = true
local MINIGAME_CLASSES = MinigameSettings.minigame_classes
local STATES = MinigameSettings.states

MinigameExtension.init = function (self, extension_init_context, unit, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._seed = nil
	self._minigame_type = MinigameSettings.types.none
	self._minigame = nil
	self._current_state = STATES.none
	self._owner_system = extension_init_context.owner_system
end

MinigameExtension.hot_join_sync = function (self, unit, sender, channel)
	fassert(self._is_server, "[MinigameSystem][hot_join_sync] server only method")
	self._minigame:hot_join_sync(sender, channel)

	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)
	local state_id = NetworkLookup.minigame_states[self._current_state]

	RPC.rpc_minigame_hot_join(channel, unit_id, is_level_unit, state_id)
end

MinigameExtension.on_add_extension = function (self, seed)
	self._seed = seed
end

MinigameExtension.setup_from_component = function (self, minigame_type, decode_symbols_sweep_duration)
	self._minigame_type = minigame_type

	fassert(self._minigame == nil, "[MinigameExtension][setup_from_component] Extension supports only 1 component per unit.")

	local minigame_context = {
		decode_target_margin = MinigameSettings.decode_target_margin,
		decode_symbols_sweep_duration = decode_symbols_sweep_duration,
		decode_symbols_stage_amount = MinigameSettings.decode_symbols_stage_amount,
		decode_symbols_items_per_stage = MinigameSettings.decode_symbols_items_per_stage,
		decode_symbols_target_margin = MinigameSettings.decode_symbols_target_margin,
		decode_symbols_total_items = MinigameSettings.decode_symbols_total_items
	}
	local minigame_class = MINIGAME_CLASSES[minigame_type]
	self._minigame = minigame_class:new(self._unit, self._is_server, self._seed, minigame_context)
end

MinigameExtension.update = function (self, unit, dt, t)
	if self._current_state == STATES.active and self._minigame:is_completed() then
		self:completed()
	end
end

MinigameExtension.minigame_type = function (self)
	return self._minigame_type
end

MinigameExtension.minigame = function (self, type)
	fassert(self._minigame_type == type, "[MinigameExtension][minigame] minigame_type(%s) mismatch.", self._minigame_type)

	return self._minigame
end

MinigameExtension.current_state = function (self)
	return self._current_state
end

MinigameExtension.unit = function (self)
	return self._unit
end

MinigameExtension.start = function (self, player)
	self:_set_state(STATES.active)
	self._minigame:start(player)

	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(self._unit)

		Managers.state.game_session:send_rpc_clients_except("rpc_minigame_sync_start", player:channel_id(), unit_id, is_level_unit)
	end
end

MinigameExtension.stop = function (self, player)
	self:_set_state(STATES.none)
	self._minigame:stop()

	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(self._unit)

		if player then
			Managers.state.game_session:send_rpc_clients_except("rpc_minigame_sync_stop", player:channel_id(), unit_id, is_level_unit)
		else
			Managers.state.game_session:send_rpc_clients("rpc_minigame_sync_stop", unit_id, is_level_unit)
		end
	end
end

MinigameExtension.completed = function (self)
	self:_set_state(STATES.completed)

	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_minigame_sync_completed", unit_id, is_level_unit)
	end
end

MinigameExtension.setup_game = function (self)
	fassert(self._is_server, "[MinigameExtension] Server only method.")
	self._minigame:setup_game()
end

MinigameExtension.on_action_pressed = function (self, t)
	fassert(self._is_server, "[MinigameExtension] Server only method.")

	if self._current_state == STATES.active then
		self._minigame:on_action_pressed(t)
	end
end

MinigameExtension.rpc_set_minigame_state = function (self, state)
	self:_set_state(state)
end

MinigameExtension._set_state = function (self, state)
	if self._current_state ~= state then
		if state == STATES.active then
			self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
		else
			self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
		end
	end

	self._current_state = state
end

return MinigameExtension
