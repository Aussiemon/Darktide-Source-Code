-- chunkname: @scripts/extension_systems/trigger/trigger_system.lua

require("scripts/extension_systems/trigger/trigger_extension")

local TriggerSystem = class("TriggerSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_volume_trigger_activate_on_client",
	"rpc_volume_trigger_deactivate_on_client",
	"rpc_volume_trigger_unit_enter_on_client",
	"rpc_volume_trigger_unit_exit_on_client",
}

TriggerSystem.init = function (self, ...)
	TriggerSystem.super.init(self, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

TriggerSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	TriggerSystem.super.destroy(self)
end

TriggerSystem.rpc_volume_trigger_activate_on_client = function (self, channel_id, volume_unit_id, unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local unit = unit_spawner_manager:unit(unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_activate(unit)
end

TriggerSystem.rpc_volume_trigger_deactivate_on_client = function (self, channel_id, volume_unit_id, unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local unit = unit_spawner_manager:unit(unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_deactivate(unit)
end

TriggerSystem.rpc_volume_trigger_unit_enter_on_client = function (self, channel_id, volume_unit_id, enter_unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local entering_unit = unit_spawner_manager:unit(enter_unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_on_unit_enter(entering_unit)
end

TriggerSystem.rpc_volume_trigger_unit_exit_on_client = function (self, channel_id, volume_unit_id, exit_unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local exiting_unit = unit_spawner_manager:unit(exit_unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_on_unit_exit(exiting_unit)
end

return TriggerSystem
