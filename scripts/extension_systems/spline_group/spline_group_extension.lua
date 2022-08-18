local SplineGroupExtension = class("SplineGroupExtension")

SplineGroupExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
end

SplineGroupExtension.setup_from_component = function (self, objective_name, spline_names)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local mission_exists = mission_objective_system:objective_definition(objective_name)

	fassert(mission_exists, "[SplineGroupExtension][setup_from_component] The Objective Name \"%s\" on Unit: \"%s\" with id: \"%s\" is not a correct Objective Name! Make sure it is spelled correctly. Available Objective Names are found in on of the \"..._objective_template.lua\" files]", objective_name, self._unit, Unit.id_string(self._unit))

	self._objective_name = objective_name
	self._spline_names = spline_names
end

SplineGroupExtension.objective_name = function (self)
	return self._objective_name
end

SplineGroupExtension.splines = function (self)
	return self._spline_names
end

return SplineGroupExtension
