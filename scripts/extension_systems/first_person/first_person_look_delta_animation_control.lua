-- chunkname: @scripts/extension_systems/first_person/first_person_look_delta_animation_control.lua

local Action = require("scripts/utilities/action/action")
local LookDelta = require("scripts/utilities/look_delta")
local Recoil = require("scripts/utilities/recoil")
local Sway = require("scripts/utilities/sway")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local FirstPersonLookDeltaAnimationControl = class("FirstPersonLookDeltaAnimationControl")

FirstPersonLookDeltaAnimationControl.init = function (self, first_person_unit, unit, is_husk)
	self._first_person_unit = first_person_unit

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	if not is_husk then
		self._shooting_status_component = unit_data_extension:read_component("shooting_status")
		self._action_shoot_component = unit_data_extension:read_component("action_shoot")
		self._recoil_component = unit_data_extension:read_component("recoil")
		self._movement_state_component = unit_data_extension:read_component("movement_state")
		self._sway_control_component = unit_data_extension:read_component("sway_control")
		self._sway_component = unit_data_extension:read_component("sway")
		self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	end

	self._character_state_component = unit_data_extension:read_component("character_state")
	self._minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
	self._is_husk = is_husk
	self._look_delta_x = 0
	self._look_delta_y = 0
end

local SHOOTING_GRACE_DURATION = 0.2

FirstPersonLookDeltaAnimationControl.update = function (self, dt, t)
	local first_person_component = self._first_person_component
	local weapon_action_component = self._weapon_action_component
	local rotation = first_person_component.rotation
	local look_delta_template = LookDelta.look_delta_template(weapon_action_component, self._alternate_fire_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
	local is_shooting

	if self._is_husk then
		is_shooting = false
	else
		local shooting_status_component = self._shooting_status_component

		is_shooting = shooting_status_component.shooting or t <= shooting_status_component.shooting_end_time + SHOOTING_GRACE_DURATION
	end

	local lerp = true
	local settings, yaw_delta, pitch_delta

	if is_shooting and action_settings and not action_settings.ignore_shooting_look_delta_anim_control then
		settings = look_delta_template.shooting

		local movement_state_component = self._movement_state_component
		local shoot_rotation = self._action_shoot_component.shooting_rotation
		local recoil_template = self._weapon_extension:recoil_template()
		local sway_template = self._weapon_extension:sway_template()
		local recoiled_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, self._recoil_component, movement_state_component, rotation)

		recoiled_rotation = Sway.apply_sway_rotation(sway_template, self._sway_component, movement_state_component, recoiled_rotation)

		local rot_right = Quaternion.right(recoiled_rotation)
		local rot_up = Quaternion.up(recoiled_rotation)
		local shoot_forward = Quaternion.forward(shoot_rotation)
		local right_dot = Vector3.dot(rot_right, shoot_forward)
		local up_dot = Vector3.dot(rot_up, shoot_forward)

		yaw_delta = right_dot * (look_delta_template.yaw_multiplier or 0.2)
		pitch_delta = up_dot * (look_delta_template.pitch_multiplier or 0.2)
	else
		local previous_rotation, previous_rotation_pitch_only
		local weapon_lock_view_component = self._weapon_lock_view_component
		local weapon_lock_view_component_state = weapon_lock_view_component.state

		if weapon_lock_view_component_state == "weapon_lock" or weapon_lock_view_component_state == "weapon_lock_no_lerp" then
			settings = look_delta_template.inspect

			local yaw, pitch, roll = weapon_lock_view_component.yaw, weapon_lock_view_component.pitch, 0

			previous_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
			previous_rotation_pitch_only = Quaternion.from_yaw_pitch_roll(Quaternion.yaw(rotation), pitch, roll)
			lerp = weapon_lock_view_component_state ~= "weapon_lock_no_lerp"
		elseif self._character_state_component.state_name == "minigame" then
			settings = look_delta_template.inspect

			local minigame_character_state = self._minigame_character_state_component

			if minigame_character_state.interface_level_unit_id ~= NetworkConstants.invalid_level_unit_id then
				local is_level_unit = true
				local level_unit_id = minigame_character_state.interface_level_unit_id
				local interact_unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
				local interact_unit_pos = Unit.world_position(interact_unit, 1)
				local first_person_pos = first_person_component.position
				local player_to_interact_unit_dir = Vector3.normalize(interact_unit_pos - first_person_pos)

				previous_rotation = Quaternion.look(player_to_interact_unit_dir, Quaternion.up(rotation))
			else
				previous_rotation = self._previous_rotation and self._previous_rotation:unbox() or first_person_component.previous_rotation
			end
		else
			settings = look_delta_template.idle
			previous_rotation = self._previous_rotation and self._previous_rotation:unbox() or first_person_component.previous_rotation
		end

		local rot_right, prev_rot_right = Quaternion.right(rotation), Quaternion.right(previous_rotation)
		local rot_up = Quaternion.up(rotation)
		local rot_up, prev_rot_up = rot_up, previous_rotation_pitch_only and Quaternion.up(previous_rotation_pitch_only) or Quaternion.up(previous_rotation)
		local forward = Quaternion.forward(rotation)
		local up_dot = math.clamp(Vector3.dot(rot_up, prev_rot_up), -1, 1)

		pitch_delta = math.acos(up_dot)

		if Vector3.dot(forward, prev_rot_up) < 0 then
			pitch_delta = -pitch_delta
		end

		local right_dot = math.clamp(Vector3.dot(rot_right, prev_rot_right), -1, 1)

		yaw_delta = math.acos(right_dot)

		if Vector3.dot(forward, prev_rot_right) < 0 then
			yaw_delta = -yaw_delta
		end
	end

	local wanted_look_delta_x, wanted_look_delta_y, lerp_constant_x, lerp_constant_y = LookDelta.look_delta_values(settings, yaw_delta, pitch_delta)
	local look_delta_x = lerp and math.lerp(self._look_delta_x, wanted_look_delta_x, lerp_constant_x * 60 * dt) or wanted_look_delta_x
	local look_delta_y = lerp and math.lerp(self._look_delta_y, wanted_look_delta_y, lerp_constant_y * 60 * dt) or wanted_look_delta_y
	local world_look_delta_y = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(rotation))), Quaternion.up(rotation))
	local clamp_look_delta = not settings.no_look_delta_clamp

	if clamp_look_delta then
		look_delta_x = math.min(1, math.abs(look_delta_x)) * math.sign(look_delta_x)
		look_delta_y = math.min(1, math.abs(look_delta_y)) * math.sign(look_delta_y)
	end

	self._look_delta_x = look_delta_x
	self._look_delta_y = look_delta_y
	self._previous_rotation = QuaternionBox(rotation)

	local first_person_unit = self._first_person_unit
	local look_delta_x_variable = Unit.animation_find_variable(first_person_unit, "look_delta_x")

	if look_delta_x_variable then
		Unit.animation_set_variable(first_person_unit, look_delta_x_variable, look_delta_x)
	end

	local look_delta_y_variable = Unit.animation_find_variable(first_person_unit, "look_delta_y")

	if look_delta_y_variable then
		Unit.animation_set_variable(first_person_unit, look_delta_y_variable, look_delta_y)
	end

	local world_look_delta_y_variable = Unit.animation_find_variable(first_person_unit, "world_look_delta_y")

	if world_look_delta_y_variable then
		Unit.animation_set_variable(first_person_unit, world_look_delta_y_variable, world_look_delta_y)
	end
end

return FirstPersonLookDeltaAnimationControl
