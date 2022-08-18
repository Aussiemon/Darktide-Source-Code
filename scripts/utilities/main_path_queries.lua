local MainPathQueries = {
	segment_has_marker_type = function (path_markers, main_path_segment_index, marker_type)
		local has_marker_type = nil

		for i = 1, #path_markers, 1 do
			local path_marker = path_markers[i]
			local path_marker_main_path_segment_index = path_marker.main_path_segment_index
			local path_marker_type = path_marker.marker_type

			if path_marker_main_path_segment_index == main_path_segment_index and path_marker_type == marker_type then
				has_marker_type = true

				break
			end
		end

		return has_marker_type
	end,
	closest_position = function (position, optional_search_main_path_segment_index, optional_breaks_order)
		local start_node_index, end_node_index = nil

		if optional_search_main_path_segment_index then
			if optional_search_main_path_segment_index == 1 then
				start_node_index = 1
			else
				start_node_index = optional_breaks_order[optional_search_main_path_segment_index - 1] + 1
			end

			end_node_index = optional_breaks_order[optional_search_main_path_segment_index]
		end

		local closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index = EngineOptimized.closest_pos_at_main_path(position, start_node_index, end_node_index)
		main_path_node_index = main_path_node_index + 1

		return closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index
	end,
	closest_position_between_nodes = function (position, start_node_index, end_node_index)
		local closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index = EngineOptimized.closest_pos_at_main_path(position, start_node_index, end_node_index)
		main_path_node_index = main_path_node_index + 1

		return closest_position, travel_distance, travel_percentage, main_path_node_index, main_path_segment_index
	end,
	position_from_distance = function (wanted_distance)
		return EngineOptimized.point_on_mainpath(wanted_distance)
	end,
	total_path_distance = function ()
		return EngineOptimized.main_path_total_length()
	end,
	is_main_path_registered = function ()
		return EngineOptimized.is_main_path_registered()
	end,
	generate_unified_main_path = function (main_path_segments)
		local unified_path = {}
		local unified_travel_distances = {}
		local breaks = {}
		local breaks_order = {}
		local segment_lookup = {}
		local k = 1
		local num_main_path_segments = #main_path_segments

		for i = 1, num_main_path_segments, 1 do
			local main_path_segment = main_path_segments[i]
			local nodes = main_path_segment.nodes
			local num_nodes = #nodes
			local break_index = (k + num_nodes) - 1

			if i < num_main_path_segments then
				breaks[break_index] = 0
			end

			breaks_order[i] = break_index
			local travel_distances = main_path_segment.travel_distances

			for j = 1, num_nodes, 1 do
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
}

return MainPathQueries
