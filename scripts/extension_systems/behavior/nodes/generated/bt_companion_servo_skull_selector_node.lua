-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_companion_servo_skull_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Profiler_start = Profiler.start
local Profiler_stop = Profiler.stop
local BtCompanionServoSkullSelectorNode = class("BtCompanionServoSkullSelectorNode", "BtNode")

BtCompanionServoSkullSelectorNode.init = function (self, ...)
	BtCompanionServoSkullSelectorNode.super.init(self, ...)

	self._selector_children = {}
end

BtCompanionServoSkullSelectorNode.add_child = function (self, node)
	BtCompanionServoSkullSelectorNode.super.add_child(self, node)

	if not node.tree_node.state then
		self._selector_children[#self._selector_children + 1] = node
	end
end

BtCompanionServoSkullSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._selector_children

	do
		local node_ABILITIES = children[1]
		local leaf_node = node_ABILITIES:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_ABILITIES

			return leaf_node
		end
	end

	do
		local node_shoots = children[2]
		local is_running = last_leaf_node_running and last_running_node == node_shoots
		local sub_condition_result_01

		do
			local condition_result

			repeat
				local perception_component = blackboard.perception

				if not is_running and perception_component.lock_target then
					condition_result = false

					break
				end

				local target_unit = perception_component.target_unit

				condition_result = HEALTH_ALIVE[target_unit]
			until true

			sub_condition_result_01 = condition_result
		end

		local has_target_unit = sub_condition_result_01
		local can_shoot = blackboard.behavior.can_shoot
		local condition_result = can_shoot and has_target_unit

		if condition_result then
			local leaf_node = node_shoots:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_shoots

				return leaf_node
			end
		end
	end

	local node_idle = children[3]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtCompanionServoSkullSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame, update_rate = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame, update_rate
end

return BtCompanionServoSkullSelectorNode
