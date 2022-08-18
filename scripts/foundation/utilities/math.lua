math.degrees_to_radians = function (degrees)
	return degrees * 0.0174532925
end

math.radians_to_degrees = function (radians)
	return radians * 57.2957795
end

math.sign = function (x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	else
		return 0
	end
end

math.normalize_01 = function (value, min, max)
	fassert(min < max, "invalid range")

	return math.clamp((value - min) / (max - min), 0, 1)
end

math.clamp = function (value, min, max)
	if max < value then
		return max
	elseif value < min then
		return min
	else
		return value
	end
end

math.clamp01 = function (value)
	return math.clamp(value, 0, 1)
end

math.lerp = function (a, b, p)
	return a * (1 - p) + b * p
end

math.ilerp = function (from, to, value)
	value = math.clamp(value, math.min(from, to), math.max(from, to))

	return (value - from) / (to - from)
end

math.ilerp_no_clamp = function (from, to, value)
	return (value - from) / (to - from)
end

math.remap = function (input_min, input_max, output_min, output_max, value)
	local t = math.ilerp(input_min, input_max, value)

	return math.lerp(output_min, output_max, t)
end

math.radian_lerp = function (a, b, p)
	local pi = math.pi
	local two_pi = pi * 2

	return a + (((b - a) % two_pi + two_pi + pi) % two_pi - pi) * p
end

math.angle_lerp = function (a, b, p)
	return a + (((b - a) % 360 + 540) % 360 - 180) * p
end

math.sirp = function (a, b, t, amplitude, vertical_shift, period, phase_shift)
	local _amplitude = amplitude or 0.5
	local _vertical_shift = vertical_shift or 0.5
	local _period = period or math.pi
	local _phase_shift = phase_shift or 1
	local p = _vertical_shift + _amplitude * math.cos((_phase_shift + t) * _period)

	return math.lerp(a, b, p)
end

math.auto_lerp = function (index_1, index_2, val_1, val_2, val)
	local t = (val - index_1) / (index_2 - index_1)

	return math.lerp(val_1, val_2, t)
end

math.round_with_precision = function (value, optional_precision)
	local mul = 10^(optional_precision or 0)

	if value >= 0 then
		return math.floor(value * mul + 0.5) / mul
	else
		return math.ceil(value * mul - 0.5) / mul
	end
end

math.round_down_with_precision = function (value, optional_precision)
	local mul = 10^(optional_precision or 0)

	if value >= 0 then
		return math.floor(value * mul) / mul
	else
		return math.ceil(value * mul) / mul
	end
end

math.round = function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

math.smoothstep = function (value, min, max)
	fassert(min ~= max, "Division by zero.")

	local x = math.clamp((value - min) / (max - min), 0, 1)

	return x^3 * (x * (x * 6 - 15) + 10)
end

math.random_range = function (min, max)
	return min + math.random() * (max - min)
end

math.random_array_entry = function (array, optional_seed)
	local index = nil

	if optional_seed then
		optional_seed, index = math.next_random(optional_seed, 1, #array)
	else
		index = math.random(1, #array)
	end

	return array[index], optional_seed
end

math.two_pi = math.pi * 2
math.half_pi = math.pi * 0.5
math.inverse_sqrt_2 = 1 / math.sqrt(2)

math.mod_two_pi = function (angle)
	local result = (angle + math.two_pi) % math.two_pi

	return result
end

math.point_is_inside_2d_box = function (pos, lower_left_corner, size)
	if lower_left_corner[1] < pos[1] and pos[1] < lower_left_corner[1] + size[1] and lower_left_corner[2] < pos[2] and pos[2] < lower_left_corner[2] + size[2] then
		return true
	else
		return false
	end
end

math.box_overlap_point_radius = function (x1, y1, x2, y2, point_x, point_y, radius)
	local point_center_x = point_x * 0.5
	local point_center_y = point_y * 0.5
	local Xn = math.max(x1, math.min(point_center_x, x2))
	local Yn = math.max(y1, math.min(point_center_y, y2))
	local Dx = Xn - point_center_x
	local Dy = Yn - point_center_y
	local is_overlapping = Dx * Dx + Dy * Dy <= radius * radius

	return is_overlapping
end

math.box_overlap_box = function (box_pos, box_extent, box2_pos, box2_extent)
	if box_pos[1] < box2_pos[1] + box2_extent[1] and box2_pos[1] < box_pos[1] + box_extent[1] and box_pos[2] < box2_pos[2] + box2_extent[2] and box2_pos[2] < box_pos[2] + box_extent[2] then
		return true
	else
		return false
	end
end

math.point_is_inside_aabb = function (pos, aabb_pos, aabb_half_extents)
	if pos.x < aabb_pos.x - aabb_half_extents.x then
		return false
	end

	if pos.x > aabb_pos.x + aabb_half_extents.x then
		return false
	end

	if pos.y < aabb_pos.y - aabb_half_extents.y then
		return false
	end

	if pos.y > aabb_pos.y + aabb_half_extents.y then
		return false
	end

	if pos.z < aabb_pos.z - aabb_half_extents.z then
		return false
	end

	if pos.z > aabb_pos.z + aabb_half_extents.z then
		return false
	end

	return true
end

math.point_is_inside_oobb = function (pos, oobb_pose, oobb_radius)
	local to_local_matrix = Matrix4x4.inverse(oobb_pose)
	local local_pos = Matrix4x4.transform(to_local_matrix, pos)

	if local_pos.x > -oobb_radius[1] and local_pos.x < oobb_radius[1] and local_pos.y > -oobb_radius[2] and local_pos.y < oobb_radius[2] and local_pos.z > -oobb_radius[3] and local_pos.z < oobb_radius[3] then
		return true
	else
		return false
	end
end

math.point_is_inside_2d_triangle = function (pos, p1, p2, p3)
	local pa = p1 - pos
	local pb = p2 - pos
	local pc = p3 - pos
	local pab_n = Vector3.cross(pa, pb)
	local pbc_n = Vector3.cross(pb, pc)

	if Vector3.dot(pab_n, pbc_n) < 0 then
		return false
	end

	local pca_n = Vector3.cross(pc, pa)
	local best_normal = (Vector3.dot(pbc_n, pbc_n) < Vector3.dot(pab_n, pab_n) and pab_n) or pbc_n
	local dot_product = Vector3.dot(best_normal, pca_n)

	if dot_product < 0 then
		return false
	elseif dot_product > 0 then
		return true
	else
		local min_p = Vector3.min(pa, Vector3.min(pb, pc))
		local max_p = Vector3.max(pa, Vector3.max(pb, pc))

		return min_p.x <= 0 and min_p.y <= 0 and max_p.x >= 0 and max_p.y >= 0
	end
end

math.cartesian_to_polar = function (x, y)
	fassert(x ~= 0 and y ~= 0, "Can't convert a zero vector to polar coordinates")

	local radius = math.sqrt(x * x + y * y)
	local theta = math.atan(y / x) * 180 / math.pi

	if x < 0 then
		theta = theta + 180
	elseif y < 0 then
		theta = theta + 360
	end

	return radius, theta
end

math.circular_to_square_coordinates = function (vector)
	local u = vector.x
	local v = vector.y
	local uu = u * u
	local vv = v * v
	local sqrt = math.sqrt
	local max = math.max
	local sqrt_2 = sqrt(2)
	local x = 0.5 * (sqrt(max((2 + 2 * u * sqrt_2 + uu) - vv, 0)) - sqrt(max((2 - 2 * u * sqrt_2 + uu) - vv, 0)))
	local y = 0.5 * (sqrt(max((2 + 2 * v * sqrt_2) - uu + vv, 0)) - sqrt(max(2 - 2 * v * sqrt_2 - uu + vv, 0)))

	return Vector3(x, y, 0)
end

math.polar_to_cartesian = function (radius, theta)
	local x = radius * math.cos(theta)
	local y = radius * math.sin(theta)

	return x, y
end

math.catmullrom = function (t, p0, p1, p2, p3)
	return 0.5 * (2 * p1 + (-p0 + p2) * t + ((2 * p0 - 5 * p1 + 4 * p2) - p3) * t * t + ((-p0 + 3 * p1) - 3 * p2 + p3) * t * t * t)
end

math.closest_position = function (p0, p1, p2)
	local p0_p1_dist_sq = Vector3.distance_squared(p0, p1)
	local p0_p2_dist_sq = Vector3.distance_squared(p0, p2)

	if p0_p1_dist_sq <= p0_p2_dist_sq then
		return p1
	else
		return p2
	end
end

math.closest_point_on_sphere = function (sphere_position, sphere_radius, position)
	local v = Vector3.normalize(position - sphere_position)
	local p = v * sphere_radius
	local closest_position = p + sphere_position

	return closest_position
end

math.move_towards = function (current, target, max_delta)
	local diff = target - current
	local change = math.clamp(diff, -max_delta, max_delta)

	return current + change
end

Geometry = Geometry or {}

Geometry.is_point_inside_triangle = function (point_on_plane, tri_a, tri_b, tri_c)
	local pa = tri_a - point_on_plane
	local pb = tri_b - point_on_plane
	local pc = tri_c - point_on_plane
	local pab_n = Vector3.cross(pa, pb)
	local pbc_n = Vector3.cross(pb, pc)

	if Vector3.dot(pab_n, pbc_n) < 0 then
		return false
	end

	local pca_n = Vector3.cross(pc, pa)
	local best_normal = (Vector3.dot(pbc_n, pbc_n) < Vector3.dot(pab_n, pab_n) and pab_n) or pbc_n
	local dot_product = Vector3.dot(best_normal, pca_n)

	if dot_product < 0 then
		return false
	elseif dot_product > 0 then
		return true
	else
		local min_p = Vector3.min(pa, Vector3.min(pb, pc))
		local max_p = Vector3.max(pa, Vector3.max(pb, pc))

		return min_p.x <= 0 and min_p.y <= 0 and min_p.z <= 0 and max_p.x >= 0 and max_p.y >= 0 and max_p.z >= 0
	end
end

local Vector3_dot = Vector3 and Vector3.dot

Geometry.closest_point_on_line = function (p, p1, p2)
	local diff = p - p1
	local dir = p2 - p1
	local dot1 = Vector3_dot(diff, dir)

	if dot1 <= 0 then
		return p1
	end

	local dot2 = Vector3_dot(dir, dir)

	if dot2 <= dot1 then
		return p2
	end

	local t = dot1 / dot2

	return p1 + t * dir
end

Geometry.closest_point_on_line = EngineOptimized.closest_point_on_line

Geometry.closest_point_on_polyline = function (point, points, start_index, end_index)
	local vector3_distance_squared = Vector3.distance_squared
	local closest_point_on_line = Geometry.closest_point_on_line
	start_index = start_index or 1
	end_index = end_index or #points
	local shortest_distance = math.huge
	local result_position, result_index = nil

	for i = start_index, end_index - 1, 1 do
		local p1 = points[i]
		local p2 = points[i + 1]
		local projected_point = closest_point_on_line(point, p1, p2)
		local distance = vector3_distance_squared(projected_point, point)

		if distance < shortest_distance then
			shortest_distance = distance
			result_position = projected_point
			result_index = i
		end
	end

	return result_position, result_index
end

Intersect = Intersect or {}

Intersect.ray_line = function (ray_from, ray_direction, line_point_a, line_point_b)
	local distance_along_ray, normalized_distance_along_line = Intersect.line_line(ray_from, ray_from + ray_direction, line_point_a, line_point_b)

	if distance_along_ray == nil then
		return nil, nil
	elseif distance_along_ray < 0 then
		return nil, nil
	else
		return distance_along_ray, normalized_distance_along_line
	end
end

Intersect.ray_box = function (from, direction, pose, radius)
	local is_ray_origin_inside_box = math.point_in_box(from, pose, radius)

	if is_ray_origin_inside_box then
		return 0
	end

	local distance_along_ray = math.ray_box_intersection(from, direction, pose, radius)
	local is_box_missed_by_ray = distance_along_ray < 0

	if is_box_missed_by_ray then
		return nil
	end

	return distance_along_ray
end

Intersect.line_line = function (line_a_pt1, line_a_pt2, line_b_pt1, line_b_pt2)
	local line_a_vector = line_a_pt2 - line_a_pt1
	local line_b_vector = line_b_pt2 - line_b_pt1
	local a = Vector3.dot(line_a_vector, line_a_vector)
	local e = Vector3.dot(line_b_vector, line_b_vector)
	local b = Vector3.dot(line_a_vector, line_b_vector)
	local d = a * e - b * b

	if d < 0.001 then
		return nil, nil
	end

	local r = line_a_pt1 - line_b_pt1
	local c = Vector3.dot(line_a_vector, r)
	local f = Vector3.dot(line_b_vector, r)
	local normalized_distance_along_line_a = (b * f - c * e) / d
	local normalized_distance_along_line_b = (a * f - b * c) / d

	return normalized_distance_along_line_a, normalized_distance_along_line_b
end

Intersect.ray_segment = function (ray_from, ray_direction, segment_start, segment_end)
	local distance_along_ray, normalized_distance_along_line = Intersect.ray_line(ray_from, ray_direction, segment_start, segment_end)
	local is_line_parallel_to_or_behind_ray = distance_along_ray == nil

	if is_line_parallel_to_or_behind_ray then
		return nil
	end

	local is_intersection_inside_segment = normalized_distance_along_line >= 0 and normalized_distance_along_line <= 1

	if is_intersection_inside_segment then
		return distance_along_ray, normalized_distance_along_line
	else
		return nil, nil
	end
end

math.ease_sine = function (t)
	return 0.5 + 0.5 * math.cos((1 + t) * math.pi)
end

math.ease_exp = function (t)
	if t < 0.5 then
		return 0.5 * math.pow(2, 20 * (t - 0.5))
	end

	return 1 - 0.5 * math.pow(2, 20 * (0.5 - t))
end

math.ease_in_exp = function (t)
	return math.pow(2, 10 * (t - 1))
end

math.ease_out_exp = function (t)
	return 1 - math.pow(2, -10 * t)
end

math.easeCubic = function (t)
	t = t * 2

	if t < 1 then
		return 0.5 * t * t * t
	end

	t = t - 2

	return 0.5 * t * t * t + 1
end

math.easeInCubic = function (t)
	return t * t * t
end

math.easeOutCubic = function (t)
	t = t - 1

	return t * t * t + 1
end

math.ease_quad = function (t)
	t = t * 2

	if t < 1 then
		return 0.5 * t * t
	else
		t = t - 2

		return 1 - 0.5 * t * t
	end
end

math.ease_out_quad = function (t)
	return -1 * t * (t - 2)
end

local math_ease_cubic = math.easeCubic

math.ease_pulse = function (t)
	if t < 0.5 then
		return math_ease_cubic(2 * t)
	else
		return math_ease_cubic(2 - 2 * t)
	end
end

math.point_in_sphere = function (sphere_position, sphere_radius, point)
	local x = math.pow(point[1] - sphere_position[1], 2)
	local y = math.pow(point[2] - sphere_position[2], 2)
	local z = math.pow(point[3] - sphere_position[3], 2)
	local r2 = sphere_radius * sphere_radius

	return r2 > x + y + z
end

math.bounce = function (t)
	return math.abs(math.sin(6.28 * (t + 1) * (t + 1)) * (1 - t))
end

local DEFAULT_TOLERANCE = 1e-05

math.approximately_equal = function (a, b, optional_tolerance)
	local tolerance = optional_tolerance or DEFAULT_TOLERANCE

	return math.abs(a - b) < tolerance
end

math.ease_out_elastic = function (t)
	local p = 0
	local a = 1

	if t == 0 then
		return 0
	end

	if t == 1 then
		return 1
	end

	if p == 0 then
		p = 0.3
	end

	local s = nil

	if a < 1 then
		a = 1
		s = p / 4
	else
		s = p / (2 * math.pi) * math.asin(1 / a)
	end

	return a * math.pow(2, -10 * t) * math.sin(((t * 1 - s) * 2 * math.pi) / p) + 1
end

math.ease_sine = function (t)
	return 0.5 + 0.5 * math.cos((1 + t) * math.pi)
end

local function internal_rand_normal()
	local x1, x2, w, y1, y2 = nil

	repeat
		x1 = 2 * math.random() - 1
		x2 = 2 * math.random() - 1
		w = x1 * x1 + x2 * x2
	until w < 1

	w = math.sqrt((-2 * math.log(w)) / w)
	y1 = x1 * w
	y2 = x2 * w

	return y1, y2
end

math.rand_normal = function (min, max, variance, strict_min, strict_max)
	local average = (min + max) / 2

	if variance == nil then
		variance = 2.4
	end

	local escala = (max - average) / variance
	local x = escala * internal_rand_normal() + average

	if strict_min ~= nil then
		x = math.max(x, strict_min)
	end

	if strict_max ~= nil then
		x = math.min(x, strict_max)
	end

	return x
end

math.rand_utf8_string = function (string_length, ignore_chars)
	fassert(string_length > 0, "String length passed to math.rand_string has to be greater than 0")

	ignore_chars = ignore_chars or {
		"\"",
		"'",
		"\\",
		" "
	}
	local array = {}

	for i = 1, string_length, 1 do
		local char = nil

		while not char or table.contains(ignore_chars, char) do
			char = string.char(math.random(32, 126))
		end

		array[i] = char
	end

	return table.concat(array)
end

math.uuid = function ()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return string.gsub(template, "[xy]", function (c)
		local v = (c == "x" and math.random(0, 15)) or math.random(8, 11)

		return string.format("%x", v)
	end)
end

math.is_uuid = function (value)
	if type(value) ~= "string" then
		return false
	end

	if string.len(value) ~= 36 then
		return false
	end

	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	template = string.gsub(template, "x", "%%x")
	template = string.gsub(template, "y", "[89ab]")
	template = string.gsub(template, "-", "%%-")

	return string.match(value, template) ~= nil
end

math.get_uniformly_random_point_inside_sector = function (radius1, radius2, angle1, angle2)
	local radius1_squared = radius1 * radius1
	local radius2_squared = radius2 * radius2
	local angle = angle1 + (angle2 - angle1) * math.random()
	local r = math.sqrt(radius1_squared + (radius2_squared - radius1_squared) * math.random())
	local dx = r * math.sin(angle)
	local dy = r * math.cos(angle)

	return dx, dy
end

math.random_inside_unit_circle = function ()
	local x = math.random() * 2 - 1
	local y = math.random() * 2 - 1

	return x, y
end

math.centroid = function (points)
	local centroid = Vector3.zero()
	local n_points = #points

	for i = 1, n_points, 1 do
		local point = points[i]
		centroid = centroid + point
	end

	centroid = centroid / n_points

	return centroid
end

local MAX_SEED = 2147483647

math.random_seed = function (seed)
	if seed then
		local next_seed, new_seed = math.next_random(seed, MAX_SEED)

		return next_seed, new_seed
	else
		return math.random(MAX_SEED)
	end
end

math.distance_2d = function (x1, y1, x2, y2)
	return ((x2 - x1)^2 + (y2 - y1)^2)^0.5
end

math.distance_3d = function (x1, y1, z1, x2, y2, z2)
	return ((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)^0.5
end

math.angle = function (x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

math.index_wrapper = function (index, max_index)
	return (index - 1) % max_index + 1
end

math.snap_to_zero = function (x, epsilon)
	local EPSILON = 1e-05

	if epsilon then
		EPSILON = epsilon
	end

	if math.abs(x) < EPSILON then
		x = 0
	end

	return x
end

math.get_median_value = function (t)
	local target_table = {}

	for index, value in pairs(t) do
		fassert(type(value) == "number", "Item '" .. index .. "' is not a number. Only tables with all numerical values are allowed.")
		table.insert(target_table, value)
	end

	table.sort(target_table)

	if #target_table % 2 == 0 then
		return (target_table[#target_table / 2] + target_table[#target_table / 2 + 1]) / 2
	else
		return target_table[(#target_table + 1) / 2]
	end
end

math.quat_angle = function (from, to)
	local dot = math.min(math.abs(Quaternion.dot(from, to)), 1)
	local target_angle = 0

	if dot < 1 then
		target_angle = math.acos(dot) * 2
	end

	return target_angle
end

math.quat_rotate_towards = function (from, to, angle_rad)
	local target_angle = math.quat_angle(from, to)

	if math.abs(target_angle) < angle_rad or target_angle <= 0 then
		return to
	end

	local lerp_t = math.min(1, angle_rad / target_angle)

	return Quaternion.lerp(from, to, lerp_t)
end

return
