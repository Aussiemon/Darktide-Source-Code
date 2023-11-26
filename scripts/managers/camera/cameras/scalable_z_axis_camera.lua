-- chunkname: @scripts/managers/camera/cameras/scalable_z_axis_camera.lua

require("scripts/managers/camera/cameras/transform_camera")

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local ScalableZAxisCamera = class("ScalableZAxisCamera", "TransformCamera")

ScalableZAxisCamera.parse_parameters = function (self, camera_settings, parent_node)
	ScalableZAxisCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._z_offset = camera_settings.z_offset
	self._scale_function = camera_settings.scale_function
	self._scale_variable = camera_settings.scale_variable
	self._max_fov = camera_settings.vertical_fov and camera_settings.vertical_fov * math.pi / 180
end

ScalableZAxisCamera.update = function (self, dt, position, rotation, data)
	local scale = data[self._scale_variable] or 1
	local scale_value = self._scale_function(scale)
	local z_offset = self._z_offset
	local offset_z = z_offset * scale_value * Vector3.up()

	position = position + offset_z

	local fov = self._max_fov

	if fov then
		local parent_fov = self._parent_node:vertical_fov()

		self._vertical_fov = parent_fov + (fov - parent_fov) * scale_value
	end

	BaseCamera.update(self, dt, position, rotation, data)
end

return ScalableZAxisCamera
