-- chunkname: @scripts/extension_systems/interaction/interactor_system.lua

require("scripts/extension_systems/interaction/interactor_extension")

local InteractorSystem = class("InteractorSystem", "ExtensionSystemBase")

InteractorSystem.reset = function (self)
	for unit, extension in pairs(self._unit_to_extension_map) do
		extension:reset_interaction()
	end
end

return InteractorSystem
