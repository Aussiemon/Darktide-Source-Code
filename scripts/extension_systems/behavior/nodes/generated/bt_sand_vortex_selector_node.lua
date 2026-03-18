-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_sand_vortex_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtSandVortexSelectorNode = class("BtSandVortexSelectorNode", "BtNode")

BtSandVortexSelectorNode.init = function (self, ...)
	BtSandVortexSelectorNode.super.init(self, ...)

	self._children = {}
end

BtSandVortexSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtSandVortexSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtSandVortexSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtSandVortexSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._children

	do
		local node_death = children[1]
		local death_component = blackboard.death
		local is_dead = death_component.is_dead
		local condition_result = is_dead

		if condition_result then
			new_running_child_nodes[node_identifier] = node_death

			return node_death
		end
	end

	do
		local node_vortex_wander = children[2]

		new_running_child_nodes[node_identifier] = node_vortex_wander

		return node_vortex_wander
	end

	local node_idle = children[3]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtSandVortexSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtSandVortexSelectorNode
