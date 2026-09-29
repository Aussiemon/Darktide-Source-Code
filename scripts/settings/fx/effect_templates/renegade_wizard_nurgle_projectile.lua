-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_nurgle_projectile.lua

local RESOURCES = {
	vfx = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_projectile_nurgle",
}
local PARTICLE_VARIABLE_NAME = "projectile_size"
local PARTICLE_OFFSET = 0.2
local LERP_DURATION = 1.2
local _get_particle_position, _create_particles, _update_particles
local effect_template = {
	name = "renegade_wizard_nurgle_projectile",
	resources = RESOURCES,
	start = function (template_data, template_context)
		_create_particles(template_data.unit, template_data, template_context)

		template_data.start_t = Managers.time:time("gameplay")
	end,
	update = function (template_data, template_context, dt, t)
		_update_particles(template_data.unit, template_data, template_context, t)
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local particle_id = template_data.particle_id

		World.stop_spawning_particles(world, particle_id)
	end,
}

function _get_particle_position(unit)
	local node = Unit.node(unit, "j_leftweaponattach")
	local node_pos = Unit.world_position(unit, node)
	local node_rot = Unit.world_rotation(unit, node)
	local offset_direction = Quaternion.right(node_rot) + Quaternion.up(node_rot)

	return node_pos + offset_direction * PARTICLE_OFFSET
end

function _create_particles(unit, template_data, template_context)
	local pos = _get_particle_position(unit)

	template_data.particle_id = World.create_particles(template_context.world, RESOURCES.vfx, pos, Quaternion.identity(), nil)
end

function _update_particles(unit, template_data, template_context, t)
	local world_position = _get_particle_position(unit)

	World.move_particles(template_context.world, template_data.particle_id, world_position, Quaternion.identity())

	local particle_variable = World.find_particles_variable(template_context.world, RESOURCES.vfx, PARTICLE_VARIABLE_NAME)
	local alpha = math.clamp01(math.ilerp(template_data.start_t, template_data.start_t + LERP_DURATION, t))

	World.set_particles_variable(template_context.world, template_data.particle_id, particle_variable, Vector3(alpha, 0, 0))
end

return effect_template
