-- chunkname: @scripts/extension_systems/navigation/flying_search_engine.lua

local FlyingNavPath = require("scripts/extension_systems/navigation/flying_nav_path")
local FlyingNavPathUtility = require("scripts/extension_systems/navigation/utilities/flying_nav_path_utility")
local FlyingSearchEngine = class("FlyingSearchEngine")
local State = table.enum("find_navmesh", "traversal", "trace_path", "string_pulling", "smooth_curves", "raw_path")
local TraverseResult = table.enum("ongoing", "success", "failure", "same_cell")

FlyingSearchEngine.init = function (self, shared_svo, from, to, radius)
	self._from = Vector3Box(from)
	self._to = Vector3Box(to)
	self._state = State.find_navmesh
	self._path = nil
	self._radius = radius
	self._nav_svo = shared_svo
	self._step_size = shared_svo:high_precision()
	self._num_step_levels = 3
	self._step_data = {}
	self._points = {
		{
			from[1],
			from[2],
			from[3],
		},
	}

	local bounds = shared_svo:bounds()
	local max_bound = math.max(bounds[1], bounds[2], bounds[3])

	self._max_f = max_bound * 4
	self._query_margin = 0.5
	self._debug_draw_voxels = {}
end

FlyingSearchEngine.step = function (self, timer, budget)
	local step_data = self._step_data
	local search_complete, success

	if self._state == State.traversal then
		local result, astar_data_or_nil = self:_traverse(step_data, timer, budget)

		if result ~= TraverseResult.ongoing then
			if result == TraverseResult.success then
				self._state = State.trace_path
				step_data.trace_path = astar_data_or_nil
			elseif result == TraverseResult.same_cell then
				self._state = State.raw_path
			else
				search_complete, success = true, false
			end
		end
	elseif self._state == State.trace_path then
		local done = self:_trace_path(step_data, timer, budget)

		if done then
			self._state = State.string_pulling
		end
	elseif self._state == State.string_pulling then
		local done, points = self:_string_pull(step_data, timer, budget)

		if done then
			self._points = points
			self._state = State.smooth_curves
		end
	elseif self._state == State.smooth_curves then
		local done, points = self:_smooth_curves(step_data, timer, budget)

		if done then
			self._path = FlyingNavPath:new(points, self._max_speed)
			search_complete, success = true, true
		end
	elseif self._state == State.find_navmesh then
		local done = self:_find_navmesh(step_data, timer, budget)

		if done then
			self._state = State.traversal
		end
	elseif self._state == State.raw_path then
		local points

		success, points = self:_try_raw_path()

		if success then
			self._path = FlyingNavPath:new(points, self._max_speed)
		end

		search_complete = true
	end

	return search_complete, success
end

FlyingSearchEngine.claim_result = function (self)
	return self._path
end

FlyingSearchEngine._query_position = function (self, position)
	return self._nav_svo:overlap_sphere(position, self._radius + self._query_margin)
end

FlyingSearchEngine._find_navmesh = function (self, step_data, timer, budget)
	if not step_data.find_navmesh_begun then
		step_data.find_navmesh_begun = true

		local layer = 0

		step_data.layer = layer
		step_data.x = -layer
		step_data.y = -layer
		step_data.z = -layer
		step_data.pos = {}
		step_data.from_found = false
	end

	local Application_time_since_query = Application.time_since_query
	local reference_position = not step_data.from_found and self._from:unbox() or self._to:unbox()
	local pos = step_data.pos
	local step_size = self._step_size
	local collides
	local layer = step_data.layer

	for x = step_data.x, layer do
		for y = step_data.y, layer do
			for z = step_data.z, layer do
				if budget <= Application_time_since_query(timer) and (x ~= step_data.x or y ~= step_data.y or z ~= step_data.z) then
					step_data.x = x
					step_data.y = y
					step_data.z = z

					return false, nil
				end

				pos[1] = reference_position[1] + x * step_size
				pos[2] = reference_position[2] + y * step_size
				pos[3] = reference_position[3] + z * step_size

				local pos_as_v3 = Vector3(pos[1], pos[2], pos[3])

				collides = self:_query_position(pos_as_v3)

				if not collides then
					if step_data.from_found then
						table.clear(step_data)
						self._to:store(pos_as_v3)

						return true
					end

					step_data.from_found = true
					step_data.x = -layer
					step_data.y = -layer
					step_data.z = -layer

					if x ~= 0 or y ~= 0 or z ~= 0 then
						self._points[2] = {
							pos[1],
							pos[2],
							pos[3],
						}
					end

					return false
				end
			end
		end
	end

	step_data.layer = step_data.layer + 1

	return false
