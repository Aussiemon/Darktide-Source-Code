-- chunkname: @scripts/extension_systems/moveable_platform/moveable_platform_system.lua

local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local NetworkLookup = require("scripts/network_lookup/network_lookup")

require("scripts/extension_systems/moveable_platform/moveable_platform_extension")

local MoveablePlatformSystem = class("MoveablePlatformSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_moveable_platform_set_direction",
	"rpc_moveable_platform_set_wall_collision",
	"rpc_moveable_platform_set_story"
}

MoveablePlatformSystem.init = function (self, context, ...)
	MoveablePlatformSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	Managers.state.level_props_broadphase:register_extension_system(self)
end

MoveablePlatformSystem.destroy = function (self)
	Managers.state.level_props_broadphase:unregister_extension_system(self)

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	MoveablePlatformSystem.super.destroy(self)
end

MoveablePlatformSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)
		local story_direction = extension:story_direction()
		local direction_id = NetworkLookup.moveable_platform_direction[story_direction]

		RPC.rpc_moveable_platform_set_direction(channel, level_unit_id, direction_id)

		local wall_active = extension:wall_active()

		RPC.rpc_moveable_platform_set_wall_collision(channel, level_unit_id, wall_active)

		if extension:should_sync_story_name() then
			local story_name = extension:get_story()

			RPC.rpc_moveable_platform_set_story(channel, level_unit_id, story_name)
		end
	end
end

MoveablePlatformSystem.rpc_moveable_platform_set_direction = function (self, channel_id, level_unit_id, direction_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local direction = NetworkLookup.moveable_platform_direction[direction_id]

	extension:set_direction_husk(direction)
end

MoveablePlatformSystem.rpc_moveable_platform_set_wall_collision = function (self, channel_id, level_unit_id, active)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_wall_collision(active)
end

MoveablePlatformSystem.rpc_moveable_platform_set_story = function (self, channel_id, level_unit_id, story_name)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_story(story_name)
end

MoveablePlatformSystem.update_level_props_broadphase = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local units_nearby = LevelPropsBroadphase.check_units_nearby(Unit.world_position(unit, 1), nil, extension:player_side())
		local in_update_list = self:has_update_function("MoveablePlatformExtension", "update", unit)

		if units_nearby and not in_update_list then
			self:enable_update_function("MoveablePlatformExtension", "update", unit, extension)
			self:enable_update_function("MoveablePlatformExtension", "fixed_update", unit, extension)
		elseif not units_nearby and in_update_list then
			self:disable_update_function("MoveablePlatformExtension", "update", unit, extension)
			self:disable_update_function("MoveablePlatformExtension", "fixed_update", unit, extension)
		end
	end
end

MoveablePlatformSystem.units_are_locked = function (self)
	local unit_to_extension_map = self._unit_to_extension_map

	for _, extension in pairs(unit_to_extension_map) do
		if extension:units_locked() then
			return true
		end
	end

	return false
end

return MoveablePlatformSystem
