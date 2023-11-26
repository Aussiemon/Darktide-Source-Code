-- chunkname: @scripts/managers/camera/cameras/scalable_transform_camera.lua

require("scripts/managers/camera/cameras/transform_camera")

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local ScalableTransformCamera = class("ScalableTransformCamera", "TransformCamera")

ScalableTransformCamera.parse_parameters = function (self, camera_settings, parent_node)
	ScalableTransformCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._scale_function = camera_settings.scale_function
	self._scale_variable = camera_settings.scale_variable
	self._max_fov = camera_settings.vertical_fov and camera_settings.vertical_fov * math.pi / 180
	self._ignore_offset_variable = "ignore_offset"
end

ScalableTransformCamera.update = function (self, dt, position, rotation, data)
	local scale = data[self._scale_variable] or 1
	local scale_value = self._scale_function(scale)
	local ignore_offset = data[self._ignore_offset_variable]
	local offset_position = not ignore_offset and self._offset_position or Vector3(0, 0, 0)
	local offset_x = offset_position.x * scale_value * Quaternion.right(rotation)
	local offset_y = offset_position.y * scale_value * Quaternion.forward(rotation)
	local offset_z = offset_position.z * scale_value * Quaternion.up(rotation)

	position = position + offset_x + offset_y + offset_z

	local fov = self._max_fov

	if fov then
		local parent_fov = self._parent_node:vertical_fov()

		self._vertical_fov = parent_fov + (fov - parent_fov) * scale_value
	end

	BaseCamera.update(self, dt, position, rotation, data)
end

ScalableTransformCamera.set_ignore_offset = function (self, ignore_offset)
	self._ignore_offset = ignore_offset
end

return ScalableTransformCamera
