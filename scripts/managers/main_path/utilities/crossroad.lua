local MainPathQueries = require("scripts/utilities/main_path_queries")
local Crossroad = {
	generate_road_choices = function (crossroads, seed)
		local chosen_road_id = nil
		local chosen_crossroads = {}

		for crossroads_id, crossroad in pairs(crossroads) do
			seed, chosen_road_id = math.next_random(seed, 1, #crossroad.roads)
			chosen_crossroads[crossroads_id] = chosen_road_id
		end

		return chosen_crossroads
	end
}
local to_remove = {}
local to_stitch = {}
local crossroad_main_path_segment_indices = {}
local chosen_crossroad_segments = {}

Crossroad.stitch_and_remove_unused_roads = function (crossroads, chosen_crossroads, main_path_segments, path_markers, seed)
	table.clear(to_remove)
	table.clear(to_stitch)
	table.clear(crossroad_main_path_segment_indices)
	table.clear(chosen_crossroad_segments)

	local num_main_path_segments = #main_path_segments

	for crossroads_id, chosen_road_id in pairs(chosen_crossroads) do
		local crossroad = crossroads[crossroads_id]

		Log.info("Crossroad", "Using road %d at crossroad %s (1/%d roads).", chosen_road_id, crossroads_id, #crossroad.roads)

		for i = num_main_path_segments, 1, -1 do
			local main_path_segment = main_path_segments[i]

			if main_path_segment.crossroads_id == crossroads_id and main_path_segment.road_id == chosen_road_id then
				chosen_crossroad_segments[i] = true
				crossroad_main_path_segment_indices[#crossroad_main_path_segment_indices + 1] = i

				Log.info("Crossroad", "\t\t-> preparing to stitch road %d that has main path segment index %d", main_path_segment.road_id, i)
			end
		end

		for i = 1, num_main_path_segments, 1 do
			local main_path_segment = main_path_segments[i]

			if main_path_segment.crossroads_id == crossroads_id and main_path_segment.road_id ~= chosen_road_id then
				Log.info("Crossroad", "\t\t-> removing road %d with main path segment index %d from crossroad %s", main_path_segment.road_id, i, main_path_segment.crossroads_id)

				to_remove[#to_remove + 1] = i
			end
		end
	end

	local num_crossroad_segment_indices = #crossroad_main_path_segment_indices
	local num_to_remove = #to_remove

	for i = num_crossroad_segment_indices, 1, -1 do
		repeat
			to_stitch[#to_stitch + 1] = {}
			local crossroad_stitch = to_stitch[#to_stitch]
			local index = crossroad_main_path_segment_indices[i]
			local previous_main_path_segment_index = index - 1

			for j = num_to_remove, 1, -1 do
				local removed_main_path_segment_index = to_remove[j]

				if previous_main_path_segment_index == removed_main_path_segment_index then
					previous_main_path_segment_index = previous_main_path_segment_index - 1
				end
			end

			local previous_has_break = MainPathQueries.segment_has_marker_type(path_markers, previous_main_path_segment_index, "break")

			if not previous_has_break then
				crossroad_stitch[#crossroad_stitch + 1] = previous_main_path_segment_index
				crossroad_stitch[#crossroad_stitch + 1] = index
			end

			local crossroad_has_break = MainPathQueries.segment_has_marker_type(path_markers, index, "break")

			if crossroad_has_break then
				break
			end

			local next_main_path_index = index + 1

			for j = 1, num_to_remove, 1 do
				local removed_main_path_index = to_remove[j]

				if next_main_path_index == removed_main_path_index then
					next_main_path_index = next_main_path_index + 1
				end
			end

			if previous_has_break then
				crossroad_stitch[#crossroad_stitch + 1] = index
			end

			if not chosen_crossroad_segments[next_main_path_index] then
				crossroad_stitch[#crossroad_stitch + 1] = next_main_path_index
			end
		until true
	end

	local num_to_stitch = #to_stitch

	for i = 1, num_to_stitch, 1 do
		repeat
			local stitched_indices = to_stitch[i]
			local num_stitched_indices = #stitched_indices

			if num_stitched_indices <= 1 then
				break
			end

			local wanted_main_path_segment_index = stitched_indices[1]
			local wanted_main_path_segment = main_path_segments[wanted_main_path_segment_index]
			local wanted_main_path_nodes = wanted_main_path_segment.nodes

			for j = 2, num_stitched_indices, 1 do
				local stitch_index = stitched_indices[j]
				local stitch_main_path = main_path_segments[stitch_index]
				local stitch_main_path_nodes = stitch_main_path.nodes
				local num_nodes_to_stitch = #stitch_main_path_nodes

				for k = 1, num_nodes_to_stitch, 1 do
					local stiched_node = stitch_main_path_nodes[k]
					wanted_main_path_nodes[#wanted_main_path_nodes + 1] = stiched_node
				end

				Log.info("Crossroad", "Stitched and removed main path segment index %d", stitch_index)

				to_remove[#to_remove + 1] = stitch_index
			end
		until true
	end

	table.sort(to_remove, function (a, b)
		return a < b
	end)

	num_to_remove = #to_remove

	for i = num_to_remove, 1, -1 do
		local index = to_remove[i]

		table.remove(main_path_segments, index)
	end
end

return Crossroad
