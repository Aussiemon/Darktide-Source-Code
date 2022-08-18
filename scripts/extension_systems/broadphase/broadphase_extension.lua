local BroadphaseExtension = class("BroadphaseExtension")
local unit_node = Unit.node
local unit_world_position = Unit.world_position
local broadphase_add = Broadphase.add
local broadphase_remove = Broadphase.remove
local broadphase_move = Broadphase.move

BroadphaseExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._broadphase = extension_init_context.broadphase
	self._broadphase_categories = extension_init_data.categories
	self._broadphase_radius = extension_init_data.radius
	self._broadphase_node_name = extension_init_data.node_name
	self._broadphase_node_id = nil
	self._broadphase_id = nil

	if self._broadphase_categories then
		self:_add_to_broadphase()
	end
end

BroadphaseExtension.destroy = function (self)
	self:_remove_from_broadphase()
end

BroadphaseExtension.setup_from_component = function (self, broadphase_category, broadphase_radius, broadphase_node_name)
	fassert(self._broadphase_categories == nil, "[BroadphaseExtension][Unit:%s] Component already registered.", Unit.id_string(self._unit))

	self._broadphase_categories = broadphase_category
	self._broadphase_radius = broadphase_radius
	self._broadphase_node_name = broadphase_node_name

	self:_add_to_broadphase()
end

BroadphaseExtension._add_to_broadphase = function (self)
	fassert(self._broadphase_categories, "[BroadphaseExtension][Unit:%s] Broadphase categories not set.", Unit.id_string(self._unit))

	local unit = self._unit
	local broadphase = self._broadphase
	local broadphase_radius = self._broadphase_radius
	local broadphase_categories = self._broadphase_categories
	local optional_node_name = self._broadphase_node_name
	local optional_node = optional_node_name and unit_node(unit, optional_node_name)
	local position = (optional_node and unit_world_position(unit, optional_node)) or POSITION_LOOKUP[unit]
	self._broadphase_id = broadphase_add(broadphase, unit, position, broadphase_radius, broadphase_categories)
	self._broadphase_node_id = optional_node
end

BroadphaseExtension._remove_from_broadphase = function (self)
	if self._broadphase_id then
		broadphase_remove(self._broadphase, self._broadphase_id)

		self._broadphase_id = nil
	end
end

BroadphaseExtension.update = function (self, unit, ...)
	local optional_node = self._broadphase_node_id
	local position = (optional_node and unit_world_position(unit, optional_node)) or POSITION_LOOKUP[unit]

	broadphase_move(self._broadphase, self._broadphase_id, position)
end

return BroadphaseExtension
