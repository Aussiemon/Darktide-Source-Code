-- chunkname: @scripts/extension_systems/mission_objective_zone_scannable/mission_objective_zone_scannable_system.lua

require("scripts/extension_systems/mission_objective_zone_scannable/mission_objective_zone_scannable_extension")

local MissionObjectiveZoneScannableSystem = class("MissionObjectiveZoneScannableSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_mission_objective_zone_scannable_hot_join_sync",
	"rpc_mission_objective_zone_scannable_set_active",
}

MissionObjectiveZoneScannableSystem.init = function (self, context, system_init_data, ...)
	MissionObjectiveZoneScannableSystem.super.init(self, context, system_init_data, ...)

	local network_event_delegate = context.network_event_delegate

	self._network_event_delegate = network_event_delegate

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MissionObjectiveZoneScannableSystem.on_gameplay_post_init = function (self, level)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		extension:on_gameplay_post_init(level)
	end
end

MissionObjectiveZoneScannableSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	MissionObjectiveZoneScannableSystem.super.destroy(self)
end

MissionObjectiveZoneScannableSystem.rpc_mission_objective_zone_scannable_hot_join_sync = function (self, channel_id, level_unit_id, active)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	if active then
		extension:set_active(active)
	end
end

MissionObjectiveZoneScannableSystem.rpc_mission_objective_zone_scannable_set_active = function (self, channel_id, level_unit_id, active)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_active(active)
end

return MissionObjectiveZoneScannableSystem
