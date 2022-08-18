local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local CriticallyDampenedString = require("scripts/utilities/critically_dampened_string")
local CriticallyDampenedStringTransformCamera = class("CriticallyDampenedStringTransformCamera", "BaseCamera")

CriticallyDampenedStringTransformCamera.init = function (self, root_node)
	BaseCamera.init(self, root_node)

	self._position_box = Vector3Box(Vector3.zero())
	self._velocity_box = Vector3Box(Vector3.zero())
	self._camera_position_box = Vector3Box(Vector3.zero())
end

CriticallyDampenedStringTransformCamera.destroy = function (self)
	self._position_box = nil
	self._velocity_box = nil
	self._approximate_camera_velocity_box = nil

	BaseCamera.destroy(self)
end

CriticallyDampenedStringTransformCamera.parse_parameters = function (self, camera_settings, parent_node)
	BaseCamera.parse_parameters(self, camera_settings, parent_node)

	self._halflife = camera_settings.halflife or 0.1
end

CriticallyDampenedStringTransformCamera.update = function (self, dt, position, rotation, data)
	local position_box = self._position_box
	local velocity_box = self._velocity_box
	local camera_position_box = self._camera_position_box
	local last_frames_camera_position = camera_position_box:unbox()
	local approximate_camera_velocity = (position - last_frames_camera_position) / dt
	local saved_position = position_box:unbox()
	local saved_velocity = velocity_box:unbox()

	CriticallyDampenedString.step(saved_position, saved_velocity, position, approximate_camera_velocity, self._halflife, dt)
	position_box:store(saved_position)
	velocity_box:store(saved_velocity)
	camera_position_box:store(position)
	BaseCamera.update(self, dt, saved_position, rotation, data)
end

return CriticallyDampenedStringTransformCamera
