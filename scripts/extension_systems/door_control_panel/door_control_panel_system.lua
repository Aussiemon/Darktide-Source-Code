require("scripts/extension_systems/door_control_panel/door_control_panel_extension")

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local DoorControlPanelSystem = class("DoorControlPanelSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_sync_door_control_panel_state"
}

DoorControlPanelSystem.init = function (self, extension_system_creation_context, ...)
	DoorControlPanelSystem.super.init(self, extension_system_creation_context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

DoorControlPanelSystem.on_gameplay_post_init = function (self, level)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.on_gameplay_post_init then
			extension:on_gameplay_post_init(level)
		end
	end
end

DoorControlPanelSystem.destroy = function (self, ...)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	DoorControlPanelSystem.super.destroy(self, ...)
end

DoorControlPanelSystem.rpc_sync_door_control_panel_state = function (self, channel_id, unit_object_id, state_lookup_id)
	local is_level_unit = false
	local unit = Managers.state.unit_spawner:unit(unit_object_id, is_level_unit)
	local state = NetworkLookup.door_control_panel_states[state_lookup_id]
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_sync_door_control_panel_state(state)
end

return DoorControlPanelSystem
