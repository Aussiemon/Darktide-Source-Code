-- chunkname: @scripts/managers/main_path/utilities/spawn_point_queries.lua

local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local SpawnPointQueries = {}
local ABOVE, BELOW, HORIZONTAL = 1, 1, 3

SpawnPointQueries.generate_nav_triangle_group = function (nav_world, group_distance, group_cutoff_values, nav_tag_cost_table)
	local main_path_length = EngineOptimized.main_path_total_length()
	local half_distance = group_distance / 2
	local travel_distance = half_distance
	local travel_end_distance = main_path_length - group_distance
	local flood_fill_positions = {}
	local group_index_to_mainpath_index = {}

	while travel_distance <= travel_end_distance do
		local position = MainPathQueries.position_from_distance(travel_distance)
		local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, ABOVE, BELOW, HORIZONTAL)

		if position_on_navmesh then
			local group_index = #flood_fill_positions + 1

			flood_fill_positions[group_index] = position_on_navmesh

			local _, _, _, node_index, _ = MainPathQueries.closest_position(position_on_navmesh)

			group_index_to_mainpath_index[group_index] = node_index
		end

		travel_distance = travel_distance + group_distance
	end

	local nav_triangle_group = GwNavTriangleGroup.create_by_flood_fill_from_positions(nav_world, flood_fill_positions, group_cutoff_values, nav_tag_cost_table)

	return nav_triangle_group, flood_fill_positions, group_index_to_mainpath_index
end

