-- chunkname: @scripts/settings/fx/effect_templates/chaos_daemonhost_ambience.lua

local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local AMBIENCE_SETTINGS = ChaosDaemonhostSettings.ambience
local DEATH_SETTINGS = ChaosDaemonhostSettings.death
local STAGES = ChaosDaemonhostSettings.stages
local WWISE_DAEMONHOST_RANGE = "daemonhost_range"
local WWISE_DAEMONHOST_STAGE = "daemonhost_stage"
local WWISE_DEFAULT_DAEMONHOST_RANGE = 100
local BODY_EMISSIVE_MATERIAL = "body"
local BODY_EMISSIVE_MATERIAL_VARIABLE = "emissive_intensity_scalar"
local SFX_IDLE_START = "wwise/events/minions/play_enemy_daemonhost_ambience_idle"
local SFX_IDLE_STOP = "wwise/events/minions/stop_enemy_daemonhost_ambience_idle"
local resources = {
	sfx_idle_start = SFX_IDLE_START,
	sfx_idle_stop = SFX_IDLE_STOP,
	ambience_settings = AMBIENCE_SETTINGS,
}
local _update_ambience, _update_dying, _update_passive, _update_frost_screen_space, _switch_stage, _screen_distortion_intensity, _screen_frost_intensity, _sfx_distortion_intensity, _distance_to_local_player_or_nil
local effect_template = {
	name = "chaos_daemonhost_ambience",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")
		local source_id = dialogue_extension:get_wwise_source_id()

		WwiseWorld.trigger_resource_event(wwise_world, SFX_IDLE_START, source_id)

		template_data.source_id = source_id

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session, template_data.game_object_id = game_session, game_object_id

		local light_name = AMBIENCE_SETTINGS.light_name
		local light = Unit.light(unit, light_name)

		Light.set_enabled(light, true)

		template_data.light = light

		local screen_effect_distortion_settings = AMBIENCE_SETTINGS.screen_effect_distortion
		local screen_distortion_particle_effect = screen_effect_distortion_settings.particle_effect
		local screen_effect_distortion_id = World.create_particles(world, screen_distortion_particle_effect, Vector3(0, 0, 1))

		template_data.screen_effect_distortion_id = screen_effect_distortion_id

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local body_slot_unit = visual_loadout_extension:slot_unit("slot_body")

		template_data.body_slot_unit = body_slot_unit

		local fog_settings = AMBIENCE_SETTINGS.fog_effect
		local fog_particle_effect = fog_settings.particle_effect
		local position = Unit.world_position(unit, 1)
		local fog_position = position + Vector3.up()
		local fog_effect_id = World.create_particles(world, fog_particle_effect, fog_position)

		template_data.fog_effect_id = fog_effect_id
		template_data.intensity_sin_value = 0

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.breed = unit_data_extension:breed()

		local stage = GameSession.game_object_field(game_session, game_object_id, "stage")

		_switch_stage(template_data, template_context, stage)

		local screen_effect_frost_settings = AMBIENCE_SETTINGS.screen_effect_frost

		if screen_effect_frost_settings then
			local screen_effect_frost_particle_effect = screen_effect_frost_settings.particle_effect
			local screen_effect_frost_id = World.create_particles(world, screen_effect_frost_particle_effect, Vector3(0, 0, 1))

			template_data.screen_effect_frost_id = screen_effect_frost_id
			template_data.screen_frost_intensity = 0

			local cloud_name, variable_name = "frost", "distance_scalar"

			World.set_particles_material_scalar(template_context.world, screen_effect_frost_id, cloud_name, variable_name, 0)
		end

		template_data.next_vo_trigger_t = 0
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local wanted_stage = GameSession.game_object_field(game_session, game_object_id, "stage")
		local previous_stage = template_data.stage

		if previous_stage ~= wanted_stage then
			_switch_stage(template_data, template_context, wanted_stage)
		end

		local stage = template_data.stage
		local is_dying = stage == STAGES.death_normal or stage == STAGES.death_leave

		if stage == STAGES.passive then
			_update_passive(template_data, template_context, dt)
		elseif is_dying then
			_update_dying(template_data, template_context, stage, dt, t)
		else
			_update_ambience(template_data, template_context, stage, dt)
		end

		_update_frost_screen_space(template_data, template_context, stage, dt)
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local wwise_world = template_context.wwise_world

		WwiseWorld.set_global_parameter(wwise_world, WWISE_DAEMONHOST_RANGE, WWISE_DEFAULT_DAEMONHOST_RANGE)

		local source_id = template_data.source_id

		WwiseWorld.set_source_parameter(wwise_world, source_id, WWISE_DAEMONHOST_STAGE, STAGES.passive)
		WwiseWorld.trigger_resource_event(wwise_world, SFX_IDLE_STOP, source_id)

		local world = template_context.world
		local screen_effect_distortion_id = template_data.screen_effect_distortion_id

		World.destroy_particles(world, screen_effect_distortion_id)

		local fog_effect_id = template_data.fog_effect_id

		World.stop_spawning_particles(world, fog_effect_id)

		local frost_effect_id = template_data.screen_effect_frost_id

		if frost_effect_id then
			World.destroy_particles(world, frost_effect_id)
		end
	end,
}

