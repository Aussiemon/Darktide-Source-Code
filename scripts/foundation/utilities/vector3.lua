local Vector3 = Vector3
local Vector3_to_elements = Vector3.to_elements

Vector3.flat = function (v)
	local x, y = Vector3_to_elements(v)

	return Vector3(x, y, 0)
end

Vector3.step = function (start, target, step_size)
	local offset = target - start
	local distance = Vector3.length(offset)

	if distance < step_size then
		return target, true
	else
		return start + Vector3.normalize(offset) * step_size, false
	end
end

Vector3.smoothstep = function (t, v1, v2)
	local smoothstep = math.smoothstep(t, 0, 1)

	return Vector3.lerp(v1, v2, smoothstep)
end

local PI = math.pi

Vector3.flat_angle = function (v1, v2)
	local a1 = math.atan2(v1.y, v1.x)
	local a2 = math.atan2(v2.y, v2.x)

	return (a2 - a1 + PI) % (2 * PI) - PI
end

Vector3.clamp = function (v, min, max)
	local x, y, z = Vector3.to_elements(v)
	local math_clamp = math.clamp

	return Vector3(math_clamp(x, min, max), math_clamp(y, min, max), math_clamp(z, min, max))
end

Vector3.invalid_vector = function ()
	return Vector3(math.huge, math.huge, math.huge)
end

Vector3.to_array = function (vector, array)
	array = array or {}
	array[1], array[2], array[3] = Vector3.to_elements(vector)

	return array
end

Vector3.from_array = function (array)
	return Vector3(array[1], array[2], array[3])
end

Vector3.from_array_flat = function (array)
	return Vector3(array[1], array[2], 0)
end

Vector3.from_table = function (table)
	return Vector3(table.x, table.y, table.z)
end

Vector3.compact_string = function (v)
	return string.format("(%g,%g,%g)", v[1], v[2], v[3])
end

Vector3.from_compact_string = function (s)
	local x, y, z = string.match(s, "([%d%.]+)%,([%d%.]+)%,([%d%.]+)")

	return Vector3(x, y, z)
end

Vector3.one = function ()
	return Vector3(1, 1, 1)
end

Vector3.slerp = function (start, stop, d)
	local dot = Vector3.dot(start, stop)
	local theta = math.acos(dot) * d
	local relative_vec = Vector3.normalize(stop - start * dot)
	local result = start * math.cos(theta) + relative_vec * math.sin(theta)

	return result
end

local EPSILON = 1e-05

Vector3.project_on_normal = function (vector, plane_normal)
	local square_magnitude = Vector3.dot(plane_normal, plane_normal)

	if square_magnitude < EPSILON then
		return Vector3.zero()
	end

	local dot = Vector3.dot(vector, plane_normal)
	local projected_vector = plane_normal * dot / square_magnitude

	return projected_vector
end

Vector3.project_on_plane = function (vector, plane_normal)
	local square_magnitude = Vector3.dot(plane_normal, plane_normal)

	if square_magnitude < EPSILON then
		return Vector3.zero()
	end

	local dot = Vector3.dot(vector, plane_normal)

	return Vector3(vector.x - plane_normal.x * dot / square_magnitude, vector.y - plane_normal.y * dot / square_magnitude, vector.z - plane_normal.z * dot / square_magnitude)
end
