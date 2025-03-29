-- chunkname: @scripts/extension_systems/behavior/nodes/bt_node.lua

local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local BtEnterHooks = require("scripts/extension_systems/behavior/utilities/bt_enter_hooks")
local BtLeaveHooks = require("scripts/extension_systems/behavior/utilities/bt_leave_hooks")
local BtNode = class("BtNode")

BtNode.init = function (self, identifier, parent, condition_name, enter_hook, leave_hook, run_hook, tree_node)
	self.tree_node = tree_node
	self.parent = parent
	self.identifier = identifier

	local condition = BtConditions[condition_name]

	self.condition_name = condition_name
	self.run_hook = run_hook

	self:_init_enter_function(enter_hook)
	self:_init_leave_function(leave_hook)
end

local function _should_visit_node(node, old_running_child_nodes, new_running_child_nodes)
	local parent = node.parent

	return parent and new_running_child_nodes[parent.identifier] ~= old_running_child_nodes[parent.identifier]
end

BtNode._init_enter_function = function (self, enter_hook)
	local enter_hook_name, args_or_nil

	if enter_hook then
		enter_hook_name = enter_hook

		if type(enter_hook) == "table" then
			enter_hook_name = enter_hook.hook
			args_or_nil = enter_hook.args
		end
	end

	if enter_hook then
		self.enter = function (_self, unit, breed, blackboard, scratchpad, action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
			local current_parent = _self.parent

			if current_parent and _should_visit_node(current_parent, old_running_child_nodes, new_running_child_nodes) then
				local parent_tree_node = current_parent.tree_node
				local parent_action_data = parent_tree_node.action_data

				current_parent:enter(unit, breed, blackboard, scratchpad, parent_action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
			end

			BtEnterHooks[enter_hook_name](unit, breed, blackboard, scratchpad, action_data, t, args_or_nil)

			local metatable = getmetatable(self)

			metatable.enter(_self, unit, breed, blackboard, scratchpad, action_data, t, node_data)
		end
	else
		self.enter = function (_self, unit, breed, blackboard, scratchpad, action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
			local current_parent = _self.parent

			if current_parent and _should_visit_node(current_parent, old_running_child_nodes, new_running_child_nodes) then
				local parent_tree_node = current_parent.tree_node
				local parent_action_data = parent_tree_node.action_data

				current_parent:enter(unit, breed, blackboard, scratchpad, parent_action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
			end

			local metatable = getmetatable(self)

			metatable.enter(_self, unit, breed, blackboard, scratchpad, action_data, t, node_data)
		end
	end
end

BtNode._init_leave_function = function (self, leave_hook)
	local leave_hook_name, args_or_nil

	if leave_hook then
		leave_hook_name = leave_hook

		if type(leave_hook) == "table" then
			leave_hook_name = leave_hook.hook
			args_or_nil = leave_hook.args
		end
	end

	if leave_hook then
		self.leave = function (_self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
			local metatable = getmetatable(self)

			metatable.leave(_self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data)
			BtLeaveHooks[leave_hook_name](unit, breed, blackboard, scratchpad, action_data, t, args_or_nil, reason)

			local current_parent = _self.parent

			if current_parent and _should_visit_node(current_parent, old_running_child_nodes, new_running_child_nodes) then
				local parent_tree_node = current_parent.tree_node
				local parent_action_data = parent_tree_node.action_data

				current_parent:leave(unit, breed, blackboard, scratchpad, parent_action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
			end
		end
	else
		self.leave = function (_self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
			local metatable = getmetatable(self)

			metatable.leave(_self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data)

			local current_parent = _self.parent

			if current_parent and _should_visit_node(current_parent, old_running_child_nodes, new_running_child_nodes) then
				local parent_tree_node = current_parent.tree_node
				local parent_action_data = parent_tree_node.action_data

				current_parent:leave(unit, breed, blackboard, scratchpad, parent_action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
			end
		end
	end
end

BtNode.init_values = function (self, blackboard, action_data, node_data)
	return
end

BtNode.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t, node_data, old_running_child_nodes, new_running_child_nodes)
	return
end

BtNode.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy, node_data, old_running_child_nodes, new_running_child_nodes)
	return
end

BtNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	ferror("[BtNode] Implement run() in inherited class: %q", self.identifier)
end

return BtNode
