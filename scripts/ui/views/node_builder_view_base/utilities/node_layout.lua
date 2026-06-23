-- chunkname: @scripts/ui/views/node_builder_view_base/utilities/node_layout.lua

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

NodeLayout.unique_node_by_talent_name = function (node_layout, talent_name)
	local found_node, is_unique
	local nodes = node_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local talent = node.talent

		if talent == talent_name then
			is_unique = not found_node
			found_node = node

			break
		end
	end

	return found_node, is_unique
end

local temp_ignore_list = {}

NodeLayout._num_steps_to_start_recursive_internal = function (node_layout, node, ignore_list, step_count)
	if node.type == "start" then
		return true, 0
	end

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
					return NodeLayout._num_steps_to_start_recursive_internal(node_layout, parent_node, ignore_list, step_count)
				end
			end
		end
	end

	return false, -1
end

NodeLayout.num_steps_to_start_recursive = function (node_layout, talent_name, ignore_list, step_count)
	local node, is_unique = NodeLayout.unique_node_by_talent_name(node_layout, talent_name)

	if node then
		local found, steps = NodeLayout._num_steps_to_start_recursive_internal(node_layout, node, ignore_list, step_count)

		return found, steps, is_unique
	end

	return false, -1, is_unique
end

NodeLayout.fallback_icon = function ()
	return "content/ui/textures/icons/talents/psyker/psyker_ability_discharge"
end

return NodeLayout
