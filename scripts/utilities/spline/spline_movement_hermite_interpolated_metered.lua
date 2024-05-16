-- chunkname: @scripts/utilities/spline/spline_movement_hermite_interpolated_metered.lua

local Hermite = require("scripts/utilities/spline/hermite")
local SplineMovementHermiteInterpolatedMetered = class("SplineMovementHermiteInterpolatedMetered")

SplineMovementHermiteInterpolatedMetered.init = function (self, spline_curve, splines, spline_class, subdivisions)
	self._splines = splines
	self._spline_curve = spline_curve
	self._spline_class = spline_class
	self._speed = 0
	self._current_spline_index = 1
	self._t = 0
	self._current_subdivision_index = 1
	self._current_spline_curve_distance = 0

	self:_build_subdivisions(subdivisions, splines, spline_class)
end

SplineMovementHermiteInterpolatedMetered.recalc_splines = function (self)
	self:_set_spline_lengths(self._splines, self._spline_class)
end

local function unpack_unbox(t, k)
	k = k or 1

	local var = t[k]

	if not var then
		return nil
	end

	return var:unbox(), unpack_unbox(t, k + 1)
end

SplineMovementHermiteInterpolatedMetered._build_subdivisions = function (self, subdivisions, splines, spline_class)
	local first_point = spline_class.calc_point(0, unpack_unbox(splines[1].points))
	local points = {}

	points[0] = first_point

	for index, spline in ipairs(splines) do
		for sub_index = 1, subdivisions do
			local point = spline_class.calc_point(sub_index / subdivisions, unpack_unbox(spline.points))

			points[#points + 1] = point
		end
	end

	points[-1] = first_point
	points[#points + 1] = points[#points]

	for index, spline in ipairs(splines) do
		local subs = {}
		local point_index = (index - 1) * subdivisions

		spline.length = 0

		for sub_index = 1, subdivisions do
			local sub = {}
			local p0, p1, p2, p3 = points[point_index - 1], points[point_index], points[point_index + 1], points[point_index + 2]

			sub.points = {
				Vector3Box(p0),
				Vector3Box(p1),
				Vector3Box(p2),
				Vector3Box(p3),
			}

			local vectors, quaternions, matrices = Script.temp_count()

			sub.length = Hermite.length(10, p0, p1, p2, p3)

			Script.set_temp_count(vectors, quaternions, matrices)

			point_index = point_index + 1
			subs[#subs + 1] = sub
			spline.length = spline.length + sub.length
		end

		spline.subdivisions = subs
	end
end

SplineMovementHermiteInterpolatedMetered._set_spline_lengths = function (self, splines, spline_class, segments_per_spline)
	segments_per_spline = segments_per_spline or 10

	for index, spline in ipairs(splines) do
		local points = spline.points

		spline.length = spline_class.length(segments_per_spline, unpack_unbox(points))
	end
end

SplineMovementHermiteInterpolatedMetered.current_position = function (self)
	local current_subdivision = self:_current_spline_subdivision()

	return Hermite.calc_point(self._t, unpack_unbox(current_subdivision.points))
end

SplineMovementHermiteInterpolatedMetered.current_tangent_direction = function (self)
	local current_subdivision = self:_current_spline_subdivision()

	return Hermite.calc_tangent(self._t, unpack_unbox(current_subdivision.points))
end

SplineMovementHermiteInterpolatedMetered._current_spline = function (self)
	return self._splines[self._current_spline_index]
end

SplineMovementHermiteInterpolatedMetered.update = function (self, dt)
	local state = self:move(dt * self._speed)

	return state
end

SplineMovementHermiteInterpolatedMetered.distance = function (self, from_index, from_subdiv, from_spline_t, to_index, to_subdiv, to_spline_t)
	local distance = 0
	local splines = self._splines

	if to_index < from_index then
		local from_spline = splines[from_index]

		distance = distance - from_spline_t * from_spline.subdivisions[from_subdiv].length

		local from_subdivs = from_spline.subdivisions

		for i = 1, from_subdiv - 1 do
			distance = distance - from_subdivs[i].length
		end

		for i = to_index + 1, from_index - 1 do
			distance = distance - splines[i].length
		end

		local to_spline = splines[to_index]
		local to_subdivs = to_spline.subdivisions

		for i = to_subdiv + 1, #to_subdivs do
			distance = distance - to_subdivs[i].length
		end

		distance = distance - (1 - to_spline_t) * to_subdivs[to_subdiv].length
	elseif from_index < to_index then
		local from_spline = splines[from_index]
		local from_subdivs = from_spline.subdivisions

		distance = distance + (1 - from_spline_t) * from_subdivs[from_subdiv].length

		for i = from_subdiv + 1, #from_subdivs do
			distance = distance + from_subdivs[i].length
		end

		for i = from_index + 1, to_index - 1 do
			distance = distance + splines[i].length
		end

		local to_spline = splines[to_index]
		local to_subdivs = to_spline.subdivisions

		for i = 1, to_subdiv - 1 do
			distance = distance + to_subdivs[i].length
		end

		distance = distance + to_spline_t * to_subdivs[to_subdiv].length
	elseif from_index == to_index and from_subdiv < to_subdiv then
		local subdivs = splines[from_index].subdivisions

		distance = distance + (1 - from_spline_t) * subdivs[from_subdiv].length

		for i = from_subdiv + 1, to_subdiv - 1 do
			distance = distance + subdivs[i].length
		end

		distance = distance + to_spline_t * subdivs[to_subdiv].length
	elseif from_index == to_index and to_subdiv < from_subdiv then
		local subdivs = splines[from_index].subdivisions

		distance = distance - from_spline_t * subdivs[from_subdiv].length

		for i = to_subdiv + 1, from_subdiv - 1 do
			distance = distance - subdivs[i].length
		end

		distance = distance - (1 - to_spline_t) * subdivs[to_subdiv].length
	else
		distance = (to_spline_t - from_spline_t) * splines[from_index].subdivisions[from_subdiv].length
	end

	return distance
end

SplineMovementHermiteInterpolatedMetered.set_speed = function (self, speed)
	self._speed = speed
end

SplineMovementHermiteInterpolatedMetered.speed = function (self)
	return self._speed
end

SplineMovementHermiteInterpolatedMetered._current_spline_subdivision = function (self)
	return self:_current_spline().subdivisions[self._current_subdivision_index]
end

SplineMovementHermiteInterpolatedMetered.move = function (self, delta)
	local current_spline = self:_current_spline()
	local current_subdivision = self:_current_spline_subdivision()
	local current_subdivision_length = current_subdivision.length
	local new_t = self._t + delta / current_subdivision_length

	if new_t > 1 and self._current_spline_index == #self._splines and self._current_subdivision_index == #current_spline.subdivisions then
		self._t = 1

		local remainder = (new_t - 1) * current_subdivision_length
		local moved_distance = delta - remainder

		self._current_spline_curve_distance = self._current_spline_curve_distance + moved_distance

		return "end"
	elseif new_t > 1 then
		self._current_subdivision_index = self._current_subdivision_index + 1

		if self._current_subdivision_index > #current_spline.subdivisions then
			self._current_subdivision_index = 1
			self._current_spline_index = self._current_spline_index + 1
		end

		self._t = 0

		local remainder = (new_t - 1) * current_subdivision_length
		local moved_distance = delta - remainder

		self._current_spline_curve_distance = self._current_spline_curve_distance + moved_distance

		return self:move(remainder)
	elseif new_t <= 0 and self._current_spline_index == 1 and self._current_subdivision_index == 1 then
		self._t = 0
		self._current_spline_curve_distance = 0

		return "start"
	elseif new_t < 0 then
		self._current_subdivision_index = self._current_subdivision_index - 1

		if self._current_subdivision_index == 0 then
			self._current_spline_index = self._current_spline_index - 1
			self._current_subdivision_index = #self:_current_spline().subdivisions
		end

		self._t = 1

		local remainder = new_t * current_subdivision_length
		local moved_distance = delta - remainder

		self._current_spline_curve_distance = self._current_spline_curve_distance + moved_distance

		return self:move(remainder)
	else
		self._t = new_t
		self._current_spline_curve_distance = self._current_spline_curve_distance + delta

		return "moving"
	end
end

SplineMovementHermiteInterpolatedMetered.reset_to_start = function (self)
	self._current_spline_index = 1
	self._current_subdivision_index = 1
	self._t = 0
	self._current_spline_curve_distance = 0
end

SplineMovementHermiteInterpolatedMetered.reset_to_end = function (self)
	local current_spline = self:_current_spline()

	self._current_spline_index = #self._splines
	self._current_subdivision_index = #current_spline.subdivisions
	self._t = 1

	local from_spline_index, from_subdivision_index, from_t = 1, 1, 0
	local to_spline_index, to_subdivision_index, to_t = self._current_spline_index, self._current_subdivision_index, self._t

	self._current_spline_curve_distance = self:distance(from_spline_index, from_subdivision_index, from_t, to_spline_index, to_subdivision_index, to_t)
end

SplineMovementHermiteInterpolatedMetered.set_spline_index = function (self, spline_index, subdivision_index, t)
	self._current_spline_index = spline_index
	self._current_subdivision_index = subdivision_index
	self._t = t

	local from_spline_index, from_subdivision_index, from_t = 1, 1, 0

	self._current_spline_curve_distance = self:distance(from_spline_index, from_subdivision_index, from_t, spline_index, subdivision_index, t)
end

SplineMovementHermiteInterpolatedMetered.current_spline_index = function (self)
	return self._current_spline_index
end

SplineMovementHermiteInterpolatedMetered.current_subdivision_index = function (self)
	return self._current_subdivision_index
end

SplineMovementHermiteInterpolatedMetered.current_t = function (self)
	return self._t
end

SplineMovementHermiteInterpolatedMetered.current_spline_curve_distance = function (self)
	return self._current_spline_curve_distance
end

return SplineMovementHermiteInterpolatedMetered
