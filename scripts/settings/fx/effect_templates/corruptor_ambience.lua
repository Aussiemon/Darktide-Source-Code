local WWISE_CORRUPTOR_DISTANCE_PARAMETER = "corruptor_distance"
local WWISE_DEFAULT_CORRUPTOR_DISTANCE = 100
local SFX_AMBIENCE_START = "wwise/events/world/play_corruptor_ambience"
local SFX_AMBIENCE_STOP = "wwise/events/world/stop_corruptor_ambience"
local ON_SCREEN_PARTICLE_EFFECT = "content/fx/particles/screenspace/screen_corruptor_distortion"
local sfx_distance_settings = {
	multiplier = 1,
	min = 5,
	max = 100
}
local vfx_distance_settings = {
	multiplier = 0.5,
	min = 4,
	max = 14
}
local resources = {
	sfx_idle_start = SFX_AMBIENCE_START,
	sfx_idle_stop = SFX_AMBIENCE_STOP,
	on_screen_particle_effect = ON_SCREEN_PARTICLE_EFFECT
}
local _distance_to_local_player_or_nil = nil
local effect_template = {
	name = "corruptor_ambience",
	resources = resources,
	start = function (template_data, template_context)
		local position = template_data.position
		template_data.position_boxed = Vector3Box(position)
		local world = template_context.world
		local on_screen_effect_id = World.create_particles(world, ON_SCREEN_PARTICLE_EFFECT, Vector3(0, 0, 1))
		template_data.on_screen_effect_id = on_screen_effect_id
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, position, Quaternion.identity())

		WwiseWorld.trigger_resource_event(wwise_world, SFX_AMBIENCE_START, source_id)

		template_data.source_id = source_id
	end,
	update = function (template_data, template_context, dt, t)
		local position = template_data.position_boxed:unbox()
		local distance_to_local_player = _distance_to_local_player_or_nil(position)

		if not distance_to_local_player then
			return
		end

		local wwise_world = template_context.wwise_world
		local distance = math.clamp(distance_to_local_player * sfx_distance_settings.multiplier or 1, sfx_distance_settings.min, sfx_distance_settings.max)

		WwiseWorld.set_global_parameter(wwise_world, WWISE_CORRUPTOR_DISTANCE_PARAMETER, distance)

		local world = template_context.world
		local on_screen_intensity = (1 - math.normalize_01(distance, vfx_distance_settings.min, vfx_distance_settings.max)) * vfx_distance_settings.multiplier
		local on_screen_effect_id = template_data.on_screen_effect_id
		local cloud_name = "static"
		local variable_name = "distance_scalar"

		World.set_particles_material_scalar(world, on_screen_effect_id, cloud_name, variable_name, on_screen_intensity)
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local on_screen_effect_id = template_data.on_screen_effect_id

		World.destroy_particles(world, on_screen_effect_id)

		local wwise_world = template_context.wwise_world

		WwiseWorld.set_global_parameter(wwise_world, WWISE_CORRUPTOR_DISTANCE_PARAMETER, WWISE_DEFAULT_CORRUPTOR_DISTANCE)

		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, SFX_AMBIENCE_STOP, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)
	end
}

function _distance_to_local_player_or_nil(position)
	local local_player = Managers.player:local_player(1)
	local local_player_unit = local_player and local_player.player_unit
	local_player_unit = local_player_unit or (local_player and local_player.camera_handler:camera_follow_unit())

	if not local_player_unit or not ALIVE[local_player_unit] then
		return nil
	end

	local local_player_position = POSITION_LOOKUP[local_player_unit]
	local distance = Vector3.distance(position, local_player_position)

	return distance
end

return effect_template
