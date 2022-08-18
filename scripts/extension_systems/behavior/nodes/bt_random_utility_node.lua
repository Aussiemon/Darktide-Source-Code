require("scripts/extension_systems/behavior/nodes/bt_node")

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local Utility = require("scripts/extension_systems/behavior/utilities/utility")
local BtRandomUtilityNode = class("BtRandomUtilityNode", "BtNode")

BtRandomUtilityNode.init = function (self, ...)
	BtRandomUtilityNode.super.init(self, ...)

	self._children = {}
	self._action_list = {}
	local tree_node = self.tree_node
	self._fallback_node_name = tree_node.fallback_node
	self._fail_cooldown_duration = tree_node.fail_cooldown or 0
end

BtRandomUtilityNode.init_values = function (self, blackboard, action_data, node_data)
	BtRandomUtilityNode.super.init_values(self, blackboard, action_data, node_data)

	local node_identifier = self.identifier

	fassert(node_data[node_identifier] == nil, "[BtRandomUtilityNode] Node data for %q was already created.", node_identifier)

	local children = self._children
	local num_children = table.size(children)
	local utility_node_data = Script.new_map(num_children)
	node_data[node_identifier] = {
		fail_cooldown_t = 0,
		utility_node_data = utility_node_data
	}

	for identifier, node in pairs(children) do
		local tree_node = node.tree_node
		local child_action_data = tree_node.action_data

		node:init_values(blackboard, child_action_data, node_data)

		utility_node_data[identifier] = {
			last_time = -math.huge,
			last_done_time = -math.huge
		}
	end
end

BtRandomUtilityNode.ready = function (self, lua_node)
	local action_list = self._action_list
	local children = self._children

	for name, child_node in pairs(children) do
		local action_data = child_node.tree_node.action_data
		action_list[#action_list + 1] = action_data
	end
end

BtRandomUtilityNode.add_child = function (self, node)
	self._children[node.identifier] = node
end

local function _swap(t, i, j)
	local temp = t[i]
	t[i] = t[j]
	t[j] = temp
end

local function _randomize_actions(unit, actions, blackboard, scratchpad, t, utility_node_data, node_children, fallback_node_name, last_running_child_node, last_leaf_node_running)
	local CONDITIONS = BtConditions
	local get_action_utility = Utility.get_action_utility
	local fallback_node = nil
	local total_utility_score = 0
	local num_actions = #actions

	for i = 1, num_actions, 1 do
		local action = actions[i]
		local action_name = action.name
		local node = node_children[action_name]
		local condition_name = node.condition_name
		local tree_node = node.tree_node
		local is_running = last_leaf_node_running and last_running_child_node == node
		local score = 0

		if CONDITIONS[condition_name](unit, blackboard, scratchpad, tree_node.condition_args, tree_node.action_data, is_running) then
			local utility_data = utility_node_data[action_name]
			score = get_action_utility(action, blackboard, t, utility_data)

			if action_name == fallback_node_name then
				fallback_node = node
			end
		end

		action.utility_score = score
		total_utility_score = total_utility_score + score
	end

	for i = 1, num_actions, 1 do
		local picked_index = nil
		local random_utility_score = math.random() * total_utility_score

		for j = i, num_actions, 1 do
			local action = actions[j]
			local action_utility_score = action.utility_score

			if random_utility_score < action_utility_score then
				picked_index = j

				break
			end

			random_utility_score = random_utility_score - action_utility_score
		end

		if not picked_index then
			num_actions = i - 1

			return num_actions, fallback_node
		end

		local picked_action = actions[picked_index]
		total_utility_score = total_utility_score - picked_action.utility_score

		if picked_index ~= i then
			_swap(actions, picked_index, i)
		end
	end

	return num_actions, fallback_node
end

local CHILD_IS_RUNNING = true

BtRandomUtilityNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local data = node_data[node_identifier]

	if t < data.fail_cooldown_t then
		return nil
	end

	local CONDITIONS = BtConditions
	local leaf_node = nil
	local running_child_node = old_running_child_nodes[node_identifier]
	local running_child_condition_name = running_child_node and running_child_node.condition_name
	local running_child_tree_node = running_child_node and running_child_node.tree_node
	local running_child_condition_args = running_child_tree_node and running_child_tree_node.condition_args
	local running_child_action_data = running_child_tree_node and running_child_tree_node.action_data

	if not evaluate_utility and running_child_node and CONDITIONS[running_child_condition_name](unit, blackboard, scratchpad, running_child_condition_args, running_child_action_data, CHILD_IS_RUNNING) then
		if running_child_node.evaluate then
			leaf_node = running_child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
		else
			leaf_node = running_child_node
		end

		if leaf_node then
			new_running_child_nodes[node_identifier] = running_child_node

			return leaf_node
		end
	end

	local actions = self._action_list
	local node_children = self._children
	local utility_node_data = data.utility_node_data
	local fallback_node_name = self._fallback_node_name
	local num_actions, fallback_node = _randomize_actions(unit, actions, blackboard, scratchpad, t, utility_node_data, node_children, fallback_node_name, running_child_node, last_leaf_node_running)

	for i = 1, num_actions, 1 do
		local action = actions[i]
		local action_name = action.name
		local child_node = node_children[action_name]
		local utility_data = utility_node_data[action_name]
		utility_data.last_time = t

		if child_node.evaluate then
			leaf_node = child_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
		else
			leaf_node = child_node
		end

		if leaf_node then
			new_running_child_nodes[node_identifier] = child_node

			return leaf_node
		elseif action_name == fallback_node_name then
			fallback_node = nil
		end
	end

	if fallback_node then
		if fallback_node.evaluate then
			leaf_node = fallback_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
		else
			leaf_node = fallback_node
		end

		if leaf_node then
			new_running_child_nodes[node_identifier] = fallback_node

			return leaf_node
		end
	end

	local fail_cooldown_duration = self._fail_cooldown_duration
	data.fail_cooldown_t = t + fail_cooldown_duration

	return nil
end

BtRandomUtilityNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_node_id = running_node.identifier
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	if result == "done" then
		local data = node_data[node_identifier]
		local utility_node_data = data.utility_node_data
		local utility_data = utility_node_data[running_node_id]
		utility_data.last_done_time = t
	end

	return result, evaluate_utility_next_frame
end

return BtRandomUtilityNode
