-- chunkname: @scripts/utilities/spline/bezier.lua

local Bezier = {}

Bezier.calc_point = function (t, p1, c1, c2, p2)
	local t_inv = 1 - t
	local res = t_inv^3 * p1 + 3 * t_inv^2 * t * c1 + 3 * t_inv * t^2 * c2 + t^3 * p2

	return res
end

Bezier.calc_tangent = function (t, p1, c1, c2, p2)
	local res = Vector3.normalize(-3 * (p1 * (t - 1)^2 + c1 * (-3 * t^2 + 4 * t - 1) + t * (3 * c2 * t - 2 * c2 - p2 * t)))

	return res
end

Bezier.draw = function (segments, script_drawer, tangent_scale, color, p1, c1, c2, p2)
	segments = segments or 20

	local segment_increment = 1 / segments
	local t = 0
	local point_a = Bezier.calc_point(t, p1, c1, c2, p2)

	for segment = 0, segments do
		t = segment_increment * segment

		local point_b = Bezier.calc_point(t, p1, c1, c2, p2)

		script_drawer:line(point_a, point_b, color)

		if tangent_scale then
			local tangent = Bezier.calc_tangent(t, p1, c1, c2, p2)

			script_drawer:vector(point_b, tangent * tangent_scale, color)
		end

		point_a = point_b
	end
end

Bezier.length = function (segments, p1, c1, c2, p2)
	local length = 0
	local last_point = p1

	for fraction = 1, segments - 1 do
		local point = Bezier.calc_point(fraction / segments, p1, c1, c2, p2)

		length = length + Vector3.length(point - last_point)
		last_point = point
	end

	length = length + Vector3.length(p2 - last_point)

	return length
end

Bezier.next_index = function (points, index)
	local next_index = index + 3
	local next_index_end_point = next_index + 3

	return points[next_index_end_point] and next_index or nil
end

Bezier.spline_points = function (points, index)
	return points[index], points[index + 1], points[index + 2], points[index + 3]
end

return Bezier
