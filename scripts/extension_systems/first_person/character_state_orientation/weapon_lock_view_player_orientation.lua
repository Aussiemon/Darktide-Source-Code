require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local _look_delta = nil
local WeaponLockViewPlayerOrientation = class("WeaponLockViewPlayerOrientation", "BasePlayerOrientation")

WeaponLockViewPlayerOrientation.init = function (self, player, orientation)
	WeaponLockViewPlayerOrientation.super.init(self, player, orientation)

	local settings = PlayerOrientationSettings.default
	self._mouse_scale = settings.mouse_scale
	self._delta_x = 0
	self._delta_y = 0
	self._look_delta_x = 0
	self._look_delta_y = 0
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
end

WeaponLockViewPlayerOrientation.destroy = function (self)
	WeaponLockViewPlayerOrientation.super.destroy(self)

	self._mouse_scale = nil
	self._delta_x = nil
	self._delta_y = nil
	self._look_delta_x = nil
	self._look_delta_y = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

local PI = math.pi
local PI_2 = PI * 2
local context = {}
local INPUT_MODIFIER = 0.05
local MAX_DELTA = 0.01
local DECELERATION = -5
local YAW_CONSTRAINT = PI * 0.2
local PITCH_CONSTRAINT = PI * 0.25

WeaponLockViewPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local player = self._player
	local viewport_name = player.viewport_name
	local current_fov = Fov.sensitivity_modifier(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * current_fov * INPUT_MODIFIER
	local mouse_scale = self._mouse_scale
	local orientation = self._orientation
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch

	table.clear(context)

	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, context)
	local look_delta_x = _look_delta(look_delta.x, self._look_delta_x, DECELERATION, MAX_DELTA, main_dt)
	local look_delta_y = _look_delta(look_delta.y, self._look_delta_y, DECELERATION, MAX_DELTA, main_dt)
	self._look_delta_x = look_delta_x
	self._look_delta_y = look_delta_y
	local weapon_lock_view = self._weapon_lock_view_component
	local yaw_origin = weapon_lock_view.yaw
	local pitch_origin = weapon_lock_view.pitch
	local yaw = Orientation.clamp_from_origin(orientation.yaw, look_delta_x, yaw_origin, YAW_CONSTRAINT)
	local pitch = Orientation.clamp_from_origin(orientation.pitch, -look_delta_y, pitch_origin, PITCH_CONSTRAINT)
	pitch = math.clamp((pitch + PI) % PI_2 - PI, min_pitch, max_pitch) % PI_2
	orientation.yaw = math.mod_two_pi(yaw)
	orientation.pitch = math.mod_two_pi(pitch)
	orientation.roll = 0
end

function _look_delta(new_input, previous_input, decay, input_cap, dt)
	local look_delta = (previous_input + new_input) * math.exp(decay * dt)
	look_delta = math.min(input_cap, math.abs(look_delta)) * math.sign(look_delta)

	return look_delta
end

return WeaponLockViewPlayerOrientation
