-- chunkname: @scripts/extension_systems/first_person/character_state_orientation/weapon_force_view_player_orientation.lua

require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local _look_delta
local WeaponForceViewPlayerOrientation = class("WeaponForceViewPlayerOrientation", "BasePlayerOrientation")

WeaponForceViewPlayerOrientation.init = function (self, player, orientation)
	self._player = player
	self._orientation = orientation

	local player_unit = player.player_unit
	local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

	self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
end

WeaponForceViewPlayerOrientation.destroy = function (self)
	WeaponForceViewPlayerOrientation.super.destroy(self)
end

local PI = math.pi
local context = {}

WeaponForceViewPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local orientation = self._orientation

	table.clear(context)

	local weapon_lock_view = self._weapon_lock_view_component
	local pitch_origin = weapon_lock_view.pitch
	local diff_pitch = math.mod_two_pi(math.abs(orientation.pitch - pitch_origin))

	if diff_pitch > PI then
		pitch_origin = pitch_origin + PI * 2
	end

	local yaw_origin = weapon_lock_view.yaw
	local diff_yaw = math.mod_two_pi(math.abs(orientation.yaw - yaw_origin))

	if diff_yaw > PI then
		yaw_origin = yaw_origin + PI * 2
	end

	local lerp = math.clamp01(main_dt * 6)
	local yaw = math.lerp(orientation.yaw, yaw_origin, lerp)
	local pitch = math.lerp(orientation.pitch, pitch_origin, lerp)

	orientation.yaw = math.mod_two_pi(yaw)
	orientation.pitch = math.mod_two_pi(pitch)
	orientation.roll = 0
end

return WeaponForceViewPlayerOrientation
