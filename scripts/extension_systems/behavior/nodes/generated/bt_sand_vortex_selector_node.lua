-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_sand_vortex_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Profiler_start = Profiler.start
local Profiler_stop = Profiler.stop
local BtSandVortexSelectorNode = class("BtSandVortexSelectorNode", "BtNode")

BtSandVortexSelectorNode.init = function (self, ...)
	BtSandVortexSelectorNode.super.init(self, ...)

	self._selector_children = {}
end

BtSandVortexSelectorNode.add_child = function (self, node)
	BtSandVortexSelectorNode.super.add_child(self, node)

	if not node.tree_node.state then
		self._selector_children[#self._selector_children + 1] = node
	end
end

BtSandVortexSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._selector_children

	do
		local node_vortex_wander = children[1]

		new_running_child_nodes[node_identifier] = node_vortex_wander

		return node_vortex_wander
	end

	local node_idle = children[2]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtSandVortexSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame, update_rate = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame, update_rate
end

return BtSandVortexSelectorNode
