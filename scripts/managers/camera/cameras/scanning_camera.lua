local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local ScanningCamera = class("ScanningCamera", "BaseCamera")

ScanningCamera.init = function (self, root_node)
	ScanningCamera.super.init(self, root_node)

	self._reset = true
	self._current_rotation = QuaternionBox(Quaternion.identity())
end

ScanningCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	self._angle_tolerance = camera_settings.angle_tolerance
end

ScanningCamera.set_active = function (self, active)
	local old_active = self:active()

	if active and not old_active then
		self._reset = true
	end

	ScanningCamera.super.set_active(self, active)
end

ScanningCamera.update = function (self, dt, position, rotation, data)
	if self._reset then
		self._reset = false

		self._current_rotation:store(rotation)
	end

	local current_rotation = self._current_rotation:unbox()
	local angle = Quaternion.angle(rotation, current_rotation)
	local angle_tolerance = self._angle_tolerance

	if angle_tolerance < angle then
		local angle_differnce = angle - angle_tolerance
		local lerp_t = math.clamp01(angle_differnce / math.pi)
		current_rotation = Quaternion.lerp(current_rotation, rotation, lerp_t)
	end

	self._current_rotation:store(current_rotation)
	BaseCamera.update(self, dt, position, current_rotation, data)
end

return ScanningCamera