end

local CELL_X, CELL_Y, CELL_Z = 1, 2, 3
local CELL_REAL_X, CELL_REAL_Y, CELL_REAL_Z = 4, 5, 6
local CELL_F, CELL_G = 7, 8
local CELL_DIR_IDX = 9
local CELL_HASH = 10
local CELL_PARENT_HASH = 11
local _a_star_search, _create_cell, _push_to_open_list, _pop_from_open_list, _mark_visited, _is_visited, _is_blocked, _is_valid, _is_destination, _calculate_h_value

FlyingSearchEngine._traverse = function (self, step_data, timer, budget)
	if not step_data.traversal_begun then
		step_data.traversal_begun = true

		local from = self._points[#self._points]
		local to = self._to:unbox()
		local real_to_x, real_to_y, real_to_z = to[1], to[2], to[3]
		local diff_x, diff_y, diff_z = from[1] - real_to_x, from[2] - real_to_y, from[3] - real_to_z
		local step_size = self._step_size
		local to_x, to_y, to_z = 0, 0, 0
		local dist = (diff_x^2 + diff_y^2 + diff_z^2)^0.5
		local from_x, from_y, from_z = self._nav_svo:clamp_coord(0, math.ceil(-dist / step_size), 0)

		if from_x == to_x and from_y == to_y and from_z == to_z then
			return TraverseResult.same_cell, nil
		end

		local clamped_dist = math.abs(from_y) * step_size

		diff_x, diff_y, diff_z = diff_x / dist * clamped_dist, diff_y / dist * clamped_dist, diff_z / dist * clamped_dist

		local real_from_x, real_from_y, real_from_z = real_to_x + diff_x, real_to_y + diff_y, real_to_z + diff_z
		local dir_x, dir_y, dir_z = real_to_x - real_from_x, real_to_y - real_from_y, real_to_z - real_from_z

		do
			local inv_len = 1 / (dir_x^2 + dir_y^2 + dir_z^2)^0.5

			dir_x = dir_x * inv_len
			dir_y = dir_y * inv_len
			dir_z = dir_z * inv_len
		end

		local function _cross(x1, y1, z1, x2, y2, z2)
			return y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2
		end

		local function _normalize(x, y, z)
			local inv_len = 1 / (x^2 + y^2 + z^2)^0.5

			return x * inv_len, y * inv_len, z * inv_len
		end

		local function _negate(x, y, z)
			return -x, -y, -z
		end

		local ref_x, ref_y, ref_z = 0, 0, 0

		if dir_x + dir_y > 1e-06 then
			ref_z = 1
		else
			ref_x = 1
		end

		local right, right_coord = {
			_normalize(_cross(dir_x, dir_y, dir_z, ref_x, ref_y, ref_z)),
		}, {
			1,
			0,
			0,
		}
		local left, left_coord = {
			_negate(unpack(right)),
		}, {
			-1,
			0,
			0,
		}
		local up, up_coord = {
			_cross(dir_x, dir_y, dir_z, unpack(right)),
		}, {
			0,
			0,
			1,
		}
		local down, down_coord = {
			_negate(unpack(up)),
		}, {
			0,
			0,
			-1,
		}
		local forward, forward_coord = {
			dir_x,
			dir_y,
			dir_z,
		}, {
			0,
			1,
			0,
		}
		local back, back_coord = {
			-dir_x,
			-dir_y,
			-dir_z,
		}, {
			0,
			-1,
			0,
		}
		local dirs = {
			forward,
			right,
			left,
			up,
			down,
			back,
		}
		local coord_dirs = {
			forward_coord,
			right_coord,
			left_coord,
			up_coord,
			down_coord,
			back_coord,
		}
		local astar_data = {
			nav_svo = self._nav_svo,
			from_pos = {
				real_from_x,
				real_from_y,
				real_from_z,
			},
			to_coord = {
				to_x,
				to_y,
				to_z,
			},
			to_pos = {
				real_to_x,
				real_to_y,
				real_to_z,
			},
			closed_list = {},
			seen_list = {},
			open_list = {},
			radius = self._radius,
			dirs = dirs,
			coord_dirs = coord_dirs,
			step_size = step_size,
			num_step_levels = self._num_step_levels,
		}

		step_data.astar_data = astar_data

		local initial_cell = _create_cell(astar_data, from_x, from_y, from_z, real_from_x, real_from_y, real_from_z, 0, 0, 0, nil)

		_push_to_open_list(astar_data, initial_cell)
	end

	local astar_data = step_data.astar_data
	local result, resulting_astar_data = _a_star_search(astar_data, timer, budget)

	if result ~= TraverseResult.ongoing then
		table.clear(step_data)

		return result, resulting_astar_data
	end

	return TraverseResult.ongoing, nil
end

function _push_to_open_list(astar_data, cell)
	local list = astar_data.open_list
	local list_size = #list + 1

	list[list_size] = cell

	local i = list_size

	while i > 1 do
		local parent = math.floor(i / 2)

		if list[i][CELL_F] >= list[parent][CELL_F] then
			break
		end

		list[i], list[parent] = list[parent], list[i]
		i = parent
	end
end

function _pop_from_open_list(astar_data)
	local list = astar_data.open_list

	if not next(list) then
		return nil
	end

	local list_size = #list
	local min = list[1]

	list[1] = list[list_size]

	table.remove(list)

	list_size = list_size - 1

	local i = 1

	while true do
		local left = i * 2
		local right = i * 2 + 1
		local smallest = i

		if left <= list_size and list[left][CELL_F] < list[smallest][CELL_F] then
			smallest = left
		end

		if right <= list_size and list[right][CELL_F] < list[smallest][CELL_F] then
			smallest = right
		end

		if smallest == i then
			break
		end

		list[i], list[smallest] = list[smallest], list[i]
		i = smallest
	end

	return min
end

function _a_star_search(astar_data, timer, budget)
	local dirs = astar_data.dirs
	local coord_dirs = astar_data.coord_dirs
	local base_step_size = astar_data.step_size
	local num_step_levels = astar_data.num_step_levels
	local to_pos = astar_data.to_pos
	local real_to_x, real_to_y, real_to_z = to_pos[1], to_pos[2], to_pos[3]
	local Application_time_since_query = Application.time_since_query
	local found
	local cell = _pop_from_open_list(astar_data)

	while cell do
		local x, y, z = cell[CELL_X], cell[CELL_Y], cell[CELL_Z]
		local real_x, real_y, real_z = cell[CELL_REAL_X], cell[CELL_REAL_Y], cell[CELL_REAL_Z]

		_mark_visited(astar_data, x, y, z, cell)

		for i = 1, 6 do
			local dir = coord_dirs[i]
			local move_dir = dirs[i]

			for step_i = num_step_levels, 1, -1 do
				local step = 2^step_i
				local step_size = base_step_size * step
				local new_real_x, new_real_y, new_real_z = real_x + move_dir[1] * step_size, real_y + move_dir[2] * step_size, real_z + move_dir[3] * step_size
				local dist_sq = (new_real_x - real_to_x)^2 + (new_real_y - real_to_y)^2 + (new_real_z - real_to_z)^2
				local new_x, new_y, new_z = x + dir[1] * step, y + dir[2] * step, z + dir[3] * step

				if dist_sq < step_size^2 then
					step_size = dist_sq^0.5
					new_x, new_y, new_z = 0, 0, 0
					new_real_x, new_real_y, new_real_z = to_pos[1], to_pos[2], to_pos[3]
				end

				if not _is_visited(astar_data, new_x, new_y, new_z) and _is_valid(astar_data, new_x, new_y, new_z) and not _is_blocked(astar_data, real_x, real_y, real_z, new_real_x, new_real_y, new_real_z) then
					if _is_destination(astar_data, new_x, new_y, new_z) then
						found = true
						astar_data.found = _create_cell(astar_data, new_x, new_y, new_z, new_real_x, new_real_y, new_real_z, 0, 0, i, cell[CELL_HASH])

						table.clear(astar_data.open_list)

						do break end
						break
					end

					do
						local g = cell[CELL_G] + step_size / step_i
						local h = _calculate_h_value(new_real_x, new_real_y, new_real_z, real_to_x, real_to_y, real_to_z)
						local f = g + h
						local cell_or_nil = _create_cell(astar_data, new_x, new_y, new_z, new_real_x, new_real_y, new_real_z, f, g, i, cell[CELL_HASH])

						_push_to_open_list(astar_data, cell_or_nil)
					end

					break
				end
			end

			if found then
				break
			end
		end

		if found then
			break
		end

		if budget <= Application_time_since_query(timer) then
			return TraverseResult.ongoing, nil
		end

		cell = _pop_from_open_list(astar_data)
	end

	if found then
		return TraverseResult.success, astar_data
	elseif not cell then
		return TraverseResult.failure, nil
	end

	return TraverseResult.ongoing, nil
end

function _create_cell(astar_data, x, y, z, real_x, real_y, real_z, f, g, dir_idx, parent_hash)
	local hash = astar_data.nav_svo:hash_coordinate(x, y, z)
	local cell = {
		x,
		y,
		z,
		real_x,
		real_y,
		real_z,
		f,
		g,
		dir_idx,
		hash,
		parent_hash,
	}

	astar_data.seen_list[hash] = cell

	return cell
end

function _mark_visited(astar_data, x, y, z, cell)
	local hash = astar_data.nav_svo:hash_coordinate(x, y, z)

	astar_data.closed_list[hash] = cell
end

function _is_visited(astar_data, x, y, z)
	local hash = astar_data.nav_svo:hash_coordinate(x, y, z)

	return astar_data.closed_list[hash]
end

function _is_valid(astar_data, x, y, z)
	return astar_data.nav_svo:is_valid_coordinate(x, y, z)
end

function _is_blocked(astar_data, from_x, from_y, from_z, to_x, to_y, to_z)
	local radius = astar_data.radius

	return astar_data.nav_svo:overlap_capsule(Vector3(from_x, from_y, from_z), Vector3(to_x, to_y, to_z), radius)
end

function _is_destination(astar_data, x, y, z)
	local to_coord = astar_data.to_coord

	return to_coord[1] == x and to_coord[2] == y and to_coord[3] == z
end

function _calculate_h_value(x, y, z, to_x, to_y, to_z)
	return ((x - to_x)^2 + (y - to_y)^2 + (z - to_z)^2)^0.5
end

FlyingSearchEngine._trace_path = function (self, step_data)
	local trace_path = step_data.trace_path
	local hash = trace_path.found[CELL_HASH]
	local temp_points = {}
	local temp_n_points = 0
	local last_dir_idx

	repeat
		local cell = trace_path.seen_list[hash]
		local dir_idx = cell[CELL_DIR_IDX]
		local pos_x, pos_y, pos_z = cell[CELL_REAL_X], cell[CELL_REAL_Y], cell[CELL_REAL_Z]

		if dir_idx == last_dir_idx and temp_n_points > 1 then
			local prev_point = temp_points[temp_n_points]

			prev_point[1] = pos_x
			prev_point[2] = pos_y
			prev_point[3] = pos_z
		else
			temp_n_points = temp_n_points + 1
			temp_points[temp_n_points] = {
				pos_x,
				pos_y,
				pos_z,
			}
		end

		last_dir_idx = dir_idx
		hash = cell[CELL_PARENT_HASH]
	until not hash

	local points = self._points
	local points_n = #points

	for i = temp_n_points, 1, -1 do
		points_n = points_n + 1
		points[points_n] = temp_points[i]
	end

	return true
end

FlyingSearchEngine._string_pull = function (self, step_data, timer, budget)
	local points = self._points
	local num_points = #points

	if num_points <= 3 then
		return true, points
	end

	if not step_data.string_pull_begun then
		step_data.string_pull_begun = true
		step_data.num_pulled_indices = 1
		step_data.start_pivot = 1
		step_data.end_pivot = num_points
		step_data.direction = 1
	end

	local Application_time_since_query = Application.time_since_query
	local start_pivot = step_data.start_pivot
	local end_pivot = step_data.end_pivot
	local num_pulled_indices = step_data.num_pulled_indices
	local direction = step_data.direction

	repeat
		local index_to_test = start_pivot + (direction == 1 and math.ceil or math.floor)((end_pivot - start_pivot) / 2)
		local pull_index = num_pulled_indices
		local blocked = self._nav_svo:overlap_capsule(Vector3.from_array(points[index_to_test]), Vector3.from_array(points[pull_index]), self._radius)

		if blocked then
			end_pivot = index_to_test
			direction = -1
		elseif end_pivot - start_pivot > 1 then
			start_pivot = index_to_test
			direction = 1
		else
			local num_to_remove = index_to_test - num_pulled_indices - 1

			for i = 1, num_to_remove do
				table.remove(points, index_to_test - i)

				num_points = num_points - 1
			end

			num_pulled_indices = num_pulled_indices + 1
			start_pivot = num_pulled_indices
			end_pivot = num_points

			if num_pulled_indices >= num_points - 1 then
				table.clear(step_data)

				return true, points
			end
		end

		if budget <= Application_time_since_query(timer) then
			step_data.start_pivot = start_pivot
			step_data.end_pivot = end_pivot
			step_data.num_pulled_indices = num_pulled_indices
			step_data.direction = direction

			return false, nil
		end
	until false
end

local smooth_order = {
	1,
	0.5,
	0.25,
	-1,
	-0.5,
	-0.25,
}
local num_attempts = #smooth_order

FlyingSearchEngine._smooth_curves = function (self, step_data, timer, budget)
	local points = self._points

	if not step_data.curve_smoothing_begun then
		step_data.curve_smoothing_begun = true
		step_data.current_idx = 1

		for i = 1, #points do
			local p = points[i]

			p.entry_bezier_point = {
				p[1],
				p[2],
				p[3],
			}
			p.exit_bezier_point = {
				p[1],
				p[2],
				p[3],
			}
		end
	end

	local Application_time_since_query = Application.time_since_query
	local spline_offset = self._radius * 4
	local half_spline_offset = spline_offset * 0.5
	local num_points = #points
	local current_idx = step_data.current_idx

	while current_idx < num_points - 1 do
		local p1 = points[current_idx]
		local p2 = points[current_idx + 1]
		local diff_x, diff_y, diff_z = p2[1] - p1[1], p2[2] - p1[2], p2[3] - p1[3]
		local dist = (diff_x^2 + diff_y^2 + diff_z^2)^0.5
		local dist_inv = 1 / dist
		local dir_x, dir_y, dir_z = diff_x * dist_inv, diff_y * dist_inv, diff_z * dist_inv
		local p3 = points[current_idx + 2]
		local exit_diff_x, exit_diff_y, exit_diff_z = p3[1] - p2[1], p3[2] - p2[2], p3[3] - p2[3]
		local exit_dist = (exit_diff_x^2 + exit_diff_y^2 + exit_diff_z^2)^0.5
		local exit_dist_inv = 1 / exit_dist
		local exit_dir_x, exit_dir_y, exit_dir_z = exit_diff_x * exit_dist_inv, exit_diff_y * exit_dist_inv, exit_diff_z * exit_dist_inv

		if spline_offset < dist then
			local new_point = {
				p2[1] - dir_x * spline_offset,
				p2[2] - dir_y * spline_offset,
				p2[3] - dir_z * spline_offset,
				exit_bezier_point = {},
				entry_bezier_point = {},
			}
			local new_entry = new_point.entry_bezier_point

			new_entry[1] = new_point[1]
			new_entry[2] = new_point[2]
			new_entry[3] = new_point[3]

			local new_exit = new_point.exit_bezier_point

			new_exit[1] = new_point[1] + dir_x * half_spline_offset
			new_exit[2] = new_point[2] + dir_y * half_spline_offset
			new_exit[3] = new_point[3] + dir_z * half_spline_offset

			local smooth_dist = half_spline_offset / 1.4142135623730951
			local next_entry = p2.entry_bezier_point
			local success = false

			for i = 1, num_attempts do
				local offset = smooth_dist * smooth_order[i]

				next_entry[1] = p2[1] - exit_dir_x * offset
				next_entry[2] = p2[2] - exit_dir_y * offset
				next_entry[3] = p2[3] - exit_dir_z * offset

				if self:_validate_spline(new_point, p2) then
					success = true

					break
				end
			end

			if not success then
				next_entry[1] = p2[1]
				next_entry[2] = p2[2]
				next_entry[3] = p2[3]
			end

			table.insert(points, current_idx + 1, new_point)

			num_points = num_points + 1
			current_idx = current_idx + 2
		else
			local half_dist = dist * 0.5
			local from_exit = p1.exit_bezier_point

			from_exit[1] = p1[1] + dir_x * half_dist
			from_exit[2] = p1[2] + dir_y * half_dist
			from_exit[3] = p1[3] + dir_z * half_dist

			local smooth_dist = half_dist / 1.4142135623730951
			local to_entry = p2.entry_bezier_point
			local success = false

			for i = 1, num_attempts do
				local offset = smooth_dist * smooth_order[i]

				to_entry[1] = p2[1] - exit_dir_x * offset
				to_entry[2] = p2[2] - exit_dir_y * offset
				to_entry[3] = p2[3] - exit_dir_z * offset

				if self:_validate_spline(p1, p2) then
					success = true

					break
				end
			end

			if not success then
				to_entry[1] = p2[1]
				to_entry[2] = p2[2]
				to_entry[3] = p2[3]
			end

			current_idx = current_idx + 1
		end

		if budget <= Application_time_since_query(timer) then
			step_data.current_idx = current_idx

			return false, nil
		end
	end

	table.clear(step_data)

	return true, points
end

FlyingSearchEngine._validate_spline = function (self, from_point, to_point)
	local last_point = FlyingNavPathUtility.position_in_spline(from_point, to_point, 0)
	local segments = FlyingNavPathUtility.num_spline_segments()

	for i = 1, segments do
		local next_point = FlyingNavPathUtility.position_in_spline(from_point, to_point, i / segments)

		if self._nav_svo:overlap_capsule(Vector3.from_array(last_point), Vector3.from_array(next_point), self._radius) then
			return false
		end

		last_point = next_point
	end

	return true
end

FlyingSearchEngine._try_raw_path = function (self)
	local points = self._points
	local from = self._from:unbox()
	local to = self._to:unbox()

	if self._nav_svo:overlap_capsule(from, to, self._radius) then
		return false
	end

	table.clear(points)

	points[1] = {
		from[1],
		from[2],
		from[3],
		entry_bezier_point = {
			from[1],
			from[2],
			from[3],
		},
		exit_bezier_point = {
			from[1],
			from[2],
			from[3],
		},
	}
	points[2] = {
		to[1],
		to[2],
		to[3],
		entry_bezier_point = {
			to[1],
			to[2],
			to[3],
		},
		exit_bezier_point = {
			to[1],
			to[2],
			to[3],
		},
	}

	return true, points
end

return FlyingSearchEngine
