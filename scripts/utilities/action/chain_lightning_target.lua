local GrowQueue = require("scripts/foundation/utilities/grow_queue")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = class("ChainLightningTarget")

ChainLightningTarget.init = function (self, max_targets_settings, depth, use_random, optional_parent, ...)
	local num_values = select("#", ...)
	local values = {}
	local num_key_value_pairs = select("#", ...)

	for i = 1, num_key_value_pairs, 2 do
		local key, value = select(i, ...)
		values[key] = value
	end

	self._values = values
	self._parent = optional_parent
	self._children = {}
	self._num_children = 0
	self._max_targets_settings = max_targets_settings
	self._max_num_children = ChainLightning.calculate_max_targets(max_targets_settings, depth + 1, use_random)
	self._use_random = use_random
	self._depth = depth
	self._marked_for_deletion = false
end

ChainLightningTarget.set_value = function (self, key, value)
	self._values[key] = value
end

ChainLightningTarget.value = function (self, key)
	return self._values[key]
end

ChainLightningTarget.add_child = function (self, ...)
	local new_num_children = self._num_children + 1
	local max_children = self._max_num_children

	if max_children < new_num_children then
		return
	end

	local max_targets_settings = self._max_targets_settings
	local use_random = self._use_random
	local node = ChainLightningTarget:new(max_targets_settings, self._depth + 1, use_random, self, ...)
	self._children[node] = true
	self._num_children = new_num_children

	return node
end

ChainLightningTarget.remove_child = function (self, child)
	self._children[child] = nil
	self._num_children = self._num_children - 1
end

ChainLightningTarget.depth = function (self)
	return self._depth
end

ChainLightningTarget.parent = function (self)
	return self._parent
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

ChainLightningTarget.max_num_children = function (self)
	return self._max_num_children
end

ChainLightningTarget.set_max_num_children = function (self, max_num_children)
	self._max_num_children = max_num_children
end

ChainLightningTarget.num_available_children = function (self)
	return self._max_num_children - self._num_children
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

local queue = GrowQueue:new()

ChainLightningTarget.traverse_breadth_first = function (root, return_table, validation_func, ...)
	queue:push_back(root)

	while queue:size() > 0 do
		local node = queue:pop_first()

		if not validation_func or validation_func(node, ...) then
			return_table[#return_table + 1] = node
		end

		for child_node, _ in pairs(node:children()) do
			queue:push_back(child_node)
		end
	end
end

ChainLightningTarget.traverse_depth_first = function (node, return_table, validation_func, ...)
	for child_node, _ in pairs(node:children()) do
		ChainLightningTarget.traverse_depth_first(child_node, return_table, validation_func, ...)
	end

	if not validation_func or validation_func(node, ...) then
		return_table[#return_table + 1] = node
	end
end

ChainLightningTarget.remove_all_child_nodes = function (node, on_delete_func, ...)
	for child_node, _ in pairs(node:children()) do
		ChainLightningTarget.remove_all_child_nodes(child_node, on_delete_func, ...)

		if on_delete_func then
			on_delete_func(child_node, ...)
		end

		node:remove_child(child_node)
	end
end

ChainLightningTarget.remove_child_nodes_marked_for_deletion = function (node, on_delete_func, ...)
	for child_node, _ in pairs(node:children()) do
		if child_node:is_marked_for_deletion() then
			ChainLightningTarget.remove_all_child_nodes(child_node, on_delete_func, ...)

			if on_delete_func then
				on_delete_func(child_node, ...)
			end

			node:remove_child(child_node)
		else
			ChainLightningTarget.remove_child_nodes_marked_for_deletion(child_node, on_delete_func, ...)
		end
	end
end

return ChainLightningTarget
