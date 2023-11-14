local AimProjectile = {}
local PI = math.pi
local parameter_table = {}

AimProjectile.aim_parameters = function (initial_position, initial_rotation, look_rotation, locomotion_template, throw_type, time_in_action)
	local throw_config = locomotion_template.trajectory_parameters[throw_type]
	local local_shoot_offset = Vector3(throw_config.offset_right or 0, throw_config.offset_forward or 0, throw_config.offset_up or 0)
	local offset = Quaternion.rotate(look_rotation, local_shoot_offset)
	local position = initial_position + offset
	local speed_initial = throw_config.speed_initial
	local speed_maximal = throw_config.speed_maximal
	local speed_charge_duration = throw_config.speed_charge_duration

	if speed_maximal < speed_initial then
		speed_maximal = speed_initial
	end

	local speed = nil

	if speed_charge_duration == 0 then
		speed = speed_maximal
	else
		local alpha = time_in_action / speed_charge_duration
		alpha = math.clamp(alpha, 0, 1)
		speed = math.lerp(speed_initial, speed_maximal, alpha)
	end

	local rotation_offset_initial = throw_config.rotation_offset_initial:unbox()
	local rotation_offset_maximal = throw_config.rotation_offset_maximal:unbox()
	local rotation_charge_duration = throw_config.rotation_charge_duration
	local max_iterations = throw_config.aim_max_iterations
	local direction = nil

	if rotation_charge_duration == 0 then
		local maximal_ypr = rotation_offset_maximal
		local maximal_offset = Quaternion.from_yaw_pitch_roll(maximal_ypr.x, maximal_ypr.y, maximal_ypr.z)
		local new_look_rotation = Quaternion.multiply(look_rotation, maximal_offset)
		direction = Quaternion.forward(new_look_rotation)
	else
		local charge_direction_time = time_in_action
		local alpha = charge_direction_time / rotation_charge_duration
		alpha = math.clamp(alpha, 0, 1)
		local initial_ypr = rotation_offset_initial
		local initial_offset = Quaternion.from_yaw_pitch_roll(initial_ypr.x, initial_ypr.y, initial_ypr.z)
		local maximal_ypr = rotation_offset_maximal
		local maximal_offset = Quaternion.from_yaw_pitch_roll(maximal_ypr.x, maximal_ypr.y, maximal_ypr.z)
		local new_offset = Quaternion.lerp(initial_offset, maximal_offset, alpha)
		local current_pitch = Quaternion.pitch(look_rotation)
		local offset_pitch = Quaternion.pitch(new_offset)
		local offseted_pitch = current_pitch + offset_pitch + current_pitch * 0.5
		local pitch_limit = PI / 2 * 0.73
		local actual_pitch = math.min(offseted_pitch, PI / 2 * 0.73)
		local pitch_scale = math.max(actual_pitch - pitch_limit * 0.75, 0) / (pitch_limit * 0.25)
		speed = speed + 0.5 * speed * pitch_scale * pitch_scale
		local yaw = Quaternion.yaw(look_rotation)
		local roll = Quaternion.roll(look_rotation)
		local aim_rotation = Quaternion.from_yaw_pitch_roll(yaw, actual_pitch, roll)
		direction = Quaternion.forward(aim_rotation)
	end

	local place_distance = throw_config.place_distance
	local rotation = initial_rotation
	local integrator_parameters = locomotion_template.integrator_parameters

	if integrator_parameters.rotate_towards_direction then
		rotation = Quaternion.look(direction)
	end

	table.clear(parameter_table)

	parameter_table.position = position
	parameter_table.rotation = rotation
	parameter_table.direction = direction
	parameter_table.speed = speed
	parameter_table.max_iterations = max_iterations
	parameter_table.place_distance = place_distance

	return parameter_table
end

AimProjectile.get_spawn_parameters_from_current_aim = function (action_settings, shoot_position, shoot_rotation, projectile_locomotion_template)
	local initial_position = shoot_position
	local initial_rotation = Quaternion.identity()
	local time_in_action = 0
	local throw_type = action_settings.throw_type
	local aim_parameters = AimProjectile.aim_parameters(initial_position, initial_rotation, shoot_rotation, projectile_locomotion_template, throw_type, time_in_action)
	local position = aim_parameters.position
	local rotation = aim_parameters.rotation
	local direction = aim_parameters.direction
	local speed = aim_parameters.speed
	local throw_config = projectile_locomotion_template.trajectory_parameters[throw_type]
	local angular_velocity = nil

	if throw_config.randomized_angular_velocity then
		local max = throw_config.randomized_angular_velocity
		angular_velocity = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif throw_config.initial_angular_velocity then
		angular_velocity = throw_config.initial_angular_velocity:unbox()
	else
		angular_velocity = Vector3.zero()
	end

	return position, rotation, direction, speed, angular_velocity
end

AimProjectile.get_spawn_parameters_from_aim_component = function (action_aim_projectile_component)
	local position = action_aim_projectile_component.position
	local rotation = action_aim_projectile_component.rotation
	local direction = action_aim_projectile_component.direction
	local speed = action_aim_projectile_component.speed
	local angular_velocity = action_aim_projectile_component.momentum

	return position, rotation, direction, speed, angular_velocity
end

return AimProjectile
