-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_companion_dog_hub_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtCompanionDogHubSelectorNode = class("BtCompanionDogHubSelectorNode", "BtNode")

BtCompanionDogHubSelectorNode.init = function (self, ...)
	BtCompanionDogHubSelectorNode.super.init(self, ...)

	self._children = {}
end

BtCompanionDogHubSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtCompanionDogHubSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtCompanionDogHubSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtCompanionDogHubSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._children

	do
		local node_manual_teleport = children[1]
		local teleport_component = blackboard.teleport
		local condition_result = teleport_component.has_teleport_position

		if condition_result then
			new_running_child_nodes[node_identifier] = node_manual_teleport

			return node_manual_teleport
		end
	end

	do
		local node_hub_interaction_with_player_selector = children[2]
		local hub_interaction_component = blackboard.hub_interaction_with_player
		local condition_result = hub_interaction_component.has_owner_started_interaction

		if condition_result then
			local leaf_node = node_hub_interaction_with_player_selector:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_hub_interaction_with_player_selector

				return leaf_node
			end
		end
	end

	do
		local node_follow = children[3]
		local tree_node = node_follow.tree_node
		local action_data = tree_node.action_data
		local behavior_component = blackboard.behavior
		local owner_unit = behavior_component.owner_unit
		local owner_position = POSITION_LOOKUP[owner_unit]
		local current_state = behavior_component.current_state
		local outer_circle_distance = action_data.idle_circle_distances.outer_circle_distance
		local inner_circle_distance = action_data.idle_circle_distances.inner_circle_distance
		local companion_position = POSITION_LOOKUP[unit]
		local companion_owner_vector = Vector3.flat(companion_position - owner_position)
		local distance_from_owner = Vector3.length(companion_owner_vector)
		local sub_condition_result_01

		do
			local behavior_component = blackboard.behavior
			local owner_unit = behavior_component.owner_unit
			local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
			local owner_speed = Vector3.length(Vector3.flat(owner_locomotion_extension:current_velocity()))
			local condition_result = owner_speed > 0.05

			sub_condition_result_01 = condition_result
		end

		local is_owner_moving = sub_condition_result_01
		local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
		local owner_speed_normalized = Vector3.normalize(Vector3.flat(owner_locomotion_extension:current_velocity()))
		local companion_owner_vector_normalized = Vector3.normalize(companion_owner_vector)
		local cos = Vector3.dot(companion_owner_vector_normalized, owner_speed_normalized)
		local far_distance = action_data.far_distance
		local cone_cos = action_data.cone_angle and math.cos(action_data.cone_angle * 0.5) or math.huge
		local far_distance_check = not far_distance or far_distance < distance_from_owner or cos < cone_cos
		local condition_result = is_owner_moving and (current_state == "follow" or outer_circle_distance < distance_from_owner and far_distance_check)

		if condition_result then
			local leaf_node = node_follow:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_follow

				return leaf_node
			end
		end
	end

	local node_rest = children[4]
	local leaf_node = node_rest:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

	if leaf_node then
		new_running_child_nodes[node_identifier] = node_rest

		return leaf_node
	end
end

BtCompanionDogHubSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtCompanionDogHubSelectorNode
