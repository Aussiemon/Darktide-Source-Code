-- chunkname: @scripts/components/chain_sword_spin.lua

local ChainSwordSpin = component("ChainSwordSpin")
local DEFAULT_SPEED = 1

ChainSwordSpin.init = function (self, unit)
	if not Unit.has_animation_state_machine(unit) then
		self._initialized = false

		return
	end

	self._initialized = true
	self._unit = unit
	self._speed_variable_index = Unit.animation_find_variable(unit, "speed")

	self:_set_speed()
end

ChainSwordSpin.editor_validate = function (self, unit)
	return true, ""
end

ChainSwordSpin._set_speed = function (self, speed)
	speed = speed or DEFAULT_SPEED

	local unit = self._unit

	if speed >= 0 then
		Unit.animation_event(unit, "forward")
	else
		Unit.animation_event(unit, "backward")

		speed = -speed
	end

	Unit.animation_set_variable(unit, self._speed_variable_index, speed)
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

ChainSwordSpin.events.set_speed = function (self, speed)
	if not self._initialized then
		Log.error("ChainSwordSpin", "Trying to set speed for a unit without an animation state machine")

		return
	end

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
