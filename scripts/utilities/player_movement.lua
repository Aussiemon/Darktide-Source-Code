local PlayerMovement = {
	teleport = function (player, position, rotation)
		assert(Managers.state.game_session:is_server(), "Can't teleport players on clients, game uses authoritative server network model.")

		local cb = callback(PlayerMovement._teleport_callback, player.player_unit, Vector3Box(position), (rotation and QuaternionBox(rotation)) or nil)

		Managers.state.game_mode:register_physics_safe_callback(cb)
	end,
	_teleport_callback = function (player_unit, boxed_position, boxed_rotation)
		if ALIVE[player_unit] then
			local position = boxed_position:unbox()
			local rotation = (boxed_rotation and boxed_rotation:unbox()) or nil
			local mover = Unit.mover(player_unit)

			Mover.set_position(mover, position)

			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local locomotion_component = unit_data_extension:write_component("locomotion")
			local new_rotation, new_position = PlayerMovement.calculate_relative_rotation_position(locomotion_component.parent_unit, rotation, position)
			locomotion_component.position = new_position

			if new_rotation then
				locomotion_component.rotation = new_rotation
			end

			local locomotion_steering = unit_data_extension:write_component("locomotion_steering")
			locomotion_steering.velocity_wanted = Vector3.zero()
			local player = Managers.state.player_unit_spawn:owner(player_unit)

			if not player.remote and rotation then
				local pitch = Quaternion.pitch(rotation)
				local yaw = Quaternion.yaw(rotation)

				player:set_orientation(yaw, pitch, 0)
			end

			local navigation_extension = ScriptUnit.has_extension(player_unit, "navigation_system")

			if navigation_extension then
				navigation_extension:teleport(position)
			end

			local behavior_extension = ScriptUnit.has_extension(player_unit, "behavior_system")

			if behavior_extension then
				behavior_extension:clear_failed_paths()
			end
		end
	end,
	locomotion_position = function (locomotion_component)
		local parent_unit = locomotion_component.parent_unit
		local position = locomotion_component.position
		local _, absolute_position = PlayerMovement.calculate_absolute_rotation_position(parent_unit, nil, position)

		return absolute_position
	end,
	calculate_absolute_rotation_position = function (parent_unit, relative_rotation, relative_position)
		if not parent_unit then
			return relative_rotation, relative_position
		else
			local parent_position = Unit.world_position(parent_unit, 1)
			local parent_rotation = Unit.world_rotation(parent_unit, 1)
			local parent_pose = Matrix4x4.from_quaternion_position(parent_rotation, parent_position)
			local relative_pose = Matrix4x4.identity()

			if relative_rotation and relative_position then
				relative_pose = Matrix4x4.from_quaternion_position(relative_rotation, relative_position)
			elseif relative_rotation and not relative_position then
				relative_pose = Matrix4x4.from_quaternion(relative_rotation)
			elseif not relative_rotation and relative_position then
				relative_pose = Matrix4x4.from_translation(relative_position)
			end

			local absolute_pose = Matrix4x4.multiply(relative_pose, parent_pose)
			local absolute_position = Matrix4x4.translation(absolute_pose)
			local absolute_rotation = Matrix4x4.rotation(absolute_pose)

			return absolute_rotation, absolute_position
		end
	end,
	calculate_relative_rotation_position = function (parent_unit, absolute_rotation, absolute_position)
		if not parent_unit then
			return absolute_rotation, absolute_position
		else
			local parent_position = Unit.world_position(parent_unit, 1)
			local parent_rotation = Unit.world_rotation(parent_unit, 1)
			local parent_pose = Matrix4x4.from_quaternion_position(parent_rotation, parent_position)
			local inverted_parent_pose = Matrix4x4.inverse(parent_pose)
			local absolute_pose = Matrix4x4.identity()

			if absolute_rotation and absolute_position then
				absolute_pose = Matrix4x4.from_quaternion_position(absolute_rotation, absolute_position)
			elseif absolute_rotation and not absolute_position then
				absolute_pose = Matrix4x4.from_quaternion(absolute_rotation)
			elseif not absolute_rotation and absolute_position then
				absolute_pose = Matrix4x4.from_translation(absolute_position)
			end

			local relative_pose = Matrix4x4.multiply(absolute_pose, inverted_parent_pose)
			local relative_position = Matrix4x4.translation(relative_pose)
			local relative_rotation = Matrix4x4.rotation(relative_pose)

			return relative_rotation, relative_position
		end
	end
}
local ROTATION_SOFT_LIMIT = math.pi * 0.5
local ROTATION_HARD_LIMIT = math.pi * 0.75

PlayerMovement.calculate_final_unit_rotation = function (current_rotation, target_rotation, forward_rotation, t, is_husk)
	local angle_to_forward = Quaternion.angle(current_rotation, forward_rotation)
	local angle_to_target = Quaternion.angle(current_rotation, target_rotation)

	if not is_husk then
		if ROTATION_HARD_LIMIT < angle_to_forward then
			local clamp_lerp = 0.95 * ROTATION_HARD_LIMIT / angle_to_forward

			return Quaternion.lerp(forward_rotation, current_rotation, clamp_lerp)
		end

		local angle_speed_up = 1 + ((ROTATION_SOFT_LIMIT < angle_to_forward and angle_to_target) or 0)
		t = t * angle_speed_up
	end

	if angle_to_forward > math.pi * 0.5 and angle_to_forward < angle_to_target then
		return Quaternion.lerp(current_rotation, forward_rotation, t)
	end

	return Quaternion.lerp(current_rotation, target_rotation, t)
end

return PlayerMovement
