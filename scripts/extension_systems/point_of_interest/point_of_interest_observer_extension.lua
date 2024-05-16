-- chunkname: @scripts/extension_systems/point_of_interest/point_of_interest_observer_extension.lua

local PointOfInterestObserverExtension = class("PointOfInterestObserverExtension")

PointOfInterestObserverExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local view_angle = extension_init_data.view_angle or math.pi / 2

	self._view_half_angle = view_angle * 0.5
	self._last_lookat_trigger = -math.huge
	self._first_person_component = nil
end

PointOfInterestObserverExtension.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
end

PointOfInterestObserverExtension.last_lookat_trigger = function (self)
	return self._last_lookat_trigger
end

PointOfInterestObserverExtension.set_last_lookat_trigger = function (self, t)
	self._last_lookat_trigger = t
end

PointOfInterestObserverExtension.first_person_position_rotation = function (self)
	local first_person_component = self._first_person_component
	local observer_position = first_person_component.position
	local observer_rotation = first_person_component.rotation

	return observer_position, observer_rotation
end

PointOfInterestObserverExtension.view_half_angle = function (self)
	return self._view_half_angle
end

return PointOfInterestObserverExtension
