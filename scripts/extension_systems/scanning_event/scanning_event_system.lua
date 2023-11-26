-- chunkname: @scripts/extension_systems/scanning_event/scanning_event_system.lua

require("scripts/extension_systems/scanning_event/scanning_device_extension")

local ScanningEventSystem = class("ScanningEventSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_scanning_device_hot_join",
	"rpc_scanning_device_finished"
}

ScanningEventSystem.init = function (self, context, system_init_data, ...)
	ScanningEventSystem.super.init(self, context, system_init_data, ...)

	self._level_name = context.level_name
	self._network_event_delegate = context.network_event_delegate

	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

ScanningEventSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local past_spline_start_position = extension:past_spline_start_position()
		local at_end_position = extension:at_end_position()
		local reached_end_of_spline = extension:reached_end_of_spline()
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)

		if level_unit_id then
			RPC.rpc_scanning_device_hot_join(channel, level_unit_id, past_spline_start_position, at_end_position, reached_end_of_spline)
		end
	end
end

ScanningEventSystem.get_scanning_device_units = function (self)
	return self._unit_to_extension_map
end

ScanningEventSystem.on_gameplay_post_init = function (self, level)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.on_gameplay_post_init then
			extension:on_gameplay_post_init(level)
		end
	end
end

ScanningEventSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	ScanningEventSystem.super.destroy(self)
end

ScanningEventSystem.rpc_scanning_device_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:finished_event()
end

ScanningEventSystem.rpc_scanning_device_hot_join = function (self, channel_id, unit_id, past_spline_start_position, at_end_position, reached_end_of_spline)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:hot_join_sync(past_spline_start_position, at_end_position, reached_end_of_spline)
end

return ScanningEventSystem
