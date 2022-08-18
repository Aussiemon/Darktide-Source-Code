local CameraTransitionBase = require("scripts/managers/camera/transitions/camera_transition_base")
local CameraTransitionGeneric = class("CameraTransitionGeneric", "CameraTransitionBase")

CameraTransitionGeneric.init = function (self, node_1, node_2, duration, speed, settings)
	CameraTransitionBase.init(self, node_1, node_2, duration, speed, settings)

	self._transition_func = settings.transition_func
	self._parameter = settings.parameter
end

CameraTransitionGeneric.update = function (self, dt, parameter_value, update_time)
	CameraTransitionBase.update(self, dt, update_time)

	local target = self._node_2[self._parameter](self._node_2)
	local duration = self._duration
	local speed = self._speed
	local value, done = nil

	if speed and duration then
		assert(false, "CameraTransitionGeneric:update() transition has defined both speed and duration, only one can be allowed at once")
	elseif speed then
		local max_length = target - parameter_value
		local dist_moved = self._time * speed

		if max_length < dist_moved then
			value = target
			done = true
		else
			value = parameter_value + dist_moved
		end
	elseif duration then
		local t = self._time / duration
		t = math.min(t, 1)

		if self._transition_func then
			t = self._transition_func(t)
		end

		value = parameter_value * (1 - t) + target * t
		done = duration < self._time
	end

	return value, done
end
