-- chunkname: @scripts/extension_systems/servo_skull/servo_skull_system.lua

require("scripts/extension_systems/servo_skull/servo_skull_extension")
require("scripts/extension_systems/servo_skull/servo_skull_activator_extension")

local ServoSkullSystem = class("ServoSkullSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_servo_skull_do_pulse_fx",
	"rpc_servo_skull_player_nearby",
	"rpc_servo_skull_activator_set_visibility",
	"rpc_servo_skull_set_scanning_active"
}

ServoSkullSystem.init = function (self, context, system_init_data, ...)
	ServoSkullSystem.super.init(self, context, system_init_data, ...)

	self._network_event_delegate = context.network_event_delegate

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ServoSkullSystem.on_gameplay_post_init = function (self, level)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.on_gameplay_post_init then
			extension:on_gameplay_post_init(level)
		end
	end
end

ServoSkullSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.hidden and extension:hidden() then
			local hidden = extension:hidden()
			local level_unit_id = Managers.state.unit_spawner:level_index(unit)

			RPC.rpc_servo_skull_activator_set_visibility(channel, level_unit_id, not hidden)
		end

		if extension.get_scanning_active and extension:get_scanning_active() then
			local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

			RPC.rpc_servo_skull_set_scanning_active(channel, game_object_id, true)
		end
	end
end

ServoSkullSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

ServoSkullSystem.rpc_servo_skull_do_pulse_fx = function (self, channel_id, game_object_id)
	local is_level_unit = false
	local unit = Managers.state.unit_spawner:unit(game_object_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:do_pulse_fx()
end

ServoSkullSystem.rpc_servo_skull_player_nearby = function (self, channel_id, game_object_id, player_nearby)
	local is_level_unit = false
	local unit = Managers.state.unit_spawner:unit(game_object_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:player_nearby(player_nearby)
end

ServoSkullSystem.rpc_servo_skull_activator_set_visibility = function (self, channel_id, level_unit_id, value)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_visibility(value)
end

ServoSkullSystem.rpc_servo_skull_set_scanning_active = function (self, channel_id, game_object_id, active)
	local is_level_unit = false
	local unit = Managers.state.unit_spawner:unit(game_object_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_scanning_active(active)
end

return ServoSkullSystem
