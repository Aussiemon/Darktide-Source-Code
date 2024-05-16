-- chunkname: @scripts/managers/camera/cameras/transform_camera.lua

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local TransformCamera = class("TransformCamera", "BaseCamera")

TransformCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._offset_position = Vector3(0, 0, 0)
end

TransformCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	if camera_settings.offset_position then
		self._offset_position = camera_settings.offset_position
	end
end

TransformCamera.update = function (self, dt, position, rotation, data)
	local offset_position = self._offset_position
	local offset_x = offset_position.x * Quaternion.right(rotation)
	local offset_y = offset_position.y * Quaternion.forward(rotation)
	local offset_z = offset_position.z * Quaternion.up(rotation)

	position = position + offset_x + offset_y + offset_z

	BaseCamera.update(self, dt, position, rotation, data)
end

return TransformCamera
