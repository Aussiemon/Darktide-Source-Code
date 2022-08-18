local MinigameSettings = require("scripts/settings/minigame/minigame_settings")

require("scripts/extension_systems/minigame/minigame_extension")

local MinigameSystem = class("MinigameSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_minigame_hot_join",
	"rpc_minigame_sync_start",
	"rpc_minigame_sync_stop",
	"rpc_minigame_sync_completed",
	"rpc_minigame_sync_decode_symbols_set_stage",
	"rpc_minigame_sync_decode_symbols_set_start_time",
	"rpc_minigame_sync_decode_symbols_set_symbols",
	"rpc_minigame_sync_decode_symbols_set_target"
}

MinigameSystem.init = function (self, context, system_init_data, ...)
	MinigameSystem.super.init(self, context, system_init_data, ...)

	self._seed = (self._is_server and system_init_data.level_seed) or nil
	local network_event_delegate = self._network_event_delegate

	if not self._is_server and network_event_delegate then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MinigameSystem.destroy = function (self, ...)
	local network_event_delegate = self._network_event_delegate

	if not self._is_server and network_event_delegate then
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	MinigameSystem.super.destroy(self, ...)
end

MinigameSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = MinigameSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	extension:on_add_extension(self._seed)

	return extension
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

MinigameSystem.rpc_minigame_sync_decode_symbols_set_stage = function (self, channel_id, unit_id, is_level_unit, stage)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.decode_symbols)

	minigame:set_current_stage(stage)
end

MinigameSystem.rpc_minigame_sync_decode_symbols_set_start_time = function (self, channel_id, unit_id, is_level_unit, fixed_frame_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local minigame = extension:minigame(MinigameSettings.types.decode_symbols)
	local start_time = fixed_frame_id * GameParameters.fixed_time_step

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

return MinigameSystem
