local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local RotationCamera = class("RotationCamera", "BaseCamera")

RotationCamera.init = function (self, ...)
	RotationCamera.super.init(self, ...)

	self._offset_pitch = 0
	self._offset_yaw = 0
	self._offset_roll = 0
end

local INV_180 = 0.005555555555555556

RotationCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	if camera_settings.offset_pitch then
		self._offset_pitch = math.pi * camera_settings.offset_pitch * INV_180
	end

	if camera_settings.offset_yaw then
		self._offset_yaw = math.pi * camera_settings.offset_yaw * INV_180
	end

	if camera_settings.offset_roll then
		self._offset_roll = math.pi * camera_settings.offset_roll * INV_180
	end
end

RotationCamera.update = function (self, dt, position, rotation, data)
	local offset_yaw_rot = Quaternion(Vector3.up(), self._offset_yaw)
	local offset_pitch_rot = Quaternion(Vector3.right(), self._offset_pitch)
	local offset_roll_rot = Quaternion(Vector3.forward(), self._offset_roll)
	local new_rot = Quaternion.multiply(Quaternion.multiply(Quaternion.multiply(rotation, offset_yaw_rot), offset_pitch_rot), offset_roll_rot)

	BaseCamera.update(self, dt, position, new_rot, data)
end

return RotationCamera
