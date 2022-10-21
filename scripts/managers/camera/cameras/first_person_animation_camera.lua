local BaseCamera = require("scripts/managers/camera/cameras/base_camera")
local FirstPersonAnimationCamera = class("FirstPersonAnimationCamera", "BaseCamera")

FirstPersonAnimationCamera.parse_parameters = function (self, camera_settings, ...)
	BaseCamera.parse_parameters(self, camera_settings, ...)

	self._animation_object = camera_settings.animation_object
end

FirstPersonAnimationCamera.set_root_unit = function (self, unit, object)
	BaseCamera.set_root_unit(self, unit, object)

	local first_person_ext = ScriptUnit.extension(unit, "first_person_system")
	self._first_person_unit = first_person_ext:first_person_unit()
	self._animation_object_id = Unit.node(self._first_person_unit, self._animation_object)
end

FirstPersonAnimationCamera.update = function (self, dt, position, rotation, data)
	local root_unit = self._root_unit
	local rot_offset = Quaternion.identity()
	local pos_offset = Vector3.zero()

	if ALIVE[root_unit] then
		local pose = Unit.local_pose(self._first_person_unit, self._animation_object_id)
		pos_offset = Matrix4x4.translation(pose)
		rot_offset = Matrix4x4.rotation(pose)
	end

	local new_rotation = Quaternion.multiply(rotation, rot_offset)
	local new_position = position + Quaternion.rotate(new_rotation, pos_offset)

	BaseCamera.update(self, dt, new_position, new_rotation, data)
end

return FirstPersonAnimationCamera
