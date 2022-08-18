local FlamerPilotLightEffects = class("FlamerPilotLightEffects")
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive_loop"
local SHOULD_FADE_KILL = false
local EXTERNAL_PROPERTIES = {}

FlamerPilotLightEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	self._world = context.world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources._pilot

	if not is_husk then
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		self._looping_particle_component = unit_data_extension:write_component(LOOPING_PARTICLE_ALIAS)
	end
end

FlamerPilotLightEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

FlamerPilotLightEffects.update = function (self, unit, dt, t)
	return
end

FlamerPilotLightEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

FlamerPilotLightEffects.wield = function (self)
	if self._is_husk then
		return
	end

	self:_start_effects()
end

FlamerPilotLightEffects.unwield = function (self)
	if self._is_husk then
		return
	end

	self:_destroy_effects()
end

FlamerPilotLightEffects.destroy = function (self)
	if self._is_husk then
		return
	end

	self:_destroy_effects()
end

FlamerPilotLightEffects._start_effects = function (self)
	local particles_spawned = self._looping_particle_component.is_playing

	if not particles_spawned then
		self._fx_extension:spawn_looping_particles(LOOPING_PARTICLE_ALIAS, self._fx_source_name, EXTERNAL_PROPERTIES)
	end
end

FlamerPilotLightEffects._destroy_effects = function (self)
	local particles_spawned = self._looping_particle_component.is_playing

	if particles_spawned then
		self._fx_extension:stop_looping_particles(LOOPING_PARTICLE_ALIAS, SHOULD_FADE_KILL)
	end
end

return FlamerPilotLightEffects
