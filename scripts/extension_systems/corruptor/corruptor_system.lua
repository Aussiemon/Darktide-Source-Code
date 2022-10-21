require("scripts/extension_systems/corruptor/corruptor_extension")

local CorruptorSystem = class("CorruptorSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_set_corruptor_eye_active",
	"rpc_set_corruptor_eye_hidden"
}

CorruptorSystem.init = function (self, context, ...)
	CorruptorSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

CorruptorSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	CorruptorSystem.super.destroy(self)
end

CorruptorSystem.rpc_set_corruptor_eye_active = function (self, channel_id, level_unit_id, activated)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:set_eye_activated(activated)
end

CorruptorSystem.rpc_set_corruptor_eye_hidden = function (self, channel_id, level_unit_id, hidden)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:set_eye_hidden(hidden)
end

return CorruptorSystem
