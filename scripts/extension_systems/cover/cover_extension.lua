-- chunkname: @scripts/extension_systems/cover/cover_extension.lua

local CoverSlots = require("scripts/extension_systems/cover/utilities/cover_slots")
local CoverExtension = class("CoverExtension")

CoverExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._physics_world = extension_init_context.physics_world
	self._nav_world = extension_init_context.nav_world
	self._unit = unit
	self._node_positions = CoverSlots.fetch_node_positions(unit)
	self._cover_type = "high"
	self._cover_slots = {}
	self._enabled = true
end

CoverExtension.setup_from_component = function (self, cover_type, enabled)
	self._cover_type = cover_type
	self._enabled = enabled

	if enabled then
		local unit = self._unit
		local physics_world = self._physics_world
		local nav_world = self._nav_world
		local node_positions = self._node_positions
		local cover_slots = CoverSlots.create(physics_world, nav_world, unit, cover_type, node_positions)

		self._cover_slots = cover_slots

		local cover_system = Managers.state.extension:system("cover_system")

		for i = 1, #cover_slots do
			local cover_slot = cover_slots[i]

			cover_system:add_cover_slot_to_broadphase(unit, cover_slot)
		end
	end
end

CoverExtension.cover_type = function (self)
	return self._cover_type
end

CoverExtension.enabled = function (self)
	return self._enabled
end

return CoverExtension
