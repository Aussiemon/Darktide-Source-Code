-- chunkname: @scripts/settings/fx/effect_templates/live_events/torment/chaos_daemonhost_torment_nova_area.lua

local VFX = "content/fx/particles/enemies/daemonhost/elite_daemonhost_nova_shockwave_area"
local SFX_START = "wwise/events/world/play_event_daemonhost_aoe_channeling_loop"
local SFX_STOP = "wwise/events/world/stop_event_daemonhost_aoe_channeling_loop"
local resources = {
	vfx = VFX,
	sfx_idle_start = SFX_START,
	sfx_idle_stop = SFX_STOP,
}
local effect_template = {
	name = "chaos_daemonhost_torment_nova_area",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local unit = template_data.unit
		local wwise_world = template_context.wwise_world
		local position = template_data.position or Unit.world_position(unit, 1)
		local rotation = ALIVE[unit] and Unit.local_rotation(unit, 1) or Quaternion.identity()

		WwiseWorld.trigger_resource_event(wwise_world, SFX_START)

		template_data.effect_id = World.create_particles(world, VFX, position, rotation, nil, template_data.particle_group)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id
		local wwise_world = template_context.wwise_world

		if effect_id then
			World.destroy_particles(world, effect_id)

			template_data.effect_id = nil
		end

		WwiseWorld.trigger_resource_event(wwise_world, SFX_STOP)
	end,
}

return effect_template
