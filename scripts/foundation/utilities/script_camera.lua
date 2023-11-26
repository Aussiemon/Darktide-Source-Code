-- chunkname: @scripts/foundation/utilities/script_camera.lua

local ScriptCamera = {}

ScriptCamera.position = function (camera)
	local camera_unit = Camera.get_data(camera, "unit")

	return Unit.local_position(camera_unit, 1)
end

ScriptCamera.rotation = function (camera)
	local camera_unit = Camera.get_data(camera, "unit")

	return Unit.local_rotation(camera_unit, 1)
end

ScriptCamera.pose = function (camera)
	local camera_unit = Camera.get_data(camera, "unit")

	return Unit.local_pose(camera_unit, 1)
end

ScriptCamera.local_position = function (camera)
	local camera_unit = Camera.get_data(camera, "unit")

	return Camera.local_position(camera, camera_unit)
end

ScriptCamera.local_rotation = function (camera)
	local camera_unit = Camera.get_data(camera, "unit")

	return Camera.local_rotation(camera, camera_unit)
end

ScriptCamera.set_local_position = function (camera, position)
	local camera_unit = Camera.get_data(camera, "unit")

	Camera.set_local_position(camera, camera_unit, position)
end

ScriptCamera.set_local_rotation = function (camera, rotation)
	local camera_unit = Camera.get_data(camera, "unit")

	Camera.set_local_rotation(camera, camera_unit, rotation)
end

ScriptCamera.set_local_pose = function (camera, pose)
	local camera_unit = Camera.get_data(camera, "unit")

	Camera.set_local_pose(camera, camera_unit, pose)
end

ScriptCamera.force_update = function (world, camera)
	local camera_unit = Camera.get_data(camera, "unit")

	World.update_unit(world, camera_unit)
end

return ScriptCamera
