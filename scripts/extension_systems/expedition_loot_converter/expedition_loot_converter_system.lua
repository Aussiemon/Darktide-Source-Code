-- chunkname: @scripts/extension_systems/expedition_loot_converter/expedition_loot_converter_system.lua

local ExpeditionLootConverterExtension = require("scripts/extension_systems/expedition_loot_converter/expedition_loot_converter_extension")
local ExpeditionLootConverterSystem = class("ExpeditionLootConverterSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_expedition_loot_converter_use",
	"rpc_expedition_loot_converter_hot_join",
	"rpc_expedition_loot_converter_despawn_loot_unit",
	"rpc_expedition_loot_converter_convertion_complete",
}

ExpeditionLootConverterSystem.init = function (self, context, system_init_data, ...)
	ExpeditionLootConverterSystem.super.init(self, context, system_init_data, ...)

	self._mission_settings_health_station = self:_fetch_settings(system_init_data.mission, context.circumstance_name)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionLootConverterSystem._fetch_settings = function (self, mission, circumstance_name)
	local original_settings = mission.health_station

	return original_settings
end

ExpeditionLootConverterSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

ExpeditionLootConverterSystem.update = function (self, context, dt, t, ...)
	ExpeditionLootConverterSystem.super.update(self, context, dt, t, ...)
end

ExpeditionLootConverterSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local unit_spawner_manager = Managers.state.unit_spawner
		local unit_level_id = unit_spawner_manager:level_index(unit)
		local can_interact = extension:can_interact()

		RPC.rpc_expedition_loot_converter_hot_join(channel, unit_level_id, can_interact)
	end
end

ExpeditionLootConverterSystem.rpc_expedition_loot_converter_use = function (self, channel_id, unit_level_id, pickup_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit = unit_spawner_manager:unit(unit_level_id, true)
	local loot_converter_extension = self._unit_to_extension_map[unit]
	local pickup_name = NetworkLookup.pickup_names[pickup_id]

	loot_converter_extension:begin_convertion(pickup_name)
end

ExpeditionLootConverterSystem.rpc_expedition_loot_converter_hot_join = function (self, channel_id, unit_level_id, can_interact)
	local unit_spawner_manager = Managers.state.unit_spawner
	local loot_converter_unit = unit_spawner_manager:unit(unit_level_id, true)
	local loot_converter_extension = self._unit_to_extension_map[loot_converter_unit]

	loot_converter_extension:hot_join_sync(can_interact)
end

ExpeditionLootConverterSystem.rpc_expedition_loot_converter_despawn_loot_unit = function (self, channel_id, unit_level_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local loot_converter_unit = unit_spawner_manager:unit(unit_level_id, true)
	local loot_converter_extension = self._unit_to_extension_map[loot_converter_unit]

	loot_converter_extension:despawn_loot_unit()
end

ExpeditionLootConverterSystem.rpc_expedition_loot_converter_convertion_complete = function (self, channel_id, unit_level_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local loot_converter_unit = unit_spawner_manager:unit(unit_level_id, true)
	local loot_converter_extension = self._unit_to_extension_map[loot_converter_unit]

	loot_converter_extension:convertion_completed()
end

return ExpeditionLootConverterSystem
