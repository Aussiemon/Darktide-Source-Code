-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_renegade_gunner_tg_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Profiler_start = Profiler.start
local Profiler_stop = Profiler.stop
local BtRenegadeGunnerTgSelectorNode = class("BtRenegadeGunnerTgSelectorNode", "BtNode")

BtRenegadeGunnerTgSelectorNode.init = function (self, ...)
	BtRenegadeGunnerTgSelectorNode.super.init(self, ...)

	self._selector_children = {}
end

BtRenegadeGunnerTgSelectorNode.add_child = function (self, node)
	BtRenegadeGunnerTgSelectorNode.super.add_child(self, node)

	if not node.tree_node.state then
		self._selector_children[#self._selector_children + 1] = node
	end
end

BtRenegadeGunnerTgSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._selector_children
	local node_shoot_spray_n_pray = children[1]

	new_running_child_nodes[node_identifier] = node_shoot_spray_n_pray

	return node_shoot_spray_n_pray
end

BtRenegadeGunnerTgSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame, update_rate = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame, update_rate
end

return BtRenegadeGunnerTgSelectorNode
