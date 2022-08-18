local ProjectileStickyLocomotion = {
	calculate_sticky_pose = function (sticking_to_unit, sticking_to_actor_index, world_position, world_rotation)
		local sticking_to_unit_pose = Unit.world_pose(sticking_to_unit, sticking_to_actor_index)
		local inv_sticking_to_unit_pose = Matrix4x4.inverse(sticking_to_unit_pose)
		local sicking_world_pose = Matrix4x4.from_quaternion_position(world_rotation, world_position)
		local sticking_to_pose = Matrix4x4.multiply(sicking_world_pose, inv_sticking_to_unit_pose)

		return sticking_to_pose
	end
}

ProjectileStickyLocomotion.calculate_sticky_position_and_rotation = function (sticking_to_unit, sticking_to_actor_index, world_position, world_rotation)
	local sticky_pose = ProjectileStickyLocomotion.calculate_sticky_pose(sticking_to_unit, sticking_to_actor_index, world_position, world_rotation)
	local local_position = Matrix4x4.translation(sticky_pose)
	local local_rotation = Matrix4x4.rotation(sticky_pose)

	return local_position, local_rotation
end

return ProjectileStickyLocomotion
