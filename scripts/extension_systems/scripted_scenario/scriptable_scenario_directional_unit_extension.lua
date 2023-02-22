local ScriptableScenarioDirectionalUnitExtension = class("ScriptableScenarioDirectionalUnitExtension")
ScriptableScenarioDirectionalUnitExtension.UPDATE_DISABLED_BY_DEFAULT = true

ScriptableScenarioDirectionalUnitExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._spawn_group = Unit.get_data(unit, "attached_unit_settings.spawn_group")
	self._identifier = Unit.get_data(unit, "directional_unit_identifier")
	local attached_unit = Unit.flow_variable(self._unit, "attached_unit")
	self._attached_unit = Unit.alive(attached_unit) and attached_unit or nil
end

ScriptableScenarioDirectionalUnitExtension.unit = function (self)
	return self._unit
end

ScriptableScenarioDirectionalUnitExtension.spawn_attached_unit = function (self)
	Unit.flow_event(self._unit, "spawn_attached_unit")

	self._attached_unit = Unit.flow_variable(self._unit, "attached_unit")

	return self._attached_unit
end

ScriptableScenarioDirectionalUnitExtension.unspawn_attached_unit = function (self)
	Unit.flow_event(self._unit, "unspawn_attached_unit")

	self._attached_unit = nil
end

ScriptableScenarioDirectionalUnitExtension.attached_unit = function (self)
	return self._attached_unit
end

ScriptableScenarioDirectionalUnitExtension.spawn_group = function (self)
	return self._spawn_group
end

ScriptableScenarioDirectionalUnitExtension.identifier = function (self)
	return self._identifier
end

ScriptableScenarioDirectionalUnitExtension.update = function (self, unit, dt, t)
	return
end

ScriptableScenarioDirectionalUnitExtension.destroy = function (self)
	self._unit = nil
end

return ScriptableScenarioDirectionalUnitExtension
