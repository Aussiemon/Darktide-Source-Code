-- chunkname: @scripts/foundation/utilities/math.lua

local Vector3, Quaternion, Matrix4x4 = Vector3, Quaternion, Matrix4x4
local Vector3_dot = Vector3 and Vector3.dot
local math = math
local math_sqrt, math_cos, math_sin, math_random = math.sqrt, math.cos, math.sin, math.random
local math_abs, math_min, math_max = math.abs, math.min, math.max
local pi = math.pi

math.two_pi = pi * 2
math.half_pi = pi * 0.5
math.inverse_sqrt_2 = 1 / math_sqrt(2)
math.nan = 0 / 0

math.is_nan = function (x)
	return x ~= x
end

math.degrees_to_radians = math.rad
math.radians_to_degrees = math.deg

math.sign = function (x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	else
		return 0
	end
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
	if value > 1 then
		return 1
	elseif value < 0 then
		return 0
	else
		return value
	end
end

local math_clamp = math.clamp
local math_clamp01 = math.clamp01

math.normalize_01 = function (value, min, max)
	return math_clamp01((value - min) / (max - min))
end

math.ilerp = function (from, to, value)
	value = math_clamp(value, math_min(from, to), math_max(from, to))

	return (value - from) / (to - from)
end

math.ilerp_no_clamp = function (from, to, value)
	return (value - from) / (to - from)
end

math.lerp = function (a, b, p)
	return a * (1 - p) + b * p
end

math.remap = function (input_min, input_max, output_min, output_max, value)
	local t = math.ilerp(input_min, input_max, value)

	return math.lerp(output_min, output_max, t)
end

math.auto_lerp = function (index_1, index_2, val_1, val_2, val)
	local t = (val - index_1) / (index_2 - index_1)

	return math.lerp(val_1, val_2, t)
end

math.radian_lerp = function (a, b, p)
	local two_pi = pi * 2

	return a + p * (((b - a) % two_pi + pi) % two_pi - pi)
end

math.sirp = function (a, b, t, amplitude, vertical_shift, period, phase_shift)
	local _amplitude = amplitude or 0.5
	local _vertical_shift = vertical_shift or 0.5
	local _period = period or pi
	local _phase_shift = phase_shift or 1
	local p = _vertical_shift + _amplitude * math_cos((_phase_shift + t) * _period)

	return math.lerp(a, b, p)
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
	local x = math_clamp((value - min) / (max - min), 0, 1)

	return x * x * x * (x * (x * 6 - 15) + 10)
end

math.random_range = function (min, max)
	return min + math_random() * (max - min)
end

math.random_array_entry = function (array, optional_seed)
	local index

	if optional_seed then
		optional_seed, index = math.next_random(optional_seed, #array)
	else
		index = math_random(#array)
	end

	return array[index], optional_seed
end

math.mod_two_pi = function (angle)
	return angle % math.two_pi
end

math.point_is_inside_2d_box = function (pos, lower_left_corner, size)
	return pos[1] > lower_left_corner[1] and pos[1] < lower_left_corner[1] + size[1] and pos[2] > lower_left_corner[2] and pos[2] < lower_left_corner[2] + size[2]
end

math.box_overlap_point_radius = function (x1, y1, x2, y2, circle_x, circle_y, circle_radius)
	local xn = math_clamp(circle_x, x1, x2)
	local yn = math_clamp(circle_y, y1, y2)
	local dx = xn - circle_x
	local dy = yn - circle_y

	return dx * dx + dy * dy <= circle_radius * circle_radius
end

math.box_overlap_box = function (a_pos, a_size, b_pos, b_size)
	return a_pos[1] + a_size[1] >= b_pos[1] and b_pos[1] + b_size[1] >= a_pos[1] and a_pos[2] + a_size[2] >= b_pos[2] and b_pos[2] + b_size[2] >= a_pos[2]
end

math.point_in_sphere = function (sphere_position, sphere_radius, point)
	local dx = point[1] - sphere_position[1]
	local dy = point[2] - sphere_position[2]
	local dz = point[3] - sphere_position[3]

	return dx * dx + dy * dy + dz * dz < sphere_radius * sphere_radius
end

math.point_is_inside_aabb = function (pos, aabb_pos, aabb_half_extents)
	return not (pos.x < aabb_pos.x - aabb_half_extents.x) and not (pos.x > aabb_pos.x + aabb_half_extents.x) and not (pos.y < aabb_pos.y - aabb_half_extents.y) and not (pos.y > aabb_pos.y + aabb_half_extents.y) and not (pos.z < aabb_pos.z - aabb_half_extents.z) and not (pos.z > aabb_pos.z + aabb_half_extents.z)
end

math.point_is_inside_2d_triangle = function (pos, p1, p2, p3)
	local pa = p1 - pos
	local pb = p2 - pos
	local pc = p3 - pos
	local pab_n = Vector3.cross(pa, pb)
	local pbc_n = Vector3.cross(pb, pc)

	if Vector3_dot(pab_n, pbc_n) < 0 then
		return false
	end

	local pca_n = Vector3.cross(pc, pa)
	local best_normal = Vector3_dot(pab_n, pab_n) > Vector3_dot(pbc_n, pbc_n) and pab_n or pbc_n
	local dot_product = Vector3_dot(best_normal, pca_n)

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

math.circular_to_square_coordinates = function (vector)
	local x, y = vector.x, vector.y
	local w = x * x - y * y
	local k = 4 * math.inverse_sqrt_2
	local u, v = x * k, y * k

	return Vector2(0.5 * (math_sqrt(math_max(2 + u + w, 0)) - math_sqrt(math_max(2 - u + w, 0))), 0.5 * (math_sqrt(math_max(2 + v - w, 0)) - math_sqrt(math_max(2 - v - w, 0))))
end

math.cartesian_to_polar = function (x, y)
	local r = math_sqrt(x * x + y * y)

	return r, math.atan2(y, x)
end

math.polar_to_cartesian = function (radius, theta)
	return radius * math_cos(theta), radius * math_sin(theta)
end

math.catmullrom = function (t, p0, p1, p2, p3)
	return 0.5 * (2 * p1 + (-p0 + p2) * t + (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t + (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t)
end

math.closest_position = function (p0, p1, p2)
	if Vector3.distance_squared(p0, p1) <= Vector3.distance_squared(p0, p2) then
		return p1
	else
		return p2
	end
end

math.closest_point_on_sphere = function (sphere_position, sphere_radius, position)
	local v = Vector3.normalize(position - sphere_position)
	local p = v * sphere_radius

	return p + sphere_position
end

math.move_towards = function (current, target, max_delta)
	return current + math_clamp(target - current, -max_delta, max_delta)
end

Geometry = Geometry or {}

Geometry.is_point_inside_triangle = function (point_on_plane, tri_a, tri_b, tri_c)
	local pa = tri_a - point_on_plane
	local pb = tri_b - point_on_plane
	local pc = tri_c - point_on_plane
	local pab_n = Vector3.cross(pa, pb)
	local pbc_n = Vector3.cross(pb, pc)

	if Vector3_dot(pab_n, pbc_n) < 0 then
		return false
	end

	local pca_n = Vector3.cross(pc, pa)
	local best_normal = Vector3_dot(pab_n, pab_n) > Vector3_dot(pbc_n, pbc_n) and pab_n or pbc_n
	local dot_product = Vector3_dot(best_normal, pca_n)

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
	local result_position, result_index

	for i = start_index, end_index - 1 do
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
	local a = Vector3_dot(line_a_vector, line_a_vector)
	local e = Vector3_dot(line_b_vector, line_b_vector)
	local b = Vector3_dot(line_a_vector, line_b_vector)
	local d = a * e - b * b

	if d < 0.001 then
		return nil, nil
	end

	local r = line_a_pt1 - line_b_pt1
	local c = Vector3_dot(line_a_vector, r)
	local f = Vector3_dot(line_b_vector, r)
	local normalized_distance_along_line_a = (b * f - c * e) / d
	local normalized_distance_along_line_b = (a * f - b * c) / d

	return normalized_distance_along_line_a, normalized_distance_along_line_b
end

Intersect.ray_segment = function (ray_from, ray_direction, segment_start, segment_end)
	local distance_along_ray, normalized_distance_along_line = Intersect.ray_line(ray_from, ray_direction, segment_start, segment_end)

	if distance_along_ray == nil then
		return nil
	end

	if normalized_distance_along_line >= 0 and normalized_distance_along_line <= 1 then
		return distance_along_ray, normalized_distance_along_line
	else
		return nil, nil
	end
end

math.ease_sine = function (t)
	return 0.5 + 0.5 * math_cos((1 + t) * pi)
end

math.ease_in_sine = function (t)
	return 1 - math.cos(t * pi / 2)
end

math.ease_exp = function (t)
	if t < 0.5 then
		return 0.5 * 2^(20 * (t - 0.5))
	end

	return 1 - 0.5 * 2^(20 * (0.5 - t))
end

math.ease_in_exp = function (t)
	return 2^(10 * (t - 1))
end

math.ease_out_exp = function (t)
	return 1 - 2^(-10 * t)
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

math.ease_in_quad = function (t)
	return t * t
end

local math_ease_cubic = math.easeCubic

math.ease_pulse = function (t)
	if t < 0.5 then
		return math_ease_cubic(2 * t)
	else
		return math_ease_cubic(2 - 2 * t)
	end
end

math.bounce = function (t)
	return math_abs(math_sin(6.28 * (t + 1) * (t + 1)) * (1 - t))
end

math.ease_out_bounce = function (t)
	local n1 = 7.5625
	local d1 = 2.75

	if t < 1 / d1 then
		return n1 * t * t
	elseif t < 2 / d1 then
		local x = t - 1.5 / d1

		return n1 * x * x + 0.75
	elseif t < 2.5 / d1 then
		local x = t - 2.25 / d1

		return n1 * x * x + 0.9375
	else
		local x = t - 2.625 / d1

		return n1 * x * x + 0.984375
	end
end

local math_ease_out_bounce = math.ease_out_bounce

math.ease_in_out_bounce = function (t)
	if t < 0.5 then
		return (1 - math_ease_out_bounce(1 - 2 * t)) / 2
	else
		return (1 + math_ease_out_bounce(2 * t - 1)) / 2
	end
end

math.ease_out_elastic = function (t)
	if t == 0 or t == 1 then
		return t
	end

	local p = 0.3

	return 2^(-10 * t) * math_sin((t - p * 0.25) * (2 * pi) / p) + 1
end

math.ease_sine = function (t)
	return 0.5 + 0.5 * math_cos((1 + t) * pi)
end

local MAX_SEED = 2147483647

math.random_seed = function (seed)
	if seed then
		local next_seed, new_seed = math.next_random(seed, MAX_SEED)

		return next_seed, new_seed
	else
		return math_random(MAX_SEED)
	end
end

math.distance_2d = function (x1, y1, x2, y2)
	local dx, dy = x2 - x1, y2 - y1

	return math_sqrt(dx * dx + dy * dy)
end

math.distance_3d = function (x1, y1, z1, x2, y2, z2)
	local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1

	return math_sqrt(dx * dx + dy * dy + dz * dz)
end

math.angle = function (x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

math.index_wrapper = function (index, max_index)
	return (index - 1) % max_index + 1
end

math.approximately_equal = function (a, b, tolerance)
	return math_abs(a - b) < (tolerance or 1e-05)
end

local _median_table = {}

math.get_median_value = function (t)
	local n = 0

	table.clear(_median_table)

	for index, value in pairs(t) do
		n = n + 1
		_median_table[n] = value
	end

	table.sort(_median_table)

	if n % 2 == 0 then
		return (_median_table[n / 2] + _median_table[n / 2 + 1]) / 2
	else
		return _median_table[(n + 1) / 2]
	end
end

math.quat_angle = function (from, to)
	local dot = math_abs(Quaternion.dot(from, to))
	local target_angle = 0

	if dot < 1 then
		target_angle = 2 * math.acos(dot)
	end

	return target_angle
end

math.quat_rotate_towards = function (from, to, angle_rad)
	local target_angle = math.quat_angle(from, to)

	if angle_rad > math_abs(target_angle) or target_angle <= 0 then
		return to
	end

	local lerp_t = math_min(1, angle_rad / target_angle)

	return Quaternion.lerp(from, to, lerp_t)
end

math.uuid = function ()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return string.gsub(template, "[xy]", function (c)
		local v = c == "x" and math.random(0, 15) or math.random(8, 11)

		return string.format("%x", v)
	end)
end

local _uuidv4_pattern = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

_uuidv4_pattern = string.gsub(_uuidv4_pattern, "x", "%%x")
_uuidv4_pattern = string.gsub(_uuidv4_pattern, "y", "[89ab]")
_uuidv4_pattern = string.gsub(_uuidv4_pattern, "-", "%%-")

math.is_uuid = function (value)
	return type(value) == "string" and #value == 36 and string.find(value, _uuidv4_pattern) ~= nil
end
