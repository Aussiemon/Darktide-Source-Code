﻿-- chunkname: @scripts/components/interpolate_animation_variable.lua

local InterpolateAnimationVariable = component("InterpolateAnimationVariable")

InterpolateAnimationVariable.init = function (self, unit)
	self._unit = unit
	self._variable_name = self:get_data(unit, "variable_name")

	local val_from = self:get_data(unit, "val_from")
	local val_to = self:get_data(unit, "val_to")

	self._method = self:get_data(unit, "method")
	self._transition_time = self:get_data(unit, "transition_time")
	self._transition_speed = 1 / self._transition_time
	self._val1 = val_from
	self._val2 = val_to
	self._anim_variable = Unit.animation_find_variable(unit, self._variable_name)
	self._val_from = 0
	self._val_to = 0
	self._animation_time = 1

	return true
end

InterpolateAnimationVariable.editor_init = function (self, unit)
	return
end

InterpolateAnimationVariable.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_animation_state_machine(unit) then
		success = false
		error_message = error_message .. "\nMissing unit animation state machine"
	end

	local variable_name = self:get_data(unit, "variable_name")

	if variable_name ~= "" then
		if rawget(_G, "LevelEditor") and Unit.has_animation_state_machine(unit) and Unit.animation_find_variable(unit, variable_name) == nil then
			success = false
			error_message = error_message .. "\nCan't find animation variable " .. variable_name
		end
	else
		success = false
		error_message = error_message .. "\nMissing unit data 'variable_name' it can't be empty"
	end

	return success, error_message
end

InterpolateAnimationVariable.enable = function (self, unit)
	return
end

InterpolateAnimationVariable.disable = function (self, unit)
	return
end

InterpolateAnimationVariable.destroy = function (self, unit)
	return
end

InterpolateAnimationVariable.update = function (self, unit, dt, t)
	if self._animation_time < 1 then
		self._animation_time = self._animation_time + dt * self._transition_speed

		if self._animation_time >= 1 then
			self._animation_time = 1
		end

		self:variable_updated()
	end

	return true
end

InterpolateAnimationVariable.editor_update = function (self, unit, dt, t)
	return
end

InterpolateAnimationVariable.variable_updated = function (self)
	local val = self._animation_time

	if self._method == "easing" then
		val = (math.cos((1 + val) * math.pi) + 1) / 2
	end

	Unit.animation_set_variable(self._unit, self._anim_variable, math.lerp(self._val_from, self._val_to, val))
end

InterpolateAnimationVariable.start_transition = function (self, target_value)
	if self._val_to == target_value then
		return
	end

	local from = self._val_to
	local to = target_value

	if to - from == 0 then
		self._animation_time = 1
	else
		local current_speed = Unit.animation_get_variable(self._unit, self._anim_variable)

		self._animation_time = (current_speed - from) / (to - from)

		if math.abs(self._animation_time) >= 1 then
			self._animation_time = 0
			from = current_speed
		elseif self._animation_time < 0 then
			self._animation_time = -self._animation_time
		end
	end

	self._val_from = from
	self._val_to = to

	self:variable_updated()
end

InterpolateAnimationVariable.function_advance = function (self, unit)
	self:start_transition(self._val2)
end

InterpolateAnimationVariable.function_revert = function (self, unit)
	self:start_transition(self._val1)
end

InterpolateAnimationVariable.function_stop = function (self, unit)
	self:start_transition(0)
end

InterpolateAnimationVariable.component_data = {
	variable_name = {
		category = "Transition",
		ui_name = "Variable Name",
		ui_type = "text_box",
		value = "speed",
	},
	val_from = {
		category = "Transition",
		decimals = 100,
		step = 0.1,
		ui_name = "Value From",
		ui_type = "number",
		value = 0,
	},
	val_to = {
		category = "Transition",
		decimals = 100,
		step = 0.1,
		ui_name = "Value To",
		ui_type = "number",
		value = 1,
	},
	method = {
		category = "Transition",
		ui_name = "Interpolation Method",
		ui_type = "combo_box",
		value = "linear",
		options_keys = {
			"Linear",
			"Easing",
		},
		options_values = {
			"linear",
			"easing",
		},
	},
	transition_time = {
		category = "Transition",
		decimals = 100,
		step = 0.1,
		ui_name = "Transition time",
		ui_type = "number",
		value = 1,
	},
	inputs = {
		function_advance = {
			accessibility = "public",
			type = "event",
		},
		function_revert = {
			accessibility = "public",
			type = "event",
		},
		function_stop = {
			accessibility = "public",
			type = "event",
		},
	},
}

return InterpolateAnimationVariable
