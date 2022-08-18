local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local LerpRotationCamera = class("LerpRotationCamera", "BaseCamera")

LerpRotationCamera.init = function (self, ...)
	LerpRotationCamera.super.init(self, ...)

	self._offset_pitch = 0
	self._offset_yaw = 0
	self._old_lerp_rotation = nil
end

local INV_180 = 0.005555555555555556

LerpRotationCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	if camera_settings.offset_pitch then
		self._offset_pitch = math.pi * camera_settings.offset_pitch * INV_180
	end

	if camera_settings.offset_yaw then
		self._offset_yaw = math.pi * camera_settings.offset_yaw * INV_180
	end
end

LerpRotationCamera.update = function (self, dt, position, rotation, data)
	local lerp_rotation = nil

	if data.end_rotation_variable then
		local start_rotation_variable = nil

		if data.start_rotation_variable then
			start_rotation_variable = data.start_rotation_variable:unbox()
		end

		if not self._old_lerp_rotation then
			local old_lerp_rotation = start_rotation_variable or rotation
			self._old_lerp_rotation = QuaternionBox(old_lerp_rotation)
		end

		local old_rotation = self._old_lerp_rotation:unbox()
		local end_rotation = data.end_rotation_variable:unbox()
		local lerp_t = dt * 2
		lerp_rotation = Quaternion.lerp(old_rotation, end_rotation, lerp_t)

		self._old_lerp_rotation:store(lerp_rotation)
	else
		lerp_rotation = (self._old_lerp_rotation and self._old_lerp_rotation:unbox()) or rotation
		self._old_lerp_rotation = nil
	end

	local rot = lerp_rotation or rotation
	local offset_yaw_rot = Quaternion(Vector3.up(), self._offset_yaw)
	local offset_pitch_rot = Quaternion(Vector3.right(), self._offset_pitch)
	local new_rot = Quaternion.multiply(Quaternion.multiply(rot, offset_yaw_rot), offset_pitch_rot)

	BaseCamera.update(self, dt, position, new_rot, data)
end

return LerpRotationCamera
