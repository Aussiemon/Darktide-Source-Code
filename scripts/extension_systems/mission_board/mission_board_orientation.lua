local MissionBoardOrientation = class("MissionBoardOrientation")

MissionBoardOrientation.init = function (self, orientation)
	self._mission_board_orientation = orientation
	self._movement = 0
	self._rotation_acceleration = 0
	self._rotation_deceleration = 0
	self._rotation_wanted_speed = 0
end

MissionBoardOrientation.destroy = function (self)
	self._orientation = nil
end

MissionBoardOrientation._setup_mission_board_extension = function (self)
	local mission_board_system = Managers.state.extension:system("mission_board_system")
	local mission_board_unit = mission_board_system:mission_board_unit()
	local mission_board_extension = ScriptUnit.extension(mission_board_unit, "mission_board_system")
	self._mission_board_extension = mission_board_extension
	self._rotation_acceleration = mission_board_extension:camera_rotation_acceleration()
	self._rotation_deceleration = mission_board_extension:camera_rotation_deceleration()
	self._rotation_wanted_speed = mission_board_extension:camera_rotation_wanted_speed()

	return mission_board_extension
end

MissionBoardOrientation.player_orientation = function (self, orientation)
	self._mission_board_orientation.yaw = orientation.yaw
	self._mission_board_orientation.pitch = orientation.pitch
	self._movement = 0
end

MissionBoardOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local orientation = self._mission_board_orientation
	local mission_board_extension = self._mission_board_extension
	mission_board_extension = mission_board_extension or self:_setup_mission_board_extension()
	local movement = mission_board_extension:movement()
	local yaw = orientation.yaw - movement
	yaw = math.mod_two_pi(yaw)
	orientation.yaw = yaw
	orientation.pitch = 0
	orientation.roll = 0
end

MissionBoardOrientation.orientation = function (self)
	return self._mission_board_orientation.yaw, self._mission_board_orientation.pitch, self._mission_board_orientation.roll
end

MissionBoardOrientation.orientation_offset = function (self)
	local pitch_offset = 0
	local yaw_offset = 0
	local roll_offset = 0

	return pitch_offset, yaw_offset, roll_offset
end

return MissionBoardOrientation
