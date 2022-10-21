local CommunicationWheelPlayerOrientation = class("CommunicationWheelPlayerOrientation")

CommunicationWheelPlayerOrientation.init = function (self, orientation)
	self._orientation = orientation
end

CommunicationWheelPlayerOrientation.destroy = function (self)
	self._orientation = nil
end

CommunicationWheelPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	return
end

CommunicationWheelPlayerOrientation.orientation = function (self)
	local orientation = self._orientation

	return orientation.yaw, orientation.pitch, orientation.roll
end

CommunicationWheelPlayerOrientation.orientation_offset = function (self)
	return 0, 0, 0
end

return CommunicationWheelPlayerOrientation
