-- chunkname: @scripts/managers/main_path/path_types/path_type_linear.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local PathTypeLinear = class("PathTypeLinear")

PathTypeLinear.init = function (self, world, nav_world, num_sides, is_server, use_nav_point_time_slice)
	self._world = world
	self._nav_world = nav_world

	local invalid_vector = Vector3.invalid_vector()
	local side_progress_on_path = Script.new_array(num_sides)

	for i = 1, num_sides do
		side_progress_on_path[i] = {
			behind_travel_changed_t = 0,
			forward_travel_changed_t = 0,
			furthest_travel_distance = 0,
			furthest_worst_travel_distance = 0,
			ahead_path_position = Vector3Box(invalid_vector),
			behind_path_position = Vector3Box(invalid_vector),
		}
	end

	self._side_progress_on_path = side_progress_on_path
	self._segment_index_by_unit = {}
	self._group_index_by_unit = {}
	self._previous_frame_group_index_by_unit = {}
end

PathTypeLinear.destroy = function (self)
	return
end

PathTypeLinear.ahead_unit = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local path_position = progress_on_path.ahead_unit and progress_on_path.ahead_path_position:unbox() or nil

	return progress_on_path.ahead_unit, progress_on_path.ahead_travel_distance, path_position
end

PathTypeLinear.behind_unit = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local path_position = progress_on_path.behind_unit and progress_on_path.behind_path_position:unbox() or nil

	return progress_on_path.behind_unit, progress_on_path.behind_travel_distance, path_position
end

PathTypeLinear.furthest_travel_distance = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]

	return progress_on_path.furthest_travel_distance
end

PathTypeLinear.furthest_travel_percentage = function (self, side_id)
	local furthest_travel_distance = self:furthest_travel_distance(side_id)
	local total_path_distance = MainPathQueries.total_path_distance()
	local percentage = furthest_travel_distance / total_path_distance

	return percentage
end

PathTypeLinear.time_since_forward_travel_changed = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local forward_travel_changed_t = progress_on_path.forward_travel_changed_t
	local t = Managers.time:time("gameplay")
	local diff = t - forward_travel_changed_t

	return diff
end

PathTypeLinear.time_since_behind_travel_changed = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local behind_travel_changed_t = progress_on_path.behind_travel_changed_t
	local t = Managers.time:time("gameplay")
	local diff = t - behind_travel_changed_t

	return diff
end

PathTypeLinear.segment_index_by_unit = function (self, unit)
	return self._segment_index_by_unit[unit]
end

PathTypeLinear.update_progress_on_path = function (self, t)
	local main_path_manager = Managers.state.main_path
	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local side_system = Managers.state.extension:system("side_system")
	local sides = side_system:sides()
	local segment_index_by_unit = self._segment_index_by_unit

	table.clear(segment_index_by_unit)

	self._group_index_by_unit, self._previous_frame_group_index_by_unit = self._previous_frame_group_index_by_unit, self._group_index_by_unit

	table.clear(self._group_index_by_unit)

	local group_index_by_unit, previous_frame_group_index_by_unit = self._group_index_by_unit, self._previous_frame_group_index_by_unit
	local side_progress_on_path = self._side_progress_on_path
	local invalid_vector = Vector3.invalid_vector()
	local nav_world = self._nav_world
	local num_sides = #sides

	for i = 1, num_sides do
		local ahead_unit, behind_unit
		local ahead_path_position, behind_path_position = invalid_vector, invalid_vector
		local best_travel_distance, worst_travel_distance = -math.huge, math.huge
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

			local start_index = main_path_manager:node_index_by_nav_group_index(group_index or 1)
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

		if best_travel_distance > progress_on_path.furthest_travel_distance then
			progress_on_path.furthest_travel_distance = best_travel_distance
			progress_on_path.forward_travel_changed_t = t
		end

		progress_on_path.behind_unit = behind_unit
		progress_on_path.behind_travel_distance = behind_unit and worst_travel_distance or nil

		progress_on_path.behind_path_position:store(behind_path_position)

		if worst_travel_distance > progress_on_path.furthest_worst_travel_distance then
			progress_on_path.furthest_worst_travel_distance = worst_travel_distance
			progress_on_path.behind_travel_changed_t = t
		end
	end
end

return PathTypeLinear
