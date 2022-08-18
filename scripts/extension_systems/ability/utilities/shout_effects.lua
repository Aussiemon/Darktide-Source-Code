local ShoutEffects = class("ShoutEffects")

ShoutEffects.init = function (self, equiped_ability_effect_scripts_context, ability_template)
	self._world = equiped_ability_effect_scripts_context.world
	self._wwise_world = equiped_ability_effect_scripts_context.wwise_world
	self._ability_template = ability_template
	self._vfx = ability_template.vfx
	self._delay_t = self._vfx.delay
	self._is_local_unit = equiped_ability_effect_scripts_context.is_local_unit
	local unit_data_extension = equiped_ability_effect_scripts_context.unit_data_extension
	self._combat_ability_component = unit_data_extension:read_component("combat_ability")
	self._active = false
end

ShoutEffects.destroy = function (self)
	self:_destroy_effects()
end

ShoutEffects.update = function (self, unit, dt, t)
	if not self._active and self._combat_ability_component.active then
		local delay_t = self._delay_t

		if delay_t then
			delay_t = delay_t - dt
			self._delay_t = delay_t
		end

		if not delay_t or delay_t < 0 then
			self._active = true
			self._delay_t = self._vfx.delay

			self:_spawn_effects(unit)
		end
	elseif self._active and not self._combat_ability_component.active then
		self._active = false
	end

	local position = POSITION_LOOKUP[unit] + Vector3.up()

	self:_update_effect_positions(position, self._effect_id)
end

ShoutEffects._spawn_effects = function (self, unit)
	local world = self._world
	local effect_name = self._vfx.name
	local position = POSITION_LOOKUP[unit] + Vector3.up()
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	if fx_extension then
		local optional_variable_name = "size"
		local optional_variable_value = Vector3(5, 5, 5)
		local effect_id = fx_extension:spawn_particles(effect_name, position, nil, nil, optional_variable_name, optional_variable_value)
		self._effect_id = effect_id
	end
end

ShoutEffects._destroy_effects = function (self)
	local world = self._world

	if self._effect_id then
		World.destroy_particles(world, self._effect_id)

		self._effect_id = nil
	end
end

ShoutEffects._update_effect_positions = function (self, target_position, effect_id)
	if not effect_id then
		return
	end

	local world = self._world

	World.move_particles(world, effect_id, target_position)
end

return ShoutEffects
