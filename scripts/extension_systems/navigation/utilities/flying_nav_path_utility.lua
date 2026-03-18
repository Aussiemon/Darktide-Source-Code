-- chunkname: @scripts/extension_systems/navigation/utilities/flying_nav_path_utility.lua

local FlyingNavPathUtility = {}

FlyingNavPathUtility.num_spline_segments = function ()
	return 20
end

FlyingNavPathUtility.position_in_spline = function (from_point, to_point, t)
	local p1 = from_point
	local c1 = from_point.exit_bezier_point
	local c2 = to_point.entry_bezier_point
	local p2 = to_point
	local u = 1 - t
	local u2 = u * u
	local u3 = u2 * u
	local t2 = t * t
	local t3 = t2 * t

	return Vector3(p1[1] * u3 + c1[1] * (3 * u2 * t) + c2[1] * (3 * u * t2) + p2[1] * t3, p1[2] * u3 + c1[2] * (3 * u2 * t) + c2[2] * (3 * u * t2) + p2[2] * t3, p1[3] * u3 + c1[3] * (3 * u2 * t) + c2[3] * (3 * u * t2) + p2[3] * t3)
end

return FlyingNavPathUtility
