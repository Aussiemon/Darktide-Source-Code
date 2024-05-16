-- chunkname: @scripts/extension_systems/first_person/character_state_orientation/smooth_force_view_player_orientation.lua

require("scripts/extension_systems/first_person/character_state_orientation/base_player_orientation")

local Action = require("scripts/utilities/weapon/action")
local Breed = require("scripts/utilities/breed")
local Fov = require("scripts/utilities/camera/fov")
local Orientation = require("scripts/utilities/orientation")
local PlayerOrientationSettings = require("scripts/settings/player_character/player_orientation_settings")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
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
	local fov_sensitivity_modifier = Fov.sensitivity_modifier(viewport_name)
	local sensitivity = player.sensitivity * sensitivity_modifier * fov_sensitivity_modifier
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
	local stuck_dir_x, stuck_dir_y, stuck_dir_z = stuck_direction.x, stuck_direction.y, stuck_direction.z
	local wanted_yaw = math.atan2(stuck_dir_y, stuck_dir_x) - HALF_PI
	local wanted_pitch = math.asin(stuck_dir_z)

	wanted_yaw = math.mod_two_pi(wanted_yaw)
	wanted_pitch = math.mod_two_pi(wanted_pitch)

	local look_delta_x, look_delta_y = look_delta.x, look_delta.y
	local yaw = Orientation.clamp_from_origin(orientation.yaw, look_delta_x, wanted_yaw, CONSTRAINT)
	local pitch = Orientation.clamp_from_origin(orientation.pitch, -look_delta_y, wanted_pitch, CONSTRAINT)
	local new_yaw, new_pitch = math.mod_two_pi(yaw), math.mod_two_pi(pitch)
	local delta_yaw, delta_pitch

	if new_yaw - HALF_PI < 0 or new_yaw + HALF_PI > PI_2 then
		delta_yaw = (wanted_yaw + PI) % PI_2 - (new_yaw + PI) % PI_2
	else
		delta_yaw = wanted_yaw - new_yaw
	end

	if new_pitch - HALF_PI < 0 or new_pitch + HALF_PI > PI_2 then
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
	local disable_vertical_force_view = false
	local weapon_action_component = self._weapon_action_component
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)

	if current_action_settings then
		local special_active_at_start = weapon_action_component.special_active_at_start
		local hit_stickyness_settings = special_active_at_start and current_action_settings.hit_stickyness_settings_special_active or current_action_settings.hit_stickyness_settings

		disable_vertical_force_view = hit_stickyness_settings and hit_stickyness_settings.disable_vertical_force_view

		local sitck_to_unit = action_sweep_component.sweep_aborted_unit
		local unit_data_extension = sitck_to_unit and ScriptUnit.extension(sitck_to_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()

		if Breed.is_prop(breed) then
			disable_vertical_force_view = true
		end
	end

	if disable_vertical_force_view then
		nudged_pitch = orientation.pitch
	end

	orientation.yaw = math.mod_two_pi(nudged_yaw)
	orientation.pitch = math.mod_two_pi(nudged_pitch)
	orientation.roll = 0
end

return SmoothForceViewPlayerOrientation
