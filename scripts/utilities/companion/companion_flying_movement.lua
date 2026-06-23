-- chunkname: @scripts/utilities/companion/companion_flying_movement.lua

local CompanionFlyingMovement = {}

CompanionFlyingMovement.visual_smooth_position = function (unit, target_companion_offset, dt, responsiveness, companion_position_offset)
	local alpha = 1 - math.exp(-responsiveness * dt)
	local new_position = companion_position_offset + (target_companion_offset - companion_position_offset) * alpha

	return new_position
end

CompanionFlyingMovement.visual_smooth_rotation = function (unit, target_forward, dt, world_rotation, movement_settings, current_movement_type, target_unit_position, unit_node_position, current_pitch)
	local current_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(world_rotation)))
	local responsiveness = movement_settings.rotation_responsiveness[current_movement_type]
	local alpha = 1 - math.exp(-responsiveness * dt)
	local new_direction = Vector3.normalize(current_forward + (target_forward - current_forward) * alpha)
	local yaw_only = Quaternion.look(new_direction, Vector3.up())
	local pitch_only = Quaternion.identity()
	local pitch_angle = current_pitch

	if target_unit_position then
		local to_target = Vector3.normalize(target_unit_position - unit_node_position)

		pitch_angle = math.asin(to_target.z)

		local pitch_responsiveness = movement_settings.pitch_rotation_responsiveness[current_movement_type]
		local alpha_pitch = 1 - math.exp(-pitch_responsiveness * dt)

		pitch_angle = current_pitch + (pitch_angle - current_pitch) * alpha_pitch

		local max_pitch = movement_settings.max_pitch

		max_pitch = math.degrees_to_radians(max_pitch)
		pitch_angle = math.clamp(pitch_angle, -max_pitch, max_pitch)
		pitch_only = Quaternion.axis_angle(Vector3.right(), pitch_angle)
	end

	local final_rotation = Quaternion.multiply(yaw_only, pitch_only)

	return final_rotation, pitch_angle
end

CompanionFlyingMovement.set_up_animation_variables = function (self, animation_extension, velocity)
	if not animation_extension then
		return
	end

	animation_extension:set_variable("velocity_length", Vector3.length(velocity))
end

return CompanionFlyingMovement
