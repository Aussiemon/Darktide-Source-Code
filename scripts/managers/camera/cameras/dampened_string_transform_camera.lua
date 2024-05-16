-- chunkname: @scripts/managers/camera/cameras/dampened_string_transform_camera.lua

local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local DampenedString = require("scripts/utilities/dampened_string")
local DampenedStringTransformCamera = class("DampenedStringTransformCamera", "BaseCamera")

DampenedStringTransformCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._position_box = Vector3Box(Vector3.zero())
	self._first_frame = true
end

DampenedStringTransformCamera.destroy = function (self)
	self._position_box = nil

	BaseCamera.destroy(self)
end

DampenedStringTransformCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	self._halflife = camera_settings.halflife or 0.1
end

DampenedStringTransformCamera.update = function (self, dt, position, rotation, data)
	local position_box = self._position_box
	local saved_position = position_box:unbox()

	if self._first_frame then
		saved_position = position
		self._first_frame = false
	else
		DampenedString.step(saved_position, position, self._halflife, dt)
	end

	position_box:store(saved_position)
	BaseCamera.update(self, dt, saved_position, rotation, data)
end

return DampenedStringTransformCamera
