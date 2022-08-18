require("scripts/extension_systems/luggable_socket/luggable_socket_extension")

local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local LuggableSocketSystem = class("LuggableSocketSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_luggable_socket_hot_join",
	"rpc_luggable_socket_luggable",
	"rpc_luggable_socket_unlock",
	"rpc_luggable_socket_set_visibility"
}

LuggableSocketSystem.init = function (self, extension_system_creation_context, ...)
	LuggableSocketSystem.super.init(self, extension_system_creation_context, ...)

	self._socket_units = {}

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	Managers.state.level_props_broadphase:register_extension_system(self)
end

LuggableSocketSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = LuggableSocketSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	self._socket_units[#self._socket_units + 1] = unit

	return extension
end

LuggableSocketSystem.destroy = function (self, ...)
	Managers.state.level_props_broadphase:unregister_extension_system(self)

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
		local socketed_unit = extension:socketed_unit()

		if socketed_unit then
			local socketed_is_level_unit, socketed_id = unit_spawner_manager:game_object_id_or_level_index(socketed_unit)

			RPC.rpc_luggable_socket_hot_join(channel, socket_id, socket_is_level_unit, socketed_id, socketed_is_level_unit)
		else
			RPC.rpc_luggable_socket_hot_join(channel, socket_id, socket_is_level_unit, NetworkConstants.invalid_game_object_id, false)
		end
	end
end

LuggableSocketSystem.socket_units = function (self)
	return self._socket_units
end

LuggableSocketSystem.update_level_props_broadphase = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local units_nearby = LevelPropsBroadphase.check_units_nearby(POSITION_LOOKUP[unit])
		local in_update_list = self:has_update_function("LuggableSocketExtension", "update", unit)

		if units_nearby and not in_update_list then
			self:enable_update_function("LuggableSocketExtension", "update", unit, extension)
		elseif not units_nearby and in_update_list then
			self:disable_update_function("LuggableSocketExtension", "update", unit, extension)
		end
	end
end

LuggableSocketSystem.rpc_luggable_socket_hot_join = function (self, channel_id, socket_id, socket_is_level_unit, socketed_id, socketed_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner

	fassert(unit_spawner_manager:valid_unit_id(socket_id, socket_is_level_unit), "[LuggableSocketSystem] Incorrect socket_id")

	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local socketed_unit = nil

	if unit_spawner_manager:valid_unit_id(socketed_id, socketed_is_level_unit) then
		socketed_unit = unit_spawner_manager:unit(socketed_id, socketed_is_level_unit)
	end

	local extension = self._unit_to_extension_map[socket_unit]

	extension:hot_join_sync(socketed_unit)
end

LuggableSocketSystem.rpc_luggable_socket_luggable = function (self, channel_id, socket_id, socket_is_level_unit, socketed_id, socketed_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner

	fassert(unit_spawner_manager:valid_unit_id(socket_id, socket_is_level_unit), "[LuggableSocketSystem] Incorrect socket_id")
	fassert(unit_spawner_manager:valid_unit_id(socketed_id, socketed_is_level_unit), "[LuggableSocketSystem] Incorrect socketed_id")

	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local socketed_unit = unit_spawner_manager:unit(socketed_id, socketed_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:socket_luggable(socketed_unit)
end

LuggableSocketSystem.rpc_luggable_socket_unlock = function (self, channel_id, socket_id, socket_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner

	fassert(unit_spawner_manager:valid_unit_id(socket_id, socket_is_level_unit), "[LuggableSocketSystem] Incorrect socket_id")

	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:unlock_socket()
end

LuggableSocketSystem.rpc_luggable_socket_set_visibility = function (self, channel_id, socket_id, socket_is_level_unit, value)
	local unit_spawner_manager = Managers.state.unit_spawner

	fassert(unit_spawner_manager:valid_unit_id(socket_id, socket_is_level_unit), "[LuggableSocketSystem] Incorrect socket_id")

	local socket_unit = unit_spawner_manager:unit(socket_id, socket_is_level_unit)
	local extension = self._unit_to_extension_map[socket_unit]

	extension:set_socket_visibility(value)
end

return LuggableSocketSystem
