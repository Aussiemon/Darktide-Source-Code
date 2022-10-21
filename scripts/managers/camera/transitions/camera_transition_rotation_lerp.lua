local CameraTransitionBase = require("scripts/managers/camera/transitions/camera_transition_base")
local CameraTransitionRotationLerp = class("CameraTransitionRotationLerp", "CameraTransitionBase")

CameraTransitionRotationLerp.init = function (self, node_1, node_2, duration, speed, settings)
	CameraTransitionBase.init(self, node_1, node_2, duration, speed, settings)

	self._freeze_node_1 = settings.freeze_start_node

	if self._freeze_node_1 then
		local node_1_rot = node_1:rotation()
		self._node_1_rot_table = QuaternionBox(node_1_rot)
	end

	self._transition_func = settings.transition_func
end

CameraTransitionRotationLerp.update = function (self, dt, rotation, update_time)
	CameraTransitionBase.update(self, dt, update_time)

	local node_1_rot = self._freeze_node_1 and self._node_1_rot_table:unbox() or rotation
	local node_2_rot = self._node_2:rotation()
	local duration = self._duration
	local t = self._time / duration
	t = math.min(t, 1)
	local done = t == 1

	if self._transition_func then
		t = self._transition_func(t)
	end

	local rot = Quaternion.lerp(node_1_rot, node_2_rot, math.min(t, 1))

	return rot, done
end

return CameraTransitionRotationLerp
