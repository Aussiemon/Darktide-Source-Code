local ChainSwordSpin = component("ChainSwordSpin")

ChainSwordSpin.init = function (self, unit)
	if not Unit.has_animation_state_machine(unit) then
		return
	end

	self._unit = unit
	self._speed = Unit.get_data(unit, "speed")
	self._speed_variable_index = Unit.animation_find_variable(unit, "speed")

	self:_set_speed()
end

ChainSwordSpin._set_speed = function (self, speed)
	self._speed = speed

	if not self._speed then
		self._speed = 0
	end

	if self._speed >= 0 then
		Unit.animation_event(self._unit, "forward")
	else
		Unit.animation_event(self._unit, "backward")
	end

	if self._speed < 0 then
		self._speed = self._speed * -1
	end

	Unit.animation_set_variable(self._unit, self._speed_variable_index, self._speed)
end

ChainSwordSpin.enable = function (self, unit)
	return
end

ChainSwordSpin.disable = function (self, unit)
	return
end

ChainSwordSpin.destroy = function (self, unit)
	return
end

ChainSwordSpin.update = function (self, unit, dt, t)
	return
end

ChainSwordSpin.changed = function (self, unit)
	return
end

ChainSwordSpin.events.set_speed = function (self, speed)
	self:_set_speed(speed)
end

ChainSwordSpin.component_data = {
	inputs = {
		set_speed = {
			accessibility = "public",
			type = "event"
		}
	}
}

return ChainSwordSpin
