require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local SmoothForceViewPlayerOrientation = class("SmoothForceViewPlayerOrientation", "BasePlayerOrientation")

SmoothForceViewPlayerOrientation.init = function (self, player, orientation)
	SmoothForceViewPlayerOrientation.super.init(self, player, orientation)

	local settings = PlayerOrientationSettings.default
	self._mouse_scale = settings.mouse_scale
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
end

SmoothForceViewPlayerOrientation.destroy = function (self)
	SmoothForceViewPlayerOrientation.super.destroy(self)

	self._mouse_scale = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

local PI = math.pi
local HALF_PI = PI * 0.5
local PI_2 = PI * 2
local MAX_NUDGE_PER_SEC = HALF_PI
local NUDGE_MIN = PI * 0.015625
local NUDGE_MAX = PI * 0.125
local CONSTRAINT = NUDGE_MAX + PI * 0.25
local look_delta_context = {}

SmoothForceViewPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier, rotation_contraints)
	local player = self._player
	local viewport_name = player.viewport_name
	local current_fov = Fov.sensitivity_modifier(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * current_fov
	local mouse_scale = self._mouse_scale
	local orientation = self._orientation
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch
	local first_person_unit = self._first_person_unit
	local action_sweep_component = self._action_sweep_component

	self:_fill_look_delta_context(look_delta_context)

	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, look_delta_context)
	local stick_to_position = SweepStickyness.stick_to_position(action_sweep_component)
	local player_position = Unit.world_position(first_person_unit, 1)
	local stuck_direction = Vector3.normalize(stick_to_position - player_position)
	local stuck_dir_x = stuck_direction.x
	local stuck_dir_y = stuck_direction.y
	local stuck_dir_z = stuck_direction.z
	local wanted_yaw = math.atan2(stuck_dir_y, stuck_dir_x) - HALF_PI
	local wanted_pitch = math.asin(stuck_dir_z)
	wanted_yaw = math.mod_two_pi(wanted_yaw)
	wanted_pitch = math.mod_two_pi(wanted_pitch)
	local look_delta_x = look_delta.x
	local look_delta_y = look_delta.y
	local yaw = Orientation.clamp_from_origin(orientation.yaw, look_delta_x, wanted_yaw, CONSTRAINT)
	local pitch = Orientation.clamp_from_origin(orientation.pitch, -look_delta_y, wanted_pitch, CONSTRAINT)
	local new_yaw = math.mod_two_pi(yaw)
	local new_pitch = math.mod_two_pi(pitch)
	local delta_yaw, delta_pitch = nil

	if new_yaw - HALF_PI < 0 or PI_2 < new_yaw + HALF_PI then
		delta_yaw = (wanted_yaw + PI) % PI_2 - (new_yaw + PI) % PI_2
	else
		delta_yaw = wanted_yaw - new_yaw
	end

	if new_pitch - HALF_PI < 0 or PI_2 < new_pitch + HALF_PI then
		delta_pitch = (wanted_pitch + PI) % PI_2 - (new_pitch + PI) % PI_2
	else
		delta_pitch = wanted_pitch - new_pitch
	end

	local yaw_p = math.max(math.ilerp_no_clamp(NUDGE_MIN, NUDGE_MAX, math.abs(delta_yaw)), 0)
	local yaw_nudge = math.sign(delta_yaw) * MAX_NUDGE_PER_SEC * main_dt * math.ease_out_exp(yaw_p)
	local nudged_yaw = (new_yaw + yaw_nudge) % PI_2
	local pitch_p = math.max(math.ilerp_no_clamp(NUDGE_MIN, NUDGE_MAX, math.abs(delta_pitch)), 0)
	local pitch_nudge = math.sign(delta_pitch) * MAX_NUDGE_PER_SEC * main_dt * pitch_p
	local nudged_pitch = math.clamp((new_pitch + PI) % PI_2 - PI + pitch_nudge, min_pitch, max_pitch) % PI_2
	orientation.yaw = math.mod_two_pi(nudged_yaw)
	orientation.pitch = math.mod_two_pi(nudged_pitch)
	orientation.roll = 0
end

return SmoothForceViewPlayerOrientation
