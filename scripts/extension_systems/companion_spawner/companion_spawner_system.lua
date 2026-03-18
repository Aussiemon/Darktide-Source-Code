-- chunkname: @scripts/extension_systems/companion_spawner/companion_spawner_system.lua

require("scripts/extension_systems/companion_spawner/companion_spawner_extension")

local CompanionSpawnerSystem = class("CompanionSpawnerSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_companion_despawn_units",
	"rpc_companion_spawn_unit",
}

CompanionSpawnerSystem.init = function (self, context, ...)
	CompanionSpawnerSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

CompanionSpawnerSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	CompanionSpawnerSystem.super.destroy(self)
end

CompanionSpawnerSystem.rpc_companion_despawn_units = function (self, channel_id, unit_id)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local extension = self._unit_to_extension_map[unit]

	extension:despawn_units()
end

CompanionSpawnerSystem.rpc_companion_spawn_unit = function (self, channel_id, unit_id, spawned_unit_id, optional_look_up_key)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local extension = self._unit_to_extension_map[unit]
	local unit_spawner = Managers.state.unit_spawner
	local spawned_unit = unit_spawner:unit(spawned_unit_id)

	extension:register_spawned_companion_unit(spawned_unit)

	if optional_look_up_key then
		extension:rpc_add_spawned_unit_lookup(optional_look_up_key, spawned_unit)
	end
end

return CompanionSpawnerSystem
