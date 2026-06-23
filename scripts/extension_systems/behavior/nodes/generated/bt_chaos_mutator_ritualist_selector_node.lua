-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_chaos_mutator_ritualist_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Profiler_start = Profiler.start
local Profiler_stop = Profiler.stop
local BtChaosMutatorRitualistSelectorNode = class("BtChaosMutatorRitualistSelectorNode", "BtNode")

BtChaosMutatorRitualistSelectorNode.init = function (self, ...)
	BtChaosMutatorRitualistSelectorNode.super.init(self, ...)

	self._selector_children = {}
end

BtChaosMutatorRitualistSelectorNode.add_child = function (self, node)
	BtChaosMutatorRitualistSelectorNode.super.add_child(self, node)

	if not node.tree_node.state then
		self._selector_children[#self._selector_children + 1] = node
	end
end

BtChaosMutatorRitualistSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._selector_children

	do
		local node_stagger = children[1]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0
		local condition_result = is_staggered

		if condition_result then
			new_running_child_nodes[node_identifier] = node_stagger

			return node_stagger
		end
	end

	local node_chanting = children[2]

	new_running_child_nodes[node_identifier] = node_chanting

	return node_chanting
end

BtChaosMutatorRitualistSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame, update_rate = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame, update_rate
end

return BtChaosMutatorRitualistSelectorNode
