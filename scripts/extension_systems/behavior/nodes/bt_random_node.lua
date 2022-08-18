require("scripts/extension_systems/behavior/nodes/bt_node")

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local LoadedDice = require("scripts/utilities/loaded_dice")
local BtRandomNode = class("BtRandomNode", "BtNode")

BtRandomNode.init = function (self, ...)
	BtRandomNode.super.init(self, ...)

	self._children = {}
end

BtRandomNode.init_values = function (self, blackboard, action_data, node_data)
	BtRandomNode.super.init_values(self, blackboard, action_data, node_data)

	local node_identifier = self.identifier

	fassert(node_data[node_identifier] == nil, "[BtRandomNode] Node data for %q was already created.", node_identifier)

	node_data[node_identifier] = true
	local children = self._children

	for i = 1, #children, 1 do
		local child = children[i]
		local child_tree_node = child.tree_node
		local child_action_data = child_tree_node.action_data

		child:init_values(blackboard, child_action_data, node_data)
	end
end

BtRandomNode.ready = function (self, lua_node)
	local children = self._children
	local num_children = #children
	local probabilities = Script.new_array(num_children)

	for i = 1, num_children, 1 do
		local child = children[i]
		local action_data = child.tree_node.action_data
		probabilities[i] = action_data.random_weight
	end

	self._probabilities, self._alias = LoadedDice.create(probabilities, false)
end

BtRandomNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtRandomNode.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data)
	local node_identifier = self.identifier
	node_data[node_identifier] = true
end

BtRandomNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local CONDITIONS = BtConditions
	local leaf_node = nil
	local node_identifier = self.identifier
	local should_reroll = node_data[node_identifier]
	local child_is_running = not should_reroll

	if should_reroll then
		local start_index = LoadedDice.roll(self._probabilities, self._alias)
		local children = self._children
		local num_children = #children

		for i = 1, num_children, 1 do
			local child_index = ((start_index + i) - 2) % num_children + 1
			local child_node = children[child_index]
			local child_condition_name = child_node.condition_name
			local child_tree_node = child_node.tree_node

			if CONDITIONS[child_condition_name](unit, blackboard, scratchpad, child_tree_node.condition_args, child_tree_node.action_data, child_is_running) then
				if child_node.evaluate then
					leaf_node = child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
				else
					leaf_node = child_node
				end

				if leaf_node then
					new_running_child_nodes[node_identifier] = child_node
					node_data[node_identifier] = false

					return leaf_node
				end
			end
		end

		return nil
	else
		local child_node = old_running_child_nodes[node_identifier]
		local child_condition_name = child_node.condition_name
		local child_tree_node = child_node.tree_node

		if CONDITIONS[child_condition_name](unit, blackboard, scratchpad, child_tree_node.condition_args, child_tree_node.action_data, child_is_running) then
			if child_node.evaluate then
				leaf_node = child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
			else
				leaf_node = child_node
			end

			if leaf_node then
				new_running_child_nodes[node_identifier] = child_node
			end
		end

		return leaf_node
	end
end

BtRandomNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	if result ~= "running" then
		node_data[node_identifier] = true
	end

	return result, evaluate_utility_next_frame
end

return BtRandomNode
