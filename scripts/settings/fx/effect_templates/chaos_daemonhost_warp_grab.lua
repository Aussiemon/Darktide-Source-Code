local MinionPerception = require("scripts/utilities/minion_perception")
local HIT_PARTICLE_NAME = "content/fx/particles/enemies/daemonhost/daemonhost_beam_hit"
local HIT_PARTICLE_NODE_NAME = "j_hips"
local HIT_WWISE_EVENT = "wwise/events/minions/play_enemy_daemonhost_grab_beam"
local HIT_WWISE_STOP_EVENT = "wwise/events/minions/stop_enemy_daemonhost_grab_beam"
local FX_NODE_NAME = "j_righthand"
local FX_PARTICLE_NAME = "content/fx/particles/enemies/daemonhost/daemonhost_hand_execution"
local _start_fx = nil
local resources = {
	hit_particle_name = HIT_PARTICLE_NAME,
	beam_sound_event = HIT_WWISE_EVENT,
	stop_beam_sound_event = HIT_WWISE_STOP_EVENT
}
local effect_template = {
	name = "chaos_daemonhost_warp_grab",
	resources = resources,
	start = function (template_data, template_context)
		return
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local game_session = template_context.game_session
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		if not ALIVE[target_unit] then
			return
		end

		if not template_data.hit_particle_id then
			_start_fx(target_unit, template_data, template_context)
		end

		local node = Unit.node(target_unit, HIT_PARTICLE_NODE_NAME)
		local position = Unit.world_position(target_unit, node)

		if template_data.hit_particle_id then
			World.move_particles(template_context.world, template_data.hit_particle_id, position)
		end

		if template_data.source_id then
			WwiseWorld.set_source_position(template_context.wwise_world, template_data.source_id, position)
		end
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local hit_particle_id = template_data.hit_particle_id

		if hit_particle_id then
			World.stop_spawning_particles(world, hit_particle_id)
		end

		local fx_particle_id = template_data.fx_particle_id

		if fx_particle_id then
			World.stop_spawning_particles(world, fx_particle_id)
		end

		local source_id = template_data.source_id

		if source_id then
			WwiseWorld.trigger_resource_event(wwise_world, HIT_WWISE_STOP_EVENT, source_id)
			WwiseWorld.destroy_manual_source(wwise_world, source_id)
		end
	end
}

function _start_fx(target_unit, template_data, template_context)
	local world = template_context.world
	local wwise_world = template_context.wwise_world
	local hit_fx_node = Unit.node(target_unit, HIT_PARTICLE_NODE_NAME)
	local hit_fx_position = Unit.world_position(target_unit, hit_fx_node)
	local hit_particle_id = World.create_particles(world, HIT_PARTICLE_NAME, hit_fx_position)
	template_data.hit_particle_id = hit_particle_id
	local source_id = WwiseWorld.make_manual_source(wwise_world, hit_fx_position, Quaternion.identity())

	WwiseWorld.trigger_resource_event(wwise_world, HIT_WWISE_EVENT, source_id)

	local daemonhost_unit = template_data.unit
	local daemonhost_fx_node = Unit.node(daemonhost_unit, FX_NODE_NAME)
	local daemonhost_fx_position = Unit.world_position(daemonhost_unit, daemonhost_fx_node)
	local fx_particle_id = World.create_particles(world, FX_PARTICLE_NAME, daemonhost_fx_position)
	local pose = Matrix4x4.identity()
	local orphaned_policy = "destroy"

	World.link_particles(world, fx_particle_id, daemonhost_unit, daemonhost_fx_node, pose, orphaned_policy)

	template_data.fx_particle_id = fx_particle_id
end

return effect_template
