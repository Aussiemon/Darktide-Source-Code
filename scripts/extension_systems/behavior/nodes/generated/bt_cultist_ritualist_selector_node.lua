-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_cultist_ritualist_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtCultistRitualistSelectorNode = class("BtCultistRitualistSelectorNode", "BtNode")

BtCultistRitualistSelectorNode.init = function (self, ...)
	BtCultistRitualistSelectorNode.super.init(self, ...)

	self._children = {}
end

BtCultistRitualistSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtCultistRitualistSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtCultistRitualistSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtCultistRitualistSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
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
		local node_stagger = children[2]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0
		local condition_result = is_staggered

		if condition_result then
			new_running_child_nodes[node_identifier] = node_stagger

			return node_stagger
		end
	end

	local node_chanting = children[3]

	new_running_child_nodes[node_identifier] = node_chanting

	return node_chanting
end

BtCultistRitualistSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtCultistRitualistSelectorNode
