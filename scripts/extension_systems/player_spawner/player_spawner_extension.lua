-- chunkname: @scripts/extension_systems/player_spawner/player_spawner_extension.lua

local PlayerSpawnerExtension = class("PlayerSpawnerExtension")

PlayerSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._player_side = "heroes"
	self._spawn_identifier = "default"
	self._spawn_priority = 1
	self._player_spawner_system = extension_init_context.owner_system
end

PlayerSpawnerExtension.setup_from_component = function (self, unit, player_side, spawn_identifier, spawn_priority)
	self._player_side = player_side
	self._spawn_identifier = spawn_identifier
	self._spawn_priority = spawn_priority

	self._player_spawner_system:add_spawn_point(unit, player_side, spawn_identifier, spawn_priority)
end

return PlayerSpawnerExtension
