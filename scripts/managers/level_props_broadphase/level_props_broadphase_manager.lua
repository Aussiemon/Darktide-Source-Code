-- chunkname: @scripts/managers/level_props_broadphase/level_props_broadphase_manager.lua

local LevelPropsBroadphaseManager = class("LevelPropsBroadphaseManager")
local CHECK_INTERVAL = 3

LevelPropsBroadphaseManager.init = function (self)
	self._check_timer = 0
	self._extension_systems = {}
end

LevelPropsBroadphaseManager.destroy = function (self)
	table.clear(self._extension_systems)
end

LevelPropsBroadphaseManager.update = function (self, dt, t)
	if t > self._check_timer then
		for _, extension_system in ipairs(self._extension_systems) do
			if extension_system.update_level_props_broadphase then
				extension_system:update_level_props_broadphase()
			end
		end

		self._check_timer = self._check_timer + CHECK_INTERVAL
	end
end

LevelPropsBroadphaseManager.register_extension_system = function (self, extension_system)
	table.insert(self._extension_systems, extension_system)
end

LevelPropsBroadphaseManager.unregister_extension_system = function (self, extension_system)
	local index = table.find(self._extension_systems, extension_system)

	if index then
		table.swap_delete(self._extension_systems, index)
	end
end

return LevelPropsBroadphaseManager
