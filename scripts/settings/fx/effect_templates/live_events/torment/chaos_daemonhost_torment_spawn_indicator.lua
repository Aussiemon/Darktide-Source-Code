-- chunkname: @scripts/settings/fx/effect_templates/live_events/torment/chaos_daemonhost_torment_spawn_indicator.lua

local VFX = "content/fx/particles/enemies/daemonhost/elite_daemonhost_spawn_in_location_indicator"
local resources = {
	vfx = VFX,
}
local effect_template = {
	name = "chaos_daemonhost_torment_spawn_indicator",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local position = template_data.position

		template_data.effect_id = World.create_particles(world, VFX, position, Quaternion.identity(), nil, template_data.particle_group)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id

		if effect_id then
			World.stop_spawning_particles(world, effect_id)

			template_data.effect_id = nil
		end
	end,
}

return effect_template
