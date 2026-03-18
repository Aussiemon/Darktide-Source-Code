-- chunkname: @scripts/extension_systems/navigation/flying_nav_path.lua

local FlyingNavPathUtility = require("scripts/extension_systems/navigation/utilities/flying_nav_path_utility")
local FlyingNavPath = class("FlyingNavPath")

FlyingNavPath.init = function (self, points)
	self._points = points
	self._num_points = #points
	self._progress_index = 1
end

local function _dot(ax, ay, az, bx, by, bz)
	return ax * bx + ay * by + az * bz
end

local function _dir_len(x, y, z)
	local len_sq = x^2 + y^2 + z^2

	if len_sq < 1e-06 then
		return 0, 0, 0, 0
	end

	local len = len_sq^0.5
	local inv_len = 1 / len

	return x * inv_len, y * inv_len, z * inv_len, len
end

FlyingNavPath.velocity_at = function (self, position, max_speed, nav_step_dt)
	local points = self._points
	local num_points = self._num_points
	local to_point, progress_index = self:_next_point(position)

	self._progress_index = math.max(self._progress_index, progress_index)

	local trace_offset = max_speed * nav_step_dt
	local from_point = points[progress_index]
	local find_spline_segment = true
	local num_segments = FlyingNavPathUtility.num_spline_segments()
	local trace_x, trace_y, trace_z
	local forward_index = progress_index + 1
	local distance_left = trace_offset

	while true do
		local dx, dy, dz, dir_x, dir_y, dir_z, len, optional_spline_segment

		if find_spline_segment then
			optional_spline_segment = self:_find_spline_segment(from_point, to_point, position)
			find_spline_segment = false
		end

		local trace_point_found = false
		local prev_pos = optional_spline_segment and position or Vector3(from_point[1], from_point[2], from_point[3])

		for i = optional_spline_segment or 1, num_segments do
			local next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, i / num_segments)

			dx, dy, dz = next_pos[1] - prev_pos[1], next_pos[2] - prev_pos[2], next_pos[3] - prev_pos[3]
			dir_x, dir_y, dir_z, len = _dir_len(dx, dy, dz)

			if distance_left < len then
				dx = dir_x * distance_left
				dy = dir_y * distance_left
				dz = dir_z * distance_left
				trace_x = prev_pos[1] + dx
				trace_y = prev_pos[2] + dy
				trace_z = prev_pos[3] + dz
				trace_point_found = true
				distance_left = 0

				break
			end

			distance_left = distance_left - len
			prev_pos = next_pos
		end

		if trace_point_found then
			break
		elseif forward_index == num_points then
			trace_x, trace_y, trace_z = to_point[1], to_point[2], to_point[3]

			break
		end

		from_point = to_point
		forward_index = forward_index + 1
		to_point = points[forward_index]
	end

	local move_to = Vector3(trace_x, trace_y, trace_z)
	local diff = move_to - position
	local len = Vector3.length(diff)

	if len < 1e-06 then
		return Vector3.zero()
	end

	local speed = max_speed

	if forward_index == num_points then
		speed = math.min(max_speed, len / nav_step_dt)
	end

	local dir = diff / len

	return dir * speed
end

FlyingNavPath.position_ahead_on_path = function (self, position, distance, clamp_to_path)
	local points = self._points
	local num_points = self._num_points
	local to_point, from_index = self:_next_point(position)
	local to_index = from_index + 1
	local distance_left = distance
	local find_spline_segment = true
	local from_point = points[from_index]
	local num_segments = FlyingNavPathUtility.num_spline_segments()

	while true do
		local optional_spline_segment

		if find_spline_segment then
			local path_pos

			optional_spline_segment, path_pos = self:_find_spline_segment(from_point, to_point, position)
			find_spline_segment = false

			if clamp_to_path then
				position = path_pos
			end
		end

		local prev_pos = optional_spline_segment and position or Vector3(from_point[1], from_point[2], from_point[3])

		for i = optional_spline_segment or 1, num_segments do
			local next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, i / num_segments)
			local from_x, from_y, from_z = prev_pos[1], prev_pos[2], prev_pos[3]
			local diff_x, diff_y, diff_z = next_pos[1] - from_x, next_pos[2] - from_y, next_pos[3] - from_z
			local dist = (diff_x^2 + diff_y^2 + diff_z^2)^0.5

			if distance_left <= dist then
				local inv_dist = dist == 0 and 0 or 1 / dist
				local dir_x, dir_y, dir_z = diff_x * inv_dist, diff_y * inv_dist, diff_z * inv_dist
				local is_goal = to_index == num_points and i == num_segments and dist - distance_left < 1e-06

				return Vector3(from_x + dir_x * distance_left, from_y + dir_y * distance_left, from_z + dir_z * distance_left), is_goal, from_index, distance
			end

			distance_left = distance_left - dist
			prev_pos = next_pos
		end

		from_point = to_point
		to_index = to_index + 1
		to_point = points[to_index]

		if not to_point then
			local is_goal = true

			return Vector3(from_point[1], from_point[2], from_point[3]), is_goal, from_index, distance - distance_left
		end
	end