function _switch_stage(template_data, template_context, new_stage)
	local ambience_settings = AMBIENCE_SETTINGS[new_stage]

	if ambience_settings then
		local light_radius = ambience_settings.light_radius
		local radius_min = light_radius.min
		local radius_max = light_radius.max
		local light = template_data.light

		Light.set_falloff_start(light, radius_min)
		Light.set_falloff_end(light, radius_max)

		local light_color = ambience_settings.color
		local color_filter = Vector3(light_color[1] / 255, light_color[2] / 255, light_color[3] / 255)

		Light.set_color_filter(light, color_filter)

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.set_source_parameter(wwise_world, source_id, WWISE_DAEMONHOST_STAGE, new_stage)

		local emissive_material_intensity = ambience_settings.emissive_material_intensity

		if emissive_material_intensity then
			local body_slot_unit = template_data.body_slot_unit

			Unit.set_scalar_for_material(body_slot_unit, BODY_EMISSIVE_MATERIAL, BODY_EMISSIVE_MATERIAL_VARIABLE, emissive_material_intensity)
		end
	end

	template_data.stage = new_stage
end

function _update_dying(template_data, template_context, stage, dt, t)
	local death_settings = DEATH_SETTINGS[stage]

	if death_settings then
		local alpha_clip_settings = death_settings.alpha_clip

		if alpha_clip_settings then
			if not template_data.alpha_clip_start_t then
				template_data.alpha_clip_start_t = t + alpha_clip_settings.delay
				template_data.previous_alpha_clip_lerp = 1
			end

			if t > template_data.alpha_clip_start_t then
				if not template_data.alpha_lerp_start_t then
					template_data.alpha_lerp_start_t = t
				end

				local lerp_t = math.min(dt * alpha_clip_settings.speed, 1)
				local final_value = math.lerp(template_data.previous_alpha_clip_lerp, 0, lerp_t)

				template_data.previous_alpha_clip_lerp = final_value

				local body_slot_unit = template_data.body_slot_unit
				local material_scalar_key = alpha_clip_settings.material_scalar_key
				local material_variable_key = alpha_clip_settings.material_variable_key

				Unit.set_scalar_for_material(body_slot_unit, material_variable_key, material_scalar_key, final_value)
			end
		end
	end

	local unit = template_data.unit
	local distance = _distance_to_local_player_or_nil(unit)

	if distance then
		if not template_data.dying_effect_t then
			template_data.dying_emissive_t = t + 0.16666666666666666
			template_data.dying_sfx_t = t + 0.16666666666666666
			template_data.dying_screen_fx_t = t + 0.16666666666666666
			template_data.dying_effect_t = 0
		end

		local dying_effect_t = template_data.dying_effect_t + dt

		template_data.dying_effect_t = dying_effect_t

		local dying_emissive_t = template_data.dying_emissive_t

		if dying_emissive_t <= t then
			local DURATION = 1.1666666666666667
			local lerp_value = math.lerp(1, 0, dying_effect_t / DURATION)
			local emissive_intensity = math.clamp(lerp_value, 0, 1)
			local body_slot_unit = template_data.body_slot_unit

			Unit.set_scalar_for_material(body_slot_unit, BODY_EMISSIVE_MATERIAL, BODY_EMISSIVE_MATERIAL_VARIABLE, emissive_intensity)
		end

		local dying_sfx_t = template_data.dying_sfx_t

		if dying_sfx_t <= t then
			local DURATION = 2.1666666666666665
			local lerp_value = math.lerp(1, 0, dying_effect_t / DURATION)
			local sfx_distortion_lerp = math.clamp(lerp_value, 0, 1)
			local ambience_settings = AMBIENCE_SETTINGS[stage]

			if ambience_settings then
				local sfx_distortion_settings = ambience_settings.sfx_distortion
				local sfx_distortion_range = _sfx_distortion_intensity(distance, sfx_distortion_settings)
				local wwise_world = template_context.wwise_world

				WwiseWorld.set_global_parameter(wwise_world, WWISE_DAEMONHOST_RANGE, sfx_distortion_range * sfx_distortion_lerp)
			end
		end

		local dying_screen_fx_t = template_data.dying_screen_fx_t

		if dying_screen_fx_t <= t then
			local DURATION = 2.1666666666666665
			local lerp_value = math.lerp(1, 0, dying_effect_t / DURATION)
			local screen_distortion_lerp = math.clamp(lerp_value, 0, 1)
			local screen_distortion_intensity = _screen_distortion_intensity(distance)

			screen_distortion_intensity = screen_distortion_intensity * screen_distortion_lerp

			local world = template_context.world
			local screen_effect_distortion_id = template_data.screen_effect_distortion_id
			local cloud_name, variable_name = "static", "distance_scalar"

			World.set_particles_material_scalar(world, screen_effect_distortion_id, cloud_name, variable_name, screen_distortion_intensity)
		end
	end
