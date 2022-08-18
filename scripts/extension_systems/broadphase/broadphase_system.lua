require("scripts/extension_systems/broadphase/broadphase_extension")

local Pickups = require("scripts/settings/pickup/pickups")
local BroadphaseSystem = class("BroadphaseSystem", "ExtensionSystemBase")

local function _generate_broadphase_categories(system_init_data)
	local side_names = system_init_data.side_names
	local broadphase_categories = table.append({
		"doors",
		"pickups"
	}, side_names)
	local pickup_groups = Pickups.by_group

	for group_name, _ in pairs(pickup_groups) do
		broadphase_categories[#broadphase_categories + 1] = group_name
	end

	return broadphase_categories
end

local BROADPHASE_CELL_RADIUS = 50
local MAX_EXPECTED_ENTITIES = 512

BroadphaseSystem.init = function (self, extension_system_creation_context, system_init_data, ...)
	BroadphaseSystem.super.init(self, extension_system_creation_context, system_init_data, ...)

	local broadphase_categories = _generate_broadphase_categories(system_init_data)
	self.broadphase = Broadphase(BROADPHASE_CELL_RADIUS, MAX_EXPECTED_ENTITIES, broadphase_categories)
	self._extension_init_context.broadphase = self.broadphase
end

return BroadphaseSystem
