require("scripts/extension_systems/destructible/destructible_extension")

local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local DestructibleSystem = class("DestructibleSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_destructible_damage_taken",
	"rpc_destructible_last_destruction",
	"rpc_sync_destructible",
	"rpc_destructible_mark_for_deletion"
}

DestructibleSystem.init = function (self, extension_system_creation_context, ...)
	DestructibleSystem.super.init(self, extension_system_creation_context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	else
		self._removed_level_unit_ids = {}
	end

	Managers.state.level_props_broadphase:register_extension_system(self)
end

DestructibleSystem.on_remove_extension = function (self, unit, extension_name)
	if self._is_server then
		local is_level_unit, level_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

		if is_level_unit then
			self._removed_level_unit_ids[#self._removed_level_unit_ids + 1] = level_unit_id
		end
	end

	DestructibleSystem.super.on_remove_extension(self, unit, extension_name)
end

DestructibleSystem.destroy = function (self, ...)
	Managers.state.level_props_broadphase:unregister_extension_system(self)

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	DestructibleSystem.super.destroy(self, ...)
end

DestructibleSystem.hot_join_sync = function (self, sender, channel)
	local removed_level_unit_ids = self._removed_level_unit_ids

	for ii = 1, #removed_level_unit_ids do
		local level_unit_id = removed_level_unit_ids[ii]

		RPC.rpc_destructible_mark_for_deletion(channel, level_unit_id)
	end

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		extension:hot_join_sync(unit, sender)
	end
end

DestructibleSystem.update_level_props_broadphase = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local broadphase_radius = extension:broadphase_radius()
		local units_nearby = LevelPropsBroadphase.check_units_nearby(POSITION_LOOKUP[unit], broadphase_radius)
		local in_update_list = self:has_update_function("DestructibleExtension", "update", unit)

		if units_nearby and not in_update_list then
			self:enable_update_function("DestructibleExtension", "update", unit, extension)
		elseif not units_nearby and in_update_list then
			self:disable_update_function("DestructibleExtension", "update", unit, extension)
		end
	end
end

DestructibleSystem.rpc_destructible_damage_taken = function (self, channel_id, unit_id, is_level_unit)
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_destructible_damage_taken()
	end
end

DestructibleSystem.rpc_destructible_last_destruction = function (self, channel_id, unit_id, is_level_unit)
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_destructible_last_destruction()
	end
end

DestructibleSystem.rpc_sync_destructible = function (self, channel_id, unit_id, is_level_unit, current_stage, visible, from_hot_join_sync)
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_sync_destructible(current_stage, visible, from_hot_join_sync)
	end
end

DestructibleSystem.rpc_destructible_mark_for_deletion = function (self, channel_id, level_unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

	Managers.state.unit_spawner:mark_for_deletion(unit)
end

return DestructibleSystem
