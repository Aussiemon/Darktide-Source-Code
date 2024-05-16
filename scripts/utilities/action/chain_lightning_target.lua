-- chunkname: @scripts/utilities/action/chain_lightning_target.lua

local GrowQueue = require("scripts/foundation/utilities/grow_queue")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = class("ChainLightningTarget")

ChainLightningTarget.init = function (self, chain_settings, optional_depth, use_random, optional_parent, ...)
	local num_values = select("#", ...)
	local values = {}
	local num_key_value_pairs = select("#", ...)

	for i = 1, num_key_value_pairs, 2 do
		local key, value = select(i, ...)

		values[key] = value
	end

	local depth = optional_depth or 1

	self._values = values
	self._parent = optional_parent
	self._children = {}
	self._num_children = 0
	self._chain_settings = chain_settings
	self._has_variable_num_children = not not chain_settings.max_targets_at_time
	self._use_random = use_random

	local time_active = 0

	self._max_num_children = ChainLightning.max_targets(time_active, chain_settings, depth + 1, use_random)
	self._depth = depth
	self._marked_for_deletion = false
end

ChainLightningTarget.set_value = function (self, key, value)
	self._values[key] = value
end

ChainLightningTarget.value = function (self, key)
	return self._values[key]
end

ChainLightningTarget.add_child = function (self, on_add_func, func_context, ...)
	local new_num_children = self._num_children + 1
	local max_children = self._max_num_children

	if max_children < new_num_children then
		return
	end

	local node = ChainLightningTarget:new(self._chain_settings, self._depth + 1, self._use_random, self, ...)

	self._children[node] = node
	self._num_children = new_num_children

	if on_add_func then
		on_add_func(node, func_context)
	end

	return node
end

ChainLightningTarget.transfer_child_to_node = function (self, moving_child_node, ignore_max_num_children, on_transfer_func, func_context)
	local new_num_children = self._num_children + 1
	local max_num_children = self._max_num_children

	if not ignore_max_num_children and max_num_children < new_num_children then
		return
	end

	moving_child_node:set_parent(self)

	if on_transfer_func then
		on_transfer_func(moving_child_node, func_context)
	end

	self._children[moving_child_node] = moving_child_node
	self._num_children = new_num_children
end

ChainLightningTarget.remove_child = function (self, child, on_remove_func, func_context)
	if not self._children[child] then
		return
	end

	if on_remove_func then
		on_remove_func(child, func_context)
	end

	self._children[child] = nil
	self._num_children = self._num_children - 1
end

ChainLightningTarget.depth = function (self)
	return self._depth
end

ChainLightningTarget.parent = function (self)
	return self._parent
end

ChainLightningTarget.set_parent = function (self, parent_node)
	self._parent = parent_node
end

ChainLightningTarget.is_marked_for_deletion = function (self)
	return self._marked_for_deletion
end

ChainLightningTarget.mark_for_deletion = function (self)
	self._marked_for_deletion = true
end

ChainLightningTarget.children = function (self)
	return self._children
end

ChainLightningTarget.num_children = function (self)
	return self._num_children
end

ChainLightningTarget.max_num_children = function (self)
	return self._max_num_children
end

ChainLightningTarget.num_available_children = function (self)
	return self._max_num_children - self._num_children
end

ChainLightningTarget.set_max_num_children = function (self, max_num_children)
	self._max_num_children = max_num_children
end

ChainLightningTarget.recalculate_max_num_children = function (self, t, start_t)
	if not self._has_variable_num_children or not t or not start_t then
		return
	end

	local time_active = t - start_t

	self._max_num_children = ChainLightning.max_targets(time_active, self._chain_settings, self._depth, self._use_random)
end

ChainLightningTarget.is_empty = function (self)
	return self._num_children == 0
end

ChainLightningTarget.is_full = function (self)
	return self._num_children == self._max_num_children
end

ChainLightningTarget.clear = function (self, optional_max_num_children)
	table.clear(self._children)

	self._num_children = 0
	self._value = nil
	self._max_num_children = optional_max_num_children or self._max_num_children
end

local traverse_queue = GrowQueue:new()

ChainLightningTarget.traverse_breadth_first = function (t, node, return_table, validation_func, ...)
	traverse_queue:push_back(node)

	while traverse_queue:size() > 0 do
		local current_node = traverse_queue:pop_first()

		if not validation_func or validation_func(t, current_node, ...) then
			return_table[#return_table + 1] = current_node
		end

		for child_node, _ in pairs(current_node:children()) do
			traverse_queue:push_back(child_node)
		end
	end
end

ChainLightningTarget.traverse_depth_first = function (t, node, return_table, validation_func, ...)
	for child_node, _ in pairs(node:children()) do
		ChainLightningTarget.traverse_depth_first(t, child_node, return_table, validation_func, ...)
	end

	if not validation_func or validation_func(t, node, ...) then
		return_table[#return_table + 1] = node
	end
end

ChainLightningTarget.remove_all_child_nodes = function (node, on_remove_func, func_context)
	for child_node, _ in pairs(node:children()) do
		ChainLightningTarget.remove_all_child_nodes(child_node, on_remove_func, func_context)
		node:remove_child(child_node, on_remove_func, func_context)
	end
end

ChainLightningTarget.remove_child_nodes_marked_for_deletion = function (root, on_remove_func, func_context)
	for child_node, _ in pairs(root:children()) do
		if child_node:is_marked_for_deletion() then
			ChainLightningTarget.remove_all_child_nodes(child_node, on_remove_func, func_context)
			root:remove_child(child_node, on_remove_func, func_context)
		else
			ChainLightningTarget.remove_child_nodes_marked_for_deletion(child_node, on_remove_func, func_context)
		end
	end
end

ChainLightningTarget.remove_node_and_transfer_all_child_nodes_to_parent = function (node, on_transfer_func, on_remove_func, func_context)
	local parent_node = node:parent()

	if parent_node then
		for child_node, _ in pairs(node:children()) do
			parent_node:transfer_child_to_node(child_node, true, on_transfer_func, func_context)
		end

		parent_node:remove_child(node, on_remove_func, func_context)
	end
end

ChainLightningTarget.move_all_child_nodes_to_new_root = function (old_root_node, new_root_node, on_transfer_func, on_remove_func, func_context)
	for child_node, _ in pairs(old_root_node:children()) do
		new_root_node:transfer_child_to_node(child_node, true, on_transfer_func, func_context)
		old_root_node:remove_child(child_node, on_remove_func, func_context)
	end
end

return ChainLightningTarget
