-- chunkname: @scripts/extension_systems/minigame/minigame_system.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")

require("scripts/extension_systems/minigame/minigame_extension")

local MinigameSystem = class("MinigameSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_minigame_hot_join",
	"rpc_minigame_sync_start",
	"rpc_minigame_sync_stop",
	"rpc_minigame_sync_completed",
	"rpc_minigame_sync_game_state",
	"rpc_minigame_sync_set_stage",
	"rpc_minigame_sync_generate_board",
	"rpc_minigame_sync_balance_set_position",
	"rpc_minigame_sync_decode_symbols_set_start_time",
	"rpc_minigame_sync_decode_symbols_set_symbols",
	"rpc_minigame_sync_decode_symbols_set_target",
	"rpc_minigame_sync_drill_generate_targets",
	"rpc_minigame_sync_drill_set_cursor",
	"rpc_minigame_sync_drill_set_search",
	"rpc_minigame_sync_frequency_set_target_frequency"
}
local SERVER_RPCS = {
	"rpc_minigame_sync_frequency_test_frequency"
}

MinigameSystem.init = function (self, context, system_init_data, ...)
	MinigameSystem.super.init(self, context, system_init_data, ...)

	self._seed = self._is_server and system_init_data.level_seed or nil
	self._default_minigame_type = system_init_data.mission.minigame_type or MinigameSettings.default_minigame_type

	local network_event_delegate = self._network_event_delegate

	if network_event_delegate then
		if self._is_server then
			network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		else
			network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
		end
	end
end

MinigameSystem.destroy = function (self, ...)
	local network_event_delegate = self._network_event_delegate

	if network_event_delegate then
		if self._is_server then
			network_event_delegate:unregister_events(unpack(SERVER_RPCS))
		else
			network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
		end
	end

	MinigameSystem.super.destroy(self, ...)
end

MinigameSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = MinigameSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	extension:on_add_extension(self._seed)

	if self._seed then
		self._seed = self._seed + 1
	end

	return extension
end

MinigameSystem.default_minigame_type = function (self)
	return self._default_minigame_type
end

MinigameSystem.rpc_minigame_hot_join = function (self, channel_id, unit_id, is_level_unit, state_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local state = NetworkLookup.minigame_states[state_id]

	extension:rpc_set_minigame_state(state)
end

MinigameSystem.rpc_minigame_sync_start = function (self, channel_id, unit_id, is_level_unit)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:start()
end

MinigameSystem.rpc_minigame_sync_stop = function (self, channel_id, unit_id, is_level_unit)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:stop()
end

MinigameSystem.rpc_minigame_sync_completed = function (self, channel_id, unit_id, is_level_unit)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:completed()
end

MinigameSystem.rpc_minigame_sync_game_state = function (self, channel_id, unit_id, is_level_unit, state_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame()
	local state = NetworkLookup.minigame_game_states[state_id]

	minigame:set_state(state)
end

MinigameSystem.rpc_minigame_sync_generate_board = function (self, channel_id, unit_id, is_level_unit, seed)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame()

	minigame:generate_board(seed)
end

MinigameSystem.rpc_minigame_sync_balance_set_position = function (self, channel_id, unit_id, is_level_unit, position_x, position_y)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.balance)

	minigame:set_position(position_x, position_y)
end

MinigameSystem.rpc_minigame_sync_set_stage = function (self, channel_id, unit_id, is_level_unit, stage)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame()

	minigame:set_current_stage(stage)
end

MinigameSystem.rpc_minigame_sync_decode_symbols_set_start_time = function (self, channel_id, unit_id, is_level_unit, fixed_frame_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.decode_symbols)
	local start_time = fixed_frame_id * Managers.state.game_session.fixed_time_step

	minigame:set_start_time(start_time)
end

MinigameSystem.rpc_minigame_sync_decode_symbols_set_symbols = function (self, channel_id, unit_id, is_level_unit, symbols)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.decode_symbols)

	minigame:set_symbols(symbols)
end

MinigameSystem.rpc_minigame_sync_decode_symbols_set_target = function (self, channel_id, unit_id, is_level_unit, stage, target)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.decode_symbols)

	minigame:set_target(stage, target)
end

MinigameSystem.rpc_minigame_sync_drill_generate_targets = function (self, channel_id, unit_id, is_level_unit, seed)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.drill)

	minigame:generate_targets(seed)
end

MinigameSystem.rpc_minigame_sync_drill_set_cursor = function (self, channel_id, unit_id, is_level_unit, x, y, index)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.drill)

	minigame:set_cursor_position(x, y, index)
end

MinigameSystem.rpc_minigame_sync_drill_set_search = function (self, channel_id, unit_id, is_level_unit, searching, time)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.drill)

	minigame:set_searching(searching and time)
end

MinigameSystem.rpc_minigame_sync_frequency_test_frequency = function (self, channel_id, unit_id, is_level_unit, frequency_x, frequency_y)
	local peer_id = Network.peer_id(channel_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.frequency)

	minigame:test_frequency(frequency_x, frequency_y)
end

MinigameSystem.rpc_minigame_sync_frequency_set_target_frequency = function (self, channel_id, unit_id, is_level_unit, frequency_x, frequency_y)
	if is_level_unit then
		if unit_id == NetworkConstants.invalid_level_unit_id then
			return
		end
	elseif unit_id == NetworkConstants.invalid_game_object_id then
		return
	end

	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	if not unit then
		return
	end

	local extension = self._unit_to_extension_map[unit]

	if not extension then
		return
	end

	local minigame = extension:minigame(MinigameSettings.types.frequency)

	if not minigame then
		return
	end

	minigame:set_target_frequency(frequency_x, frequency_y)
end

return MinigameSystem
