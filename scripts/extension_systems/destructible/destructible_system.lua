﻿-- chunkname: @scripts/extension_systems/destructible/destructible_system.lua

require("scripts/extension_systems/destructible/destructible_extension")

local DestructibleSystem = class("DestructibleSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_destructible_damage_taken",
	"rpc_destructible_last_destruction",
	"rpc_sync_destructible",
	"rpc_destructible_mark_for_deletion",
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
		local is_level_unit, level_unit_id, level_hash = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

		if is_level_unit then
			self._removed_level_unit_ids[#self._removed_level_unit_ids + 1] = {
				unit_id = level_unit_id,
				level_hash = level_hash,
			}
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

DestructibleSystem.clear_unit_from_removed_level_list = function (self, unit_id)
	local removed_level_unit_ids = self._removed_level_unit_ids

	for i = #removed_level_unit_ids, 1, -1 do
		if removed_level_unit_ids[i].unit_id == unit_id and removed_level_unit_ids[i].level_hash ~= NetworkConstants.invalid_level_name_hash then
			table.remove(removed_level_unit_ids, i)

			break
		end
	end
end

DestructibleSystem.hot_join_sync = function (self, sender, channel)
	local removed_level_unit_ids = self._removed_level_unit_ids

	for ii = 1, #removed_level_unit_ids do
		local level_unit_id = removed_level_unit_ids[ii]

		RPC.rpc_destructible_mark_for_deletion(channel, level_unit_id.unit_id, level_unit_id.level_hash)
	end

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		extension:hot_join_sync(unit, sender)
	end
end

DestructibleSystem.rpc_destructible_damage_taken = function (self, channel_id, unit_id, is_level_unit, optional_level_name_hash)
	local invalid_id = is_level_unit and unit_id == NetworkConstants.invalid_level_unit_id or unit_id == NetworkConstants.invalid_game_object_id

	if not invalid_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit, optional_level_name_hash)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_destructible_damage_taken()
	end
end

DestructibleSystem.rpc_destructible_last_destruction = function (self, channel_id, unit_id, is_level_unit, optional_level_name_hash)
	local invalid_id = is_level_unit and unit_id == NetworkConstants.invalid_level_unit_id or unit_id == NetworkConstants.invalid_game_object_id

	if not invalid_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit, optional_level_name_hash)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_destructible_last_destruction()
	end
end

DestructibleSystem.rpc_sync_destructible = function (self, channel_id, unit_id, is_level_unit, current_stage, visible, from_hot_join_sync, optional_level_name_hash)
	local invalid_id = is_level_unit and unit_id == NetworkConstants.invalid_level_unit_id or unit_id == NetworkConstants.invalid_game_object_id

	if not invalid_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit, optional_level_name_hash)
		local extension = self._unit_to_extension_map[unit]

		extension:rpc_sync_destructible(current_stage, visible, from_hot_join_sync)
	end
end

DestructibleSystem.rpc_destructible_mark_for_deletion = function (self, channel_id, level_unit_id, optional_level_name_hash)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit, optional_level_name_hash)

	Managers.state.unit_spawner:mark_for_deletion(unit)
end

return DestructibleSystem
