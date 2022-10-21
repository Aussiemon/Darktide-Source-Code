require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local LedgeHangingPlayerOrientation = class("LedgeHangingPlayerOrientation", "BasePlayerOrientation")

LedgeHangingPlayerOrientation.init = function (self, player, orientation)
	LedgeHangingPlayerOrientation.super.init(self, player, orientation)

	local settings = PlayerOrientationSettings.default
	self._mouse_scale = settings.mouse_scale
	self._min_pitch = settings.min_pitch
	self._max_pitch = settings.max_pitch
	self._parent_unit = nil
	self._relative_orientation = QuaternionBox()
end

LedgeHangingPlayerOrientation.destroy = function (self)
	LedgeHangingPlayerOrientation.super.init(self)

	self._mouse_scale = nil
	self._min_pitch = nil
	self._max_pitch = nil
end

LedgeHangingPlayerOrientation._check_for_parent_reference_transition = function (self, player_unit)
	if ALIVE[player_unit] then
		local locomotion_component = self._locomotion_component
		local current_parent_unit = locomotion_component.parent_unit

		if self._parent_unit ~= current_parent_unit then
			if not current_parent_unit then
				self:_switch_to_absolute_orientation()
			else
				self:_switch_to_relative_orientation(current_parent_unit)
			end
		end
	end
end

LedgeHangingPlayerOrientation._switch_to_absolute_orientation = function (self)
	local parent_unit = self._parent_unit
	local relative_orientation_quaternion = self._relative_orientation:unbox()
	local absolute_orientation = PlayerMovement.calculate_absolute_rotation(parent_unit, relative_orientation_quaternion)
	self._orientation.yaw = Quaternion.yaw(absolute_orientation)
	self._orientation.pitch = Quaternion.pitch(absolute_orientation)
	self._orientation.roll = Quaternion.roll(absolute_orientation)
	self._parent_unit = nil
end

LedgeHangingPlayerOrientation._switch_to_relative_orientation = function (self, parent_unit)
	self._parent_unit = parent_unit
	local absolute_orientation_quaternion = Quaternion.from_yaw_pitch_roll(self._orientation.yaw, self._orientation.pitch, self._orientation.roll)
	local relative_rotation = PlayerMovement.calculate_relative_rotation(parent_unit, absolute_orientation_quaternion)

	self._relative_orientation:store(relative_rotation)
end

local PI = math.pi
local PI_2 = PI * 2
local look_delta_context = {}

LedgeHangingPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier)
	local player = self._player
	local viewport_name = player.viewport_name
	local current_fov = Fov.from_viewport(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * current_fov
	local mouse_scale = self._mouse_scale
	local min_pitch = self._min_pitch
	local max_pitch = self._max_pitch
	local parent_unit = self._parent_unit

	self:_check_for_parent_reference_transition(player.player_unit)
	self:_fill_look_delta_context(look_delta_context)

	local look_delta = Orientation.look_delta(main_dt, input, sensitivity, mouse_scale, look_delta_context)
	local relative_orientation_quaternion = self._relative_orientation:unbox()
	local absolute_orientation = nil

	if parent_unit then
		absolute_orientation = PlayerMovement.calculate_absolute_rotation(parent_unit, relative_orientation_quaternion)
	else
		absolute_orientation = relative_orientation_quaternion
	end

	local absolute_yaw = Quaternion.yaw(absolute_orientation)
	local absolute_pitch = Quaternion.pitch(absolute_orientation)
	local absolute_roll = Quaternion.roll(absolute_orientation)
	absolute_yaw = (absolute_yaw - look_delta.x) % PI_2
	absolute_pitch = math.clamp((absolute_pitch + PI) % PI_2 - PI + look_delta.y, min_pitch, max_pitch) % PI_2
	local new_absolute_orientation = Quaternion.from_yaw_pitch_roll(absolute_yaw, absolute_pitch, absolute_roll)
	local new_relative_rotation = nil

	if parent_unit then
		new_relative_rotation = PlayerMovement.calculate_relative_rotation(parent_unit, new_absolute_orientation)
	else
		new_relative_rotation = new_absolute_orientation
	end

	self._relative_orientation:store(new_relative_rotation)

	self._orientation.yaw = math.mod_two_pi(absolute_yaw)
	self._orientation.pitch = math.mod_two_pi(absolute_pitch)
	self._orientation.roll = 0
end

return LedgeHangingPlayerOrientation
