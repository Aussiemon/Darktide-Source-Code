-- chunkname: @scripts/extension_systems/prop_collision/prop_collision_extension.lua

local PropCollisionExtension = class("PropCollisionExtension")
local BROADPHASE_CATEGORIES = {
	"prop_collision",
}

PropCollisionExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._shape = nil
	self._broadphase_id = nil

	local broadphase_system = Managers.state.extension:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase
end

PropCollisionExtension.setup_from_component = function (self, shape, radius, polygon_nodes)
	self._shape = shape
	self._radius = radius
	self._polygon_nodes = polygon_nodes
	self._broadphase_id = Broadphase.add(self._broadphase, self._unit, POSITION_LOOKUP[self._unit], 4, BROADPHASE_CATEGORIES)
end

PropCollisionExtension.destroy = function (self)
	if self._broadphase_id then
		Broadphase.remove(self._broadphase, self._broadphase_id)

		self._broadphase_id = nil
	end
end

PropCollisionExtension.shape = function (self)
	return self._shape
end

PropCollisionExtension.radius = function (self)
	return self._radius
end

local NODE_POSITIONS = {}

PropCollisionExtension.polygon_nodes = function (self)
	table.clear(NODE_POSITIONS)

	local unit = self._unit
	local nodes = self._polygon_nodes

	for i = 1, #nodes do
		local target_node = Unit.node(unit, nodes[i])

		NODE_POSITIONS[#NODE_POSITIONS + 1] = Vector3.flat(Unit.world_position(unit, target_node))
	end

	return NODE_POSITIONS
end

PropCollisionExtension.set_position = function (self, position)
	Unit.set_local_position(self._unit, 1, position)
	self:update_position()
end

PropCollisionExtension.update_position = function (self)
	local position = Unit.local_position(self._unit, 1)

	Broadphase.move(self._broadphase, self._broadphase_id, position)
end

return PropCollisionExtension
