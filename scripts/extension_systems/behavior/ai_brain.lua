-- chunkname: @scripts/extension_systems/behavior/ai_brain.lua

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local AiBrain = class("AiBrain")

AiBrain.init = function (self, unit, breed, blackboard, behavior_tree, behavior_extension)
	self._unit = unit
	self._breed = breed
	self._blackboard = blackboard
	self._active = true
	self._node_data = {}
	self._scratchpad = {}
	self._running_child_nodes = {}
	self._old_running_child_nodes = {}
	self._running_state_node = nil
	self._behavior_extension = behavior_extension

	self:set_behavior_tree(behavior_tree)
end

AiBrain.destroy = function (self, t)
	if not Network.game_session() then
		return
	end

	self:shutdown_behavior_tree(t, true)
end

AiBrain.set_active = function (self, active)
	if active == self._active then
		return
	end

	self._active = active
end

AiBrain.active = function (self)
	return self._active
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

AiBrain.state_event = function (self, state_name)
	if state_name == "base" then
		self._running_state_node = nil

		return
	end

	local state_node = self:_state_node()
	local new_state_node = self:_find_state_node(state_node, state_name)

	if new_state_node then
		self._running_state_node = new_state_node
	end
end

local _traversed_nodes_scratch = {}

AiBrain._find_state_node = function (self, from_node, state_name, optional_traversed_nodes)
	local CONDITIONS = BtConditions
	local traversed_nodes = optional_traversed_nodes

	if not traversed_nodes then
		traversed_nodes = _traversed_nodes_scratch

		table.clear(traversed_nodes)
	end

	traversed_nodes[from_node] = true

	local children = from_node:children()

	for i = 1, #children do
		local child_node = children[i]

		if not traversed_nodes[child_node] then
			traversed_nodes[child_node] = true

			local child_tree_node = child_node.tree_node

			if child_tree_node.state == state_name then
				local blackboard, scratchpad = self._blackboard, self._scratchpad
				local last_leaf_node_running = self._running_leaf_node_result == "running"
				local old_running_child_nodes = self._old_running_child_nodes
				local child_is_running = last_leaf_node_running and old_running_child_nodes[child_node.identifier] == child_node
				local condition_name = child_node.condition_name

				if not condition_name or CONDITIONS[condition_name](self._unit, blackboard, scratchpad, child_tree_node.condition_args, child_tree_node.action_data, child_is_running, 0) then
					return child_node
				end
			end

			local found_node = self:_find_state_node(child_node, state_name, traversed_nodes)

			if found_node then
				return found_node
			end
		end
	end

	local parent = from_node.parent

	if parent and not traversed_nodes[parent] then
		return self:_find_state_node(parent, state_name, traversed_nodes)
	end

	return nil
end

AiBrain._state_node = function (self)
	return self._running_state_node or self._behavior_tree:root()
end

AiBrain.leave_state = function (self)
	self._running_state_node = nil
end

local _traversed_exit_states = {}

AiBrain.update = function (self, unit, dt, t)
	self._running_child_nodes, self._old_running_child_nodes = self._old_running_child_nodes, self._running_child_nodes

	local breed = self._breed
	local state_node, node_data = self:_state_node(), self._node_data
	local blackboard, scratchpad, evaluate_utility = self._blackboard, self._scratchpad, self._evaluate_utility
	local old_running_child_nodes, new_running_child_nodes = self._old_running_child_nodes, self._running_child_nodes
	local last_leaf_node_result = self._running_leaf_node_result
	local last_leaf_node_running = last_leaf_node_result == "running"
	local leaf_node

	if state_node.evaluate then
		leaf_node = state_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	elseif not state_node.condition_name or BtConditions[state_node.condition_name](unit, blackboard, scratchpad, state_node.condition_args, state_node.action_data, last_leaf_node_running, dt) then
		leaf_node = state_node
	end

	if leaf_node == nil and state_node.tree_node.exit_state then
		local traversed_exit_states = _traversed_exit_states

		table.clear(traversed_exit_states)

		repeat
			if traversed_exit_states[state_node] then
				ferror("[AiBrain] Invalid behavior tree, circular exit states detected starting at node: %s. Involved nodes: %s", state_node.identifier, table.concat(table.keys(traversed_exit_states), ", "))
			end

			traversed_exit_states[state_node] = true

			self:state_event(state_node.tree_node.exit_state)

			state_node = self:_state_node()
			leaf_node = state_node:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
		until leaf_node or state_node.tree_node.exit_state == nil

		if not leaf_node then
			-- Nothing
		end
	end

	if not leaf_node then
		return
	end

	local last_leaf_node = self._running_leaf_node
	local last_leaf_node_done = not last_leaf_node_running

	if last_leaf_node_done or leaf_node ~= last_leaf_node then
		if last_leaf_node_done and leaf_node.parent ~= last_leaf_node.parent then
			local reason, destroy = "aborted", false
			local parent_node = last_leaf_node.parent
			local parent_tree_node = parent_node.tree_node
			local parent_action_data = parent_tree_node.action_data

			parent_node:leave(unit, breed, blackboard, scratchpad, parent_action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
		elseif not last_leaf_node_done and last_leaf_node then
			local reason, destroy = "aborted", false
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

	local root_tree_node = state_node.tree_node
	local root_action_data = root_tree_node.action_data
	local result, evaluate_utility_next_frame = state_node:run(unit, breed, blackboard, scratchpad, root_action_data, dt, t, node_data, new_running_child_nodes)
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
