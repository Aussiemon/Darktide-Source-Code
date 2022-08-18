require("scripts/extension_systems/trigger/trigger_extension")

local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local TriggerSystem = class("TriggerSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_volume_trigger_activate_on_client",
	"rpc_volume_trigger_deactivate_on_client",
	"rpc_volume_trigger_unit_enter_on_client",
	"rpc_volume_trigger_unit_exit_on_client"
}

TriggerSystem.init = function (self, ...)
	TriggerSystem.super.init(self, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	Managers.state.level_props_broadphase:register_extension_system(self)
end

TriggerSystem.destroy = function (self)
	Managers.state.level_props_broadphase:unregister_extension_system(self)

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	TriggerSystem.super.destroy(self)
end

TriggerSystem.update_level_props_broadphase = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local units_nearby = LevelPropsBroadphase.check_units_nearby(POSITION_LOOKUP[unit])
		local in_update_list = self:has_update_function("TriggerExtension", "update", unit)

		if units_nearby and not in_update_list then
			self:enable_update_function("TriggerExtension", "update", unit, extension)
		elseif not units_nearby and in_update_list then
			self:disable_update_function("TriggerExtension", "update", unit, extension)
		end
	end
end

TriggerSystem.rpc_volume_trigger_activate_on_client = function (self, channel_id, volume_unit_id, unit_id, component_guid)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local unit = unit_spawner_manager:unit(unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_activate(component_guid, unit)
end

TriggerSystem.rpc_volume_trigger_deactivate_on_client = function (self, channel_id, volume_unit_id, unit_id, component_guid)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local unit = unit_spawner_manager:unit(unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_deactivate(component_guid, unit)
end

TriggerSystem.rpc_volume_trigger_unit_enter_on_client = function (self, channel_id, volume_unit_id, enter_unit_id, component_guid)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local entering_unit = unit_spawner_manager:unit(enter_unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_on_unit_enter(component_guid, entering_unit)
end

TriggerSystem.rpc_volume_trigger_unit_exit_on_client = function (self, channel_id, volume_unit_id, exit_unit_id, component_guid)
	local unit_spawner_manager = Managers.state.unit_spawner
	local volume_unit = unit_spawner_manager:unit(volume_unit_id, true)
	local exiting_unit = unit_spawner_manager:unit(exit_unit_id)
	local trigger_extension = self._unit_to_extension_map[volume_unit]

	trigger_extension:local_action_on_unit_exit(component_guid, exiting_unit)
end

return TriggerSystem
