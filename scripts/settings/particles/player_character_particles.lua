-- chunkname: @scripts/settings/particles/player_character_particles.lua

local PlayerCharacterParticles = {}
local particle_aliases = require("scripts/settings/particles/player_character_particle_aliases")

PlayerCharacterParticles.particle_aliases = particle_aliases

local particle_names = {}

local function _extract_particle_names(particles)
	for switch_value, particle_name in pairs(particles) do
		if type(particle_name) == "table" then
			_extract_particle_names(particle_name)
		else
			particle_names[particle_name] = true
		end
	end
end

for alias, config in pairs(particle_aliases) do
	local particles = config.particles

	_extract_particle_names(particles)
end

PlayerCharacterParticles.particle_names = particle_names

PlayerCharacterParticles.resolve_particle = function (particle_alias, properties, optional_external_properties)
	local settings = PlayerCharacterParticles.particle_aliases[particle_alias]

	if settings then
		local particles = settings.particles
		local switches = settings.switch
		local default_switch_properties = settings.default_switch_properties
		local no_default = settings.no_default
		local num_switches = #switches

		if num_switches == 0 then
			return true, particles.default
		end

		for ii = 1, num_switches do
			local switch_name = switches[ii]
			local switch_property = properties[switch_name] or optional_external_properties and optional_external_properties[switch_name] or default_switch_properties and default_switch_properties[switch_name]

			if switch_property and particles[switch_property] then
				particles = particles[switch_property]
			elseif not no_default then
				particles = particles.default
			end

			if type(particles) == "string" then
				return true, particles
			end
		end
	else
		Log.warning("PlayerCharacterParticles", "No particle alias named %q", particle_alias)
	end

	local allow_default = settings and not settings.no_default

	return allow_default, allow_default and settings.particles.default
end

local function _valid_particles_recursive(particles, relevant_particles)
	for _, particle_or_particles in pairs(particles) do
		if type(particle_or_particles) == "string" then
			relevant_particles[particle_or_particles] = true
		else
			_valid_particles_recursive(particle_or_particles, relevant_particles)
		end
	end
end

local temp_relevant_particles = {}

PlayerCharacterParticles.find_relevant_particles = function (profile_properties)
	table.clear(temp_relevant_particles)

	for particle_alias, settings in pairs(PlayerCharacterParticles.particle_aliases) do
		local particles = settings.particles
		local switches = settings.switch
		local no_default = settings.no_default
		local num_switches = #switches

		if num_switches == 0 then
			local resource_name = particles.default

			temp_relevant_particles[resource_name] = true
		else
			for ii = 1, num_switches do
				local switch_name = switches[ii]
				local switch_property = profile_properties[switch_name]

				if switch_property then
					local default_particles = particles.default

					particles = particles[switch_property] or default_particles or particles
				else
					_valid_particles_recursive(particles, temp_relevant_particles)

					break
				end

				if type(particles) == "string" then
					temp_relevant_particles[particles] = true

					break
				end
			end
		end
	end

	return temp_relevant_particles
end

return PlayerCharacterParticles
