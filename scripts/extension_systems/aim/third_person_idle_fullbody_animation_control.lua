-- chunkname: @scripts/extension_systems/aim/third_person_idle_fullbody_animation_control.lua

local ThirdPersonIdleFullbodyAnimationControl = class("ThirdPersonIdleFullbodyAnimationControl")

ThirdPersonIdleFullbodyAnimationControl.init = function (self, unit)
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._unit = unit
	self._idle_fullbody_value = 0
	self._is_moving = false
	self._is_moving_transition_start_t = 0
end

ThirdPersonIdleFullbodyAnimationControl.state_machine_changed = function (self, unit)
	self._idle_fullbody_variable = Unit.animation_find_variable(unit, "idle_fullbody")
	self._idle_fullbody_value = 0
	self._is_moving = false
	self._is_moving_transition_start_t = 0
end

ThirdPersonIdleFullbodyAnimationControl.update = function (self, dt, t)
	local unit = self._unit
	local movement_state_component = self._movement_state_component
	local is_crouching = movement_state_component.is_crouching
	local move_speed_squared = self._locomotion_extension:move_speed_squared()
	local is_moving = self._is_moving

	if not is_moving and move_speed_squared > 0.01 then
		self._is_moving_transition_start_t = t
		self._is_moving = true
	elseif is_moving and move_speed_squared < 0.01 then
		self._is_moving_transition_start_t = t
		self._is_moving = false
	end

	local wanted_idle_fullbody_value = 0
	local stop_percent_done = 0

	if not is_moving and move_speed_squared < 0.01 then
		local time_since_stop = t - self._is_moving_transition_start_t

		stop_percent_done = math.clamp(time_since_stop / 0.8, 0, 1)
		wanted_idle_fullbody_value = 1
	end

	local start_percent_done = 0

	if is_moving and move_speed_squared > 0.01 then
		local time_since_start = t - self._is_moving_transition_start_t

		start_percent_done = math.clamp(time_since_start / 0.2, 0, 1)
		wanted_idle_fullbody_value = 0
	end

	if is_crouching then
		wanted_idle_fullbody_value = 0
	end

	local lerp_t = (stop_percent_done + start_percent_done) * dt * 4
	local idle_fullbody_value = math.clamp(math.lerp(self._idle_fullbody_value, wanted_idle_fullbody_value, lerp_t), 0, 1)

	if self._idle_fullbody_variable then
		Unit.animation_set_variable(unit, self._idle_fullbody_variable, idle_fullbody_value)
	end

	self._idle_fullbody_value = idle_fullbody_value
end

return ThirdPersonIdleFullbodyAnimationControl
