local NavTagVolumeBox = {
	create_from_pose = function (nav_world, tm, half_size)
		local half_size_x, half_size_y, half_size_z = Vector3.to_elements(half_size)
		local position = Matrix4x4.translation(tm)
		local altitude = position.z
		local altitude_min = altitude - half_size_z
		local altitude_max = altitude + half_size_z
		local p1 = Matrix4x4.transform(tm, Vector3(half_size_x, half_size_y, 0))
		local p2 = Matrix4x4.transform(tm, Vector3(half_size_x, -half_size_y, 0))
		local p3 = Matrix4x4.transform(tm, Vector3(-half_size_x, -half_size_y, 0))
		local p4 = Matrix4x4.transform(tm, Vector3(-half_size_x, half_size_y, 0))

		Vector3.set_z(p1, altitude_min)
		Vector3.set_z(p2, altitude_min)
		Vector3.set_z(p3, altitude_min)
		Vector3.set_z(p4, altitude_min)

		return {
			p1,
			p2,
			p3,
			p4
		}, altitude_min, altitude_max
	end
}

NavTagVolumeBox.create_from_node = function (nav_world, unit, node_name, half_size)
	local node_index = Unit.node(unit, node_name)
	local tm = Unit.world_pose(unit, node_index)

	return NavTagVolumeBox.create_from_pose(nav_world, tm, half_size)
end

NavTagVolumeBox.create_from_mesh = function (nav_world, unit, mesh_name)
	local mesh = Unit.mesh(unit, mesh_name)
	local tm, half_size = Mesh.box(mesh)

	return NavTagVolumeBox.create_from_pose(nav_world, tm, half_size)
end

NavTagVolumeBox.create_from_unit = function (nav_world, unit)
	local tm, half_size = Unit.box(unit)

	return NavTagVolumeBox.create_from_pose(nav_world, tm, half_size)
end

return NavTagVolumeBox
