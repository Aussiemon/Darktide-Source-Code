local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local moods = MoodSettings.moods
local mood_types = MoodSettings.mood_types
local mood_status = MoodSettings.status
local mood_priority = MoodSettings.priority
local MoodHandler = class("MoodHandler")

MoodHandler.init = function (self, world, player)
	self._world = world
	self._player = player
	self._is_local_human = not player.remote and player:is_human_controlled()
	self._wwise_world = Wwise.wwise_world(world)
	local shading_environments_resources = {}
	local created_shading_environments = {}

	for _, mood_settings in pairs(moods) do
		local resource_name = mood_settings.shading_environment

		if resource_name then
			local resource = World.create_shading_environment_resource(world, resource_name)
			shading_environments_resources[resource_name] = resource
			created_shading_environments[#created_shading_environments + 1] = resource
		end
	end

	self._shading_environments_resources = shading_environments_resources
	self._created_shading_environments = created_shading_environments
	self._current_moods_status = {}

	for mood_type, _ in pairs(mood_types) do
		self._current_moods_status[mood_type] = mood_status.inactive
	end

	self._looping_particles = {}
	self._particle_material_scalar_values = {}
	self._sfx_source_ids = {}
	self._sfx_playing_ids = {}

	for mood_type, _ in pairs(mood_types) do
		self._looping_particles[mood_type] = {}
		self._particle_material_scalar_values[mood_type] = {}
		self._sfx_source_ids[mood_type] = {}
		self._sfx_playing_ids[mood_type] = {}
	end
end

MoodHandler.destroy = function (self)
	local shading_environments_resources = self._shading_environments_resources
	local created_shading_environments = self._created_shading_environments
	local world = self._world

	for i = 1, #created_shading_environments do
		local resource = created_shading_environments[i]

		World.destroy_shading_environment_resource(world, resource)
	end

	table.clear(shading_environments_resources)
	table.clear(created_shading_environments)
end

MoodHandler.update_moods = function (self, blend_list, moods_data)
	local added_moods, removing_moods, removed_moods = self:update_active_moods(moods_data)

	self:_update_sounds(added_moods, removing_moods, removed_moods, moods_data)
	self:_update_particles(added_moods, removing_moods, removed_moods, moods_data)
	self:_blend_list(blend_list, moods_data)
end

local _added_moods = {}
local _removing_moods = {}
local _removed_moods = {}

MoodHandler.update_active_moods = function (self, mood_data)
	local current_moods_status = self._current_moods_status

	table.clear(_added_moods)
	table.clear(_removing_moods)
	table.clear(_removed_moods)

	for mood_type, _ in pairs(mood_types) do
		local current_status = mood_data[mood_type].status
		local old_status = current_moods_status[mood_type]

		if current_status ~= old_status then
			if current_status == mood_status.active and old_status == mood_status.inactive then
				_added_moods[mood_type] = true
			elseif current_status == mood_status.removing and old_status == mood_status.active then
				_removing_moods[mood_type] = true
			elseif current_status == mood_status.inactive then
				_removed_moods[mood_type] = true
			end
		end
	end

	table.clear(current_moods_status)

	for mood_type, _ in pairs(mood_types) do
		current_moods_status[mood_type] = mood_data[mood_type].status
	end

	return _added_moods, _removing_moods, _removed_moods
end

MoodHandler._update_sounds = function (self, added_moods, removing_moods, removed_moods, moods_data)
	for added_mood, _ in pairs(added_moods) do
		local added_mood_settings = moods[added_mood]
		local sound_start_event = added_mood_settings.sound_start_event

		if sound_start_event then
			WwiseWorld.trigger_resource_event(self._wwise_world, sound_start_event)
		end

		local looping_sound_start_events = added_mood_settings.looping_sound_start_events

		if looping_sound_start_events then
			for i = 1, #looping_sound_start_events do
				if not self._sfx_source_ids[added_mood][i] then
					self._sfx_source_ids[added_mood][i] = {}
				end

				local sound_event = looping_sound_start_events[i]
				local _, source_id = WwiseWorld.trigger_resource_event(self._wwise_world, sound_event)
				self._sfx_source_ids[added_mood][i][sound_event] = source_id
			end
		end
	end

	for removed_mood, _ in pairs(removed_moods) do
		local removed_mood_settings = moods[removed_mood]
		local sound_stop_event = removed_mood_settings.sound_stop_event

		if sound_stop_event then
			local sound_stop_event_func = removed_mood_settings.sound_stop_event_func

			if not sound_stop_event_func or sound_stop_event_func(self._player.player_unit) then
				WwiseWorld.trigger_resource_event(self._wwise_world, sound_stop_event)
			end
		end

		local looping_sound_stop_events = removed_mood_settings.looping_sound_stop_events

		if looping_sound_stop_events then
			for i = 1, #looping_sound_stop_events do
				local sound_event = looping_sound_stop_events[i]

				WwiseWorld.trigger_resource_event(self._wwise_world, sound_event)
			end
		end
	end

	for mood_type, mood_data in pairs(moods_data) do
		if mood_data.status == mood_status.active then
			local mood = moods[mood_type]
			local source_parameters = mood.source_parameters

			if source_parameters then
				for i = 1, #source_parameters do
					local source_parameter = source_parameters[i]
					local value = mood.source_parameter_func(self._player)
					local looping_sound_start_events = mood.looping_sound_start_events
					local sound_event_id = looping_sound_start_events[i]
					local source_id = self._sfx_source_ids[mood_type][i][sound_event_id]

					WwiseWorld.set_source_parameter(self._wwise_world, source_id, source_parameter, value)
				end
			end
		end
	end
end

MoodHandler._spawn_particles = function (self, particle_name)
	local position = Vector3(0, 0, 1)
	local rotation = Quaternion.identity()
	local scale = Vector3.one()
	local particle_id = World.create_particles(self._world, particle_name, position, rotation, scale)

	return particle_id
end

MoodHandler._update_particles = function (self, added_moods, removing_moods, removed_moods, moods_data)
	local world = self._world

	for added_mood, _ in pairs(added_moods) do
		local added_mood_settings = moods[added_mood]
		local particle_effects_on_enter = added_mood_settings.particle_effects_on_enter

		if particle_effects_on_enter then
			for i = 1, #particle_effects_on_enter do
				self:_spawn_particles(particle_effects_on_enter[i])
			end
		end

		local looping_particles = self._looping_particles[added_mood]
		local particle_effects_looping = added_mood_settings.particle_effects_looping

		if particle_effects_looping then
			for i = 1, #particle_effects_looping do
				local looping_particle_id = self:_spawn_particles(particle_effects_looping[i])
				looping_particles[i] = looping_particle_id
			end
		end
	end

	for removing_mood, _ in pairs(removing_moods) do
		local removed_mood_settings = moods[removing_mood]
		local particle_effects_on_exit = removed_mood_settings.particle_effects_on_exit

		if particle_effects_on_exit then
			for i = 1, #particle_effects_on_exit do
				self:_spawn_particles(particle_effects_on_exit[i])
			end
		end

		local looping_particles = self._looping_particles[removing_mood]

		for i = #looping_particles, 1, -1 do
			local particle_id = looping_particles[i]

			World.destroy_particles(world, particle_id)

			looping_particles[i] = nil
			local mood = moods[removing_mood]
			local particles_material_scalars = mood.particles_material_scalars

			if particles_material_scalars then
				for j = 1, #particles_material_scalars do
					table.clear(self._particle_material_scalar_values[removing_mood][j])
				end
			end
		end
	end

	for removed_mood, _ in pairs(removed_moods) do
		local looping_particles = self._looping_particles[removed_mood]

		for i = #looping_particles, 1, -1 do
			local particle_id = looping_particles[i]

			World.destroy_particles(world, particle_id)

			looping_particles[i] = nil
			local mood = moods[removed_mood]
			local particles_material_scalars = mood.particles_material_scalars

			if particles_material_scalars then
				for j = 1, #particles_material_scalars do
					table.clear(self._particle_material_scalar_values[removed_mood][j])
				end
			end
		end
	end

	for mood_type, mood_data in pairs(moods_data) do
		if mood_data.status == mood_status.active then
			local mood = moods[mood_type]
			local particles_material_scalars = mood.particles_material_scalars

			if particles_material_scalars then
				for i = 1, #particles_material_scalars do
					if not self._particle_material_scalar_values[mood_type][i] then
						self._particle_material_scalar_values[mood_type][i] = {}
					end

					local particles_material_scalar = particles_material_scalars[i]
					local last_value = self._particle_material_scalar_values[mood_type][i][particles_material_scalar]
					local value = particles_material_scalar.scalar_func(self._player, last_value)
					self._particle_material_scalar_values[mood_type][i][particles_material_scalar] = value
					local on_screen_cloud_name = particles_material_scalar.on_screen_cloud_name
					local on_screen_variable_name = particles_material_scalar.on_screen_variable_name
					local on_screen_effect_id = self._looping_particles[mood_type][i]

					if on_screen_effect_id then
						World.set_particles_material_scalar(world, on_screen_effect_id, on_screen_cloud_name, on_screen_variable_name, value)
					end
				end
			end
		end
	end
end

MoodHandler._blend_list = function (self, blend_list, moods_data)
	local game_t = Managers.time:time("gameplay")

	for i = 1, #mood_priority do
		local mood_type = mood_priority[i]
		local mood_data = moods_data[mood_type]
		local settings = moods[mood_type]
		local is_active = mood_data.status ~= mood_status.inactive
		local has_shading_environment = settings.shading_environment

		if is_active and has_shading_environment then
			local weight = nil

			if mood_data.status == mood_status.active then
				local blend_in_time = settings.blend_in_time

				if not blend_in_time or blend_in_time == 0 then
					weight = 1
				else
					local time_alive = math.min(game_t - mood_data.entered_t, blend_in_time)
					weight = math.clamp(time_alive / blend_in_time, 0, 1)
				end
			elseif mood_data.status == mood_status.removing then
				local blend_out_time = settings.blend_out_time

				if not blend_out_time or blend_out_time == 0 then
					weight = 1
				else
					local time_in_remove = math.min(game_t - mood_data.removed_t, blend_out_time)
					weight = math.clamp(1 - time_in_remove / blend_out_time, 0, 1)
				end
			end

			local blend_mask = settings.blend_mask
			local resource_name = settings.shading_environment
			local shading_env_resouce = self._shading_environments_resources[resource_name]
			blend_list[#blend_list + 1] = shading_env_resouce
			blend_list[#blend_list + 1] = weight
			blend_list[#blend_list + 1] = blend_mask
		end
	end
end

return MoodHandler
