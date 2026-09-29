-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_shockwave.lua

local VFX_HEIGHT_OFFSET = Vector3Box(0, 0, 0)
local Component = require("scripts/utilities/component")
local TRAVEL_TIME_FIELD = "shockwave_travel_time"
local DEFAULT_TRAVEL_TIME = 0.5
local ARENA_RADIUS = 30
local NUM_SFX_SOURCES = 10
local RADIAN = math.pi * 2
local STEP = RADIAN / NUM_SFX_SOURCES
local UNIT_NAME = "content/fx/units/renegade_wizard_shockwave"
local RENDER_TARGET_RESOLUTION = 2048
local TOOTH_UNIT_NAME = "content/environment/artsets/imperial/spillway/props/nurgle/boss_tooth/boss_tooth_01"
local TEETH_REACTION_DELAY = 0.3
local TEETH_REACTION_EVENT = "reaction"
local resources = {
	sfx_start = "wwise/events/minions/play_enemy_psyker_shockwave_loop",
	sfx_stop = "wwise/events/minions/stop_enemy_psyker_shockwave_loop",
	vfx = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_warp_forcepush_main",
}
local _get_travel_time, _create_burst, _init_sfx_sources, _update_sfx_sources, _get_render_target, _apply_render_target, _trigger_teeth_reaction
local effect_template = {
	name = "renegade_wizard_shockwave",
	resources = resources,
	start = function (template_data, template_context)
		_get_render_target(template_data, template_context)
		_create_burst(template_data, template_context)
		_init_sfx_sources(template_data, template_context)

		template_data.teeth_reaction_timer = 0
		template_data.teeth_reaction_triggered = false
	end,
	update = function (template_data, template_context, dt, t)
		_apply_render_target(template_data, template_context, dt, t)
		_update_sfx_sources(t, dt, template_data, template_context)

		if not template_data.teeth_reaction_triggered then
			template_data.teeth_reaction_timer = template_data.teeth_reaction_timer + dt

			if template_data.teeth_reaction_timer >= TEETH_REACTION_DELAY then
				template_data.teeth_reaction_triggered = true

				_trigger_teeth_reaction(template_context)
			end
		end
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id

		if effect_id then
			World.destroy_particles(world, effect_id)

			template_data.effect_id = nil
		end

		if template_data.render_target then
			Renderer.destroy_resource(template_data.render_target)

			template_data.render_target = nil
		end

		template_data.source_render_target = nil

		for i = 1, NUM_SFX_SOURCES do
			WwiseWorld.trigger_resource_event(template_context.wwise_world, resources.sfx_stop, template_data.source_ids[i])
			WwiseWorld.destroy_manual_source(template_context.wwise_world, template_data.source_ids[i])
		end
	end,
}

function _get_travel_time(template_context, unit)
	local game_session = template_context.game_session
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if not game_object_id or not GameSession.game_object_exists(game_session, game_object_id) then
		return DEFAULT_TRAVEL_TIME
	end

	local travel_time = GameSession.game_object_field(game_session, game_object_id, TRAVEL_TIME_FIELD)

	if not travel_time or travel_time == 0 then
		travel_time = DEFAULT_TRAVEL_TIME
	end

	return travel_time
end

function _create_burst(template_data, template_context)
	local world = template_context.world
	local unit = template_data.unit
	local position = template_data.position or Unit.world_position(unit, 1)
	local rotation = ALIVE[unit] and Unit.local_rotation(unit, 1) or Quaternion.identity()
	local travel_time = _get_travel_time(template_context, unit)
	local node_position = position + VFX_HEIGHT_OFFSET:unbox()
	local effect_id = World.create_particles(world, resources.vfx, node_position, rotation, nil, template_data.particle_group)

	World.set_particles_life_time(world, effect_id, travel_time)

	template_data.effect_id = effect_id
end

