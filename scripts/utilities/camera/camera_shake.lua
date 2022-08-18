local CameraShake = {
	camera_shake_by_distance = function (shake_name, source_unit, near_dist, far_dist, near_value, far_value)
		local source_unit_data = nil

		if source_unit then
			source_unit_data = {}
			local v3 = Unit.local_position(source_unit, 1)
			source_unit_data.source_unit_position = Vector3Box(v3)
			source_unit_data.near_dist = near_dist
			source_unit_data.far_dist = far_dist
			source_unit_data.near_value = near_value
			source_unit_data.far_value = far_value
		end

		Managers.state.camera:camera_effect_shake_event(shake_name, source_unit_data)
	end
}

return CameraShake
