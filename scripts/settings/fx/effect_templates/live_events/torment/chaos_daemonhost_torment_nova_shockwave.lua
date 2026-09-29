-- chunkname: @scripts/settings/fx/effect_templates/live_events/torment/chaos_daemonhost_torment_nova_shockwave.lua

local VFX = "content/fx/particles/enemies/daemonhost/elite_daemonhost_nova_shockwave"
local VFX_HEIGHT_OFFSET = Vector3Box(0, 0, 0.25)
local resources = {
	vfx = VFX,
}
local effect_template = {
	name = "chaos_daemonhost_torment_nova_shockwave",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local unit = template_data.unit
		local position = template_data.position or Unit.world_position(unit, 1)
		local rotation = ALIVE[unit] and Unit.local_rotation(unit, 1) or Quaternion.identity()
		local node_position = position + VFX_HEIGHT_OFFSET:unbox()

		template_data.effect_id = World.create_particles(world, VFX, node_position, rotation, nil, template_data.particle_group)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id

		if effect_id then
			World.destroy_particles(world, effect_id)

			template_data.effect_id = nil
		end
	end,
}

return effect_template
