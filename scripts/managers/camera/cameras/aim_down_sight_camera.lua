require("scripts/managers/camera/cameras/transform_camera")

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local AimDownSightCamera = class("AimDownSightCamera", "TransformCamera")

AimDownSightCamera.parse_parameters = function (self, camera_settings, parent_node)
	AimDownSightCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._default_vertical_fov = math.degrees_to_radians(camera_settings.default_vertical_fov)
	self._default_custom_vertical_fov = math.degrees_to_radians(camera_settings.default_custom_vertical_fov)
	self._default_near_range = camera_settings.default_near_range
	self._vertical_fov_variable = camera_settings.vertical_fov_variable
	self._custom_vertical_fov_variable = camera_settings.custom_vertical_fov_variable
	self._near_range_variable = camera_settings.near_range_variable
end

AimDownSightCamera.update = function (self, dt, position, rotation, data)
	local offset_position = self._offset_position
	local offset_x = offset_position.x * Quaternion.right(rotation)
	local offset_y = offset_position.y * Quaternion.forward(rotation)
	local offset_z = offset_position.z * Quaternion.up(rotation)
	position = position + offset_x + offset_y + offset_z
	local vertical_fov = data[self._vertical_fov_variable] or self._default_vertical_fov
	local custom_vertical_fov = data[self._custom_vertical_fov_variable] or self._default_custom_vertical_fov
	local near_range = data[self._near_range_variable] or self._default_near_range
	self._vertical_fov = vertical_fov * self._fov_multiplier
	self._custom_vertical_fov = custom_vertical_fov
	self._near_range = near_range

	BaseCamera.update(self, dt, position, rotation, data)
end

return AimDownSightCamera
