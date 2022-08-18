require("scripts/extension_systems/networked_timer/networked_timer_extension")

local NetworkedTimerSystem = class("NetworkedTimerSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_networked_timer_sync_state",
	"rpc_networked_timer_start",
	"rpc_networked_timer_pause",
	"rpc_networked_timer_stop",
	"rpc_networked_timer_fast_forward",
	"rpc_networked_timer_rewind",
	"rpc_networked_timer_finished"
}

NetworkedTimerSystem.init = function (self, context, system_init_data, ...)
	NetworkedTimerSystem.super.init(self, context, system_init_data, ...)

	self._network_event_delegate = context.network_event_delegate

	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

NetworkedTimerSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	NetworkedTimerSystem.super.destroy(self)
end

NetworkedTimerSystem.rpc_networked_timer_sync_state = function (self, channel_id, unit_id, active, counting, total_timer, speed_modifier)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:sync_state(active, counting, total_timer, speed_modifier)
end

NetworkedTimerSystem.rpc_networked_timer_start = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:start()
end

NetworkedTimerSystem.rpc_networked_timer_pause = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:pause()
end

NetworkedTimerSystem.rpc_networked_timer_stop = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:stop()
end

NetworkedTimerSystem.rpc_networked_timer_fast_forward = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:fast_forward()
end

NetworkedTimerSystem.rpc_networked_timer_rewind = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:rewind()
end

NetworkedTimerSystem.rpc_networked_timer_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = ScriptUnit.extension(unit, "networked_timer_system")

	extension:finished()
end

return NetworkedTimerSystem