end

FlyingNavPath._next_point = function (self, position)
	local points = self._points
	local num_points = self._num_points
	local progress_index = self._progress_index
	local from_point = points[progress_index]
	local to_point = points[progress_index + 1]
	local num_segments = FlyingNavPathUtility.num_spline_segments()

	while progress_index < num_points - 1 do
		local segment, _, progress_on_segment = self:_find_spline_segment(from_point, to_point, position)

		if segment < num_segments or progress_on_segment < 1 then
			break
		end

		progress_index = progress_index + 1
		from_point = to_point
		to_point = points[progress_index + 1]
	end

	return to_point, progress_index
end

FlyingNavPath.past_end = function (self, position)
	local num_points = self._num_points

	if self._progress_index < num_points - 1 then
		return false
	end

	local _, is_goal = self:position_ahead_on_path(position, 0, true)

	return is_goal
end

FlyingNavPath.remaining_distance_from_position = function (self, position, clamp_to_path)
	local points = self._points
	local pos_on_path, _, from_index = self:position_ahead_on_path(position, 0, true)
	local total_distance = clamp_to_path and 0 or Vector3.length(position - pos_on_path)
	local num_segments = FlyingNavPathUtility.num_spline_segments()

	for point_i = from_index, self._num_points - 1 do
		local from_point = points[point_i]
		local to_point = points[point_i + 1]
		local optional_spline_segment, path_pos

		if point_i == from_index then
			optional_spline_segment, path_pos = self:_find_spline_segment(from_point, to_point, position)
		end

		local prev_pos = optional_spline_segment and path_pos or Vector3(from_point[1], from_point[2], from_point[3])

		for seg_i = optional_spline_segment or 1, num_segments do
			local next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, seg_i / num_segments)
			local from_x, from_y, from_z = prev_pos[1], prev_pos[2], prev_pos[3]
			local diff_x, diff_y, diff_z = next_pos[1] - from_x, next_pos[2] - from_y, next_pos[3] - from_z
			local dist_sq = diff_x^2 + diff_y^2 + diff_z^2

			if dist_sq > 1e-12 then
				total_distance = total_distance + dist_sq^0.5
			end

			prev_pos = next_pos
		end
	end

	return total_distance
end

FlyingNavPath.distance_between_positions = function (self, p1, p2)
	local p1_on_path, _, p1_index = self:position_ahead_on_path(p1, 0, true)
	local p2_on_path, _, p2_index = self:position_ahead_on_path(p2, 0, true)

	if p2_index < p1_index then
		p1, p2 = p2, p1
		p1_index, p2_index = p2_index, p1_index
		p1_on_path, p2_on_path = p2_on_path, p1_on_path
	end

	local points = self._points
	local total_dist = Vector3.length(p1 - p1_on_path) + Vector3.length(p2 - p2_on_path)
	local point_index = p1_index
	local from_point = points[point_index]
	local to_point = points[point_index + 1]
	local num_segments = FlyingNavPathUtility.num_spline_segments()

	for point_i = p1_index, p2_index do
		local optional_spline_segment, optional_to_segment, optional_prev_pos, optional_next_pos

		if point_i == p1_index then
			optional_spline_segment, optional_prev_pos = self:_find_spline_segment(from_point, to_point, p1)
		end

		if point_i == p2_index then
			optional_to_segment, optional_next_pos = self:_find_spline_segment(from_point, to_point, p2)
		end

		if p1_index == p2_index and optional_to_segment < optional_spline_segment then
			optional_spline_segment, optional_to_segment = optional_to_segment, optional_spline_segment
			optional_prev_pos, optional_next_pos = optional_next_pos, optional_prev_pos
		end

		local prev_pos = optional_prev_pos or Vector3(from_point[1], from_point[2], from_point[3])

		for i = optional_spline_segment or 1, optional_to_segment or num_segments do
			local next_pos

			if i == optional_to_segment then
				next_pos = optional_next_pos
			else
				next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, i / num_segments)
			end

			local from_x, from_y, from_z = prev_pos[1], prev_pos[2], prev_pos[3]
			local diff_x, diff_y, diff_z = next_pos[1] - from_x, next_pos[2] - from_y, next_pos[3] - from_z
			local dist = (diff_x^2 + diff_y^2 + diff_z^2)^0.5

			total_dist = total_dist + dist
			prev_pos = next_pos
		end

		from_point = to_point
		point_index = point_index + 1
		to_point = points[point_index]

		if not to_point then
			return total_dist
		end
	end

	return total_dist
end

