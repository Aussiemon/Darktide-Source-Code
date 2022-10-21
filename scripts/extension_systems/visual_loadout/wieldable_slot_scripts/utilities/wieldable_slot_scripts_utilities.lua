local WieldableSlotScriptsUtilities = {
	spawn_particle = function (world, fx_extension, effect_name, source_name, in_first_person)
		local particle_id = World.create_particles(world, effect_name, Vector3.zero())

		if source_name then
			local pose = Matrix4x4.identity()
			local node_unit_1p, node_1p, node_unit_3p, node_3p = fx_extension:vfx_spawner_unit_and_node(source_name)
			local node_unit = in_first_person and node_unit_1p or node_unit_3p
			local node = in_first_person and node_1p or node_3p

			World.link_particles(world, particle_id, node_unit, node, pose, "stop")
		end

		return particle_id
	end,
	destory_particle = function (world, particle_id)
		World.destroy_particles(world, particle_id)
	end
}

return WieldableSlotScriptsUtilities
