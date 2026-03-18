-- chunkname: @scripts/foundation/utilities/quaternion.lua

Quaternion.flat_no_roll = function (q)
	return Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(q))
end
