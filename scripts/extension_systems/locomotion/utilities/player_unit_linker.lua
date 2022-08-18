local unit_alive = Unit.alive
local PlayerUnitLinker = class("PlayerUnitLinker")

PlayerUnitLinker.init = function (self, world, unit)
	self._unit = unit
	self._linked = false
	self._fake_linked = false
	self._parent_unit = nil
	self._parent_node = nil
	self._node = nil
	self._world = world
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local linker_component = unit_data_extension:write_component("player_unit_linker")
	linker_component.linked = false
	linker_component.parent_unit = nil
	linker_component.parent_node = "none"
	linker_component.node = "none"
	self._unit_data_extension = unit_data_extension
	self._linker_component = linker_component
end

PlayerUnitLinker.link = function (self, parent_unit, parent_node_name, node_name)
	local linker_component = self._linker_component
	linker_component.linked = true
	linker_component.parent_unit = parent_unit
	linker_component.parent_node = parent_node_name
	linker_component.node = node_name

	self:_link(parent_unit, parent_node_name, node_name)
end

PlayerUnitLinker.unlink = function (self)
	local linker_component = self._linker_component
	linker_component.linked = false
	linker_component.parent_unit = nil
	linker_component.parent_node = "none"
	linker_component.node = "none"

	self:_unlink()
end

PlayerUnitLinker._link = function (self, parent_unit, parent_node_name, node_name)
	local unlinked_parent_node = nil

	if unit_alive(parent_unit) then
		local parent_node = Unit.node(parent_unit, parent_node_name)
		local node = Unit.node(self._unit, node_name)
		unlinked_parent_node = Unit.scene_graph_parent(self._unit, node)

		World.link_unit(self._world, self._unit, node, parent_unit, parent_node, false, false)
	else
		self._fake_linked = true
	end

	self._linked = true
	self._linked_parent_unit = parent_unit
	self._linked_parent_node = parent_node_name
	self._linked_node = node_name
	self._unlinked_parent_node = unlinked_parent_node
end

PlayerUnitLinker._unlink = function (self)
	if not self._fake_linked then
		local linked_node = self._linked_node
		local node = Unit.node(self._unit, linked_node)

		World.unlink_unit(self._world, self._unit, false)
		Unit.scene_graph_link(self._unit, node, self._unlinked_parent_node)
	end

	self._linked = false
	self._fake_linked = false
	self._linked_parent_unit = nil
	self._linked_parent_node = nil
	self._linked_node = nil
	self._unlinked_parent_node = nil
end

PlayerUnitLinker.mispredict_happened = function (self)
	local linker_component = self._linker_component
	local is_linked_locally = self._linked
	local should_be_linked = linker_component.linked
	local parent_unit = linker_component.parent_unit
	local parent_node = linker_component.parent_node
	local node = linker_component.node

	if self._linked_parent_unit ~= parent_unit or self._linked_parent_node ~= parent_node or self._linked_node ~= node then
		if is_linked_locally then
			self:_unlink()
		end

		if should_be_linked then
			self:_link(parent_unit, parent_node, node)
		end
	end
end

return PlayerUnitLinker
