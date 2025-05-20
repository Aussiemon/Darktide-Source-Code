-- chunkname: @scripts/components/gyroscope_particle_effect.lua

local GyroscopeParticleEffect = component("GyroscopeParticleEffect")

GyroscopeParticleEffect.init = function (self, unit)
	self._unit = unit
	self._world = Unit.world(unit)
	self._particle_name = self:get_data(unit, "particle")
	self._particle_id = nil

	return true
end

GyroscopeParticleEffect.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

GyroscopeParticleEffect.enable = function (self, unit)
	return
end

GyroscopeParticleEffect.disable = function (self, unit)
	return
end

GyroscopeParticleEffect.destroy = function (self, unit)
	self:_destroy_particle()
end

GyroscopeParticleEffect.update = function (self, unit, dt, t)
	local world = self._world
	local particle_id = self._particle_id

	if particle_id then
		local alive = World.are_particles_playing(world, particle_id)

		if alive then
			local world_position = Unit.world_position(unit, 1)

			World.move_particles(world, particle_id, world_position, Quaternion.identity())

			return true
		end
	end

	self._particle_id = nil

	return true
end

GyroscopeParticleEffect._create_particle = function (self)
	local world_position = Unit.world_position(self._unit, 1)

	self._particle_id = World.create_particles(self._world, self._particle_name, world_position, Quaternion.identity())
end

GyroscopeParticleEffect._destroy_particle = function (self)
	local world = self._world
	local particle_id = self._particle_id

	if particle_id then
		local alive = World.are_particles_playing(world, particle_id)

		if alive then
			World.destroy_particles(world, particle_id)
		end

		self._particle_id = nil
	end
end

GyroscopeParticleEffect.events.create_particle = function (self, unit)
	self:_create_particle()
end

GyroscopeParticleEffect.events.destroy_particle = function (self, unit)
	self:_destroy_particle()
end

GyroscopeParticleEffect.create_particle = function (self)
	self:_create_particle()
end

GyroscopeParticleEffect.destroy_particle = function (self)
	self:_destroy_particle()
end

GyroscopeParticleEffect.component_data = {
	particle = {
		filter = "particles",
		preview = false,
		ui_name = "Particle",
		ui_type = "resource",
		value = "",
	},
	inputs = {
		create_particle = {
			accessibility = "public",
			type = "event",
		},
		destroy_particle = {
			accessibility = "public",
			type = "event",
		},
	},
}

return GyroscopeParticleEffect