FlyingNavPath.distance_to_progress_on_path = function (self, position)
	local num_segments = FlyingNavPathUtility.num_spline_segments()
	local total_distance = 0
	local points = self._points
	local _, _, from_index = self:position_ahead_on_path(position, 0, true)

	for point_i = 1, from_index do
		local from_point = points[point_i]
		local to_point = points[point_i + 1]
		local optional_spline_segment, _, progress_on_segment

		if point_i == from_index then
			optional_spline_segment, _, progress_on_segment = self:_find_spline_segment(from_point, to_point, position)
		end

		local prev_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, 0)

		for i = 1, optional_spline_segment or num_segments do
			local p = i

			if i == optional_spline_segment then
				p = p - (1 - progress_on_segment)
				progress_on_segment = nil
			end

			local next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, p / num_segments)
			local from_x, from_y, from_z = prev_pos[1], prev_pos[2], prev_pos[3]
			local diff_x, diff_y, diff_z = next_pos[1] - from_x, next_pos[2] - from_y, next_pos[3] - from_z

			total_distance = total_distance + (diff_x^2 + diff_y^2 + diff_z^2)^0.5
			prev_pos = next_pos
		end
	end

	return total_distance
end

FlyingNavPath.node_position = function (self, index)
	local p = self._points[index]

	return Vector3(p[1], p[2], p[3])
end

FlyingNavPath.num_nodes = function (self)
	return self._num_points
end

local m01, m12, m23, m012, m123 = {}, {}, {}, {}, {}

FlyingNavPath.cut_path_at_index = function (self, index, optional_replacement_position)
	local cut_from = index + (optional_replacement_position and 1 or 0)

	for i = cut_from, self._num_points do
		self._points[i] = nil
	end

	self._num_points = cut_from - 1

	if optional_replacement_position then
		local p1 = self._points[self._num_points - 1]
		local p2 = self._points[self._num_points]
		local segment, _, progress_on_segment = self:_find_spline_segment(p1, p2, optional_replacement_position)
		local t = (segment - 1 + progress_on_segment) / FlyingNavPathUtility.num_spline_segments()
		local c1 = p1.exit_bezier_point
		local c2 = p2.entry_bezier_point

		m01[1] = p1[1] + (c1[1] - p1[1]) * t
		m01[2] = p1[2] + (c1[2] - p1[2]) * t
		m01[3] = p1[3] + (c1[3] - p1[3]) * t
		m12[1] = c1[1] + (c2[1] - c1[1]) * t
		m12[2] = c1[2] + (c2[2] - c1[2]) * t
		m12[3] = c1[3] + (c2[3] - c1[3]) * t
		m23[1] = c2[1] + (p2[1] - c2[1]) * t
		m23[2] = c2[2] + (p2[2] - c2[2]) * t
		m23[3] = c2[3] + (p2[3] - c2[3]) * t
		m012[1] = m01[1] + (m12[1] - m01[1]) * t
		m012[2] = m01[2] + (m12[2] - m01[2]) * t
		m012[3] = m01[3] + (m12[3] - m01[3]) * t
		m123[1] = m12[1] + (m23[1] - m12[1]) * t
		m123[2] = m12[2] + (m23[2] - m12[2]) * t
		m123[3] = m12[3] + (m23[3] - m12[3]) * t
		c1[1] = m01[1]
		c1[2] = m01[2]
		c1[3] = m01[3]
		c2[1] = m012[1]
		c2[2] = m012[2]
		c2[3] = m012[3]
		p2[1] = m012[1] + (m123[1] - m012[1]) * t
		p2[2] = m012[2] + (m123[2] - m012[2]) * t
		p2[3] = m012[3] + (m123[3] - m012[3]) * t
	end
end

FlyingNavPath._find_spline_segment = function (self, from_point, to_point, position)
	local num_segments = FlyingNavPathUtility.num_spline_segments()
	local best_segment, best_pos
	local best_dist_sq = math.huge
	local best_prev_pos, best_next_pos
	local prev_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, 0)

	for i = 1, num_segments do
		local next_pos = FlyingNavPathUtility.position_in_spline(from_point, to_point, i / num_segments)
		local closest = Geometry.closest_point_on_line(position, prev_pos, next_pos)
		local dx = closest[1] - position[1]
		local dy = closest[2] - position[2]
		local dz = closest[3] - position[3]
		local dist_sq = dx * dx + dy * dy + dz * dz

		if dist_sq < best_dist_sq then
			best_dist_sq = dist_sq
			best_segment = i
			best_pos = closest
			best_prev_pos = prev_pos
			best_next_pos = next_pos
		end

		prev_pos = next_pos
	end

	local progress_on_segment
	local segment_length = Vector3.length(best_next_pos - best_prev_pos)

	progress_on_segment = segment_length < 1e-06 and 1 or Vector3.length(best_pos - best_prev_pos) / segment_length

	return best_segment, best_pos, progress_on_segment
end

return FlyingNavPath