end

function _update_ambience(template_data, template_context, stage, dt)
	local unit = template_data.unit
	local distance = _distance_to_local_player_or_nil(unit)

	if not distance then
		return
	end

	local ambience_settings = AMBIENCE_SETTINGS[stage]
	local sfx_distortion_settings = ambience_settings.sfx_distortion
	local sfx_distortion_range = _sfx_distortion_intensity(distance, sfx_distortion_settings)
	local wwise_world = template_context.wwise_world

	WwiseWorld.set_global_parameter(wwise_world, WWISE_DAEMONHOST_RANGE, sfx_distortion_range)
end

function _update_frost_screen_space(template_data, template_context, stage, dt)
	local unit = template_data.unit
	local distance = _distance_to_local_player_or_nil(unit)

	if not distance then
		return
	end

	if stage ~= STAGES.aggroed then
		local screen_effect_frost_id = template_data.screen_effect_frost_id

		if screen_effect_frost_id then
			local screen_frost_intensity = _screen_frost_intensity(distance, stage)
			local frost_settings = AMBIENCE_SETTINGS.screen_effect_frost
			local lerp_speed = stage == STAGES.waking_up and frost_settings.waking_up_lerp_speed or frost_settings.lerp_speed
			local max_lerp = stage == STAGES.waking_up and 1 or 0.7
			local lerp_t = math.min(dt * lerp_speed, 1)

			template_data.screen_frost_intensity = math.min(math.lerp(template_data.screen_frost_intensity, screen_frost_intensity, lerp_t), max_lerp)

			local cloud_name, variable_name = "frost", "distance_scalar"

			World.set_particles_material_scalar(template_context.world, screen_effect_frost_id, cloud_name, variable_name, template_data.screen_frost_intensity)
		end
	else
		local frost_effect_id = template_data.screen_effect_frost_id

		if frost_effect_id then
			local frost_settings = AMBIENCE_SETTINGS.screen_effect_frost

			template_data.screen_frost_intensity = math.lerp(template_data.screen_frost_intensity, 0, dt * frost_settings.waking_up_lerp_speed)

			local cloud_name, variable_name = "frost", "distance_scalar"

			World.set_particles_material_scalar(template_context.world, frost_effect_id, cloud_name, variable_name, template_data.screen_frost_intensity)

			if template_data.screen_frost_intensity <= 0.05 then
				World.destroy_particles(template_context.world, frost_effect_id)

				template_data.screen_effect_frost_id = nil
			end
		end

		local screen_effect_distortion_id = template_data.screen_effect_distortion_id
		local screen_distortion_intensity = _screen_distortion_intensity(distance)
		local cloud_name, variable_name = "static", "distance_scalar"

		World.set_particles_material_scalar(template_context.world, screen_effect_distortion_id, cloud_name, variable_name, screen_distortion_intensity)
	end
end

function _update_passive(template_data, template_context, dt)
	local unit = template_data.unit
	local distance = _distance_to_local_player_or_nil(unit)

	if not distance then
		return
	end

	local wwise_world = template_context.wwise_world

	WwiseWorld.set_global_parameter(wwise_world, WWISE_DAEMONHOST_RANGE, distance)
end

function _screen_distortion_intensity(distance)
	local distortion_settings = AMBIENCE_SETTINGS.screen_effect_distortion
	local distance_min = distortion_settings.distance_min
	local distance_max = distortion_settings.distance_max
	local multiplier = distortion_settings.scalar_multiplier
	local scalar = 1 - math.normalize_01(distance, distance_min, distance_max)

	return scalar * multiplier
end

function _screen_frost_intensity(distance, stage)
	local frost_settings = AMBIENCE_SETTINGS.screen_effect_frost
	local distance_min, distance_max

	if stage == STAGES.passive then
		distance_min = frost_settings.passive_distance_min
		distance_max = frost_settings.passive_distance_max
	else
		distance_min = frost_settings.distance_min
		distance_max = frost_settings.distance_max
	end

	local multiplier = frost_settings.scalar_multiplier
	local scalar = 1 - math.normalize_01(distance, distance_min, distance_max)

	return scalar * multiplier
end

function _sfx_distortion_intensity(distance, sfx_distortion_settings)
	local sfx_distortion_distance_multiplier = sfx_distortion_settings.distance_multiplier
	local range = distance * sfx_distortion_distance_multiplier

	return range
end

function _distance_to_local_player_or_nil(daemonhost_unit)
	local local_player = Managers.player:local_player(1)
	local local_player_unit = local_player and local_player.player_unit

	local_player_unit = local_player_unit or local_player and local_player.camera_handler:camera_follow_unit()

	if not local_player_unit or not ALIVE[local_player_unit] then
		return nil
	end

	local unit_position = POSITION_LOOKUP[daemonhost_unit]
	local local_player_position = POSITION_LOOKUP[local_player_unit]
	local distance = Vector3.distance(unit_position, local_player_position)

	return distance
end

return effect_template
