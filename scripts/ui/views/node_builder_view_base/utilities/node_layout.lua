local NodeLayout = {}

NodeLayout.node_by_name = function (node_layout, name)
	local nodes = node_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local widget_name = node.widget_name

		if widget_name == name then
			return node
		end
	end
end

local temp_ignore_list = {}

NodeLayout.num_steps_to_start_recursive = function (node_layout, node, ignore_list, step_count)
	step_count = (step_count or 0) + 1

	if not ignore_list then
		ignore_list = temp_ignore_list

		table.clear(ignore_list)
	end

	ignore_list[node.widget_name] = true
	local parents = node.parents

	for i = 1, #parents do
		local parent_name = parents[i]

		if not ignore_list[parent_name] then
			local parent_node = NodeLayout.node_by_name(node_layout, parent_name)

			if parent_node then
				if parent_node.type == "start" then
					return true, step_count
				else
					return NodeLayout.num_steps_to_start_recursive(node_layout, parent_node, ignore_list, step_count)
				end
			end
		end
	end

	return false, 0
end

return NodeLayout
