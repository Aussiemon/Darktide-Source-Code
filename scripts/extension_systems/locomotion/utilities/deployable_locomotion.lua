-- chunkname: @scripts/extension_systems/locomotion/utilities/deployable_locomotion.lua

local DeployableLocomotion = {}

DeployableLocomotion.set_placed_on_unit = function (world, unit, placed_on_unit)
	local moveable_platform_extension = ScriptUnit.has_extension(placed_on_unit, "moveable_platform_system")

	if moveable_platform_extension then
		local platform_position = Unit.world_position(placed_on_unit, 1)
		local platform_rot = Unit.local_rotation(placed_on_unit, 1)
		local unit_pos = Unit.world_position(unit, 1)
		local unit_rot = Unit.local_rotation(unit, 1)
		local grounded_unit_pos = Vector3(unit_pos.x, unit_pos.y, platform_position.z)
		local position_difference = grounded_unit_pos - platform_position
		local x, y, z = Quaternion.to_euler_angles_xyz(platform_rot)
		local angle = (360 - z) * math.pi / 180
		local new_x = position_difference.x * math.cos(angle) - position_difference.y * math.sin(angle)
		local new_y = position_difference.x * math.sin(angle) + position_difference.y * math.cos(angle)
		local new_local_pos = Vector3(new_x, new_y, 0)

		World.link_unit(world, unit, 1, placed_on_unit, 1)
		Unit.set_local_position(unit, 1, new_local_pos)
		Unit.set_local_rotation(unit, 1, unit_rot)

		return placed_on_unit
	end

	return nil
end

DeployableLocomotion.teleport_deployable = function (unit, position, rotation)
	local old_pose = Matrix4x4.from_quaternion_position(Unit.world_rotation(unit, 1), Unit.world_position(unit, 1))
	local new_pose = Matrix4x4.from_quaternion_position(rotation, position)

	local function _new_rotation_and_position(previous_rotation, previous_position)
		local inverted_parent_pose = Matrix4x4.inverse(old_pose)
		local absolute_pose = Matrix4x4.from_quaternion_position(previous_rotation, previous_position)
		local relative_pose = Matrix4x4.multiply(absolute_pose, inverted_parent_pose)
		local relative_rotation, relative_position = Matrix4x4.rotation(relative_pose), Matrix4x4.translation(relative_pose)

		relative_pose = Matrix4x4.from_quaternion_position(relative_rotation, relative_position)
		absolute_pose = Matrix4x4.multiply(relative_pose, new_pose)

		return Matrix4x4.rotation(absolute_pose), Matrix4x4.translation(absolute_pose)
	end

	Unit.teleport_local_position(unit, 1, position)
	Unit.teleport_local_rotation(unit, 1, rotation)

	local num_actors = Unit.num_actors(unit)

	for i = 1, num_actors do
		local actor = Unit.actor(unit, i)

		if actor then
			local actor_position = Actor.position(actor)
			local actor_rotation = Actor.rotation(actor)
			local absolute_actor_rotation, absolute_actor_position = _new_rotation_and_position(actor_rotation, actor_position)

			Actor.teleport_position(actor, absolute_actor_position)
			Actor.teleport_rotation(actor, absolute_actor_rotation)
		end
	end
end

return DeployableLocomotion
