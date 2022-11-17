local MaterialQuery = require("scripts/utilities/material_query")
local Flamer = {}
local _get_start_position, _set_flamer_parabola, _query_ground_impact, _raycast_dynamics = nil

Flamer.start_aiming_fx = function (t, unit, vfx, sfx, wwise_world, world, data)
	local from_unit = data.from_unit
	local from_node = data.from_node
	local start_position = _get_start_position(from_unit, from_node)

	if sfx then
		local aim_sfx_event = sfx.aim_sfx_event

		if aim_sfx_event then
			local muzzle_source_id = WwiseWorld.make_manual_source(wwise_world, start_position)

			WwiseWorld.trigger_resource_event(wwise_world, aim_sfx_event, muzzle_source_id)

			data.muzzle_source_id = muzzle_source_id
		end
	end
end

Flamer.start_shooting_fx = function (t, unit, vfx, sfx, wwise_world, world, data)
	local from_unit = data.from_unit
	local from_node = data.from_node
	local start_position = _get_start_position(from_unit, from_node)

	if vfx then
		local muzzle_particle_name = vfx.muzzle_particle

		if muzzle_particle_name then
			local muzzle_particle_id = World.create_particles(world, muzzle_particle_name, start_position, Quaternion.identity())
			local orphaned_policy = "stop"

			World.link_particles(world, muzzle_particle_id, from_unit, from_node, Matrix4x4.identity(), orphaned_policy)

			data.muzzle_particle_id = muzzle_particle_id
		end

		local flamer_particle_name = vfx.flamer_particle

		if flamer_particle_name then
			local flamer_particle_id = World.create_particles(world, flamer_particle_name, start_position, Quaternion.identity())
			local orphaned_policy = "stop"

			World.link_particles(world, flamer_particle_id, from_unit, from_node, Matrix4x4.identity(), orphaned_policy)

			data.flamer_particle_id = flamer_particle_id
			local num_parabola_control_points = vfx.num_parabola_control_points

			if num_parabola_control_points then
				local parabola_particle_variables = {}

				for index = 1, num_parabola_control_points do
					local particle_variable_id = World.find_particles_variable(world, flamer_particle_name, tostring(index))

					table.insert(parabola_particle_variables, particle_variable_id)
				end

				data.parabola_particle_variables = parabola_particle_variables
			end
		end
	end

	if sfx then
		local looping_sfx_start_event = sfx.looping_sfx_start_event

		if looping_sfx_start_event then
			if not data.muzzle_source_id then
				data.muzzle_source_id = WwiseWorld.make_manual_source(wwise_world, start_position, Quaternion.identity())
			end

			local muzzle_source_id = data.muzzle_source_id

			WwiseWorld.trigger_resource_event(wwise_world, looping_sfx_start_event, muzzle_source_id)
		end
	end

	data.start_t = t
end

Flamer.update_shooting_fx = function (t, unit, vfx, sfx, wwise_world, world, physics_world, aim_position, control_point_1, control_point_2, data)
	local from_unit = data.from_unit
	local from_node = data.from_node
	local start_position = _get_start_position(from_unit, from_node)
	local direction = Vector3.normalize(aim_position - start_position)
	local range = data.range
	local hit_dynamic, dynamic_hit_position, _, dynamic_hit_normal = _raycast_dynamics(physics_world, start_position, aim_position, range)

	if vfx.hit_dynamic_particle then
		local dynamic_hit_particle_id = data.dynamic_hit_particle_id

		if hit_dynamic then
			local inv_normal_rotation = Quaternion.look(-dynamic_hit_normal)
			local directional_rotation = Quaternion.rotate(inv_normal_rotation, -direction)

			if dynamic_hit_particle_id then
				World.move_particles(world, dynamic_hit_particle_id, dynamic_hit_position, directional_rotation)
			else
				data.dynamic_hit_particle_id = World.create_particles(world, vfx.hit_dynamic_particle, dynamic_hit_position, directional_rotation)
			end
		elseif dynamic_hit_particle_id then
			World.stop_spawning_particles(world, dynamic_hit_particle_id)

			data.dynamic_hit_particle_id = nil
		end
	end

	local ground_impact_particle_name = vfx.ground_impact_particle

	if ground_impact_particle_name then
		local hit_ground, _, ground_hit_position, ground_hit_normal = _query_ground_impact(physics_world, aim_position)
		local ground_impact_particle_id = data.ground_impact_particle_id

		if hit_ground then
			local flat_direction = Vector3.normalize(Vector3.flat(aim_position - start_position))
			local dot = Vector3.dot(ground_hit_normal, flat_direction)
			local tangent = Vector3.normalize(flat_direction - dot * ground_hit_normal)
			local tangent_rotation = Quaternion.look(tangent, ground_hit_normal)

			if ground_impact_particle_id then
				World.move_particles(world, ground_impact_particle_id, ground_hit_position, tangent_rotation)
			else
				data.ground_impact_particle_id = World.create_particles(world, ground_impact_particle_name, ground_hit_position, tangent_rotation)
			end
		elseif ground_impact_particle_id then
			World.stop_spawning_particles(world, ground_impact_particle_id)

			data.ground_impact_particle_id = nil
		end
	end

	local ground_impact_sfx_start_event = sfx.ground_impact_sfx_start_event

	if ground_impact_sfx_start_event then
		local hit_ground, _, ground_hit_position = _query_ground_impact(physics_world, aim_position)
		local ground_impact_sfx_source_id = data.ground_impact_sfx_source_id

		if hit_ground then
			if ground_impact_sfx_source_id then
				WwiseWorld.set_source_position(wwise_world, ground_impact_sfx_source_id, ground_hit_position)
			else
				ground_impact_sfx_source_id = WwiseWorld.make_manual_source(wwise_world, ground_hit_position)

				WwiseWorld.trigger_resource_event(wwise_world, ground_impact_sfx_start_event, ground_impact_sfx_source_id)

				data.ground_impact_sfx_source_id = ground_impact_sfx_source_id
			end
		elseif ground_impact_sfx_source_id then
			WwiseWorld.destroy_manual_source(wwise_world, ground_impact_sfx_source_id)

			data.ground_impact_sfx_source_id = nil
		end
	end

	local parabola_particle_variables = data.parabola_particle_variables

	if parabola_particle_variables then
		local flamer_particle_id = data.flamer_particle_id
		local flamer_start_position = data.set_muzzle_as_control_point_1 and control_point_1 or start_position

		_set_flamer_parabola(world, from_unit, from_node, flamer_particle_id, parabola_particle_variables, flamer_start_position, control_point_1, control_point_2, aim_position)
	end

	local muzzle_source_id = data.muzzle_source_id

	if muzzle_source_id then
		WwiseWorld.set_source_position(wwise_world, muzzle_source_id, start_position)
	end
