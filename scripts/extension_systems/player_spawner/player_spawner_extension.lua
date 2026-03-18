-- chunkname: @scripts/extension_systems/player_spawner/player_spawner_extension.lua

local PlayerSpawnerExtension = class("PlayerSpawnerExtension")

PlayerSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._active = false
	self._identifier = nil
	self._unit = unit
	self._player_spawner_system = extension_init_context.owner_system
end

PlayerSpawnerExtension.destroy = function (self)
	self:deactivate_spawner(self._unit, self._identifier)
end

PlayerSpawnerExtension.activate_spawner = function (self, unit, player_side, identifier, ...)
	if not self._active then
		self._player_spawner_system:add_spawn_point(unit, player_side, identifier, ...)

		self._active = true
		self._identifier = identifier
	end
end

PlayerSpawnerExtension.deactivate_spawner = function (self, ...)
	if self._active then
		self._player_spawner_system:remove_spawn_point(...)

		self._active = false
	end
end

return PlayerSpawnerExtension
