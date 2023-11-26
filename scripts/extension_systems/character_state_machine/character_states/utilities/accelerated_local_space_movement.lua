-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement.lua

local AcceleratedLocalSpaceMovement = {}
local math = math
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local math_sqrt = math.sqrt
local math_cos = math.cos
local math_atan = math.atan
local math_lerp = math.lerp
local Vector3 = Vector3
local Vector3_length = Vector3.length
local Vector3_length_squared = Vector3.length_squared
local Vector3_normalize = Vector3.normalize
local Vector3_flat = Vector3.flat
local Vector3_dot = Vector3.dot
local Quaternion = Quaternion
local Quaternion_look = Quaternion.look
local Quaternion_forward = Quaternion.forward
local Quaternion_rotate = Quaternion.rotate

AcceleratedLocalSpaceMovement.speed_function = function (speed, wanted_speed, wanted_other_speed, acceleration, deceleration, dt)
	if wanted_speed == 0 then
		local v = wanted_other_speed == 0 and deceleration or acceleration

		if speed > 0 then
			speed = math_max(speed - v * dt, 0)
		else
			speed = math_min(speed + v * dt, 0)
		end
	elseif speed > 1 then
		if wanted_speed > 0 then
			speed = math_max(speed - deceleration * 0.05 * dt, 1)
		else
			speed = math_max(speed - deceleration * dt, 1)
		end
	elseif speed < -1 then
		if wanted_speed < 0 then
			speed = math_min(speed + deceleration * 0.05 * dt, -1)
		else
			speed = math_min(speed + deceleration * dt, -1)
		end
	elseif wanted_speed > 0 then
		speed = math_min(speed + acceleration * dt, wanted_speed)
	else
		speed = math_max(speed - acceleration * dt, wanted_speed)
	end

	return speed
end

local _speed_function = AcceleratedLocalSpaceMovement.speed_function

AcceleratedLocalSpaceMovement.wanted_movement = function (player_character_constants, input_source, locomotion_steering_component, movement_settings_component, first_person_component, is_crouching, velocity_current, dt, move_speed_multiplier)
	move_speed_multiplier = move_speed_multiplier or 1

	local move_input = input_source:get("move")
	local wants_move = Vector3_length_squared(move_input) > 0
	local acc = player_character_constants.acceleration
	local dec = player_character_constants.deceleration
	local x = locomotion_steering_component.local_move_x
	local y = locomotion_steering_component.local_move_y
	local wanted_x, wanted_y = Vector3.to_elements(move_input)
	local new_x, new_y = _speed_function(x, wanted_x, wanted_y, acc, dec, dt), _speed_function(y, wanted_y, wanted_x, acc, dec, dt)
	local stopped = new_x == 0 and new_y == 0
	local new_x_abs, new_y_abs = math_abs(new_x), math_abs(new_y)
	local biggest_speed = math_max(new_x_abs, new_y_abs)
	local speed_scale = stopped and 0 or math_sqrt(math_min(biggest_speed, new_x_abs * new_x_abs + new_y_abs * new_y_abs))
	local moving_backwards = new_y < 0

	if moving_backwards then
		local bw_move_scale = player_character_constants.backward_move_scale
		local direction_proportion = math_sqrt(math_cos(math_atan(new_x / new_y)))
		local bw_speed_multiplier = math_lerp(1, bw_move_scale, direction_proportion)

		speed_scale = speed_scale * bw_speed_multiplier
	end

	local current_max_move_speed
	local run_speed = player_character_constants.move_speed
	local look_rotation = first_person_component.rotation
	local flat_look_direction = Vector3_normalize(Vector3_flat(Quaternion_forward(look_rotation)))
	local wants_slide = is_crouching and Vector3_dot(velocity_current, flat_look_direction) > player_character_constants.slide_move_speed_threshold * move_speed_multiplier

	if is_crouching and not wants_slide then
		current_max_move_speed = player_character_constants.crouch_move_speed
	else
		current_max_move_speed = run_speed
	end

	local move_speed = current_max_move_speed * speed_scale * movement_settings_component.player_speed_scale
	local local_move_direction = Vector3_normalize(Vector3(new_x, new_y, 0))
	local flat_look_rotation = Quaternion_look(flat_look_direction, Vector3.up())
	local move_direction = Quaternion_rotate(flat_look_rotation, local_move_direction)

	return move_direction, move_speed, new_x, new_y, wants_move, stopped, moving_backwards, wants_slide
end

AcceleratedLocalSpaceMovement.wants_move = function (input_source)
	local move_input = input_source:get("move")

	return Vector3_length_squared(move_input) > 0
end

AcceleratedLocalSpaceMovement.set_wanted_movement = function (locomotion_steering_component, move_direction, move_speed, new_x, new_y)
	locomotion_steering_component.velocity_wanted = move_direction * move_speed
	locomotion_steering_component.local_move_x = new_x
	locomotion_steering_component.local_move_y = new_y
end

AcceleratedLocalSpaceMovement.refresh_local_move_variables = function (max_move_speed, locomotion_steering_component, locomotion_component, first_person_component)
	local current_velocity = locomotion_component.velocity_current
	local flat_velocity = Vector3_flat(current_velocity)
	local move_direction = Vector3_normalize(flat_velocity)
	local current_speed = Vector3_length(flat_velocity)
	local local_speed = math_min(current_speed / max_move_speed, 1.2)
	local aim_rot = first_person_component.rotation
	local flat_forward = Vector3_normalize(Vector3_flat(Quaternion_forward(aim_rot)))
	local local_move_direction = Vector3(Vector3_dot(Quaternion.right(aim_rot), move_direction), Vector3_dot(flat_forward, move_direction), 0)
	local abs = math_abs
	local x, y = local_move_direction.x, local_move_direction.y
	local move_x, move_y

	if x == 0 and y == 0 then
		move_x = 0
		move_y = 0
	elseif abs(x) > abs(y) then
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
