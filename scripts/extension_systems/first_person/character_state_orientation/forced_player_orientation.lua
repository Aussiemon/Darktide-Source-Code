require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local ForceLookRotation = require("scripts/extension_systems/first_person/utilities/force_look_rotation")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local ForcedPlayerOrientation = class("ForcedPlayerOrientation", "BasePlayerOrientation")

ForcedPlayerOrientation.init = function (self, player, orientation)
	ForcedPlayerOrientation.super.init(self, player, orientation)

	local settings = PlayerOrientationSettings.default
	self._mouse_scale = settings.mouse_scale
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
end

ForcedPlayerOrientation.destroy = function (self)
	ForcedPlayerOrientation.super.destroy(self)

	self._mouse_scale = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

local PI = math.pi
local PI_2 = PI * 2
local look_delta_context = {}

ForcedPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local player = self._player
	local viewport_name = player.viewport_name
	local current_fov = Fov.from_viewport(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * current_fov
	local mouse_scale = self._mouse_scale
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch
	local force_look_rotation_component = self._force_look_rotation_component

	self:_fill_look_delta_context(look_delta_context)

	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, look_delta_context)
	local yaw_offset, pitch_offset = ForceLookRotation.yaw_pitch_offset(force_look_rotation_component)
	local yaw = (self._orientation.yaw - look_delta.x + yaw_offset) % PI_2
	local pitch = math.clamp((self._orientation.pitch + PI) % PI_2 - PI + look_delta.y + pitch_offset, min_pitch, max_pitch) % PI_2
	self._orientation.yaw = math.mod_two_pi(yaw)
	self._orientation.pitch = math.mod_two_pi(pitch)
	self._orientation.roll = 0
end

return ForcedPlayerOrientation
