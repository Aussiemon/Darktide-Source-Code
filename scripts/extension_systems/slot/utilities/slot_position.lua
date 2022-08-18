local SlotPosition = {}
local Quaternion_rotate = Quaternion.rotate
local Vector3_normalize = Vector3.normalize
local Vector3_flat = Vector3.flat

SlotPosition.rotated_around_origin = function (origin, position, radians, distance)
	local direction_vector = Vector3_normalize(Vector3_flat(position - origin))
	local rotation = Quaternion(-Vector3.up(), radians)
	local vector = Quaternion_rotate(rotation, direction_vector)
	local position_rotated = origin + vector * distance

	return position_rotated
end

return SlotPosition
