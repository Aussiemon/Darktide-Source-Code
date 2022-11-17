require("scripts/extension_systems/camera/player_unit_camera_extension")
require("scripts/extension_systems/camera/player_husk_camera_extension")

local CameraSystem = class("CameraSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_player_trigger_camera_shake"
}

CameraSystem.init = function (self, extension_system_creation_context, ...)
	CameraSystem.super.init(self, extension_system_creation_context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

CameraSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	CameraSystem.super.destroy(self)
end

CameraSystem.rpc_player_trigger_camera_shake = function (self, channel_id, unit_id, event_name_id)
	local event_name = NetworkLookup.camera_shake_events[event_name_id]
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local camera_extension = self._unit_to_extension_map[unit]

	camera_extension:trigger_camera_shake(event_name)
end

return CameraSystem
