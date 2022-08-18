local AiBrain = class("AiBrain")

AiBrain.init = function (self, unit, breed, blackboard, behavior_tree)
	self._unit = unit
	self._breed = breed
	self._blackboard = blackboard
	self._node_data = {}
	self._scratchpad = {}
	self._running_child_nodes = {}
	self._old_running_child_nodes = {}

	self:set_behavior_tree(behavior_tree)
end

AiBrain.destroy = function (self, t)
	if not Network.game_session() then
		return
	end

	self:shutdown_behavior_tree(t, true)
end

AiBrain.set_behavior_tree = function (self, behavior_tree)
	local node_data = self._node_data

	table.clear(node_data)
	table.clear(self._running_child_nodes)

	self._behavior_tree = behavior_tree
	self._running_leaf_node = nil
	self._running_leaf_node_result = "running"
	self._evaluate_utility = true
	local blackboard = self._blackboard
	local root = behavior_tree:root()
	local tree_node = root.tree_node
	local action_data = tree_node.action_data

	root:init_values(blackboard, action_data, node_data)
end

AiBrain.behavior_tree = function (self)
	return self._behavior_tree
end

AiBrain.shutdown_behavior_tree = function (self, t, destroy)
	local running_leaf_node = self._running_leaf_node

	if running_leaf_node then
		local unit = self._unit
		local breed = self._breed
		local blackboard = self._blackboard
		local reason = "aborted"
		local running_child_nodes = self._running_child_nodes
		local no_child_nodes = self._old_running_child_nodes
		local node_data = self._node_data
		local scratchpad = self._scratchpad
		local running_leaf_node_result = self._running_leaf_node_result
		local running_leaf_node_done = running_leaf_node_result ~= "running"

		if running_leaf_node_done then
			local parent_node = running_leaf_node.parent
			local parent_tree_node = parent_node.tree_node
			local parent_action_data = parent_tree_node.action_data

			parent_node:leave(unit, breed, blackboard, scratchpad, parent_action_data, t, reason, destroy, node_data, running_child_nodes, no_child_nodes)
		else
			local tree_node = running_leaf_node.tree_node
			local action_data = tree_node.action_data

			running_leaf_node:leave(unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data, running_child_nodes, no_child_nodes)
			table.clear(scratchpad)
		end

		self._running_leaf_node = nil
		self._running_leaf_node_result = "running"
	end
end

AiBrain.update = function (self, unit, dt, t)
	Profiler.start("evaluate")

	self._old_running_child_nodes = self._running_child_nodes
	self._running_child_nodes = self._old_running_child_nodes
	local breed = self._breed
	local root_node = self._behavior_tree:root()
	local node_data = self._node_data
	local blackboard = self._blackboard
	local scratchpad = self._scratchpad
	local evaluate_utility = self._evaluate_utility
	local old_running_child_nodes = self._old_running_child_nodes
	local new_running_child_nodes = self._running_child_nodes
	local last_leaf_node_result = self._running_leaf_node_result
	local last_leaf_node_running = last_leaf_node_result == "running"
	local leaf_node = root_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

	fassert(leaf_node, "[AiBrain] Invalid behavior tree, no leaf node could be resolved!")

	local last_leaf_node = self._running_leaf_node
	local last_leaf_node_done = not last_leaf_node_running

	if last_leaf_node_done or leaf_node ~= last_leaf_node then
		if last_leaf_node_done and leaf_node.parent ~= last_leaf_node.parent then
			local reason = "aborted"
			local destroy = false
			local parent_node = last_leaf_node.parent
			local parent_tree_node = parent_node.tree_node
			local parent_action_data = parent_tree_node.action_data

			parent_node:leave(unit, breed, blackboard, scratchpad, parent_action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
		elseif not last_leaf_node_done and last_leaf_node then
			local reason = "aborted"
			local destroy = false
			local last_leaf_tree_node = last_leaf_node.tree_node
			local last_leaf_action_data = last_leaf_tree_node.action_data

			last_leaf_node:leave(unit, breed, blackboard, scratchpad, last_leaf_action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
			table.clear(scratchpad)
		end

		local leaf_tree_node = leaf_node.tree_node
		local leaf_action_data = leaf_tree_node.action_data
		self._running_leaf_node = leaf_node

		leaf_node:enter(unit, breed, blackboard, scratchpad, leaf_action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
	end

	table.clear(old_running_child_nodes)
	Profiler.stop("evaluate")
	Profiler.start("run")

	local root_tree_node = root_node.tree_node
	local root_action_data = root_tree_node.action_data
	local result, evaluate_utility_next_frame = root_node:run(unit, breed, blackboard, scratchpad, root_action_data, dt, t, node_data, new_running_child_nodes)
	local leaf_node_done = result ~= "running"
	self._running_leaf_node_result = result
	self._evaluate_utility = evaluate_utility_next_frame or leaf_node_done

	if leaf_node_done then
		local destroy = false
		local leaf_tree_node = leaf_node.tree_node
		local leaf_action_data = leaf_tree_node.action_data

		self._running_leaf_node:leave(unit, breed, blackboard, scratchpad, leaf_action_data, t, result, destroy, node_data, new_running_child_nodes, new_running_child_nodes)
		table.clear(scratchpad)
	end

	Profiler.stop("run")
end

AiBrain.running_action = function (self)
	local node = self._running_leaf_node
	local node_was_done = self._running_leaf_node_result ~= "running"

	if node_was_done or node == nil then
		return nil, nil
	end

	local action_name = node.identifier
	local action_data_or_nil = node.tree_node.action_data

	return action_name, action_data_or_nil
end

return AiBrain
