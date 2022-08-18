local Graph = class("Graph")

Graph.init = function (self)
	self._nodes = {}
end

Graph.clear_nodes = function (self)
	local nodes = self._nodes

	table.clear(nodes)
end

Graph.add_node = function (self, value)
	local nodes = self._nodes

	if not nodes[value] then
		nodes[value] = {
			adjacency_nodes = {}
		}
	end
end

Graph.add_edge = function (self, value_1, value_2, edge_is_undiracted)
	local nodes = self._nodes

	if (nodes[value_1] and not edge_is_undiracted) or (nodes[value_1] and nodes[value_2]) then
		local adjacency_nodes = nodes[value_1].adjacency_nodes
		adjacency_nodes[#adjacency_nodes + 1] = value_2

		if edge_is_undiracted then
			adjacency_nodes = nodes[value_2].adjacency_nodes
			adjacency_nodes[#adjacency_nodes + 1] = value_1
		end
	end
end

Graph.get_adjacency_nodes = function (self, value)
	local nodes = self._nodes
	local return_value = nil

	if nodes[value] then
		local adjacency_nodes = nodes[value].adjacency_nodes

		if #adjacency_nodes > 0 then
			return_value = adjacency_nodes
		end
	end

	return return_value
end

Graph.has_adjacency_nodes = function (self, value)
	local nodes = self._nodes

	if nodes[value] then
		local adjacency_nodes = nodes[value].adjacency_nodes

		if #adjacency_nodes > 0 then
			return true
		end
	end

	return false
end

return Graph