end

Flamer.stop_fx = function (unit, vfx, sfx, wwise_world, world, data)
	if sfx then
		local looping_sfx_stop_event = sfx.looping_sfx_stop_event

		if looping_sfx_stop_event then
			local muzzle_source_id = data.muzzle_source_id

			if muzzle_source_id then
				WwiseWorld.trigger_resource_event(wwise_world, looping_sfx_stop_event, muzzle_source_id)
				WwiseWorld.destroy_manual_source(wwise_world, muzzle_source_id)

				data.muzzle_source_id = nil
			end
		end
	end

	if vfx then
		local dynamic_hit_particle_id = data.dynamic_hit_particle_id

		if dynamic_hit_particle_id then
			World.stop_spawning_particles(world, dynamic_hit_particle_id)

			data.dynamic_hit_particle_id = nil
		end

		local ground_impact_particle_id = data.ground_impact_particle_id

		if ground_impact_particle_id then
			World.stop_spawning_particles(world, ground_impact_particle_id)

			data.ground_impact_particle_id = nil
		end

		local muzzle_particle_id = data.muzzle_particle_id

		if muzzle_particle_id then
			World.stop_spawning_particles(world, muzzle_particle_id)

			data.muzzle_particle_id = nil
		end

		local flamer_particle_id = data.flamer_particle_id

		if flamer_particle_id then
			World.stop_spawning_particles(world, flamer_particle_id)

			data.flamer_particle_id = nil
		end
	end

	local ground_impact_sfx_source_id = data.ground_impact_sfx_source_id

	if ground_impact_sfx_source_id then
		WwiseWorld.destroy_manual_source(wwise_world, ground_impact_sfx_source_id)

		data.ground_impact_sfx_source_id = nil
	end
end

function _get_start_position(from_unit, from_node)
	local start_position = Unit.world_position(from_unit, from_node)

	return start_position
end

function _raycast_dynamics(physics_world, from, to, range)
	local direction = Vector3.normalize(to - from)
	local hit, hit_position, distance, normal, actor = PhysicsWorld.raycast(physics_world, from, direction, range, "closest", "collision_filter", "filter_minion_shooting_no_friendly_fire")

	return hit, hit_position, distance, normal, actor
end

local DEFAULT_GROUND_SAMPLE_RANGE = 1

function _query_ground_impact(physics_world, aim_position, optional_sample_range)
	local range = optional_sample_range or DEFAULT_GROUND_SAMPLE_RANGE
	local from = aim_position + Vector3.up() * range
	local to = aim_position + Vector3.down() * range
	local hit, material, position, normal, hit_unit, hit_actor = MaterialQuery.query_material(physics_world, from, to, "flamer")

	return hit, material, position, normal
end

function _set_flamer_parabola(world, from_unit, source_node, flamer_particle_id, parabola_particle_variables, start_position, control_point_1, control_point_2, aim_position)
	local num_variables = #parabola_particle_variables

	for i = 1, num_variables do
		local position = nil

		if i == 1 then
			position = start_position
		elseif i == 2 then
			position = control_point_1
		elseif i == num_variables then
			position = aim_position
		else
			position = control_point_2
		end

		local control_point_variable_id = parabola_particle_variables[i]

		World.set_particles_variable(world, flamer_particle_id, control_point_variable_id, position)
	end
end

return Flamer
