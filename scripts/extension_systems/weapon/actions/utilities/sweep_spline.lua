-- chunkname: @scripts/extension_systems/weapon/actions/utilities/sweep_spline.lua

local Hermite = require("scripts/utilities/spline/hermite")
local SweepSplineTemplates = require("scripts/settings/equipment/sweep_spline_templates")
local SweepSpline = class("SweepSpline")

local function _apply_first_person_context(local_point, first_person, anchor_point_offset)
	local pos = first_person.position
	local rot = first_person.rotation

	if anchor_point_offset then
		local local_anchor_point_offset = Vector3(anchor_point_offset[1], anchor_point_offset[2], anchor_point_offset[3])
		local world_anchor_point_offset = Quaternion.rotate(rot, local_anchor_point_offset)

		pos = pos + world_anchor_point_offset
	end

	local world_offset = Quaternion.rotate(rot, local_point)

	return pos + world_offset, world_offset
end

SweepSpline.init = function (self, spline_settings, first_person_component)
	self._first_person_component = first_person_component

	if not spline_settings.points then
		local template = SweepSplineTemplates[spline_settings.template]

		spline_settings.points = table.clone(template.points)
	end

	if not spline_settings.anchor_point_offset then
		spline_settings.anchor_point_offset = {
			0,
			0,
			0
		}
	end

	self:_build(spline_settings)
end

SweepSpline.position_and_rotation = function (self, t)
	local num_splines = self._num_splines
	local spline_t = t * num_splines
	local splines_index = t == 1 and num_splines or math.floor(spline_t) + 1
	local local_t = spline_t - (splines_index - 1)
	local points = self._splines[splines_index].points
	local p1, p2, p3, p4 = points[1]:unbox(), points[2]:unbox(), points[3]:unbox(), points[4]:unbox()
	local point = Hermite.calc_point(local_t, p1, p2, p3, p4)
	local sweep_position, anchor_to_point_offset = _apply_first_person_context(point, self._first_person_component, self._anchor_point_offset)
	local tangent = Hermite.calc_tangent(local_t, p1, p2, p3, p4)

	tangent.y = 0

	local tangent_dir = Vector3.normalize(tangent)
	local roll = Vector3.angle(Vector3.right(), tangent_dir)

	if Vector3.dot(Vector3.up(), tangent_dir) > 0 then
		roll = -roll
	end

	local roll_rotation = Quaternion(Vector3.forward(), roll)
	local anchor_to_point_dir = Vector3.normalize(anchor_to_point_offset)
	local anchor_to_point_rotation = Quaternion.look(anchor_to_point_dir, Vector3.up())
	local sweep_rotation = Quaternion.multiply(anchor_to_point_rotation, roll_rotation)

	return sweep_position, sweep_rotation
end

SweepSpline.rebuild = function (self, spline_settings)
	self:_build(spline_settings)
end

SweepSpline._build = function (self, spline_settings)
	self._anchor_point_offset = spline_settings.anchor_point_offset

	local points = self:_create_points(spline_settings.points)

	self._splines, self._num_splines = self:_build_splines(points)

	local num_points = #points

	for i = 1, num_points do
		local point = points[i]

		points[i] = Vector3Box(point)
	end

	self._points = points
	self._num_points = num_points
end

SweepSpline._create_points = function (self, points)
	local spline_points = {}

	for i = 1, #points do
		local point = points[i]

		spline_points[i] = Vector3(point[1], point[2], point[3])
	end

	return spline_points
end

SweepSpline._build_splines = function (self, points)
	local splines = {}
	local index = 1
	local spline_index = 1

	while index do
		local spline_points = {
			Hermite.spline_points(points, index)
		}

		for i, point in ipairs(spline_points) do
			spline_points[i] = Vector3Box(point)
		end

		splines[spline_index] = {
			points = spline_points
		}
		index = Hermite.next_index(points, index)
		spline_index = spline_index + 1
	end

	return splines, #splines
end

SweepSpline.point = function (self, index)
	local point = self._points[index]

	return point:unbox()
end

SweepSpline.num_points = function (self)
	return self._num_points
end

return SweepSpline
