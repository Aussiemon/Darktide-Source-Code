local Hermite = {
	calc_point = function (t, p0, p1, p2, p3)
		local t2 = t * t
		local t3 = t2 * t
		local two_t3 = t3 + t3
		local two_t2 = t2 + t2
		local three_t2 = two_t2 + t2
		local h1 = two_t3 - three_t2 + 1
		local h2 = three_t2 - two_t3
		local h3 = t3 - two_t2 + t
		local h4 = t3 - t2
		local length = Vector3.length(p2 - p1)
		local t1 = Vector3.normalize(p2 - p0) * length
		local t2 = Vector3.normalize(p3 - p1) * length
		local res = p1 * h1 + p2 * h2 + t1 * h3 + t2 * h4

		return res
	end,
	calc_tangent = function (t, p0, p1, p2, p3)
		local t_sq = t * t
		local dh1 = 6 * t_sq - 6 * t
		local dh2 = 6 * t - 6 * t_sq
		local dh3 = 3 * t_sq - 4 * t + 1
		local dh4 = 3 * t_sq - 2 * t
		local length = Vector3.length(p2 - p1)
		local t1 = Vector3.normalize(p2 - p0) * length
		local t2 = Vector3.normalize(p3 - p1) * length
		local res = p1 * dh1 + p2 * dh2 + t1 * dh3 + t2 * dh4

		return res
	end
}

Hermite.draw = function (segments, script_drawer, tangent_scale, color, p0, p1, p2, p3)
	segments = segments or 20
	local segment_increment = 1 / segments
	local t = 0
	local point_a = Hermite.calc_point(t, p0, p1, p2, p3)

	for segment = 0, segments do
		t = segment_increment * segment
		local point_b = Hermite.calc_point(t, p0, p1, p2, p3)

		script_drawer:line(point_a, point_b, color)

		if tangent_scale then
			local tangent = Hermite.calc_tangent(t, p0, p1, p2, p3)

			script_drawer:vector(point_b, tangent * tangent_scale, color)
		end

		point_a = point_b
	end
end

Hermite.length = function (segments, p0, p1, p2, p3)
	local length = 0
	local last_point = p1

	for fraction = 1, segments - 1 do
		local point = Hermite.calc_point(fraction / segments, p0, p1, p2, p3)
		length = length + Vector3.length(point - last_point)
		last_point = point
	end

	length = length + Vector3.length(p2 - last_point)

	return length
end

Hermite.next_index = function (points, index)
	local next_index = index + 1
	local next_index_end_point = next_index + 1

	return points[next_index_end_point] and next_index or nil
end

Hermite.spline_points = function (points, index)
	local p1 = points[index]
	local p2 = points[index + 1]
	local p0 = points[index - 1] or 2 * p1 - p2
	local p3 = points[index + 2] or 2 * p2 - p1

	return p0, p1, p2, p3
end

return Hermite
