-- chunkname: @scripts/managers/main_path/path_types/path_type_open.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local PathTypeOpen = class("PathTypeOpen")

PathTypeOpen.init = function (self, world, nav_world, num_sides, is_server, use_nav_point_time_slice)
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
	self._travel_distance_by_side = {}
	self._last_travel_distance_update_by_side = {}
	self._last_position_by_side = {}
	self._segment_index_by_unit = {}
end

PathTypeOpen.destroy = function (self)
	return
end

PathTypeOpen.ahead_unit = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local position = progress_on_path.ahead_unit and progress_on_path.ahead_path_position:unbox() or nil

	return progress_on_path.ahead_unit, progress_on_path.ahead_travel_distance, position
end

PathTypeOpen.behind_unit = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local position = progress_on_path.behind_unit and progress_on_path.behind_path_position:unbox() or nil

	return progress_on_path.behind_unit, progress_on_path.behind_travel_distance, position
end

PathTypeOpen.furthest_travel_distance = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]

	return progress_on_path.furthest_travel_distance
end

PathTypeOpen.furthest_travel_percentage = function (self, side_id)
	local furthest_travel_distance = self:furthest_travel_distance(side_id)
	local total_map_distance = 1000
	local percentage = furthest_travel_distance / total_map_distance

	return percentage
end

PathTypeOpen.time_since_forward_travel_changed = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local forward_travel_changed_t = progress_on_path.forward_travel_changed_t
	local t = Managers.time:time("gameplay")
	local diff = t - forward_travel_changed_t

	return diff
end

PathTypeOpen.time_since_behind_travel_changed = function (self, side_id)
	local side_progress_on_path = self._side_progress_on_path
	local progress_on_path = side_progress_on_path[side_id]
	local behind_travel_changed_t = progress_on_path.behind_travel_changed_t
	local t = Managers.time:time("gameplay")
	local diff = t - behind_travel_changed_t

	return diff
end

PathTypeOpen.segment_index_by_unit = function (self, unit)
	return self._segment_index_by_unit[unit]
end

PathTypeOpen.closest_main_path_position = function (self, position, return_on_no_index)
	return MainPathQueries.closest_position(position)
end

PathTypeOpen.travel_distance_from_position = function (self, position, return_on_no_index)
	local side_system = Managers.state.extension:system("side_system")
	local hero_side = side_system:get_side_from_name("heroes")
	local hero_progress_position = self._last_position_by_side[hero_side] and self._last_position_by_side[hero_side]:unbox()

	if not hero_progress_position then
		return 0
	end

	return (self._travel_distance_by_side[hero_side] or 0) + Vector3.distance(hero_progress_position, position)
end

PathTypeOpen.generate_spawn_points = function (self, nav_triangle_group, group_to_main_path_index)
	return
end

PathTypeOpen.update_progress_on_path = function (self, t)
	local side_system = Managers.state.extension:system("side_system")
	local sides = side_system:sides()
	local segment_index_by_unit = self._segment_index_by_unit

	table.clear(segment_index_by_unit)

	local side_progress_on_path = self._side_progress_on_path
	local invalid_vector = Vector3.invalid_vector()
	local num_sides = #sides

	for i = 1, num_sides do
		local ahead_unit, behind_unit
		local ahead_path_position, behind_path_position = invalid_vector, invalid_vector
		local best_travel_distance, worst_travel_distance = -math.huge, math.huge
		local side = sides[i]
		local valid_player_units = side.valid_player_units
		local num_valid_player_units = #valid_player_units
		local side_travel_distance = self._travel_distance_by_side[i] or 0
		local old_progress_position = self._last_position_by_side[i] and self._last_position_by_side[i]:unbox()
		local progress_position
		local time_since_update = t - (self._last_travel_distance_update_by_side[i] or -math.huge)

		if num_valid_player_units > 0 and time_since_update > 2.5 then
			progress_position = Vector3.zero()

			for j = 1, num_valid_player_units do
				local player_unit = valid_player_units[j]

				progress_position = progress_position + POSITION_LOOKUP[player_unit]
			end

			progress_position = progress_position / num_valid_player_units

			if old_progress_position then
				side_travel_distance = side_travel_distance + Vector3.distance(progress_position, old_progress_position)
			end

			self._travel_distance_by_side[i] = side_travel_distance
			self._last_position_by_side[i] = Vector3Box(progress_position)
			self._last_travel_distance_update_by_side[i] = t
		end

		progress_position = progress_position or old_progress_position

		for j = 1, num_valid_player_units do
			local player_unit = valid_player_units[j]
			local player_position = POSITION_LOOKUP[player_unit]
			local travel_distance = side_travel_distance + Vector3.distance(player_position, progress_position)

			if best_travel_distance < travel_distance then
				ahead_unit = player_unit
				ahead_path_position = player_position
				best_travel_distance = travel_distance
			end

			if travel_distance < worst_travel_distance then
				behind_unit = player_unit
				behind_path_position = player_position
				worst_travel_distance = travel_distance
			end

			segment_index_by_unit[player_unit] = 1
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

return PathTypeOpen
