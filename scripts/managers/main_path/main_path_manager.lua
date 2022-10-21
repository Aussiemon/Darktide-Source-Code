local Crossroad = require("scripts/managers/main_path/utilities/crossroad")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local MainPathManagerTestify = GameParameters.testify and require("scripts/managers/main_path/main_path_manager_testify")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local MainPathManager = class("MainPathManager")
local WANTED_MAIN_PATH_VERSION = "1.00"
local TRIANGLE_GROUP_DISTANCE = 10
local TRIANGLE_GROUP_CUTOFF_VALUES = {
	25,
	50,
	75
}
local SPAWN_POINT_MIN_FREE_RADIUS = 0.5
local SPAWN_POINT_MIN_DISTANCE_TO_OTHERS = 1.5
local SPAWN_POINT_FORBIDDEN_NAV_TAG_VOLUME_TYPES = {
	"content/volume_types/nav_tag_volumes/no_spawn"
}
local NUM_SPAWNPOINTS_PER_SUBGROUP = 20
local OCCLUDED_POINTS_COLLISION_FILTER = "filter_minion_line_of_sight_check"

MainPathManager.init = function (self, world, nav_world, level_name, level_seed, num_sides, is_server, use_nav_point_time_slice)
	self._is_server = is_server
	local main_path_resource_name = level_name .. "_main_path"

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
		self._main_path_version = main_path_version
		self._main_path_segments = main_path_segments
		self._path_markers = path_markers
		local invalid_vector = Vector3.invalid_vector()
		local side_progress_on_path = Script.new_array(num_sides)

		for i = 1, num_sides do
			side_progress_on_path[i] = {
				furthest_travel_distance = 0,
				ahead_path_position = Vector3Box(invalid_vector),
				behind_path_position = Vector3Box(invalid_vector)
			}
		end

		self._side_progress_on_path = side_progress_on_path
		self._segment_index_by_unit = {}
		self._group_index_by_unit = {}
		self._previous_frame_group_index_by_unit = {}
		self._world = world
		self._nav_world = nav_world
		self._level_seed = level_seed

		if use_nav_point_time_slice then
			local spawn_points_time_slice_data = {
				last_index = 0,
				ready = false,
				parameters = {}
			}
			self._spawn_points_time_slice_data = spawn_points_time_slice_data
		end
	end
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
	local total_travel_distance = 0
	local num_segments = #main_path_segments

	for i = 1, num_segments do
		local segment = main_path_segments[i]
		local nodes = segment.nodes
		local p2 = nodes[1]:unbox()
		total_travel_distance = total_travel_distance + Vector3_distance(p1, p2)
		local travel_distances = {
			total_travel_distance
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
		EngineOptimized.unregister_main_path()

		if self._nav_spawn_points then
			GwNavSpawnPoints.destroy(self._nav_spawn_points)
			GwNavTriangleGroup.destroy(self._nav_triangle_group)
			GwNavTagLayerCostTable.destroy(self._spawn_point_cost_table)
		end
	end
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
	fassert(self._is_server, "[MainPathManager] Only server should call is_main_path_ready.")

	return self._main_path_version ~= nil and self._nav_spawn_points ~= nil
end

MainPathManager.main_path_segments = function (self)
	return self._main_path_segments
end

MainPathManager.ahead_unit = function (self, side_id)
	assert(self._is_server, "Only server should call main path ahead_unit")

	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local path_position = progress_on_path.ahead_unit and progress_on_path.ahead_path_position:unbox() or nil

	return progress_on_path.ahead_unit, progress_on_path.ahead_travel_distance, path_position
end

MainPathManager.behind_unit = function (self, side_id)
	assert(self._is_server, "Only server should call main path behind_unit")

	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local path_position = progress_on_path.behind_unit and progress_on_path.behind_path_position:unbox() or nil

	return progress_on_path.behind_unit, progress_on_path.behind_travel_distance, path_position
end

MainPathManager.furthest_travel_distance = function (self, side_id)
	assert(self._is_server, "Only server should call furthest travel distance")

	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]

	return progress_on_path.furthest_travel_distance
end

MainPathManager.furthest_travel_percentage = function (self, side_id)
	assert(self._is_server, "Only server should call furthest travel percentage")

	local furthest_travel_distance = self:furthest_travel_distance(side_id)
	local total_path_distance = MainPathQueries.total_path_distance()
	local percentage = furthest_travel_distance / total_path_distance

	return percentage
