-- chunkname: @scripts/extension_systems/aim/third_person_look_delta_animation_control.lua

local LookDelta = require("scripts/utilities/look_delta")
local ThirdPersonLookDeltaAnimationControl = class("ThirdPersonLookDeltaAnimationControl")

ThirdPersonLookDeltaAnimationControl.init = function (self, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._unit = unit
	self._look_delta_x = 0
	self._look_delta_y = 0
end

ThirdPersonLookDeltaAnimationControl.state_machine_changed = function (self, unit)
	self._look_delta_x_variable = Unit.animation_find_variable(unit, "look_delta_x")
	self._look_delta_y_variable = Unit.animation_find_variable(unit, "look_delta_y")
	self._world_look_delta_y_variable = Unit.animation_find_variable(unit, "world_look_delta_y")
end

ThirdPersonLookDeltaAnimationControl.update = function (self, dt, t, game_object_id)
	local first_person_component = self._first_person_component
	local look_delta_template = LookDelta.look_delta_template(self._weapon_action_component, self._alternate_fire_component, self._unit)
	local rotation = first_person_component.rotation
	local settings, yaw_delta, pitch_delta, previous_rotation
	local weapon_lock_view_component = self._weapon_lock_view_component
	local weapon_lock_view_component_state = weapon_lock_view_component.state

	if weapon_lock_view_component_state == "weapon_lock" or weapon_lock_view_component_state == "weapon_lock_no_delta" then
		settings = look_delta_template.inspect

		local yaw, pitch, roll = weapon_lock_view_component.yaw, weapon_lock_view_component.pitch, 0

		previous_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	else
		settings = look_delta_template.idle
		previous_rotation = first_person_component.previous_rotation
	end

	local rot_right, prev_rot_right = Quaternion.right(rotation), Quaternion.right(previous_rotation)
	local rot_up, prev_rot_up = Quaternion.up(rotation), Quaternion.up(previous_rotation)
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

	local wanted_look_delta_x, wanted_look_delta_y, lerp_constant_x, lerp_constant_y = LookDelta.look_delta_values(settings, yaw_delta, pitch_delta)
	local look_delta_x = math.lerp(self._look_delta_x, wanted_look_delta_x, lerp_constant_x)
	local look_delta_y = math.lerp(self._look_delta_y, wanted_look_delta_y, lerp_constant_y)
	local world_look_delta_y = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(rotation))), Quaternion.up(rotation))

	look_delta_x = math.min(1, math.abs(look_delta_x)) * math.sign(look_delta_x)
	look_delta_y = math.min(1, math.abs(look_delta_y)) * math.sign(look_delta_y)
	self._look_delta_x = look_delta_x
	self._look_delta_y = look_delta_y

	local unit = self._unit
	local look_delta_x_variable = self._look_delta_x_variable

	if look_delta_x_variable then
		Unit.animation_set_variable(unit, look_delta_x_variable, look_delta_x)
	end

	local look_delta_y_variable = self._look_delta_y_variable

	if look_delta_y_variable then
		Unit.animation_set_variable(unit, look_delta_y_variable, look_delta_y)
	end

	local world_look_delta_y_variable = self._world_look_delta_y_variable

	if world_look_delta_y_variable then
		Unit.animation_set_variable(unit, world_look_delta_y_variable, world_look_delta_y)
	end
end

return ThirdPersonLookDeltaAnimationControl