SpawnPointQueries.generate_nav_spawn_points = function (nav_world, nav_triangle_group, min_free_radius, min_distance_to_others, num_spawn_points_per_subgroup, nav_tag_cost_table, start_seed)
	local nav_spawn_points = GwNavSpawnPoints.create(nav_world, nav_triangle_group)
	local num_groups, num_sub_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local GwNavSpawnPoints_get_triangle_count = GwNavSpawnPoints.get_triangle_count
	local GwNavSpawnPoints_get_spawn_point_position = GwNavSpawnPoints.get_spawn_point_position
	local spawn_point_positions = Script.new_array(num_groups)
	local num_spawn_points = 0
	local seed = start_seed
	local math_next_random = math.next_random

	for i = 1, num_groups do
		local group_positions = Script.new_array(num_sub_groups)

		for j = 1, num_sub_groups do
			local num_triangles = GwNavSpawnPoints_get_triangle_count(nav_spawn_points, i, j)
			local num_sub_group_spawn_points = math.min(num_triangles, num_spawn_points_per_subgroup)
			local sub_group_positions = Script.new_array(num_sub_group_spawn_points)

			for k = 1, num_sub_group_spawn_points do
				local start_triangle_index

				seed, start_triangle_index = math_next_random(seed, 1, num_triangles)

				local found, position = GwNavSpawnPoints_get_spawn_point_position(nav_spawn_points, nav_world, i, j, start_triangle_index, min_free_radius, min_distance_to_others, nav_tag_cost_table)

				if found then
					sub_group_positions[#sub_group_positions + 1] = Vector3Box(position)
					num_spawn_points = num_spawn_points + 1
				end
			end

			group_positions[j] = sub_group_positions
		end

		spawn_point_positions[i] = group_positions
	end

	return nav_spawn_points, spawn_point_positions
end

SpawnPointQueries.update_time_slice_nav_spawn_points = function (time_slice_data, nav_spawn_points, spawn_point_positions)
	local last_index = time_slice_data.last_index
	local performance_counter_handle, duration_ms = GameplayInitTimeSlice.pre_loop()
	local GwNavSpawnPoints_get_triangle_count, GwNavSpawnPoints_get_spawn_point_position = GwNavSpawnPoints.get_triangle_count, GwNavSpawnPoints.get_spawn_point_position
	local math_next_random = math.next_random
	local parameters = time_slice_data.parameters
	local num_groups, num_sub_groups = parameters.num_groups, parameters.num_sub_groups
	local num_spawn_points_per_subgroup = parameters.num_spawn_points_per_subgroup
	local nav_world = parameters.nav_world
	local min_free_radius = parameters.min_free_radius
	local min_distance_to_others = parameters.min_distance_to_others
	local nav_tag_cost_table = parameters.nav_tag_cost_table
	local seed = parameters.seed

	for index = last_index + 1, num_groups do
		local start_timer = GameplayInitTimeSlice.pre_process(performance_counter_handle, duration_ms)

		if not start_timer then
			break
		end

		local group_positions = Script.new_array(num_sub_groups)

		for j = 1, num_sub_groups do
			local num_triangles = GwNavSpawnPoints_get_triangle_count(nav_spawn_points, index, j)
			local num_sub_group_spawn_points = math.min(num_triangles, num_spawn_points_per_subgroup)
			local sub_group_positions = Script.new_array(num_sub_group_spawn_points)

			for k = 1, num_sub_group_spawn_points do
				local start_triangle_index

				seed, start_triangle_index = math_next_random(seed, 1, num_triangles)

				local found, position = GwNavSpawnPoints_get_spawn_point_position(nav_spawn_points, nav_world, index, j, start_triangle_index, min_free_radius, min_distance_to_others, nav_tag_cost_table)

				if found then
					sub_group_positions[#sub_group_positions + 1] = Vector3Box(position)
				end
			end

			group_positions[j] = sub_group_positions
		end

		spawn_point_positions[index] = group_positions
		time_slice_data.last_index = index
		duration_ms = GameplayInitTimeSlice.post_process(performance_counter_handle, start_timer, duration_ms)
	end

	if time_slice_data.last_index == num_groups then
		GameplayInitTimeSlice.set_finished(time_slice_data)
	else
		time_slice_data.parameters.seed = seed
	end

	return time_slice_data.ready
end

local GROUP_FROM_POSITION_LIMIT_ABOVE = 1.5
local GROUP_FROM_POSITION_LIMIT_BELOW = 1.5

SpawnPointQueries.group_from_position = function (nav_world, nav_spawn_points, position, optional_above, optional_below)
	local above = optional_above or GROUP_FROM_POSITION_LIMIT_ABOVE
	local below = optional_below or GROUP_FROM_POSITION_LIMIT_BELOW
	local success, group_index, sub_group_index = GwNavSpawnPoints.get_group_from_position(nav_spawn_points, nav_world, position, above, below)

	if success then
		return group_index, sub_group_index
	end
end

SpawnPointQueries.occluded_positions_in_group = function (nav_world, nav_spawn_points, group_index, occluded_from_positions)
	local num_groups, num_sub_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local occluded_positions = {}
	local spawn_point_cost_table = Managers.state.main_path:spawn_point_cost_table()

	for i = 1, num_sub_groups do
		local points = GwNavSpawnPoints.get_occluded_points(nav_spawn_points, nav_world, group_index, i, occluded_from_positions, spawn_point_cost_table)
		local num_points = GwNavOccludedPointCollection.get_count(points)

		for j = 1, num_points do
			occluded_positions[#occluded_positions + 1] = GwNavOccludedPointCollection.get_position(points, nav_world, j)
		end
	end

	return occluded_positions
end

local DISALLOWED_DISTANCE = 8
local ALLOWED_Z_DIFF = 12

local function _remove_invalid_occluded_positions(valid_enemy_player_units_positions, occluded_positions, num_occluded_positions, min_distance, max_distance, optional_disallowed_positions)
	for i = 1, #valid_enemy_player_units_positions do
		local player_position = valid_enemy_player_units_positions[i]

		for j = num_occluded_positions, 1, -1 do
			repeat
				local occluded_position = occluded_positions[j]
				local distance = Vector3.distance(player_position, occluded_position)

				if min_distance and distance < min_distance or max_distance and max_distance < distance then
					local z_diff = math.abs(player_position.z - occluded_position.z)

					if z_diff < ALLOWED_Z_DIFF then
						table.remove(occluded_positions, j)

						num_occluded_positions = num_occluded_positions - 1
					end

					break
				end

				if optional_disallowed_positions then
					for k = 1, #optional_disallowed_positions do
						local disallowed_position = optional_disallowed_positions[k]:unbox()

						distance = Vector3.distance(disallowed_position, occluded_position)

						if distance <= DISALLOWED_DISTANCE then
							table.remove(occluded_positions, j)

							num_occluded_positions = num_occluded_positions - 1

							break
						end
					end
				end
			until true
		end
	end

	return num_occluded_positions
end

local MIN_WANTED_OCCLUDED_POSITIONS = 3

SpawnPointQueries.get_occluded_positions = function (nav_world, nav_spawn_points, from_position, side, offset_range, num_groups, optional_min_distance, optional_max_distance, optional_initial_offset, optional_only_search_forward, optional_disallowed_positions)
	local group_index, _ = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, from_position)

	if not group_index then
		return nil, nil
	end

	local occluded_positions
	local valid_enemy_player_units_positions = side.valid_enemy_player_units_positions

	if optional_initial_offset then
		local half_range = math.floor(optional_initial_offset / 2)
		local start_index = math.max(group_index - half_range, 1)
		local end_index = math.min(group_index + half_range, num_groups)

		for i = start_index, end_index do
			if occluded_positions then
				table.append(occluded_positions, SpawnPointQueries.occluded_positions_in_group(nav_world, nav_spawn_points, i, valid_enemy_player_units_positions))
			else
				occluded_positions = SpawnPointQueries.occluded_positions_in_group(nav_world, nav_spawn_points, i, valid_enemy_player_units_positions)
			end
		end
	else
		occluded_positions = SpawnPointQueries.occluded_positions_in_group(nav_world, nav_spawn_points, group_index, valid_enemy_player_units_positions)
	end

	local num_occluded_positions = #occluded_positions

	if num_occluded_positions > 0 and (optional_min_distance or optional_max_distance or optional_disallowed_positions) then
		num_occluded_positions = _remove_invalid_occluded_positions(valid_enemy_player_units_positions, occluded_positions, num_occluded_positions, optional_min_distance, optional_max_distance, optional_disallowed_positions)
	end

	if num_occluded_positions == 0 then
		local start_index, end_index

		if optional_only_search_forward then
			start_index = math.min(group_index + 1, num_groups)
			end_index = math.min(group_index + offset_range, num_groups)
		else
			local half_range = math.floor(offset_range / 2)

			start_index = math.max(group_index - half_range, 1)
			end_index = math.min(group_index + half_range, num_groups)
		end

		for i = end_index, start_index, -1 do
			table.append(occluded_positions, SpawnPointQueries.occluded_positions_in_group(nav_world, nav_spawn_points, i, valid_enemy_player_units_positions))

			num_occluded_positions = #occluded_positions

			if num_occluded_positions > 0 then
				if optional_min_distance or optional_max_distance then
					num_occluded_positions = _remove_invalid_occluded_positions(valid_enemy_player_units_positions, occluded_positions, num_occluded_positions, optional_min_distance, optional_max_distance)
				end

				if num_occluded_positions >= MIN_WANTED_OCCLUDED_POSITIONS then
					break
				end
			end
		end
	end

	if num_occluded_positions == 0 then
		return nil, nil
	end

	return occluded_positions, num_occluded_positions
end

SpawnPointQueries.get_random_occluded_position = function (nav_world, nav_spawn_points, from_position, side, offset_range, num_groups, optional_min_distance, optional_max_distance, optional_initial_offset, optional_only_search_forward, optional_disallowed_positions)
	local occluded_positions, num_occluded_positions = SpawnPointQueries.get_occluded_positions(nav_world, nav_spawn_points, from_position, side, offset_range, num_groups, optional_min_distance, optional_max_distance, optional_initial_offset, optional_only_search_forward, optional_disallowed_positions)

	if occluded_positions then
		local random_occluded_position = occluded_positions[math.random(1, num_occluded_positions)]

		return random_occluded_position
	end
end

return SpawnPointQueries
