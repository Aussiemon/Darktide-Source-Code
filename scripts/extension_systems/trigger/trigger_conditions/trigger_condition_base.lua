local TriggerConditionBase = class("TriggerConditionBase")

TriggerConditionBase.init = function (self, unit, condition_name, evaluates_bots)
	self._unit = unit
	self._registered_units = {}
	self._num_registered_units = 0
	self._condition_name = condition_name
	self._evaluates_bots = evaluates_bots
end

TriggerConditionBase.destroy = function (self)
	table.clear(self._registered_units)

	self._registered_units = nil
	self._num_registered_units = nil
	self._condition_name = nil
	self._evaluates_bots = nil
end

TriggerConditionBase.condition_name = function (self)
	return self._condition_name
end

TriggerConditionBase.registered_units = function (self)
	return self._registered_units
end

TriggerConditionBase.num_registered_units = function (self)
	return self._num_registered_units
end

TriggerConditionBase.register_unit = function (self, unit)
	if not self._registered_units[unit] then
		self._registered_units[unit] = true
		self._num_registered_units = self._num_registered_units + 1

		return true
	end

	return false
end

TriggerConditionBase.unregister_unit = function (self, unit)
	if self._registered_units[unit] then
		self._registered_units[unit] = nil
		self._num_registered_units = self._num_registered_units - 1

		return true
	end

	return false
end

TriggerConditionBase.on_volume_enter = function (self, entering_unit, dt, t)
	return false
end

TriggerConditionBase.on_volume_exit = function (self, exiting_unit)
	return false
end

TriggerConditionBase.is_condition_fulfilled = function (self, volume_id)
	return false
end

return TriggerConditionBase
