require("scripts/managers/camera/transitions/camera_transition_base")

local CameraTransitionExposureSnap = class("CameraTransitionExposureSnap", "CameraTransitionBase")

CameraTransitionExposureSnap.init = function (self, node_1, node_2, duration, speed)
	return
end

CameraTransitionExposureSnap.update = function (self, dt, update_time)
	local value = true
	local done = true

	return value, done
end

return CameraTransitionExposureSnap
