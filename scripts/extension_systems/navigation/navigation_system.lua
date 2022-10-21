require("scripts/extension_systems/navigation/bot_navigation_extension")
require("scripts/extension_systems/navigation/minion_navigation_extension")

local NavigationSystem = class("NavigationSystem", "ExtensionSystemBase")

NavigationSystem.init = function (self, ...)
	NavigationSystem.super.init(self, ...)

	self._enabled_units = {}
end

NavigationSystem.register_extension_update = function (self, unit, extension_name, extension)
	NavigationSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension.register_extension_update then
		extension:register_extension_update(unit)
	end
end

NavigationSystem.on_remove_extension = function (self, unit, extension_name)
	self._enabled_units[unit] = nil

	NavigationSystem.super.on_remove_extension(self, unit, extension_name)
end

NavigationSystem.set_enabled_unit = function (self, unit, enabled)
	local extension = self._unit_to_extension_map[unit]
	self._enabled_units[unit] = enabled and extension or nil
end

NavigationSystem.update = function (self, context, dt, t)
	GwNavWorld.join_async_update(self._nav_world)

	local enabled_units = self._enabled_units

	for unit, extension in pairs(enabled_units) do
		extension:update(unit, t)
	end
end

NavigationSystem.post_update = function (self, context, dt, t)
	self:_update_position()
end

NavigationSystem._update_position = function (self)
	local enabled_units = self._enabled_units

	for unit, extension in pairs(enabled_units) do
		extension:update_position(unit)
	end
end

return NavigationSystem
