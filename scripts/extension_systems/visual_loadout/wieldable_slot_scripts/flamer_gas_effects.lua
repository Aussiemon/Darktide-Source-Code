-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_gas_effects.lua

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local FlamerGasEffects = class("FlamerGasEffects")

FlamerGasEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local wwise_world = context.wwise_world

	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._particle_group_id = context.player_particle_group_id

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._action_module_position_finder_component = unit_data_extension:read_component("action_module_position_finder")
	self._action_flamer_gas_component = unit_data_extension:read_component("action_flamer_gas")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._locomotion_extension = ScriptUnit.has_extension(owner_unit, "locomotion_system")
	self._weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources._muzzle
	self._impact_spawn_rate = 0.1
	self._impact_spawn_time = 0
	self._impact_index = 1
	self._impact_data = {}
	self._stoped_particles = {}
	self._stoped_particles_position = {}
	self._stoped_particles_rotation = {}
	self._stoped_particles_velovity = {}
	self._is_in_first_person = nil

	for i = 1, 50 do
		self._impact_data[i] = {
			effect_name = nil,
			time = nil,
			position = Vector3Box(),
			normal = Vector3Box(),
		}
	end
end

FlamerGasEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

FlamerGasEffects.update_unit_position = function (self, unit, dt, t)
	self:_update_effects(dt, t)
end

FlamerGasEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode
end

FlamerGasEffects.wield = function (self)
	return
end

FlamerGasEffects.unwield = function (self)
	self:_destroy_effects(false)
	table.clear(self._stoped_particles)
end

FlamerGasEffects.destroy = function (self)
	self:_destroy_effects(false)
	table.clear(self._stoped_particles)
end

FlamerGasEffects._update_effects = function (self, dt, t)
	local world = self._world
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local has_fire_configuration = action_settings and (action_settings.fire_configurations or action_settings.fire_configuration)
	local fx_source_name = self._fx_source_name
	local spawner_pose = self._fx_extension:vfx_spawner_pose(fx_source_name)
	local from_pos = Matrix4x4.translation(spawner_pose)
	local first_person_rotation = self._first_person_component.rotation
	local position_finder_component = self._action_module_position_finder_component
	local to_pos = position_finder_component.position
	local position_valid = position_finder_component.position_valid
	local stream_effect_id = self._stream_effect_id
	local max_length = self._action_flamer_gas_component.range
	local direction = Vector3.normalize(from_pos + Vector3.multiply(Quaternion.forward(first_person_rotation), max_length) - from_pos)
	local rotation = Quaternion.look(direction)

	if has_fire_configuration then
		local effects = action_settings.fx
		local stream_effect_data = effects.stream_effect
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
		local stream_effect_name = should_play_husk_effect and stream_effect_data.name_3p or stream_effect_data.name
		local move_after_stop = effects.move_after_stop
		local effect_duration = effects.duration
		local weapon_extension = self._weapon_extension
		local fire_time = 0.3

		if weapon_extension then
			local weapon_handling_template = weapon_extension:weapon_handling_template()

			fire_time = weapon_handling_template.fire_rate.fire_time
		end

		fire_time = fire_time * 0.7

		local start_t = weapon_action_component.start_t or t
		local time_in_action = t - start_t

		if fire_time <= time_in_action and (not effect_duration or effect_duration > time_in_action - fire_time) then
			local sound_direction = direction
			local distance = max_length

			if position_valid then
				local direction_vector = to_pos - from_pos

				distance = Vector3.length(direction_vector)
				sound_direction = Vector3.normalize(direction_vector)
			end

			local sound_distance = math.clamp(distance - 0.1, 0, 4)
			local wanted_sound_source_pos = from_pos + sound_direction * sound_distance

			if not stream_effect_id then
				local effect_id = World.create_particles(world, stream_effect_name, from_pos, rotation, nil, self._particle_group_id)

				self._stream_effect_id = effect_id
				self._move_after_stop = move_after_stop

				local in_first_person = self._is_in_first_person

				if in_first_person then
					World.set_particles_use_custom_fov(world, effect_id, true)
				end

				local looping_sfx = effects.looping_3d_sound_effect

				if looping_sfx then
					self._looping_source_id = WwiseWorld.make_manual_source(self._wwise_world, wanted_sound_source_pos, rotation)

					WwiseWorld.trigger_resource_event(self._wwise_world, looping_sfx, self._looping_source_id)

					self._source_position = Vector3Box(wanted_sound_source_pos)
					self._stop_looping_sfx_event = effects.stop_looping_3d_sound_effect
				end
			else
				World.move_particles(world, stream_effect_id, from_pos, rotation)

				if self._looping_source_id then
					local current_pos = self._source_position:unbox()
					local new_pos = Vector3.lerp(current_pos, wanted_sound_source_pos, dt * 7)

					self._source_position:store(new_pos)
					WwiseWorld.set_source_position(self._wwise_world, self._looping_source_id, new_pos)
				end
			end

			local speed = stream_effect_data.speed
			local life = distance / speed
			local variable_index = World.find_particles_variable(self._world, stream_effect_name, "life")

			World.set_particles_variable(self._world, self._stream_effect_id, variable_index, Vector3(life, life, life))

			if self._impact_spawn_time == 0 and position_valid then
				local impact_time = t + life * 1.25
				local impact_index = self._impact_index
				local impact_data = self._impact_data
				local data = impact_data[impact_index]
				local normal = position_finder_component.normal

				data.position:store(to_pos)
				data.normal:store(normal)

				data.time = impact_time
				data.effect_name = effects.impact_effect

				local new_impact_index

				new_impact_index = impact_index == #impact_data and 1 or impact_index + 1
				self._impact_index = new_impact_index
				self._impact_spawn_time = self._impact_spawn_rate
			end
		else
			self:_destroy_effects(true, rotation)
		end
	else
		self:_destroy_effects(true, rotation)
	end

	self:_update_moving_lingering_effects(dt, t)
	self:_update_impact_effects(dt, t)
