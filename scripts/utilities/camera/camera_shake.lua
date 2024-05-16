﻿-- chunkname: @scripts/utilities/camera/camera_shake.lua

local CameraShake = {}

CameraShake.camera_shake_by_distance = function (shake_name, position, near_dist, far_dist, near_value, far_value)
	local source_unit_data = {}

	source_unit_data.source_position = Vector3Box(position)
	source_unit_data.near_dist = near_dist
	source_unit_data.far_dist = far_dist
	source_unit_data.near_value = near_value
	source_unit_data.far_value = far_value

	Managers.state.camera:camera_effect_shake_event(shake_name, source_unit_data)
end

return CameraShake
