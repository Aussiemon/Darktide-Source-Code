-- chunkname: @scripts/extension_systems/behavior/nodes/bt_sequence_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local BtSequenceNode = class("BtSequenceNode", "BtNode")

BtSequenceNode.init = function (self, ...)
	BtSequenceNode.super.init(self, ...)

	self._children = {}
end

BtSequenceNode.init_values = function (self, blackboard, action_data, node_data)
	BtSequenceNode.super.init_values(self, blackboard, action_data, node_data)

	local node_identifier = self.identifier

	node_data[node_identifier] = 1

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtSequenceNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

local function _reset_child_to_run_index(node_data, node_identifier)
	node_data[node_identifier] = 1
end

BtSequenceNode.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data)
	local node_identifier = self.identifier

	_reset_child_to_run_index(node_data, node_identifier)
end

BtSequenceNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local child_to_run_index = node_data[node_identifier]
	local children = self._children
	local child_node = children[child_to_run_index]
	local child_condition_name = child_node.condition_name
	local child_tree_node = child_node.tree_node
	local last_running_node = old_running_child_nodes[node_identifier]
	local child_is_running = last_leaf_node_running and last_running_node == child_node
	local leaf_node

	if BtConditions[child_condition_name](unit, blackboard, scratchpad, child_tree_node.condition_args, child_tree_node.action_data, child_is_running) then
		if child_node.evaluate then
			leaf_node = child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
		else
			leaf_node = child_node
		end
	end

	if leaf_node then
		new_running_child_nodes[node_identifier] = child_node
	end

	return leaf_node
end

BtSequenceNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	if result == "running" then
		return "running", evaluate_utility_next_frame
	elseif result == "done" then
		local next_child_index = node_data[node_identifier] + 1

		if next_child_index > #self._children then
			_reset_child_to_run_index(node_data, node_identifier)

			return "done"
		else
			node_data[node_identifier] = next_child_index

			return "running"
		end
	else
		_reset_child_to_run_index(node_data, node_identifier)

		return "failed"
	end
end

return BtSequenceNode
