local Bezier = require("scripts/utilities/spline/bezier")
local SplineMovementHermiteInterpolatedMetered = require("scripts/utilities/spline/spline_movement_hermite_interpolated_metered")
local SplineCurve = class("SplineCurve")

SplineCurve.init = function (self, points, class_name, movement_class, name, subdivisions)
	self._t = 0
	self._name = name
	local splines = {}
	local spline_class = Bezier
	self._spline_class = spline_class

	self:_build_splines(splines, points, spline_class)

	self._splines = splines
	self._movement = SplineMovementHermiteInterpolatedMetered:new(self, splines, spline_class, subdivisions)
end

SplineCurve.splines = function (self)
	return self._splines
end

SplineCurve.name = function (self)
	return self._name
end

SplineCurve.recalc_splines = function (self, points, name)
	self._name = name

	self:_build_splines(self._splines, points, self._spline_class)
	self._movement:recalc_splines(self._splines)
end

SplineCurve._build_splines = function (self, splines, points, spline_class)
	local index = 1
	local spline_index = 1

	while index do
		local spline_points = {
			spline_class.spline_points(points, index)
		}
		splines[spline_index] = {
			points = spline_points
		}
		index = spline_class.next_index(points, index)
		spline_index = spline_index + 1
	end

	self._num_points = #points - 1
end

local function unpack_unbox(t, k)
	k = k or 1
	local var = t[k]

	if not var then
		return nil
	end

	return var:unbox(), unpack_unbox(t, k + 1)
end

SplineCurve.length = function (self, segments_per_spline)
	local spline_class = self._spline_class
	local length = 0

	for index, spline in ipairs(self._splines) do
		if self._num_points < index then
			break
		end

		local points = spline.points
		length = length + spline_class.length(segments_per_spline, unpack_unbox(points))
	end

	return length
end

SplineCurve.get_travel_dist_to_spline_point = function (self, point_index)
	local spline_points = self._splines
	local travel_dist = 0

	for i = 1, point_index, 1 do
		local data = spline_points[i]
		local segment_length = data.length
		travel_dist = travel_dist + segment_length
	end

	return travel_dist
end

SplineCurve.get_point_at_distance = function (self, dist)
	local spline_points = self._splines
	local spline_class = self._spline_class
	local travel_dist = 0

	for i = 1, #spline_points, 1 do
		if self._num_points < i then
			break
		end

		local data = spline_points[i]
		local segment_length = data.length

		if dist < travel_dist + segment_length then
			local t = (dist - travel_dist) / segment_length
			local s = data.points
			local p0 = s[1]:unbox()
			local p1 = s[2]:unbox()
			local p2 = s[3]:unbox()
			local p3 = s[4]:unbox()
			local position = spline_class.calc_point(t, p0, p1, p2, p3)
			local tangent = spline_class.calc_tangent(t, p0, p1, p2, p3)

			return position, tangent
		end

		travel_dist = travel_dist + segment_length
	end

	local s = spline_points[#spline_points].points

	return s[3]:unbox(), spline_class.calc_tangent(1, s[1]:unbox(), s[2]:unbox(), s[3]:unbox(), s[4]:unbox()), true
end

SplineCurve.movement = function (self)
	return self._movement
end

SplineCurve.update = function (self, dt)
	self._movement:update(dt)
end

return SplineCurve
