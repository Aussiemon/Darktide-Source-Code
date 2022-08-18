local Navigation = {
	create_nav_tag_volume = function (nav_world, bottom_points, altitude_min, altitude_max, layer_id, color, optional_is_exclusive)
		local is_exclusive = optional_is_exclusive or false
		local smart_object_id = -1
		local user_data = nil
		local tag_volume = GwNavTagVolume.create(nav_world, bottom_points, altitude_min, altitude_max, is_exclusive, color, layer_id, smart_object_id, user_data)

		return tag_volume
	end,
	create_traverse_logic = function (nav_world, nav_tag_allowed_layers, optional_nav_cost_map_multipliers, enable_crowd_dispersion)
		local nav_mesh_manager = Managers.state.nav_mesh
		local nav_tag_cost_table = GwNavTagLayerCostTable.create()

		nav_mesh_manager:initialize_nav_tag_cost_table(nav_tag_cost_table, nav_tag_allowed_layers)

		local cost_maps, nav_cost_map_multiplier_table = nil

		if optional_nav_cost_map_multipliers then
			nav_cost_map_multiplier_table = GwNavCostMapMultiplierTable.create()

			nav_mesh_manager:initialize_nav_cost_map_multiplier_table(nav_cost_map_multiplier_table, optional_nav_cost_map_multipliers)

			if not table.is_empty(optional_nav_cost_map_multipliers) then
				cost_maps = {}

				for cost_map_name, _ in pairs(optional_nav_cost_map_multipliers) do
					local cost_map_id = nav_mesh_manager:nav_cost_map_id(cost_map_name)
					local cost_map = nav_mesh_manager:nav_cost_map(cost_map_id)
					cost_maps[#cost_maps + 1] = cost_map
				end
			end
		end

		local traverse_logic = GwNavTraverseLogic.create(nav_world, cost_maps, enable_crowd_dispersion)

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, nav_tag_cost_table)

		if optional_nav_cost_map_multipliers then
			GwNavTraverseLogic.set_cost_map_multiplier_table(traverse_logic, nav_cost_map_multiplier_table)
		end

		return traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table
	end,
	inside_nav_tag_volume_layer = function (nav_world, position, above, below, layer_id)
		local query_output = GwNavQueries.tag_volumes_from_position(nav_world, position, above, below)
		local result = nil

		if query_output then
			local tag_volume_n = GwNavQueries.nav_tag_volume_count(query_output)

			for i = 1, tag_volume_n, 1 do
				local tag_volume = GwNavQueries.nav_tag_volume(query_output, i)
				local _, _, tag_volume_layer_id, _, _ = GwNavTagVolume.navtag(tag_volume)

				if layer_id == tag_volume_layer_id then
					result = true

					break
				end
			end

			GwNavQueries.destroy_query_dynamic_output(query_output)
		end

		return result
	end,
	nav_tag_volume_points_center = function (points)
		local num_points = #points
		local center_pos = Vector3(0, 0, 0)

		for i = 1, num_points, 1 do
			center_pos = center_pos + Vector3(points[i][1], points[i][2], points[i][3])
		end

		return center_pos / num_points
	end,
	add_nav_data = function (nav_world, nav_data, level_name)
		local nav_data_found = false
		local num_nav_data = LevelResource.navdata_count(level_name)

		for i = 1, num_nav_data, 1 do
			local nav_data_name, _ = LevelResource.navdata_resource(level_name, i)

			if Application.can_get_resource_id("navdata", nav_data_name) then
				nav_data[#nav_data + 1] = GwNavWorld.add_navdata(nav_world, nav_data_name)
				nav_data_found = true
			end
		end

		local num_nested_levels = LevelResource.nested_level_count(level_name)

		for i = 1, num_nested_levels, 1 do
			local nested_level_name = LevelResource.nested_level_resource_name(level_name, i)
			local result = Navigation.add_nav_data(nav_world, nav_data, nested_level_name)
			nav_data_found = nav_data_found or result
		end

		return nav_data_found
	end,
	vector3s_to_arrays = function (vectors)
		local arrays = {}

		for i = 1, #vectors, 1 do
			arrays[i] = {
				Vector3.to_elements(vectors[i])
			}
		end

		return arrays
	end,
	vector3s_from_arrays = function (arrays)
		local vectors = {}

		for i = 1, #arrays, 1 do
			vectors[i] = Vector3.from_array(arrays[i])
		end

		return vectors
	end
}

return Navigation
