-- chunkname: @scripts/utilities/main_path_queries.lua

local MainPathQueries = {}

MainPathQueries.segment_has_marker_type = function (path_markers, main_path_segment_index, marker_type)
	local has_marker_type

	for i = 1, #path_markers do
		local path_marker = path_markers[i]
		local path_marker_main_path_segment_index = path_marker.main_path_segment_index
		local path_marker_type = path_marker.marker_type

		if path_marker_main_path_segment_index == main_path_segment_index and path_marker_type == marker_type then
			has_marker_type = true

			break
		end
	end

	return has_marker_type
end

MainPathQueries.closest_position = function (position, optional_search_main_path_segment_index, optional_breaks_order)
	local start_node_index, end_node_index

	if optional_search_main_path_segment_index then
		start_node_index = optional_search_main_path_segment_index == 1 and 1 or optional_breaks_order[optional_search_main_path_segment_index - 1] + 1
		end_node_index = optional_breaks_order[optional_search_main_path_segment_index]
	end

	local closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index = EngineOptimized.closest_pos_at_main_path(position, start_node_index, end_node_index)

	main_path_node_index = main_path_node_index + 1

	return closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index
end

MainPathQueries.closest_position_between_nodes = function (position, start_node_index, end_node_index)
	local closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index = EngineOptimized.closest_pos_at_main_path(position, start_node_index, end_node_index)

	main_path_node_index = main_path_node_index + 1

	return closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index
end

MainPathQueries.position_from_distance = function (wanted_distance)
	return EngineOptimized.point_on_mainpath(wanted_distance)
end

MainPathQueries.closest_travel_distance_vertical_aware = function (main_path_segments, position, max_z_diff)
	local best_distance_sq = math.huge
	local best_segment, best_node_index

	for i = 1, #main_path_segments do
		local segment = main_path_segments[i]
		local nodes = segment.nodes

		for j = 1, #nodes do
			local node_position = nodes[j]:unbox()

			if max_z_diff >= math.abs(node_position.z - position.z) then
				local to_node = node_position - position
				local distance_sq = to_node.x * to_node.x + to_node.y * to_node.y

				if distance_sq < best_distance_sq then
					best_distance_sq = distance_sq
					best_segment = segment
					best_node_index = j
				end
			end
		end
	end

	if not best_segment then
		return nil
	end

	local nodes = best_segment.nodes
	local travel_distances = best_segment.travel_distances
	local best_travel_distance = travel_distances[best_node_index]
	local node_position = nodes[best_node_index]:unbox()

	for neighbor_index = best_node_index - 1, best_node_index + 1, 2 do
		local neighbor_node = nodes[neighbor_index]

		if neighbor_node then
			local neighbor_position = neighbor_node:unbox()

			if max_z_diff >= math.abs(neighbor_position.z - position.z) then
				local edge = neighbor_position - node_position
				local edge_length_sq = Vector3.dot(edge, edge)

				if edge_length_sq > 0.001 then
					local t = math.clamp(Vector3.dot(position - node_position, edge) / edge_length_sq, 0, 1)
					local projected = node_position + edge * t
					local to_projected = projected - position
					local distance_sq = to_projected.x * to_projected.x + to_projected.y * to_projected.y

					if distance_sq < best_distance_sq then
						best_distance_sq = distance_sq

						local neighbor_travel_distance = travel_distances[neighbor_index]

						best_travel_distance = math.lerp(travel_distances[best_node_index], neighbor_travel_distance, t)
					end
				end
			end
		end
	end

	return best_travel_distance
end

MainPathQueries.total_path_distance = function ()
	return EngineOptimized.main_path_total_length()
end

MainPathQueries.is_main_path_registered = function ()
	return EngineOptimized.is_main_path_registered()
end

MainPathQueries.generate_unified_main_path = function (main_path_segments)
	local unified_path, unified_travel_distances, breaks, breaks_order, segment_lookup = {}, {}, {}, {}, {}
	local k = 1
	local num_main_path_segments = #main_path_segments

	for i = 1, num_main_path_segments do
		local main_path_segment = main_path_segments[i]
		local nodes = main_path_segment.nodes
		local num_nodes = #nodes
		local break_index = k + num_nodes - 1

		if i < num_main_path_segments then
			breaks[break_index] = 0
		end

		breaks_order[i] = break_index

		local travel_distances = main_path_segment.travel_distances

		for j = 1, num_nodes do
			unified_path[k] = nodes[j]
			unified_travel_distances[k] = travel_distances[j]
			segment_lookup[k] = i
			k = k + 1
		end
	end

	for break_index, data in pairs(breaks) do
		breaks[break_index] = (unified_travel_distances[break_index] + unified_travel_distances[break_index + 1]) / 2
	end

	return unified_path, unified_travel_distances, segment_lookup, breaks, breaks_order
end

return MainPathQueries
