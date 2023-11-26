-- chunkname: @scripts/extension_systems/specialization/specialization_system.lua

require("scripts/extension_systems/specialization/player_unit_specialization_extension")
require("scripts/extension_systems/specialization/player_husk_specialization_extension")

local SpecializationSystem = class("SpecializationSystem", "ExtensionSystemBase")

SpecializationSystem.init = function (self, ...)
	SpecializationSystem.super.init(self, ...)
end

SpecializationSystem.destroy = function (self)
	SpecializationSystem.super.destroy(self)
end

SpecializationSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = SpecializationSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	return extension
end

return SpecializationSystem
