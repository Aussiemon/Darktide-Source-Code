local TrainingGroundsDirectionalUnitExtension = class("TrainingGroundsDirectionalUnitExtension")
TrainingGroundsDirectionalUnitExtension.UPDATE_DISABLED_BY_DEFAULT = true

TrainingGroundsDirectionalUnitExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._spawn_group = Unit.get_data(self._unit, "attached_unit.spawn_group")
	local attached_unit = Unit.flow_variable(self._unit, "attached_unit")
	self._attached_unit = Unit.alive(attached_unit) and attached_unit or nil
end

TrainingGroundsDirectionalUnitExtension.unit = function (self)
	return self._unit
end

TrainingGroundsDirectionalUnitExtension.spawn_attached_unit = function (self)
	Unit.flow_event(self._unit, "spawn_attached_unit")

	self._attached_unit = Unit.flow_variable(self._unit, "attached_unit")

	return self._attached_unit
end

TrainingGroundsDirectionalUnitExtension.unspawn_attached_unit = function (self)
	Unit.flow_event(self._unit, "unspawn_attached_unit")

	self._attached_unit = nil
end

TrainingGroundsDirectionalUnitExtension.attached_unit = function (self)
	return self._attached_unit
end

TrainingGroundsDirectionalUnitExtension.spawn_group = function (self)
	return self._spawn_group
end

TrainingGroundsDirectionalUnitExtension.update = function (self, unit, dt, t)
	return
end

TrainingGroundsDirectionalUnitExtension.destroy = function (self)
	self._unit = nil
end

return TrainingGroundsDirectionalUnitExtension