end

MainPathManager.segment_index_by_unit = function (self, unit)
	assert(self._is_server, "Only server should call segment_index_by_unit")

	return self._segment_index_by_unit[unit]
end

MainPathManager.node_index_by_nav_group_index = function (self, group_index)
	assert(self._is_server, "Only server should call node_index_by_nav_group_index")

	return self._group_to_main_path_index[group_index]
end

MainPathManager.spawn_point_cost_table = function (self)
	assert(self._is_server, "Only server should call segment_index_by_unit")

	return self._spawn_point_cost_table
end

MainPathManager.on_gameplay_post_init = function (self)
	if self._main_path_version == nil then
		return
	end

	if self._is_server then
		self:_generate_spawn_points()
	end
end

MainPathManager._generate_spawn_points = function (self)
	local world = self._world
	local nav_world = self._nav_world
	local nav_triangle_group, debug_flood_fill_positions, group_to_main_path_index = SpawnPointQueries.generate_nav_triangle_group(nav_world, TRIANGLE_GROUP_DISTANCE, TRIANGLE_GROUP_CUTOFF_VALUES)
	self._nav_triangle_group = nav_triangle_group
	self._group_to_main_path_index = group_to_main_path_index
	local nav_mesh_manager = Managers.state.nav_mesh
	local spawn_point_cost_table = GwNavTagLayerCostTable.create()

	for i = 1, #SPAWN_POINT_FORBIDDEN_NAV_TAG_VOLUME_TYPES do
		local volume_type = SPAWN_POINT_FORBIDDEN_NAV_TAG_VOLUME_TYPES[i]
		local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

		for j = 1, #layer_ids do
			GwNavTagLayerCostTable.forbid_layer(spawn_point_cost_table, layer_ids[j])
		end
	end

	local allowed_layers = nav_mesh_manager:allowed_nav_tag_layers()

	for layer_name, allowed in pairs(allowed_layers) do
		if not allowed then
			local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_name)

			GwNavTagLayerCostTable.forbid_layer(spawn_point_cost_table, layer_id)
		end
	end

	self._spawn_point_cost_table = spawn_point_cost_table

	if self._spawn_points_time_slice_data then
		self:_init_time_slice_nav_points(nav_world, nav_triangle_group, SPAWN_POINT_MIN_FREE_RADIUS, SPAWN_POINT_MIN_DISTANCE_TO_OTHERS, NUM_SPAWNPOINTS_PER_SUBGROUP, spawn_point_cost_table, self._level_seed)
	else
		self._nav_spawn_points, self._spawn_point_positions = SpawnPointQueries.generate_nav_spawn_points(nav_world, nav_triangle_group, SPAWN_POINT_MIN_FREE_RADIUS, SPAWN_POINT_MIN_DISTANCE_TO_OTHERS, NUM_SPAWNPOINTS_PER_SUBGROUP, spawn_point_cost_table, self._level_seed)
	end
end

MainPathManager._init_time_slice_nav_points = function (self, nav_world, nav_triangle_group, min_free_radius, min_distance_to_others, num_spawn_points_per_subgroup, nav_tag_cost_table, start_seed)
	local spawn_points_time_slice_data = self._spawn_points_time_slice_data

	fassert(spawn_points_time_slice_data, "[MainPathManager] Instantiate class with 'use_time_slice'")

	local nav_spawn_points = GwNavSpawnPoints.create(nav_world, nav_triangle_group)
	self._nav_spawn_points = nav_spawn_points
	self._spawn_point_positions = {}
	spawn_points_time_slice_data.last_index = 0
	spawn_points_time_slice_data.ready = false
	spawn_points_time_slice_data.parameters.nav_world = nav_world
	spawn_points_time_slice_data.parameters.min_free_radius = min_free_radius
	spawn_points_time_slice_data.parameters.min_distance_to_others = min_distance_to_others
	spawn_points_time_slice_data.parameters.num_spawn_points_per_subgroup = num_spawn_points_per_subgroup
	spawn_points_time_slice_data.parameters.nav_tag_cost_table = nav_tag_cost_table
	local num_groups, num_sub_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	spawn_points_time_slice_data.parameters.num_groups = num_groups
	spawn_points_time_slice_data.parameters.num_sub_groups = num_sub_groups
	spawn_points_time_slice_data.parameters.spawn_point_positions = Script.new_array(num_groups)
	spawn_points_time_slice_data.parameters.num_spawn_points = 0
	spawn_points_time_slice_data.parameters.seed = start_seed
