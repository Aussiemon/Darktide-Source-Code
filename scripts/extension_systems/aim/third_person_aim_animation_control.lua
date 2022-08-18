local ThirdPersonAimAnimationControl = class("ThirdPersonAimAnimationControl")
local AIM_DIRECTION_MAX = 1

ThirdPersonAimAnimationControl.init = function (self, unit)
	self._unit = unit
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._look_direction_anim_var = "aim"
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._first_person_component = unit_data_extension:read_component("first_person")
end

ThirdPersonAimAnimationControl.update = function (self, dt, t)
	local look_direction_anim_var = self._animation_extension:anim_variable_id(self._look_direction_anim_var)
	local first_person_component = self._first_person_component
	local unit = self._unit
	local unit_forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local rotation = first_person_component.rotation
	local aim_direction = Quaternion.forward(rotation)
	local aim_dir_flat = Vector3.normalize(Vector3.flat(aim_direction))
	local forward_flat = Vector3.normalize(Vector3.flat(unit_forward))
	local aim_angle = math.atan2(aim_dir_flat.y, aim_dir_flat.x) - math.atan2(forward_flat.y, forward_flat.x)
	local aim_direction_scaled = ((aim_angle / math.pi + 1) % 2 - 1) * 2
	local variable_value = math.clamp(aim_direction_scaled, -AIM_DIRECTION_MAX, AIM_DIRECTION_MAX)

	Unit.animation_set_variable(unit, look_direction_anim_var, variable_value)
end

return ThirdPersonAimAnimationControl
