-- chunkname: @scripts/managers/camera/cameras/offset_camera.lua

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local OffsetCamera = class("OffsetCamera", "BaseCamera")

OffsetCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._offset_position = Vector3(0, 0, 0)
end

OffsetCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)
end

OffsetCamera.update = function (self, dt, position, rotation, data)
	local offset_position = data.offset_position or Vector3(0, 0, 0)
	local offset_x = offset_position.x * Quaternion.right(rotation)
	local offset_y = offset_position.y * Quaternion.forward(rotation)
	local offset_z = offset_position.z * Quaternion.up(rotation)

	position = position + offset_x + offset_y + offset_z

	BaseCamera.update(self, dt, position, rotation, data)
end

return OffsetCamera
