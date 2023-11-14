require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local DeadPlayerOrientation = class("DeadPlayerOrientation")

DeadPlayerOrientation.init = function (self, player, orientation)
	self._player = player
	self._orientation = orientation
	local settings = PlayerOrientationSettings.default
	self._mouse_scale = settings.mouse_scale
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
end

DeadPlayerOrientation.destroy = function (self)
	self._player = nil
	self._orientation = nil
	self._mouse_scale = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

local PI = math.pi
local PI_2 = PI * 2
local look_delta_context = {}

DeadPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local player = self._player
	local viewport_name = player.viewport_name
	local fov_sensitivity_modifier = Fov.sensitivity_modifier(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * fov_sensitivity_modifier
	local mouse_scale = self._mouse_scale
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch
	local orientation = self._orientation
	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, look_delta_context)
	local yaw = (orientation.yaw - look_delta.x) % PI_2
	local pitch = math.clamp((orientation.pitch + PI) % PI_2 - PI + look_delta.y, min_pitch, max_pitch) % PI_2
	orientation.yaw = math.mod_two_pi(yaw)
	orientation.pitch = math.mod_two_pi(pitch)
	orientation.roll = 0
end

DeadPlayerOrientation.orientation = function (self)
	return self._orientation.yaw, self._orientation.pitch, self._orientation.roll
end

DeadPlayerOrientation.orientation_offset = function (self)
	return 0, 0, 0
end

return DeadPlayerOrientation
