local WeatherExtension = class("WeatherExtension")

WeatherExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	fassert(not self._is_server, "[WeatherExtension] should only run locally on the client")

	self._unit = unit

	if DevParameters.debug_weather_vfx then
		-- Nothing
	end
end

WeatherExtension.setup_from_component = function (self, world_particles, screen_particles, priority)
	self._world_particles = world_particles
	self._screen_particles = screen_particles
	self._priority = priority
end

WeatherExtension.is_in_volume = function (self, position)
	local inside = false

	if position then
		inside = Unit.is_point_inside_volume(self._unit, "weather_volume", position)
	end

	return inside
end

WeatherExtension.get_settings = function (self)
	return self._priority, self._world_particles, self._screen_particles
end

WeatherExtension.destroy = function (self)
	self._unit = nil
end

WeatherExtension.extensions_ready = function (self, world, unit)
	return
end

return WeatherExtension
