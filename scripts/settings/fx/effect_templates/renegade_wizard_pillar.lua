-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_pillar.lua

local RISE_VFX_DELAY = 1.5
local RISE_VFX_LIFETIME = 2
local VFX_HEIGHT_OFFSET = Vector3Box(0, 0, 0.1)
local PORTAL_VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_pillar_spawn_portal"
local RISE_VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_pillar_rise"
local resources = {
	portal_vfx = PORTAL_VFX,
	rise_vfx = RISE_VFX,
}
local _create_particles, _stop_spawning_particles
local effect_template = {
	name = "renegade_wizard_pillar",
	resources = resources,
	rise_delay = RISE_VFX_DELAY,
	start = function (template_data, template_context)
		local position = template_data.position

		template_data.position_boxed = Vector3Box(position)
		template_data.start_t = Managers.time:time("gameplay")

		if DEDICATED_SERVER then
			return
		end

		template_data.portal_effect_id = _create_particles(template_data, template_context, PORTAL_VFX)
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		if not template_data.rise_effect_id then
			if t < template_data.start_t + RISE_VFX_DELAY then
				return
			end

			template_data.rise_effect_id = _create_particles(template_data, template_context, RISE_VFX)

			return
		end

		if template_data.rise_stopped then
			return
		end

		local rise_end_t = template_data.start_t + RISE_VFX_DELAY + RISE_VFX_LIFETIME

		if t < rise_end_t then
			return
		end

		World.stop_spawning_particles(template_context.world, template_data.rise_effect_id)

		template_data.rise_stopped = true
	end,
	stop = function (template_data, template_context)
		template_data.rise_effect_id = _create_particles(template_data, template_context, RISE_VFX)
		template_data.portal_effect_id = _create_particles(template_data, template_context, PORTAL_VFX)
	end,
}

function _create_particles(template_data, template_context, vfx_name)
	local world = template_context.world
	local position = template_data.position_boxed:unbox() + VFX_HEIGHT_OFFSET:unbox()

	return World.create_particles(world, vfx_name, position, Quaternion.identity(), nil, template_data.particle_group)
end

function _stop_spawning_particles(template_data, template_context)
	if DEDICATED_SERVER then
		return
	end

	local world = template_context.world
	local portal_effect_id = template_data.portal_effect_id

	if portal_effect_id then
		World.stop_spawning_particles(world, portal_effect_id)

		template_data.portal_effect_id = nil
	end

	local rise_effect_id = template_data.rise_effect_id

	if rise_effect_id then
		World.stop_spawning_particles(world, rise_effect_id)

		template_data.rise_effect_id = nil
	end
end

return effect_template
