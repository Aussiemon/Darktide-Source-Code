-- chunkname: @scripts/extension_systems/first_person/character_state_orientation/default_player_orientation.lua

require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local AimAssist = require("scripts/utilities/aim_assist")
local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local Recoil = require("scripts/utilities/recoil")
local DefaultPlayerOrientation = class("DefaultPlayerOrientation", "BasePlayerOrientation")

DefaultPlayerOrientation.init = function (self, player, orientation)
	DefaultPlayerOrientation.super.init(self, player, orientation)

	local settings = PlayerOrientationSettings.default

	self._mouse_scale = settings.mouse_scale
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
end

DefaultPlayerOrientation.destroy = function (self)
	DefaultPlayerOrientation.super.destroy(self)

	self._mouse_scale = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

local PI = math.pi
local PI_2 = PI * 2
local look_delta_context = {}

DefaultPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier, rotation_contraints)
	local player = self._player
	local viewport_name = player.viewport_name
	local fov_sensitivity_modifier = Fov.sensitivity_modifier(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * fov_sensitivity_modifier
	local mouse_scale = self._mouse_scale
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch
	local orientation = self._orientation
	local position = self._first_person_component.position
	local weapon_action_component = self._weapon_action_component
	local aim_assist_ramp_component = self._aim_assist_ramp_component
	local targeting_data = self._smart_targeting_extension:targeting_data()
	local aim_assist_context = self:_aim_assist_context()
	local aim_assist_sensitivity_modifier = AimAssist.sensitivity_modifier(aim_assist_context)

	sensitivity = sensitivity * aim_assist_sensitivity_modifier

	self:_fill_look_delta_context(look_delta_context)

	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, look_delta_context)

	if rotation_contraints then
		local yaw_contraint = rotation_contraints.yaw and rotation_contraints.yaw * main_dt

		if yaw_contraint and yaw_contraint >= 0 then
			look_delta.x = math.clamp(look_delta.x, -yaw_contraint, yaw_contraint)
		end

		local pitch_contraint = rotation_contraints.pitch and rotation_contraints.pitch * main_dt

		if pitch_contraint and pitch_contraint >= 0 then
			look_delta.y = math.clamp(look_delta.y, -pitch_contraint, pitch_contraint)
		end
	end

	AimAssist.apply_movement_aim_assist(aim_assist_context, orientation, input, look_delta, main_dt, main_t)

	orientation.yaw, orientation.pitch = AimAssist.apply_lock_on(aim_assist_context, main_t, targeting_data, look_delta, orientation.yaw, orientation.pitch)

	local yaw = (orientation.yaw - look_delta.x) % PI_2
	local pitch = math.clamp((orientation.pitch + PI) % PI_2 - PI + look_delta.y, min_pitch, max_pitch) % PI_2

	yaw, pitch = AimAssist.apply_aim_assist(main_t, main_dt, input, targeting_data, aim_assist_ramp_component, weapon_action_component, yaw, pitch, position)
	orientation.yaw = math.mod_two_pi(yaw)
	orientation.pitch = math.mod_two_pi(pitch)
	orientation.roll = 0

	AimAssist.store_target_position(aim_assist_context, orientation)
end

DefaultPlayerOrientation.orientation_offset = function (self)
	local yaw_offset, pitch_offset, roll_offset = Orientation.recoil_offset(self._orientation, self._min_pitch, self._max_pitch, self._weapon_extension, self._recoil_component, self._movement_state_component, self._locomotion_component, self._inair_state_component)

	return yaw_offset, pitch_offset, roll_offset
end

return DefaultPlayerOrientation
