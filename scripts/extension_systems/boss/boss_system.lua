require("scripts/extension_systems/boss/boss_extension")

local BossSystem = class("BossSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_start_boss_encounter"
}

BossSystem.init = function (self, context, ...)
	BossSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

BossSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	BossSystem.super.destroy(self)
end

BossSystem.rpc_start_boss_encounter = function (self, channel_id, unit_id)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local extension = self._unit_to_extension_map[unit]

	extension:start_boss_encounter()
end

return BossSystem
