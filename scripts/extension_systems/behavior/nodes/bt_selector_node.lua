require("scripts/extension_systems/behavior/nodes/bt_node")

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local BtSelectorNode = class("BtSelectorNode", "BtNode")

BtSelectorNode.init = function (self, ...)
	BtSelectorNode.super.init(self, ...)

	self._children = {}
end

BtSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local CONDITIONS = BtConditions
	local leaf_node = nil
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_condition_name = child_node.condition_name
		local child_tree_node = child_node.tree_node
		local child_is_running = last_leaf_node_running and last_running_node == child_node

		if CONDITIONS[child_condition_name](unit, blackboard, scratchpad, child_tree_node.condition_args, child_tree_node.action_data, child_is_running) then
			if child_node.evaluate then
				leaf_node = child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
			else
				leaf_node = child_node
			end

			if leaf_node then
				new_running_child_nodes[node_identifier] = child_node

				return leaf_node
			end
		end
	end
end

BtSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtSelectorNode
