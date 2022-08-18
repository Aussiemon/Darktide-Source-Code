local Action = require("scripts/utilities/weapon/action")
local FlamerGasEffects = class("FlamerGasEffects")

FlamerGasEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world
	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._action_module_position_finder_component = unit_data_extension:read_component("action_module_position_finder")
	self._action_flamer_gas_component = unit_data_extension:read_component("action_flamer_gas")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources._muzzle
	self._impact_spawn_rate = 0.1
	self._impact_spawn_time = 0
	self._impact_index = 1
	self._impact_data = {}

	for i = 1, 50, 1 do
		self._impact_data[i] = {
			position = Vector3Box(),
			normal = Vector3Box()
		}
	end
end

FlamerGasEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

FlamerGasEffects.update = function (self, unit, dt, t)
	self:_update_effects(dt, t)
end

FlamerGasEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

FlamerGasEffects.wield = function (self)
	return
end

FlamerGasEffects.unwield = function (self)
	self:_destroy_effects()
end

FlamerGasEffects.destroy = function (self)
	self:_destroy_effects()
end

FlamerGasEffects._update_effects = function (self, dt, t)
	local world = self._world
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local fire_configuration = action_settings and action_settings.fire_configuration

	if fire_configuration then
		local effects = action_settings.fx
		local stream_effect_data = effects.stream_effect
		local stream_effect_name = (self._is_local_unit and stream_effect_data.name) or stream_effect_data.name_3p
		local effect_duration = effects.duration
		local weapon_extension = self._weapon_extension
		local fire_time = 0.3

		if weapon_extension then
			local weapon_handling_template = weapon_extension:weapon_handling_template()
			fire_time = weapon_handling_template.fire_rate.fire_time
		end

		local start_t = weapon_action_component.start_t or t
		local time_in_action = t - start_t

		if fire_time <= time_in_action and (not effect_duration or effect_duration > time_in_action - fire_time) then
			local fx_source_name = self._fx_source_name
			local spawner_pose = self._fx_extension:vfx_spawner_pose(fx_source_name)
			local from_pos = Matrix4x4.translation(spawner_pose)
			local first_person_rotation = self._first_person_component.rotation
			local position_finder_component = self._action_module_position_finder_component
			local to_pos = position_finder_component.position
			local position_valid = position_finder_component.position_valid
			local stream_effect_id = self._stream_effect_id
			local max_length = self._action_flamer_gas_component.range
			local direction = Vector3.normalize((from_pos + Vector3.multiply(Quaternion.forward(first_person_rotation), max_length)) - from_pos)
			local rotation = Quaternion.look(direction)

			if not stream_effect_id then
				self._stream_effect_id = World.create_particles(world, stream_effect_name, from_pos, rotation)
			else
				World.move_particles(world, stream_effect_id, from_pos, rotation)
			end

			local speed = stream_effect_data.speed
			local distance = max_length

			if position_valid then
				distance = Vector3.distance(from_pos, to_pos)
			end

			local life = distance / speed
			local variable_index = World.find_particles_variable(self._world, stream_effect_name, "life")

			World.set_particles_variable(self._world, self._stream_effect_id, variable_index, Vector3(life, life, life))

			if self._impact_spawn_time == 0 and position_valid then
				local impact_time = t + life * 0.75
				local impact_index = self._impact_index
				local impact_data = self._impact_data
				local data = impact_data[impact_index]

				fassert(data.time == nil, "Tried adding a flamer impact effect without an available empty table, increase tables in init")

				local normal = position_finder_component.normal

				data.position:store(to_pos)
				data.normal:store(normal)

				data.time = impact_time
				data.effect_name = effects.impact_effect
				local new_impact_index = nil

				if impact_index == #impact_data then
					new_impact_index = 1
				else
					new_impact_index = impact_index + 1
				end

				self._impact_index = new_impact_index
				self._impact_spawn_time = self._impact_spawn_rate
			end
		else
			self:_destroy_effects()
		end
	else
		self:_destroy_effects()
	end

	self:_update_impact_effects(dt, t)
end

FlamerGasEffects._destroy_effects = function (self)
	local world = self._world
	local stream_effect_id = self._stream_effect_id

	if stream_effect_id then
		World.stop_spawning_particles(world, stream_effect_id)

		self._stream_effect_id = nil
	end
end

FlamerGasEffects._update_impact_effects = function (self, dt, t)
	local impact_data = self._impact_data

	for i = 1, #impact_data, 1 do
		local data = impact_data[i]
		local impact_time = data.time

		if impact_time and impact_time < t then
			local position = data.position:unbox()
			local normal = data.normal:unbox()
			local rotation = Quaternion.look(normal)
			local effect_name = data.effect_name

			World.create_particles(self._world, effect_name, position, rotation)

			data.time = nil
			data.effect_name = nil
		end
	end

	self._impact_spawn_time = math.max(self._impact_spawn_time - dt, 0)
end

return FlamerGasEffects