function _init_sfx_sources(template_data, template_context)
	local unit = template_data.unit
	local t = Managers.time:time("gameplay")
	local center_pos = template_data.position or Unit.world_position(unit, 1)

	template_data.center_pos = Vector3Box(center_pos)
	template_data.start_t = t
	template_data.end_t = t + _get_travel_time(template_context, unit)
	template_data.source_ids = {}

	for i = 1, NUM_SFX_SOURCES do
		local source_id = WwiseWorld.make_manual_source(template_context.wwise_world, center_pos, Quaternion.identity())

		WwiseWorld.trigger_resource_event(template_context.wwise_world, resources.sfx_start, source_id)

		template_data.source_ids[i] = source_id
	end
end

function _update_sfx_sources(t, dt, template_data, template_context)
	local alpha = math.ilerp(template_data.start_t, template_data.end_t, t)
	local distance = math.lerp(0, ARENA_RADIUS, alpha)

	for i = 1, NUM_SFX_SOURCES do
		local angular_delta = STEP * i
		local added_rotation = Quaternion(Vector3.up(), angular_delta)
		local horizontal_direction = Quaternion.rotate(added_rotation, Vector3.forward())
		local position = template_data.center_pos:unbox() + horizontal_direction * distance

		WwiseWorld.set_source_position(template_context.wwise_world, template_data.source_ids[i], position)
	end
end

function _get_render_target(template_data, template_context, dt, t)
	local units = World.units_by_resource(template_context.world, UNIT_NAME)
	local shockwave_unit = units and units[1]

	if not shockwave_unit then
		return
	end

	local components = Component.get_components_by_name(shockwave_unit, "WizardBossShockwave")
	local shockwave_component = components and components[1]

	if not shockwave_component then
		return
	end

	local source_render_target = shockwave_component:render_target()

	if not source_render_target then
		return
	end

	template_data.source_render_target = source_render_target

	local rt_name = "shockwave_burst_rt_" .. string.gsub(tostring(template_data), "table: ", "")

	template_data.render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, RENDER_TARGET_RESOLUTION, RENDER_TARGET_RESOLUTION, rt_name)
end

local CLOUDS_AND_MATERIALS = {
	{
		cloud_name = "push_circle",
		material_slot_name = "warp_push_circle",
	},
	{
		cloud_name = "waves",
		material_slot_name = "warp_push_wave",
	},
}

function _apply_render_target(template_data, template_context, dt, t)
	if template_data.render_target and template_data.source_render_target and template_data.effect_id and not template_data.render_init then
		Renderer.copy_render_target_rect(template_data.source_render_target, 0, 0, 1, 1, template_data.render_target, 0, 0, 1, 1)

		local all_applied = true

		for i = 1, #CLOUDS_AND_MATERIALS do
			local current_cloud_settings = CLOUDS_AND_MATERIALS[i]
			local particle_mesh = World.get_particles_mesh(template_context.world, template_data.effect_id, current_cloud_settings.cloud_name)
			local material_instance = particle_mesh and Mesh.material(particle_mesh, current_cloud_settings.material_slot_name)

			if material_instance then
				local center_position = template_data.center_pos:unbox()

				Material.set_vector3(material_instance, "position", center_position)
				Material.set_resource(material_instance, "source", template_data.render_target)
			else
				all_applied = false
			end
		end

		local cloud_id = "gpu_embers_stream_sim"
		local particle_material_instance = World.get_particles_material(template_context.world, template_data.effect_id, cloud_id)

		if particle_material_instance then
			local center_position = template_data.center_pos:unbox()

			Material.set_vector3(particle_material_instance, "position", center_position)
			Material.set_resource(particle_material_instance, "source", template_data.render_target)
		end

		template_data.render_init = all_applied
	end
end

function _trigger_teeth_reaction(template_context)
	local world = template_context.world
	local teeth_units = World.units_by_resource(world, TOOTH_UNIT_NAME)

	if not teeth_units then
		return
	end

	for i = 1, #teeth_units do
		local tooth_unit = teeth_units[i]

		if ALIVE[tooth_unit] and Unit.has_animation_event(tooth_unit, TEETH_REACTION_EVENT) then
			Unit.animation_event(tooth_unit, TEETH_REACTION_EVENT)
		end
	end
end

return effect_template
