require("scripts/extension_systems/door/door_extension")

local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local DoorSystem = class("DoorSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_sync_door_state"
}

DoorSystem.init = function (self, extension_system_creation_context, ...)
	DoorSystem.super.init(self, extension_system_creation_context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	Managers.state.level_props_broadphase:register_extension_system(self)
end

DoorSystem.rpc_sync_door_state = function (self, channel_id, unit_level_index, state_lookup_id, anim_time_normalized)
	local unit = Managers.state.unit_spawner:unit(unit_level_index, true)
	local state = NetworkLookup.door_states[state_lookup_id]
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_sync_door_state(state, anim_time_normalized)
end

DoorSystem.destroy = function (self, ...)
	Managers.state.level_props_broadphase:unregister_extension_system(self)

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	DoorSystem.super.destroy(self, ...)
end

DoorSystem.update_level_props_broadphase = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		repeat
			local ignore_broadphase = extension:ignore_broadphase()

			if ignore_broadphase then
				break
			end

			local units_nearby = LevelPropsBroadphase.check_units_nearby(POSITION_LOOKUP[unit])
			local in_update_list = self:has_update_function("DoorExtension", "update", unit)

			if units_nearby and not in_update_list then
				self:enable_update_function("DoorExtension", "update", unit, extension)
			elseif not units_nearby and in_update_list then
				self:disable_update_function("DoorExtension", "update", unit, extension)
			end
		until true
	end
end

return DoorSystem
