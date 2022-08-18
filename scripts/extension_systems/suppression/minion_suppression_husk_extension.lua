local MinionSuppressionHuskExtension = class("MinionSuppressionHuskExtension")
local CLIENT_RPCS = {
	"rpc_server_reported_unit_suppression"
}

MinionSuppressionHuskExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local is_server = extension_init_context.is_server

	assert(not is_server, "suppression husk extension should not exist on the server")

	self._unit = unit
	self._breed = extension_init_data.breed
	local network_event_delegate = extension_init_context.network_event_delegate
	self._network_event_delegate = network_event_delegate
	self._game_object_id = game_object_id

	network_event_delegate:register_session_unit_events(self, game_object_id, unpack(CLIENT_RPCS))

	self._unit_rpcs_registered = true
	self._is_suppressed = false
end

MinionSuppressionHuskExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))
end

MinionSuppressionHuskExtension.handle_unit_suppression = function (self, is_suppressed)
	local unit = self._unit

	Managers.event:trigger("event_unit_suppression", unit, is_suppressed)

	self._is_suppressed = is_suppressed
end

MinionSuppressionHuskExtension.is_suppressed = function (self)
	return self._is_suppressed
end

MinionSuppressionHuskExtension.rpc_server_reported_unit_suppression = function (self, channel_id, suppressed_unit_id, is_suppressed)
	self:handle_unit_suppression(is_suppressed)
end

return MinionSuppressionHuskExtension
