-- chunkname: @scripts/utilities/player_movement.lua

local PlayerMovement = {}

PlayerMovement.teleport = function (player, position, rotation, send_character_state_disruption_event)
	local cb = callback(PlayerMovement._teleport_callback, player.player_unit, Vector3Box(position), rotation and QuaternionBox(rotation) or nil, send_character_state_disruption_event or false)

	Managers.state.game_mode:register_physics_safe_callback(cb)
end

PlayerMovement.teleport_fixed_update = function (player_unit, position, rotation)
	PlayerMovement._teleport(player_unit, position, rotation)
end

PlayerMovement._teleport_callback = function (player_unit, boxed_position, boxed_rotation, send_character_state_disruption_event)
	if ALIVE[player_unit] then
		PlayerMovement._teleport(player_unit, boxed_position:unbox(), boxed_rotation and boxed_rotation:unbox() or nil, send_character_state_disruption_event or false)
	end
end

PlayerMovement._teleport = function (player_unit, position, rotation, send_character_state_disruption_event)
	local mover = Unit.mover(player_unit)

	Mover.set_position(mover, position)

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local locomotion_component = unit_data_extension:write_component("locomotion")

	locomotion_component.position = position

	if rotation then
		locomotion_component.rotation = rotation
	end

	local locomotion_steering = unit_data_extension:write_component("locomotion_steering")

	locomotion_steering.velocity_wanted = Vector3.zero()

	local player = Managers.state.player_unit_spawn:owner(player_unit)

	if not player.remote and rotation then
		local pitch = Quaternion.pitch(rotation)
		local yaw = Quaternion.yaw(rotation)

		player:set_orientation(yaw, pitch, 0)
	end

	local character_state_machine_extension = ScriptUnit.has_extension(player_unit, "character_state_machine_system")

	if send_character_state_disruption_event and character_state_machine_extension and character_state_machine_extension:current_state_name() == "ledge_hanging" then
		Managers.event:trigger("player_teleport_disrupt_state_server_event", player_unit, position)
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

PlayerMovement.calculate_absolute_rotation_position = function (parent_unit, relative_rotation, relative_position)
	local parent_pose = Unit.world_pose(parent_unit, 1)
	local relative_pose = Matrix4x4.from_quaternion_position(relative_rotation, relative_position)
	local absolute_pose = Matrix4x4.multiply(relative_pose, parent_pose)

	return Matrix4x4.rotation(absolute_pose), Matrix4x4.translation(absolute_pose)
end

PlayerMovement.calculate_absolute_position = function (parent_unit, relative_position)
	local parent_pose = Unit.world_pose(parent_unit, 1)
	local relative_pose = Matrix4x4.from_translation(relative_position)
	local absolute_pose = Matrix4x4.multiply(relative_pose, parent_pose)

	return Matrix4x4.translation(absolute_pose)
end

PlayerMovement.calculate_absolute_rotation = function (parent_unit, relative_rotation)
	local parent_pose = Unit.world_pose(parent_unit, 1)
	local relative_pose = Matrix4x4.from_quaternion(relative_rotation)
	local absolute_pose = Matrix4x4.multiply(relative_pose, parent_pose)

	return Matrix4x4.rotation(absolute_pose)
end

PlayerMovement.calculate_relative_rotation_position = function (parent_unit, absolute_rotation, absolute_position)
	local inverted_parent_pose = Matrix4x4.inverse(Unit.world_pose(parent_unit, 1))
	local absolute_pose = Matrix4x4.from_quaternion_position(absolute_rotation, absolute_position)
	local relative_pose = Matrix4x4.multiply(absolute_pose, inverted_parent_pose)

	return Matrix4x4.rotation(relative_pose), Matrix4x4.translation(relative_pose)
end

PlayerMovement.calculate_relative_position = function (parent_unit, absolute_position)
	local inverted_parent_pose = Matrix4x4.inverse(Unit.world_pose(parent_unit, 1))
	local absolute_pose = Matrix4x4.from_translation(absolute_position)
	local relative_pose = Matrix4x4.multiply(absolute_pose, inverted_parent_pose)

	return Matrix4x4.translation(relative_pose)
end

PlayerMovement.calculate_relative_rotation = function (parent_unit, absolute_rotation)
	local inverted_parent_pose = Matrix4x4.inverse(Unit.world_pose(parent_unit, 1))
	local absolute_pose = Matrix4x4.from_quaternion(absolute_rotation)
	local relative_pose = Matrix4x4.multiply(absolute_pose, inverted_parent_pose)

	return Matrix4x4.rotation(relative_pose)
end

local ROTATION_SOFT_LIMIT = math.pi * 0.5
local ROTATION_HARD_LIMIT = math.pi * 0.75

PlayerMovement.calculate_final_unit_rotation = function (current_rotation, target_rotation, forward_rotation, t, is_husk)
	local angle_to_forward = Quaternion.angle(current_rotation, forward_rotation)
	local angle_to_target = Quaternion.angle(current_rotation, target_rotation)

	if not is_husk then
		if angle_to_forward > ROTATION_HARD_LIMIT then
			local clamp_lerp = 0.95 * (ROTATION_HARD_LIMIT / angle_to_forward)

			return Quaternion.lerp(forward_rotation, current_rotation, clamp_lerp)
		end

		local angle_speed_up = 1 + (angle_to_forward > ROTATION_SOFT_LIMIT and angle_to_target or 0)

		t = t * angle_speed_up
	end

	if angle_to_forward > math.pi * 0.5 and angle_to_forward < angle_to_target then
		return Quaternion.lerp(current_rotation, forward_rotation, t)
	end

	return Quaternion.lerp(current_rotation, target_rotation, t)
end

return PlayerMovement