end

MainPathManager.update_time_slice_spawn_points = function (self)
	if self._main_path_version == nil or not self._is_server then
		return true
	end

	local time_slice_data = self._spawn_points_time_slice_data

	fassert(time_slice_data, "[MainPathManager] Instantiate class with 'use_time_slice'")

	local done = SpawnPointQueries.update_time_slice_nav_spawn_points(time_slice_data, self._nav_spawn_points, self._spawn_point_positions)

	return done
end

MainPathManager.update_time_slice_generate_occluded_points = function (self)
	if self._main_path_version == nil or not self._is_server then
		return true
	end

	local nav_spawn_points = self._nav_spawn_points

	fassert(nav_spawn_points, "[MainPathManager] Missing init step: [on_gameplay_post_init() -> _generate_spawn_points()]")

	local done = GwNavSpawnPoints.generate_occluded_points(nav_spawn_points, self._nav_world, self._world, OCCLUDED_POINTS_COLLISION_FILTER, GameplayInitTimeSlice.MAX_DT_IN_SEC)

	if done then
		Managers.state.pacing:on_spawn_points_generated()
	end

	return done
end

MainPathManager.update = function (self, dt, t)
	if self._main_path_version == nil then
		return
	end

	if self._nav_spawn_points then
		self:_update_progress_on_path()
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MainPathManagerTestify, self)
	end
end

MainPathManager._update_progress_on_path = function (self)
	local side_system = Managers.state.extension:system("side_system")
	local sides = side_system:sides()
	local segment_index_by_unit = self._segment_index_by_unit

	table.clear(segment_index_by_unit)

	self._previous_frame_group_index_by_unit = self._group_index_by_unit
	self._group_index_by_unit = self._previous_frame_group_index_by_unit

	table.clear(self._group_index_by_unit)

	local group_index_by_unit = self._group_index_by_unit
	local previous_frame_group_index_by_unit = self._previous_frame_group_index_by_unit
	local side_progress_on_path = self._side_progress_on_path
	local invalid_vector = Vector3.invalid_vector()
	local nav_world = self._nav_world
	local nav_spawn_points = self._nav_spawn_points
	local num_sides = #sides

	for i = 1, num_sides do
		local ahead_unit, behind_unit = nil
		local ahead_path_position = invalid_vector
		local behind_path_position = invalid_vector
		local best_travel_distance = -math.huge
		local worst_travel_distance = math.huge
		local side = sides[i]
		local valid_player_units = side.valid_player_units
		local num_valid_player_units = #valid_player_units

		for j = 1, num_valid_player_units do
			local player_unit = valid_player_units[j]
			local player_position = POSITION_LOOKUP[player_unit]
			local group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, player_position)

			if not group_index then
				local navigation_extension = ScriptUnit.extension(player_unit, "navigation_system")
				local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()

				if latest_position_on_nav_mesh then
					group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, latest_position_on_nav_mesh)
				end

				group_index = group_index or previous_frame_group_index_by_unit[player_unit]
			end

			local start_index = self:node_index_by_nav_group_index(group_index or 1)
			local end_index = start_index + 1
			local path_position, travel_distance, _, _, segment_index = MainPathQueries.closest_position_between_nodes(player_position, start_index, end_index)

			if best_travel_distance < travel_distance then
				ahead_unit = player_unit
				ahead_path_position = path_position
				best_travel_distance = travel_distance
			end

			if travel_distance < worst_travel_distance then
				behind_unit = player_unit
				behind_path_position = path_position
				worst_travel_distance = travel_distance
			end

			segment_index_by_unit[player_unit] = segment_index
			group_index_by_unit[player_unit] = group_index
		end

		local progress_on_path = side_progress_on_path[i]
		progress_on_path.ahead_unit = ahead_unit
		progress_on_path.ahead_travel_distance = ahead_unit and best_travel_distance or nil

		progress_on_path.ahead_path_position:store(ahead_path_position)

		progress_on_path.behind_unit = behind_unit
		progress_on_path.behind_travel_distance = behind_unit and worst_travel_distance or nil

		progress_on_path.behind_path_position:store(behind_path_position)

		if progress_on_path.furthest_travel_distance < best_travel_distance then
			progress_on_path.furthest_travel_distance = best_travel_distance
		end
	end
end

return MainPathManager
