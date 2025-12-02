-- chunkname: @scripts/extension_systems/spline_group/spline_group_extension.lua

local SplineGroupExtension = class("SplineGroupExtension")

SplineGroupExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
end

SplineGroupExtension.setup_from_component = function (self, objective_name, spline_names)
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
