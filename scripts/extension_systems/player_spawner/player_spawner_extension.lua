-- chunkname: @scripts/extension_systems/player_spawner/player_spawner_extension.lua

local PlayerSpawnerExtension = class("PlayerSpawnerExtension")

PlayerSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._active = false
	self._player_spawner_system = extension_init_context.owner_system
end

PlayerSpawnerExtension.activate_spawner = function (self, ...)
	if not self._active then
		self._player_spawner_system:add_spawn_point(...)

		self._active = true
	end
end

PlayerSpawnerExtension.deactivate_spawner = function (self, ...)
	if self._active then
		self._player_spawner_system:remove_spawn_point(...)

		self._active = false
	end
end

return PlayerSpawnerExtension
