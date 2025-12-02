-- chunkname: @scripts/managers/main_path/main_path_manager.lua

local Crossroad = require("scripts/managers/main_path/utilities/crossroad")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local MainPathManagerTestify = GameParameters.testify and require("scripts/managers/main_path/main_path_manager_testify")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MainPathSettings = require("scripts/settings/main_path/main_path_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local PATH_TYPES = {}

for name, class_file_name in pairs(MainPathSettings.path_types) do
	local class = require(class_file_name)

	PATH_TYPES[name] = class
end

local MainPathManager = class("MainPathManager")

MainPathManager.init = function (self, world, nav_world, level_seed, main_path_resource_name, path_type, num_sides, is_server, use_nav_point_time_slice)
	self._is_server = is_server
	self._path_type = path_type
	self._path = PATH_TYPES[path_type]:new(world, nav_world, num_sides, is_server, use_nav_point_time_slice)
	self._world = world
	self._nav_world = nav_world
	self._level_seed = level_seed

	if Application.can_get_resource("lua", main_path_resource_name) then
		local path_markers, crossroads, main_path_segments, main_path_version = self:_load_main_path_data(main_path_resource_name)

		if not table.is_empty(crossroads) then
			local chosen_crossroads = Crossroad.generate_road_choices(crossroads, level_seed)

			Crossroad.stitch_and_remove_unused_roads(crossroads, chosen_crossroads, main_path_segments, path_markers, level_seed)

			self._chosen_crossroads = chosen_crossroads
		end

		self:_calculate_travel_distances(main_path_segments)

		local num_main_path_segments = #main_path_segments
		local unified_path, unified_travel_distances, segment_lookup, _, breaks_order = MainPathQueries.generate_unified_main_path(main_path_segments)

		EngineOptimized.register_main_path(unified_path, unified_travel_distances, segment_lookup, num_main_path_segments)

		self.main_path_breaks_order = breaks_order
		self._path_markers, self._main_path_segments, self._main_path_version = path_markers, main_path_segments, main_path_version

		if use_nav_point_time_slice then
			local spawn_points_time_slice_data = {
				last_index = 0,
				ready = false,
			}

			self._spawn_points_time_slice_data = spawn_points_time_slice_data
		end
	end
end

MainPathManager.path_type = function (self)
	return self._path_type
end

MainPathManager.spawn_point_positions = function (self)
	return self._spawn_point_positions
end

MainPathManager.nav_spawn_points = function (self)
	return self._nav_spawn_points
end

MainPathManager._calculate_travel_distances = function (self, main_path_segments)
	local Vector3_distance = Vector3.distance
	local first_segment = main_path_segments[1]
	local p1 = first_segment.nodes[1]:unbox()
	local total_travel_distance, num_segments = 0, #main_path_segments

	for i = 1, num_segments do
		local segment = main_path_segments[i]
		local nodes = segment.nodes
		local p2 = nodes[1]:unbox()

		total_travel_distance = total_travel_distance + Vector3_distance(p1, p2)

		local travel_distances = {
			total_travel_distance,
		}
		local num_nodes = #nodes

		for j = 2, num_nodes do
			p1 = nodes[j - 1]:unbox()
			p2 = nodes[j]:unbox()
			total_travel_distance = total_travel_distance + Vector3_distance(p1, p2)
			travel_distances[j] = total_travel_distance
		end

		segment.travel_distances = travel_distances
		segment.path_length = travel_distances[num_nodes] - travel_distances[1]
		p1 = p2
	end
end

MainPathManager._load_main_path_data = function (self, main_path_resource_name)
	local main_path_data = dofile(main_path_resource_name)
	local path_markers = main_path_data.path_markers
	local num_path_markers = #path_markers

	for i = 1, num_path_markers do
		local path_marker = path_markers[i]
		local position_array = path_marker.position

		path_marker.position = Vector3Box(position_array[1], position_array[2], position_array[3])
	end

	local main_path_segments = main_path_data.main_path_segments
	local num_path_segments = #main_path_segments

	for i = 1, num_path_segments do
		local segment = main_path_segments[i]
		local nodes = segment.nodes
		local num_nodes = #nodes

		for j = 1, num_nodes do
			local position_array = nodes[j]

			nodes[j] = Vector3Box(position_array[1], position_array[2], position_array[3])
		end
	end

	return path_markers, main_path_data.crossroads, main_path_segments, main_path_data.version
end

MainPathManager.destroy = function (self)
	if self._main_path_version then
		self._main_path_version = nil

		EngineOptimized.unregister_main_path()

		if self._nav_spawn_points then
			GwNavSpawnPoints.destroy(self._nav_spawn_points)

			self._nav_spawn_points = nil

			GwNavTriangleGroup.destroy(self._nav_triangle_group)

			self._nav_triangle_group = nil

			GwNavTagLayerCostTable.destroy(self._spawn_point_cost_table)

			self._spawn_point_cost_table = nil
		end
	end

	self._path:destroy()
end

MainPathManager.crossroad_road_id = function (self, crossroads_id)
	local chosen_crossroads = self._chosen_crossroads
	local road_id = chosen_crossroads[crossroads_id]

	return road_id
end

MainPathManager.is_crossroad_segment_available = function (self, crossroads_id, road_id)
	local chosen_crossroads = self._chosen_crossroads
	local is_available = chosen_crossroads and chosen_crossroads[crossroads_id] == road_id

	return is_available
end

MainPathManager.is_main_path_available = function (self)
	return self._main_path_version ~= nil
end

MainPathManager.is_main_path_ready = function (self)
	return self._main_path_version ~= nil and self._nav_spawn_points ~= nil
end

MainPathManager.main_path_segments = function (self)
	return self._main_path_segments
end

MainPathManager.ahead_unit = function (self, side_id)
	return self._path:ahead_unit(side_id)
end

MainPathManager.behind_unit = function (self, side_id)
	return self._path:behind_unit(side_id)
end

MainPathManager.furthest_travel_distance = function (self, side_id)
	return self._path:furthest_travel_distance(side_id)
end

MainPathManager.furthest_travel_percentage = function (self, side_id)
	if not self:is_main_path_available() then
		return 1
	end

	return self._path:furthest_travel_percentage(side_id)
end

MainPathManager.time_since_forward_travel_changed = function (self, side_id)
	return self._path:time_since_forward_travel_changed(side_id)
end

MainPathManager.time_since_behind_travel_changed = function (self, side_id)
	return self._path:time_since_behind_travel_changed(side_id)
end

MainPathManager.segment_index_by_unit = function (self, unit)
	return self._path:segment_index_by_unit(unit)
end

MainPathManager.closest_main_path_position = function (self, position, return_on_no_index)
	return self._path:closest_main_path_position(position, return_on_no_index)
end

MainPathManager.travel_distance_from_position = function (self, position, return_on_no_index)
	return self._path:travel_distance_from_position(position, return_on_no_index)
end

MainPathManager.spawn_point_cost_table = function (self)
	return self._spawn_point_cost_table
end

MainPathManager.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local spawn_point_cost_table = self._spawn_point_cost_table

	if not spawn_point_cost_table then
		return
	end

	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(spawn_point_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(spawn_point_cost_table, layer_id)
	end
end

MainPathManager.on_gameplay_post_init = function (self)
	if self._main_path_version == nil then
		return
	end

	self:generate_spawn_points()
end

MainPathManager.generate_spawn_points = function (self)
	if not self._is_server then
		return
	end

	local nav_mesh_manager, nav_triangle_group_cost_table = Managers.state.nav_mesh, GwNavTagLayerCostTable.create()
	local triangle_group_forbidden_nav_tag_layers = MainPathSettings.triangle_group_forbidden_nav_tag_layers

	for i = 1, #triangle_group_forbidden_nav_tag_layers do
		local layer_name = triangle_group_forbidden_nav_tag_layers[i]
		local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_name)

		GwNavTagLayerCostTable.forbid_layer(nav_triangle_group_cost_table, layer_id)
	end

	local nav_world, triangle_group_distance, triangle_group_cutoff_values = self._nav_world, MainPathSettings.triangle_group_distance, MainPathSettings.triangle_group_cutoff_values
	local nav_triangle_group, debug_flood_fill_positions, group_to_main_path_index = SpawnPointQueries.generate_nav_triangle_group(nav_world, triangle_group_distance, triangle_group_cutoff_values, nav_triangle_group_cost_table)

	self._nav_triangle_group = nav_triangle_group

	self._path:generate_spawn_points(nav_triangle_group, group_to_main_path_index)
	GwNavTagLayerCostTable.destroy(nav_triangle_group_cost_table)

	local spawn_point_cost_table = GwNavTagLayerCostTable.create()

	nav_mesh_manager:initialize_nav_tag_cost_table(spawn_point_cost_table, {})

	local spawn_point_forbidden_nav_tag_volume_types = MainPathSettings.spawn_point_forbidden_nav_tag_volume_types

	for i = 1, #spawn_point_forbidden_nav_tag_volume_types do
		local volume_type = spawn_point_forbidden_nav_tag_volume_types[i]
		local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

		for j = 1, #layer_ids do
			GwNavTagLayerCostTable.forbid_layer(spawn_point_cost_table, layer_ids[j])
		end
	end

	self._spawn_point_cost_table = spawn_point_cost_table

	local parameters = {
		num_spawn_points = 0,
		nav_world = nav_world,
		min_free_radius = MainPathSettings.spawn_point_min_free_radius,
		min_distance_to_others = MainPathSettings.spawn_point_min_distance_to_others,
		num_spawn_points_per_subgroup = MainPathSettings.num_spawn_points_per_subgroup,
		num_spawn_points_per_triangle = MainPathSettings.num_spawn_points_per_triangle,
		nav_tag_cost_table = spawn_point_cost_table,
		seed = self._level_seed,
		path_type = self._path_type,
	}

	if self._spawn_points_time_slice_data then
		self:_init_time_slice_nav_points(nav_world, nav_triangle_group, parameters)
	else
		self._nav_spawn_points, self._spawn_point_positions = SpawnPointQueries.generate_nav_spawn_points(nav_world, nav_triangle_group, parameters)
	end
end

MainPathManager._init_time_slice_nav_points = function (self, nav_world, nav_triangle_group, parameters)
	local spawn_points_time_slice_data = self._spawn_points_time_slice_data
	local nav_spawn_points = GwNavSpawnPoints.create(nav_world, nav_triangle_group)
	local num_groups, num_sub_groups = GwNavSpawnPoints.get_count(nav_spawn_points)

	self._nav_spawn_points = nav_spawn_points
	self._spawn_point_positions = Script.new_array(num_groups)
	spawn_points_time_slice_data.last_index = 0
	spawn_points_time_slice_data.ready = false
	parameters.num_groups = num_groups
	parameters.num_sub_groups = num_sub_groups
	spawn_points_time_slice_data.parameters = parameters
end

MainPathManager.update_time_slice_spawn_points = function (self)
	if self._main_path_version == nil or not self._is_server then
		return true
	end

	local time_slice_data = self._spawn_points_time_slice_data
	local done = SpawnPointQueries.update_time_slice_nav_spawn_points(time_slice_data, self._nav_spawn_points, self._spawn_point_positions)

	return done
end

MainPathManager.update_time_slice_generate_occluded_points = function (self)
	if self._main_path_version == nil or not self._is_server then
		return true
	end

	local nav_spawn_points = self._nav_spawn_points
	local occluded_points_collision_filter = MainPathSettings.occluded_points_collision_filter
	local done = GwNavSpawnPoints.generate_occluded_points(nav_spawn_points, self._nav_world, self._world, occluded_points_collision_filter, GameplayInitTimeSlice.MAX_DT_IN_SEC)

	if done then
		self._spawn_points_time_slice_data.ready = true

		Managers.state.pacing:on_spawn_points_generated()
		Managers.state.mutator:on_spawn_points_generated()
	end

	return done
end

MainPathManager.update = function (self, dt, t)
	if self._main_path_version == nil then
		return
	end

	if self._nav_spawn_points then
		self._path:update_progress_on_path(t)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MainPathManagerTestify, self)
	end
end

MainPathManager.find_isolated_islands = function (self)
	local nav_blocker_units = _fetch_level_nav_blocker_units(self._world, self._debug_level_name)

	return SpawnPointQueries.find_isolated_islands(self._nav_world, self._nav_spawn_points, nav_blocker_units)
end

return MainPathManager
