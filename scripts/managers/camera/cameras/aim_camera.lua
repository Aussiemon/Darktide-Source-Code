local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local AimCamera = class("AimCamera", "BaseCamera")

AimCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._offset_pitch = 0
	self._offset_yaw = 0
	self._offset_roll = 0
	self._root_node = root_node
end

local INV_180 = 0.005555555555555556

AimCamera.parse_parameters = function (self, camera_settings, parent_node)
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

	self._ignore_aim_pitch = camera_settings.ignore_aim_pitch
end

AimCamera.set_root_rotation = function (self, rotation)
	BaseCamera.set_root_rotation(self, rotation)
end

AimCamera.update = function (self, dt, position, rotation, data)
	local root_node = self._root_node
	local aim_yaw = root_node:aim_yaw() + self._offset_yaw
	local aim_pitch = (self._ignore_aim_pitch and self._offset_pitch) or root_node:aim_pitch() + self._offset_pitch
	local aim_roll = root_node:aim_roll() + self._offset_roll
	local new_rotation = Quaternion.from_yaw_pitch_roll(aim_yaw, aim_pitch, aim_roll)

	BaseCamera.update(self, dt, position, new_rotation, data)
end

return AimCamera
