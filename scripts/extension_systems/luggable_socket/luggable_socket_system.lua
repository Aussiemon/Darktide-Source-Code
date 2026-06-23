-- chunkname: @scripts/extension_systems/luggable_socket/luggable_socket_system.lua

require("scripts/extension_systems/luggable_socket/luggable_socket_extension")

local LuggableSocketSystem = class("LuggableSocketSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_luggable_socket_luggable",
	"rpc_luggable_socket_unlock",
	"rpc_luggable_socket_set_visibility",
}

LuggableSocketSystem.init = function (self, extension_system_creation_context, ...)
	LuggableSocketSystem.super.init(self, extension_system_creation_context, ...)

	self._socket_units = {}

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self:_create_staggered_iterator("unlock_socket_iterator", function (extension, cumulative_dt)
		return extension:staggered_temp_locked_check(cumulative_dt)
	end)
end

LuggableSocketSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = LuggableSocketSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	self._socket_units[#self._socket_units + 1] = unit

	self:_register_staggered_item_update("unlock_socket_iterator", extension, 0.5)

	return extension
end

LuggableSocketSystem.on_remove_extension = function (self, unit, extension_name)
	table.remove(self._socket_units, table.find(self._socket_units, unit))
	self:_unregister_staggered_item_update("unlock_socket_iterator", self._unit_to_extension_map[unit])

	return LuggableSocketSystem.super.on_remove_extension(self, unit, extension_name)
end

LuggableSocketSystem.destroy = function (self, ...)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	LuggableSocketSystem.super.destroy(self, ...)
end

LuggableSocketSystem.hot_join_sync = function (self, sender, channel)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit_to_extension_map = self._unit_to_extension_map

	for socket_unit, extension in pairs(unit_to_extension_map) do
		local socket_is_level_unit, socket_id = unit_spawner_manager:game_object_id_or_level_index(socket_unit)
		local visible = extension:visible()

		if visible then
			RPC.rpc_luggable_socket_set_visibility(channel, socket_id, socket_is_level_unit, visible)
		end

		local socketed_unit = extension:socketed_unit()

		if socketed_unit then
			local socketed_is_level_unit, socketed_id = unit_spawner_manager:game_object_id_or_level_index(socketed_unit)

			RPC.rpc_luggable_socket_luggable(channel, socket_id, socket_is_level_unit, socketed_id, socketed_is_level_unit)
		end
	end
end

LuggableSocketSystem.socket_units = function (self)
	return self._socket_units
end

LuggableSocketSystem.rpc_luggable_socket_luggable = function (self, channel_id, socket_id, socket_is_level_unit, socketed_id, socketed_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local socketed_unit = unit_spawner_manager:unit(socketed_id, socketed_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:socket_luggable(socketed_unit)
end

LuggableSocketSystem.rpc_luggable_socket_unlock = function (self, channel_id, socket_id, socket_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:unlock_socket()
end

LuggableSocketSystem.rpc_luggable_socket_set_visibility = function (self, channel_id, socket_id, socket_is_level_unit, value)
	local unit_spawner_manager = Managers.state.unit_spawner
	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:set_socket_visibility(value)
end

return LuggableSocketSystem