end

FlamerGasEffects._update_impact_effects = function (self, dt, t)
	local impact_data = self._impact_data
	local particle_group_id = self._particle_group_id

	for i = 1, #impact_data do
		local data = impact_data[i]
		local impact_time = data.time

		if impact_time and impact_time < t then
			local position = data.position:unbox()
			local normal = data.normal:unbox()
			local rotation = Quaternion.look(normal)
			local effect_name = data.effect_name

			World.create_particles(self._world, effect_name, position, rotation, nil, particle_group_id)

			data.time = nil
			data.effect_name = nil
		end
	end

	self._impact_spawn_time = math.max(self._impact_spawn_time - dt, 0)
end

FlamerGasEffects._update_moving_lingering_effects = function (self, dt, t)
	local world = self._world
	local stoped_particles = self._stoped_particles
	local stoped_particles_position = self._stoped_particles_position
	local stoped_particles_rotation = self._stoped_particles_rotation
	local stoped_particles_velocity = self._stoped_particles_velovity

	for i = #stoped_particles, 1, -1 do
		local stoped_particle_id = stoped_particles[i]
		local position_box = stoped_particles_position[i]
		local rotation_box = stoped_particles_rotation[i]
		local velocity_box = stoped_particles_velocity[i]
		local position = position_box:unbox()
		local velocity = velocity_box:unbox()
		local rotation = rotation_box:unbox()
		local new_velocity = Vector3.lerp(velocity, Vector3.zero(), dt)
		local new_position = position + new_velocity * dt

		position_box:store(new_position)
		velocity_box:store(new_velocity)

		local are_playing = World.are_particles_playing(world, stoped_particle_id)

		if are_playing then
			World.move_particles(world, stoped_particle_id, new_position, rotation)
		else
			table.remove(stoped_particles, i)
			table.remove(stoped_particles_position, i)
			table.remove(stoped_particles_rotation, i)
			table.remove(stoped_particles_velocity, i)
		end
	end
end

FlamerGasEffects._destroy_effects = function (self, allow_move, rotation)
	local world = self._world
	local stream_effect_id = self._stream_effect_id
	local move_after_stop = self._move_after_stop

	if stream_effect_id then
		World.stop_spawning_particles(world, stream_effect_id)

		if allow_move and move_after_stop then
			local fx_source_name = self._fx_source_name
			local spawner_pose = self._fx_extension:vfx_spawner_pose(fx_source_name)
			local from_pos = Matrix4x4.translation(spawner_pose)
			local locomotion_extension = self._locomotion_extension
			local velocity = locomotion_extension and locomotion_extension:current_velocity() or Vector3.zero()
			local stoped_particles = self._stoped_particles
			local stoped_particles_position = self._stoped_particles_position
			local stoped_particles_rotation = self._stoped_particles_rotation
			local stoped_particles_velocity = self._stoped_particles_velovity
			local index = #stoped_particles + 1

			stoped_particles[index] = stream_effect_id
			stoped_particles_position[index] = Vector3Box(from_pos)
			stoped_particles_rotation[index] = QuaternionBox(rotation)
			stoped_particles_velocity[index] = Vector3Box(velocity)
		end

		self._stream_effect_id = nil
		self._move_after_stop = nil
	end

	local source_id = self._looping_source_id

	if source_id then
		WwiseWorld.trigger_resource_event(self._wwise_world, self._stop_looping_sfx_event, self._looping_source_id)
		WwiseWorld.destroy_manual_source(self._wwise_world, self._looping_source_id)

		self._looping_source_id = nil
		self._source_position = nil
	end
end

implements(FlamerGasEffects, WieldableSlotScriptInterface)

return FlamerGasEffects
