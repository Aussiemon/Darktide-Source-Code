-- chunkname: @scripts/extension_systems/weather/weather_system.lua

require("scripts/extension_systems/weather/weather_extension")

local WeatherSystem = class("WeatherSystem", "ExtensionSystemBase")

WeatherSystem.init = function (self, ...)
	WeatherSystem.super.init(self, ...)

	self._unit = nil
	self._world_particles = nil
	self._screen_particles = nil
	self._world_particles_name = nil
	self._screen_particles_name = nil
	self._particle_group = World.create_particle_group(self._world)
end

WeatherSystem.update_weather = function (self, camera_follow_unit)
	local world = self._world
	local position = POSITION_LOOKUP[camera_follow_unit]
	local world_particles_name, screen_particles_name = self:get_current_particles(position)
	local particle_group

	if GameParameters.destroy_unmanaged_particles then
		particle_group = self._particle_group
	end

	if self._unit ~= camera_follow_unit or self._world_particles_name ~= world_particles_name then
		if self._world_particles then
			World.stop_spawning_particles(world, self._world_particles)
		end

		if world_particles_name ~= "" then
			self._world_particles = World.create_particles(world, world_particles_name, Vector3(0, 0, 0), nil, nil, particle_group)

			World.link_particles(world, self._world_particles, camera_follow_unit, 1, Matrix4x4.identity(), "destroy")
		end

		self._unit = camera_follow_unit
		self._world_particles_name = world_particles_name
	end

	if self._screen_particles_name ~= screen_particles_name then
		if self._screen_particles then
			World.stop_spawning_particles(world, self._screen_particles)
		end

		if screen_particles_name ~= "" then
			self._screen_particles = World.create_particles(world, screen_particles_name, Vector3(0, 0, 1), nil, nil, particle_group)
		end

		self._screen_particles_name = screen_particles_name
	end
end

WeatherSystem.get_current_particles = function (self, position)
	local world_particles_name = ""
	local screen_particles_name = ""
	local priority = 0
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension:is_in_volume(position) then
			local volume_priority, world_particles, screen_particles = extension:get_settings()

			if priority < volume_priority then
				priority = volume_priority

				if world_particles ~= "" then
					world_particles_name = world_particles
				end

				if screen_particles ~= "" then
					screen_particles_name = screen_particles
				end
			end
		end
	end

	return world_particles_name, screen_particles_name
end

WeatherSystem.destroy = function (self)
	local world = self._world

	if self._world_particles then
		World.destroy_particles(world, self._world_particles)
	end

	if self._screen_particles then
		World.destroy_particles(world, self._screen_particles)
	end

	World.destroy_particle_group(self._world, self._particle_group)
end

return WeatherSystem
