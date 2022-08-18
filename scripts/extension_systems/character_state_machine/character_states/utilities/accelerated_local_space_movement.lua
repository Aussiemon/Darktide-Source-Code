local AcceleratedLocalSpaceMovement = {}
local Vector3_dot = Vector3.dot

AcceleratedLocalSpaceMovement.speed_function = function (speed, wanted_speed, wanted_other_speed, acceleration, deceleration, dt)
	speed = (wanted_speed ~= 0 or ((speed <= 0 or math.max(speed - v * dt, 0)) and math.min(speed + v * dt, 0))) and (speed <= 1 or math.max(speed - deceleration * dt, 1)) and (speed >= -1 or math.min(speed + deceleration * dt, -1)) and (wanted_speed <= 0 or math.min(speed + acceleration * dt, wanted_speed)) and math.max(speed - acceleration * dt, wanted_speed)

	return speed
end

local _speed_function = AcceleratedLocalSpaceMovement.speed_function

AcceleratedLocalSpaceMovement.wanted_movement = function (player_character_constants, input_source, locomotion_steering_component, movement_settings_component, first_person_component, is_crouching, velocity_current, dt)
	local move_input = input_source:get("move")
	local wants_move = Vector3.length_squared(move_input) > 0
	local acc = player_character_constants.acceleration
	local dec = player_character_constants.deceleration
	local x = locomotion_steering_component.local_move_x
	local y = locomotion_steering_component.local_move_y
	local wanted_x = move_input.x
	local wanted_y = move_input.y
	local new_x = _speed_function(x, wanted_x, wanted_y, acc, dec, dt)
	local new_y = _speed_function(y, wanted_y, wanted_x, acc, dec, dt)
	local stopped = new_x == 0 and new_y == 0
	local speed_scale = (stopped and 0) or math.sqrt(math.min(1, new_x * new_x + new_y * new_y))
	local moving_backwards = new_y < 0

	if moving_backwards then
		local bw_move_scale = player_character_constants.backward_move_scale
		local direction_proportion = math.sqrt(math.cos(math.atan(new_x / new_y)))
		local bw_speed_multiplier = math.lerp(1, bw_move_scale, direction_proportion)
		speed_scale = speed_scale * bw_speed_multiplier
	end

	local should_walk = input_source:get("walk")
	local current_max_move_speed = nil
	local run_speed = player_character_constants.move_speed
	local look_rotation = first_person_component.rotation
	local flat_look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
	local wants_slide = is_crouching and Vector3.dot(velocity_current, flat_look_direction) > 1.1 * run_speed

	if is_crouching and not wants_slide then
		current_max_move_speed = player_character_constants.crouch_move_speed
	elseif should_walk then
		current_max_move_speed = player_character_constants.walk_move_speed
	else
		current_max_move_speed = run_speed
	end

	local move_speed = current_max_move_speed * speed_scale * movement_settings_component.player_speed_scale
	local local_move_direction = Vector3.normalize(Vector3(new_x, new_y, 0))
	local flat_look_rotation = Quaternion.look(flat_look_direction, Vector3.up())
	local move_direction = Quaternion.rotate(flat_look_rotation, local_move_direction)

	return move_direction, move_speed, new_x, new_y, wants_move, stopped, moving_backwards, wants_slide
end

AcceleratedLocalSpaceMovement.set_wanted_movement = function (locomotion_steering_component, move_direction, move_speed, new_x, new_y)
	locomotion_steering_component.velocity_wanted = move_direction * move_speed
	locomotion_steering_component.local_move_x = new_x
	locomotion_steering_component.local_move_y = new_y
end

AcceleratedLocalSpaceMovement.refresh_local_move_variables = function (max_move_speed, locomotion_steering_component, locomotion_component, first_person_component)
	local current_velocity = locomotion_component.velocity_current
	local flat_velocity = Vector3.flat(current_velocity)
	local move_direction = Vector3.normalize(flat_velocity)
	local current_speed = Vector3.length(flat_velocity)
	local local_speed = math.min(current_speed / max_move_speed, 1.5)
	local aim_rot = first_person_component.rotation
	local flat_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(aim_rot)))
	local local_move_direction = Vector3(Vector3_dot(Quaternion.right(aim_rot), move_direction), Vector3_dot(flat_forward, move_direction), 0)
	local abs = math.abs
	local x = local_move_direction.x
	local y = local_move_direction.y
	local move_x, move_y = nil

	if x == 0 and y == 0 then
		move_x = 0
		move_y = 0
	elseif abs(y) < abs(x) then
		move_x = local_speed * math.sign(x)
		move_y = move_x / x * y
	else
		move_y = local_speed * math.sign(y)
		move_x = move_y / y * x
	end

	locomotion_steering_component.local_move_x = move_x
	locomotion_steering_component.local_move_y = move_y
end

return AcceleratedLocalSpaceMovement
