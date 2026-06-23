-- chunkname: @scripts/settings/fx/effect_templates/arc_chain_to_position.lua

local FX_SOURCE_NAME = "j_spine"
local link_particle_name = "content/fx/particles/abilities/chainlightning/cryptic_arc_chainlightning_attack_looping"
local hit_particle_name = "content/fx/particles/abilities/chainlightning/cryptic_arc_chainlightning_impact_looping"
local PARTICLE_VARIABLE_NAME = "length"
local Quaternion_look = Quaternion.look
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local resources = {
	link_particle_name = link_particle_name,
	hit_particle_name = hit_particle_name,
}
local vfx = {
	link_to_source = link_particle_name,
	hit = hit_particle_name,
}

local function _get_positions(unit, template_data)
	local node_index = Unit.node(unit, FX_SOURCE_NAME)
	local unit_position = Unit.world_position(unit, node_index)
	local target_position = template_data.target_pos:unbox()

	return unit_position, target_position
end

local effect_template = {
	name = "arc_chain_to_position",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local world = template_context.world
		local unit = template_data.unit
		local particle_group = template_data.particle_group

		template_data.target_pos = Vector3Box(template_data.position)

		local source_pos, target_pos = _get_positions(unit, template_data)

		if not target_pos then
			return
		end

		local line = target_pos - source_pos
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)
		local link_particle_id = World.create_particles(world, vfx.link_to_source, source_pos, rotation, nil, particle_group)
		local length_variable_index = World.find_particles_variable(world, vfx.link_to_source, PARTICLE_VARIABLE_NAME)

		World.set_particles_variable(world, link_particle_id, length_variable_index, particle_length)

		template_data.link_particle_id = link_particle_id

		local t = Managers.time:time("gameplay")

		template_data.effect_lifetime_end_t = t + 0.75
	end,
	update = function (template_data, template_context, dt, t)
		local world = template_context.world
		local unit = template_data.unit
		local source_pos, target_pos = _get_positions(unit, template_data)

		if not target_pos or not HEALTH_ALIVE[unit] or t >= template_data.effect_lifetime_end_t then
			return true
		end

		local line = target_pos - source_pos
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)
		local link_particle_id = template_data.link_particle_id

		World.move_particles(world, link_particle_id, source_pos, rotation)

		local length_variable_index = World.find_particles_variable(world, vfx.link_to_source, PARTICLE_VARIABLE_NAME)

		World.set_particles_variable(world, link_particle_id, length_variable_index, particle_length)

		return false
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local link_particle_id = template_data.link_particle_id

		if link_particle_id then
			World.stop_spawning_particles(world, link_particle_id)
		end
	end,
}

return effect_template
